# Plan: Harmonize Docker Build Path and Local Build Path

Branch: build-locally  
Goal: Make `build-locally.sh` testable via the Docker infrastructure so
that a real booted 560Z is not the only way to validate it.

---

## Background: the two build paths

### Docker path (`make build` → `tools/build.sh`)

```
rust-i586 Docker image  ──┐
                           ├─► Dockerfile (TCL 32-bit base) ──► generate-*.sh ──► .tcz artifacts
openssl-i586 Docker image ─┘
```

Concretely:
- `build.sh` writes `docker-compose.yml` and invokes `docker compose build`.
- The Dockerfile pulls a pre-built rust toolchain tar from `linichotmailca/rust-i586:$RUST_VERSION`
  and pre-built openssl shared libs from `linichotmailca/openssl-i586:$OPENSSL_VERSION`.
- Inside the container (a 32-bit TCL Linux), the generate scripts run:
  `generate-rust-tczs.sh` → `generate-tcz-companions.sh` → `generate-openssl-tcz.sh`.
- `build.sh` then `docker cp`s the resulting `.tcz` files into `release/$RUST_VERSION/`.

### Local path (`make build-locally` → `tools/build-locally.sh`)

```
github.com/linic/rust-i586/releases  ──┐
                                        ├─► build-locally.sh (on a 32-bit TCL host) ──► .tcz artifacts
github.com/linic/openssl-i586/releases ─┘
```

Concretely:
- `build-locally.sh` downloads the rust toolchain tar and the openssl shared libs
  from their respective GitHub release pages.
- It then calls the same three generate scripts (`compile_openssl_tcz`,
  `compile_rust_tcz` wrappers in `build-locally.sh` call the generate-*.sh scripts
  and set up the expected directory layout first).
- Designed to run on a booted Tiny Core Linux system (560Z or any TCL 32-bit machine).

---

## Key insight: any 32-bit TCL userspace is sufficient

The local path does not require the ThinkPad 560Z specifically. It only requires:
1. A 32-bit (`i586`/`i686`) Tiny Core Linux userspace.
2. `mksquashfs`, `coreutils`, `curl`, `git` installed (via `tce-load`).

The Docker base image `linichotmailca/tcl-core-x86:17.x-x86` **is** exactly this —
a 32-bit TCL userspace running in a container on the Debian host's x86_64 kernel.
`tce-load` works inside these containers (it was already used in the openssl-i586
and rust-i586 Dockerfiles for this purpose).

Therefore: **`build-locally.sh` can be exercised inside a Docker container.**

---

## Proposed harmonization: a `build-locally` Docker target

### What it would look like

A new `Dockerfile.local` (or a new multi-stage target in the existing `Dockerfile`)
that:

1. Uses only the TCL base image — **no** rust-i586 / openssl-i586 resource images.
2. Copies `build-locally.sh` and `tce-load-build-requirements.sh` into the container.
3. Runs `build-locally.sh $OPENSSL_VERSION $RUST_VERSION`, which:
   - Calls `tce-load -wi squashfs-tools.tcz coreutils.tcz git.tcz curl.tcz`
   - Downloads the rust toolchain tar from GitHub releases
   - Downloads the openssl shared libs from GitHub releases
   - Calls the same generate-*.sh scripts as the Docker path does

The resulting container image would contain the same `.tcz` artifacts as the current
Docker path, and `build.sh` (or a parallel `build-locally-in-docker.sh`) could
`docker cp` them out.

### Makefile target

```makefile
build-locally-in-docker:
    tools/build-locally-in-docker.sh ${OPENSSL_VERSION} ${RUST_VERSION} ${TCL_VERSION}
```

### Why this unifies the paths

- The generate-*.sh scripts are already shared between both paths.
- The only divergence is **asset acquisition**: resource images (Docker path) vs.
  GitHub release downloads (local path).
- Running `build-locally.sh` inside Docker exercises the download + packaging
  pipeline end-to-end, in the same 32-bit TCL environment the 560Z would use.
- A failure inside Docker is reproducible on the Debian host without needing the
  physical 560Z.

---

## Dependency blocker: upstream GitHub releases

The local path (and therefore `build-locally-in-docker`) **requires published GitHub
releases** from two upstream repos before it can run:

| Repo | What it provides | Release format |
|------|-----------------|----------------|
| `linic/rust-i586` | `rust-$RUST_VERSION-i586-unknown-linux-gnu.tar.gz` | GitHub release tagged `$RUST_VERSION` |
| `linic/openssl-i586` | `libssl.so.$MAJOR`, `libcrypto.so.$MAJOR` | GitHub release tagged `$OPENSSL_VERSION` |

The current Docker path is **not blocked** by this: it pulls from locally-available
Docker images (`linichotmailca/rust-i586:$RUST_VERSION`), which can be built and
exist locally before any GitHub release is published.

### The asymmetry today

```
Docker path:  local Docker image  ──► works without a GitHub release
Local path:   GitHub release      ──► blocked until upstream releases exist
```

For the harmonized Docker test (`build-locally-in-docker`), the same GitHub release
requirement applies. So the practical order of operations for each new Rust version is:

1. Build and push `linichotmailca/rust-i586:$RUST_VERSION`
   (in `rust-i586` repo — this is the Docker image, not the GitHub release).
2. Use the Docker path (`make build`) to verify the `.tcz` packaging.
   **This is what the current 1.95.0 release will do.**
3. Publish GitHub releases in `rust-i586` and `openssl-i586`.
4. Run `build-locally-in-docker` to validate the local path.
5. Only then is the 560Z test merely a final sanity-check, not a blocker.

---

## Open questions for linic

**Q1. Directory layout for `build-locally-in-docker`.**
Should the script produce artifacts in the same `release/$RUST_VERSION/` directory
as `build.sh`, or in a separate `release-local/$RUST_VERSION/`? Keeping them
separate makes it easy to diff the two sets of artifacts.
*My default:* `release/$RUST_VERSION/` — same as now; the diff can be done with
`md5sum -c`.

**Q2. Dockerfile vs. new script.**
Prefer a dedicated `Dockerfile.local` (keeps the two build modes cleanly separated)
or a new multi-stage target in the existing `Dockerfile` (one file to maintain)?
*My default:* new `Dockerfile.local` — the two build modes differ enough in their
FROM chain that mixing them in one file would be confusing.

**Q3. Handling the `ensure_git_repo` step in the Docker context.**
`build-locally.sh` checks for the git repo and offers to clone it if missing.
Inside Docker, the repo is always COPYed in, so this step would be a no-op.
Is that acceptable, or should we add a `--skip-git-check` flag?
*My default:* acceptable as-is — the check passes trivially (dir exists).

---

## Scope of this plan

This plan covers **design and documentation only**. Implementation of
`build-locally-in-docker` is deferred until:
- The 1.95.0 Docker-path release is validated (current priority).
- GitHub releases for `rust-i586` and `openssl-i586` 1.95.0 are published.

The current `build-locally` branch focuses on the Docker path for 1.95.0.
The harmonization work should live on its own branch (suggested: `harmonize-build-paths`).

---

## Status

- [x] Document the two paths and the TCL userspace insight
- [x] Identify the GitHub-release dependency blocker
- [x] Propose the `build-locally-in-docker` approach
- [ ] Implement `Dockerfile.local` / `build-locally-in-docker.sh` — deferred
- [ ] Implement Makefile target — deferred
- [ ] Validate local path via Docker for 1.95.0 — deferred (needs GitHub releases)
