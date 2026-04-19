# tools/ revamp journal

Branch: `build-locally`

Goal: finish the `build-locally.sh` rewrite linic started in commit `b38dbc1`, so that `tools/build-locally.sh OPENSSL_VERSION RUST_VERSION` can be invoked from inside a booted Tiny Core Linux (no Docker) and end up with the same set of artifacts the Docker build produces: `openssl-x.y.z-i586.tcz`, `rust-x.y.z-i586.tcz`, `rust-x.y.z-i586-doc.tcz`, and their `.dep` / `.info` / hash companions.

A worked sibling journal lives at `/home/code/mes-repertoires-git/tcl-core-560z/TOOLS_REVAMP.md` (branch `improving_compile_scripts`) — same protocol, different repo.

---

## State of the revamp (starting point)

Last commit on `build-locally`:

- `b38dbc1` — *"build-locally.sh rewrite in process..."* — Makefile + 4 tool scripts touched. linic's own commit message makes clear the work was mid-rewrite.

The diff touched:

- `Makefile` — added `build-locally` target.
- `tools/build-locally.sh` — **new**, 194 lines, clearly in-progress (has a literal `CONTINUER ICI A VERIFIER LES RESULTATS` sentinel at line 104).
- `tools/generate-openssl-tcz.sh` — rewritten into `usage / compile / main` pattern.
- `tools/generate-rust-tczs.sh` — rewritten into `usage / compile / main` pattern.
- `tools/generate-tcz-companions.sh` — rewritten into `usage / compile / main` pattern, ~460 → ~160 lines.

Other tools/ scripts were not touched in this commit: `build.sh`, `echo_sleep.sh`, `github-release-download.sh`, `load-test.sh`, `publish.sh`.

### Known bugs / rough edges spotted while reading

**`tools/build-locally.sh`**

1. **Line 104**: literal sentence `CONTINUER ICI A VERIFIER LES RESULTATS` — obvious stop marker; will produce "command not found" at runtime. Remove.
2. **Line 85**: `cd "$OPENSSL_COMPILE_DIR"` — variable never set. The compile dir in scope is `$OPENSSL_TCZ_COMPILE_DIR`.
3. **Line 103**: `cd "$RUST_COMPILE_DIR"` — ditto; should be `$RUST_TCZ_COMPILE_DIR`.
4. **Line 96**: `RUST_TOOLCHAIN_TAR_PATH="$RUST_DEPENDENCY_PATH/$RUST_TOOLCHOAIN_TAR"` — typo `TOOLCHOAIN`. Same typo also lives in `tools/generate-rust-tczs.sh` line 32 — cross-checked via grep.
5. **Line 153**: `if [ ! $# -eq 1 ]` — should be `-eq 2` (script takes `OPENSSL_VERSION RUST_VERSION`).
6. **Lines 154–156**: `echo $PARAMETER_ERROR_MESSAGE; exit $?` — `$PARAMETER_ERROR_MESSAGE` never set (the `usage()` function defines a local `USAGE` variable); `exit $?` after a successful `echo` exits 0. Needs `usage; exit $?`.
7. **End of file**: `main` is defined but never invoked. Missing `main "$@"`.
8. **Name mismatch**: `main()` sets `GIT_REPO_PATH`; `compile_openssl_tcz` / `compile_rust_tcz` reference `$GIT_REPO_DIR`. Pick one.
9. **`clone()`**: always runs the https clone, even if the ssh clone succeeded — no `else` on the result check. Minor but real.
10. **`clone()`**: the second https attempt still returns `$RESULT` from the first (ssh) attempt on the path where ssh succeeded; but logic-wise, if ssh failed the second clone runs into a non-empty directory and will itself fail anyway. The control flow is wrong, not just cosmetic.

**`tools/generate-rust-tczs.sh`**

11. **Line 32**: `$RUST_TOOLCHOAIN_TAR` typo (same as build-locally.sh).
12. **Lines 75–82**: `main()` only assigns `RUST_VERSION=$1` and never calls `compile()`. Currently the script does nothing useful when invoked.
13. **Line 84**: has `main "$@"` — fine.

**`tools/generate-openssl-tcz.sh`**

14. **Line 113**: `cd "$OPENSSL_COMPILE_DIR"` inside `main()` — `OPENSSL_COMPILE_DIR` never set. Most likely meant `$OPENSSL_TCZ_COMPILE_DIR`. (Or drop the `cd` — `compile()` uses absolute paths throughout.)
15. **Line 123**: `main "$A"` — typo, should be `main "$@"`. Without this the script silently no-ops.

**`tools/generate-tcz-companions.sh`**

16. **Lines 151–161**: `main()` assigns variables but never calls `compile()`. Same bug pattern as `generate-rust-tczs.sh`.
17. **No trailing `main "$@"`** at end of file.

**Environmental gaps (not bugs, but will block the first end-to-end run)**

18. There is no `tce-load-build-requirements.sh` in this repo. The Dockerfile handles dependency install via `tce-load -wi coreutils.tcz` as its only line, because everything heavy (the rust toolchain tar) is pulled in via `COPY`. For a booted-TC run we'll need at least `squashfs-tools.tcz` (for `mksquashfs`) and `coreutils.tcz` (for `sha512sum` etc.), plus `curl` (usually built in) and `git`.

---

## Plan of what's missing

Ordered lowest-risk first.

### Phase 1 — fix the obvious bugs (quick, safe)

- [x] Write this journal and commit it.
- [x] `build-locally.sh`: remove the `CONTINUER ICI ...` sentinel.
- [x] `build-locally.sh`: fix `OPENSSL_COMPILE_DIR` → `OPENSSL_TCZ_COMPILE_DIR`; fix `RUST_COMPILE_DIR` → `RUST_TCZ_COMPILE_DIR`.
- [x] `build-locally.sh`: fix `RUST_TOOLCHOAIN_TAR` → `RUST_TOOLCHAIN_TAR`.
- [x] `build-locally.sh`: arg count check `-eq 2`; replace `echo $PARAMETER_ERROR_MESSAGE; exit $?` with `usage; exit $?`.
- [x] `build-locally.sh`: unify `GIT_REPO_PATH` → `GIT_REPO_DIR` (matches the `_DIR` used by the two compile helpers).
- [x] `build-locally.sh`: fix `clone()` so https is tried only when ssh actually failed (nested the https block inside the ssh-failure branch).
- [x] `build-locally.sh`: add `main "$@"` at end.
- [x] `build-locally.sh`: check generate-rust-tczs.sh result before running generate-tcz-companions.sh (was silently chained without checking).
- [x] `generate-rust-tczs.sh`: fix `$RUST_TOOLCHOAIN_TAR` typo; have `main` call `compile`; add `main "$@"`.
- [x] `generate-openssl-tcz.sh`: fix `main "$A"` → `main "$@"`; dropped the `cd "$OPENSSL_COMPILE_DIR"` line (undefined var; `compile()` uses absolute paths throughout).
- [x] `generate-openssl-tcz.sh`, `generate-tcz-companions.sh`: `usage()` now `return 2` instead of implicit 0, matching `generate-rust-tczs.sh`.
- [x] `generate-tcz-companions.sh`: have `main` call `compile`; add `main "$@"`; default `RESOURCE_FILES_DIRECTORY=.` so the info/info-doc/rust.tcz.dep lookups resolve relative to cwd (matches Docker's `WORKDIR /home/tc`).
- [x] Commit Phase 1.

### Phase 2 — wire up a local build dependency installer (medium, safe)

- [x] New `tools/tce-load-build-requirements.sh` — `tce-load -wi squashfs-tools.tcz coreutils.tcz git.tcz curl.tcz`. Deliberately *not* the full rust-i586 list, because build-locally.sh repackages a prebuilt toolchain tar rather than compiling rust from source.
- [x] `build-locally.sh`: call it from `main()` after `ensure_git_repo`, before any `get_*` / `compile_*` step. Resolves the tce-load script via `SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"` so `build-locally.sh` can be invoked from any cwd.
- [x] Commit Phase 2.

### Phase 3 — smoke-test what can be validated from this workspace

- [ ] `sh -n` on every touched script.
- [ ] Run `build-locally.sh` with 0 / 1 / 3 args and confirm the usage/error path is clean.
- [ ] Document in this journal that the full end-to-end run on a booted 560Z is **not** validated from here — that is linic's follow-up.

### Phase 4 — out of scope for this session (but noted)

- `build.sh` (the Docker entrypoint) still has `[ ! Dockerfile ]` / `[ ! echo_sleep ]` guards that always pass (same pre-existing bug family that the 560z revamp addressed). Not touched here — pre-existing and not blocking.
- `ensure_git_repo` / `clone` — keep as fixed, but if linic would rather drop them (mirroring the rust-i586 pattern where you copy the script out by hand), that's a follow-up.

---

## Log (what I completed, in order)

- `2026-04-18` — Wrote this journal, read the four files in the commit and the reference `rust-i586/tools/build-locally.sh`, listed the bugs, set up the phased plan. No code changes yet; this is the handshake commit.
- `2026-04-18` — Phase 1: fixed the 17-ish bugs from the journal. `build-locally.sh` now parses args correctly, uses the right variable names, has a working `clone()` fallback, and ends with `main "$@"`. All three `generate-*.sh` scripts now actually invoke their `compile()` function (they were no-ops before). Usage paths all exit 2 consistently. Smoke-tested with 0/1/3 args on `build-locally.sh` and bad-input on each `generate-*.sh` — all print usage and exit 2. `sh -n` passes on all four files.
- `2026-04-18` — Phase 2: added `tools/tce-load-build-requirements.sh` that loads `squashfs-tools coreutils git curl`. `build-locally.sh` `main()` now invokes it after `ensure_git_repo` and bails on failure. Resolved the sibling script path via `SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"` so the script is cwd-independent. `sh -n` passes.

---

## Clarifying questions for linic

Numbered so you can reply `"Q3: option b"`.

**Q1. Scope of this session.**
Just finish `build-locally.sh` + the related `generate-*.sh` fixes (what you had open in `b38dbc1`), or also refactor `build.sh`, `publish.sh` etc. like the 560z revamp did?
*My default:* only what's in flight — stop once `build-locally.sh` is runnable end-to-end. The other scripts already work via Docker; refactoring them is a separate task.

**Q2. `ensure_git_repo` / `clone`.**
Keep the "clone the repo if missing" bootstrap in `build-locally.sh` (so a fresh TC can run the script once it's copied to `/home/tc`), or drop it entirely like `rust-i586/tools/build-locally.sh` does (which assumes you're already in the checkout)?
*My default:* keep it, just fix it — you clearly wrote it on purpose.

**Q3. `tce-load-build-requirements.sh` contents.**
Minimum set I'm planning: `squashfs-tools.tcz coreutils.tcz git.tcz curl.tcz`. Anything else you routinely need on the 560Z that I should preload? (The rust-i586 one also lists `cmake compiletc gcc zlib_base-dev openssl-dev openssl ninja python3.9` — those are for building rust *from source*, not needed here since we pull a prebuilt toolchain tar.)
*My default:* the minimum set above.

**Q4. Where does the openssl `compile()` expect to `cd`?**
`generate-openssl-tcz.sh` main() has `cd "$OPENSSL_COMPILE_DIR"` (undefined). Looking at `compile()`, every path is absolute — the `cd` isn't needed. Safe to delete the line?
*My default:* delete.

**Q5. Info dirs get mutated in-place.**
`generate-openssl-tcz.sh` / `generate-tcz-companions.sh` write into `info/`, `info-doc/`, `info-openssl/` — those are git-tracked. In Docker that's fine (the container is throwaway); on the 560Z it dirties the working tree. OK as-is, or should the scripts copy the info dirs to a scratch dir and mutate the copies?
*My default:* leave as-is — matches current Docker behaviour, and you've lived with it fine in the other repos.

**Q6. CIP / cert setup.**
rust-i586's `build-locally.sh` calls `get-certificate.sh / compare-certificate.sh / trust-certificate.sh` because it fetches source from rust-lang. Our script only `curl`s release assets from `github.com/linic/...`. System CA bundle should cover that. Confirm we don't need the cert dance?
*My default:* skip cert setup. Add it only if the smoke run on the 560Z fails on TLS.

---

## Decisions made without input (record of assumptions)

*(Appended as I go. All of these are reversible via `git revert` of the relevant phase commit.)*

**Phase 1**

- **Variable rename direction** (`GIT_REPO_PATH` → `GIT_REPO_DIR`, not the other way): picked `_DIR` because the compile helpers already used it and because `rust-i586/tools/build-locally.sh` uses `COMPILE_DIR` / `RUST_GIT_DIR` — consistent naming. Reversible.
- **Dropped the `cd "$OPENSSL_COMPILE_DIR"` line** in `generate-openssl-tcz.sh` `main()` rather than renaming it to `$OPENSSL_TCZ_COMPILE_DIR`. `compile()` uses absolute paths (`$OPENSSL_VERSION_TCZ_PATH`, `$OPENSSL_INFO_FILES_PATH`) so cwd doesn't matter. Deleting is the smaller change. Reversible via `git revert`.
- **`RESOURCE_FILES_DIRECTORY="${RESOURCE_FILES_DIRECTORY:-.}"` default** in `generate-tcz-companions.sh` `main()`: the script was never setting this, relying on the Dockerfile's implicit `WORKDIR /home/tc` + the fact that `.` resolves relative to cwd. Making it an explicit default (overridable via env) keeps the Docker behaviour while letting `build-locally.sh` `cd` the right place first. See Q5 in this doc.
- **`usage()` returns 2 everywhere**: harmonised the three `generate-*.sh` scripts. `generate-rust-tczs.sh` already returned 2; the other two implicitly returned 0 which made `exit $?` on the error path misleadingly signal success. Low-risk, matches the existing intent.

**Phase 2**

- **Minimum tce-load set** (`squashfs-tools coreutils git curl`) rather than rust-i586's much larger set. Scope rationale: our build-locally.sh assembles .tcz files from prebuilt binaries; it never invokes a C/C++ toolchain. If the end-to-end run on the 560Z turns out to need something else (e.g. a specific tar with xz support), add it then. See Q3 in this doc.
- **`SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"`** to locate the sibling `tce-load-build-requirements.sh`: makes `build-locally.sh` invokable from any cwd (matches the `make build-locally` target, which runs from the repo root). No environment assumptions beyond POSIX sh.

---

## Things out of scope / left alone

- `build.sh` — the Docker entrypoint. Has its own `[ ! Dockerfile ]` pre-existing bug family; not part of this rewrite.
- `publish.sh`, `github-release-download.sh`, `load-test.sh`, `echo_sleep.sh` — untouched by linic in `b38dbc1`; I won't touch them either unless they get in the way.
- `Dockerfile`, `docker-compose.yml` — not affected.
- Actually running the end-to-end build on a booted Tiny Core Linux 560Z / equivalent. **This cannot be validated from this workspace.** linic to run it and report back.
