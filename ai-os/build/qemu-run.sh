#!/bin/sh
set -eu
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
AIOS_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
ISO="$AIOS_ROOT/ai-os.iso"
SERIAL_LOG="$AIOS_ROOT/qemu-serial.log"

[ -f "$ISO" ] || { echo "Missing $ISO"; exit 1; }
[ -f "$AIOS_ROOT/disk.qcow2" ] || qemu-img create -f qcow2 "$AIOS_ROOT/disk.qcow2" 16G
qemu-system-x86_64 \
  -m 2048 -smp 2 \
  -machine q35,accel=kvm:tcg \
  -cpu host \
  -drive file="$ISO",media=cdrom,if=virtio \
  -drive file="$AIOS_ROOT/disk.qcow2",if=virtio,format=qcow2 \
  -netdev user,id=n1 -device virtio-net-pci,netdev=n1 \
  -device virtio-rng-pci \
  -serial file:"$SERIAL_LOG" \
  -nographic \
  -d guest_errors,int,cpu_reset \
  -D "$AIOS_ROOT/qemu-debug.log"
