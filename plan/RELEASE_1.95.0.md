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

## Status

- [ ] Check for `linichotmailca/rust-i586:1.95.0` locally (handled in `rust-i586` repo)
- [ ] Fix double `main "$@"` call in `generate-rust-tczs.sh`
- [ ] Add USER root regression-fix block to Dockerfile
- [ ] Update `Makefile` RUST_VERSION → 1.95.0
- [ ] Add changelog entry for 1.95.0
- [ ] Build and verify `.tcz` packages
- [ ] Push / release (discuss with Nic before completing this step)
