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

- [ ] Write this journal and commit it.
- [ ] `build-locally.sh`: remove the `CONTINUER ICI ...` sentinel.
- [ ] `build-locally.sh`: fix `OPENSSL_COMPILE_DIR` → `OPENSSL_TCZ_COMPILE_DIR`; fix `RUST_COMPILE_DIR` → `RUST_TCZ_COMPILE_DIR`.
- [ ] `build-locally.sh`: fix `RUST_TOOLCHOAIN_TAR` → `RUST_TOOLCHAIN_TAR`.
- [ ] `build-locally.sh`: arg count check `-eq 2`; replace `echo $PARAMETER_ERROR_MESSAGE; exit $?` with `usage; exit $?`.
- [ ] `build-locally.sh`: unify `GIT_REPO_PATH` / `GIT_REPO_DIR`.
- [ ] `build-locally.sh`: fix `clone()` so https is tried only when ssh actually failed.
- [ ] `build-locally.sh`: add `main "$@"` at end.
- [ ] `generate-rust-tczs.sh`: fix `$RUST_TOOLCHOAIN_TAR` typo; have `main` call `compile`.
- [ ] `generate-openssl-tcz.sh`: fix `main "$A"` → `main "$@"`; remove/fix the `cd "$OPENSSL_COMPILE_DIR"` line.
- [ ] `generate-tcz-companions.sh`: have `main` call `compile`; add `main "$@"`.
- [ ] Commit Phase 1.

### Phase 2 — wire up a local build dependency installer (medium, safe)

- [ ] New `tools/tce-load-build-requirements.sh` — loads at minimum `squashfs-tools.tcz`, `coreutils.tcz`, `git.tcz`, `curl.tcz` (pattern mirrored from `rust-i586/tools/tce-load-build-requirements.sh`).
- [ ] `build-locally.sh`: call `tce-load-build-requirements.sh` from `main()` after arg parsing, before any download / compile step.
- [ ] Commit Phase 2.

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

---

## Things out of scope / left alone

- `build.sh` — the Docker entrypoint. Has its own `[ ! Dockerfile ]` pre-existing bug family; not part of this rewrite.
- `publish.sh`, `github-release-download.sh`, `load-test.sh`, `echo_sleep.sh` — untouched by linic in `b38dbc1`; I won't touch them either unless they get in the way.
- `Dockerfile`, `docker-compose.yml` — not affected.
- Actually running the end-to-end build on a booted Tiny Core Linux 560Z / equivalent. **This cannot be validated from this workspace.** linic to run it and report back.
