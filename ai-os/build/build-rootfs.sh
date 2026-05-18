#!/bin/sh
set -eu
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
OUT_ROOT="$PROJECT_ROOT/ai-os/rootfs"
HOST_ARCH=$(uname -m)
TARGET_ARCH="${TARGET_ARCH:-$HOST_ARCH}"
arm_mode=no
[ "$HOST_ARCH" = "aarch64" ] || [ "$HOST_ARCH" = "arm64" ] && arm_mode=yes
if [ "$TARGET_ARCH" != "$HOST_ARCH" ]; then
  echo "cross target=$TARGET_ARCH host=$HOST_ARCH"
fi
if [ "$arm_mode" = yes ]; then
  echo "ARM optimization: using prebuilt kernel + skipping heavy native rebuild"
  [ -x "$PROJECT_ROOT/installer/arm/prebuilt-kernel.sh" ] && "$PROJECT_ROOT/installer/arm/prebuilt-kernel.sh" || true
else
  [ -x "$PROJECT_ROOT/init/init" ] || make -C "$PROJECT_ROOT/init" all
  [ -x "$PROJECT_ROOT/userland/aish/aish" ] || make -C "$PROJECT_ROOT/userland/aish" all
fi
mkdir -p "$OUT_ROOT/usr/lib/ai-os/recovery" "$OUT_ROOT/usr/lib/ai-os/tools"
install -Dm755 "$PROJECT_ROOT/recovery/recovery-shell.sh" "$OUT_ROOT/usr/lib/ai-os/recovery/recovery-shell.sh"
install -Dm755 "$PROJECT_ROOT/recovery/bin/fs-repair.sh" "$OUT_ROOT/usr/lib/ai-os/recovery/fs-repair.sh"
install -Dm755 "$PROJECT_ROOT/recovery/bin/net-repair.sh" "$OUT_ROOT/usr/lib/ai-os/recovery/net-repair.sh"
install -Dm755 "$PROJECT_ROOT/recovery/ui/snapshot-restore.sh" "$OUT_ROOT/usr/lib/ai-os/recovery/snapshot-restore.sh"
install -Dm755 "$PROJECT_ROOT/tools/arch-detect/arch-detect.sh" "$OUT_ROOT/usr/lib/ai-os/tools/arch-detect.sh"
echo "rootfs optimized for $TARGET_ARCH"
