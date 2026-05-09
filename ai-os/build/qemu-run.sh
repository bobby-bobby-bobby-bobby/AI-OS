#!/bin/sh
set -eu
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
AIOS_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
. "$SCRIPT_DIR/arch-target.conf"
ISO="$AIOS_ROOT/ai-os.iso"
SERIAL_LOG="$AIOS_ROOT/serial.log"
[ -f "$ISO" ] || { echo "Missing $ISO"; exit 1; }
[ -f "$AIOS_ROOT/disk.qcow2" ] || qemu-img create -f qcow2 "$AIOS_ROOT/disk.qcow2" 16G
MACH="q35"; [ "$TARGET_ARCH" = "aarch64" ] && MACH="virt"
qemu-system-${TARGET_ARCH} \
  -m 2048 -smp 2 -machine ${MACH},accel=kvm:tcg \
  -drive file="$ISO",media=cdrom,if=virtio \
  -drive file="$AIOS_ROOT/disk.qcow2",if=virtio,format=qcow2 \
  -append "console=ttyS0,115200n8 init=/sbin/init" \
  -serial file:"$SERIAL_LOG" -nographic \
  -d guest_errors,int,cpu_reset -D "$AIOS_ROOT/qemu-debug.log"
