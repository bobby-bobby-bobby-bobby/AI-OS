#!/usr/bin/env bash
set -euo pipefail

root_mnt=${1:?root}; disk=${2:?disk}

mkdir -p "$root_mnt/boot/grub"
cat > "$root_mnt/boot/grub/grub.cfg" <<'GRUB'
set timeout=3
set default=0
menuentry 'AI-OS' {
  linux /boot/vmlinuz root=LABEL=AIOS_ROOT rw quiet
  initrd /boot/initramfs.img
}
GRUB

if command -v grub-install >/dev/null 2>&1; then
  grub-install --target=x86_64-efi --efi-directory="$root_mnt/boot/efi" --boot-directory="$root_mnt/boot" --removable || true
  grub-install --target=i386-pc --boot-directory="$root_mnt/boot" "$disk" || true
fi

echo "bootloader stage complete"
