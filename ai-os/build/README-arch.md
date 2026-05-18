# Architecture Targeting

- Configure `arch-target.conf`:
  - `TARGET_ARCH=x86_64|aarch64`
  - `CROSS_COMPILE=yes|no`
  - `QEMU_EMULATE=yes|no`
- If host arch != target arch, set `CROSS_COMPILE=yes` and `QEMU_EMULATE=yes`.
- Use `toolchain-install.sh` to prepare a cross toolchain stub.
