#!/usr/bin/env bash
set -euo pipefail

disk=${1:?disk}; fs=${2:-btrfs}; root_mnt=${3:-/mnt/ai-os}
efi_part="${disk}1"; root_part="${disk}2"

mkdir -p "$root_mnt"
mkfs.vfat -F32 "$efi_part"
case "$fs" in
  btrfs) mkfs.btrfs -f "$root_part" ;;
  ext4) mkfs.ext4 -F "$root_part" ;;
  *) echo "unsupported fs: $fs" >&2; exit 1 ;;
esac

mount "$root_part" "$root_mnt"
mkdir -p "$root_mnt/boot/efi"
mount "$efi_part" "$root_mnt/boot/efi"

echo "formatted and mounted at $root_mnt"
