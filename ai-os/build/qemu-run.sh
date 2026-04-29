#!/bin/sh
set -e

ISO=ai-os.iso

if [ ! -f $ISO ]; then
  echo "ISO not found. Build it first with build-iso.sh."
  exit 1
fi

qemu-system-x86_64 \
  -m 4096 \
  -smp 4 \
  -enable-kvm \
  -cdrom $ISO \
  -boot d \
  -vga virtio \
  -nic user,model=virtio \
  -name "AI-Generated OS Test VM"
