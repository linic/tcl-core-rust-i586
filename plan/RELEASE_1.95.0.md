# Plan: Release 1.95.0

Scouted from `rust-i586` session on 2026-04-26. Check if `linichotmailca/rust-i586:1.95.0`
is available locally or pull it.

## Known issues to fix before building

1. **`generate-rust-tczs.sh` calls `main "$@"` twice** — lines 86 and 88 both call `main "$@"`.
   The second call is a bug; remove it.

2. **Dockerfile needs the same `17.x-x86` base image regression fixes** as `rust-i586`:
   The `17.x-x86` floating tag introduced three regressions (observed 2026-04-26):
   - `/tmp` lost world-write permission
   - `sudo` lost SUID bit
   - `/home/tc` changed ownership to root

   Add a `USER root` RUN block near the top of the Dockerfile (after the `FROM` line):
   ```dockerfile
   USER root
   RUN chmod 1777 /tmp && chown -R tc:staff /tmp/tce /tmp/tcloop && chmod u+s /usr/bin/sudo \
       && chown tc:staff /home/tc
   USER tc
   ```

3. **Makefile `RUST_VERSION`** — still set to `1.93.1`; update to `1.95.0`.

## Changelog entry

The changelog is current through `1.93.0 → 1.93.1` (2026/03/06). Add an entry for `→ 1.95.0`.

## Additional fix found during prep

**`generate-openssl-tcz.sh` broken paths** (pre-existing since b38dbc1 rewrite):
The b38dbc1 rewrite set `OPENSSL_SQUASHFS_SOURCE_PATH` to a non-existent
`$HOME_TC/openssl-$VERSION-i586_tcz/squashfs-root` and output the TCZ to a
`-release` subdirectory that is never created in Docker. The Dockerfile actually
stages libs at `$HOME_TC/openssl/usr/lib/` and expects the TCZ at `$HOME_TC/`.
Rewrote the script back to the 4244d68 design (squash from `$HOME_TC/openssl`,
output TCZ + companions to `$HOME_TC`). RESOURCE_FILES_DIRECTORY defaults to `.`
which resolves to `$HOME_TC` after the internal `cd "$HOME_TC"` — matching the
Dockerfile's COPY of info-openssl to WORKDIR.

## Status

- [x] Check for `linichotmailca/rust-i586:1.95.0` locally — confirmed present
- [x] Fix double `main "$@"` call in `generate-rust-tczs.sh`
- [x] Add USER root regression-fix block to Dockerfile
- [x] Update `Makefile` RUST_VERSION → 1.95.0
- [x] Update `docker-compose.yml` RUST_VERSION → 1.95.0
- [x] Fix `generate-openssl-tcz.sh` broken paths (additional fix, see above)
- [x] Add changelog entry for 1.95.0 (handled automatically by generate-tcz-companions.sh during build)
- [x] Build and verify `.tcz` packages — all 22 artifacts in release/1.95.0/, load-test passed (cargo ran Hello World)
- [ ] Push / release (discuss with Nic before completing this step)
