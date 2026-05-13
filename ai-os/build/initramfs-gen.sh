#!/bin/sh
set -eu
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
OUT="$ROOT/ai-os/iso/boot/initramfs.img"
STAGE="$ROOT/ai-os/initramfs-stage"
rm -rf "$STAGE" && mkdir -p "$STAGE"/{bin,sbin,etc,proc,sys,dev,run,var/log}
cp "$ROOT/init/init" "$STAGE/sbin/init"
command -v busybox >/dev/null 2>&1 && cp "$(command -v busybox)" "$STAGE/bin/busybox" || true
[ -d "$ROOT/ai-os/kernel/modules" ] && mkdir -p "$STAGE/lib" && cp -a "$ROOT/ai-os/kernel/modules" "$STAGE/lib/" || true
( cd "$STAGE" && find . -print0 | cpio --null -ov --format=newc ) | gzip -9 > "$OUT"
echo "initramfs generated: $OUT"
