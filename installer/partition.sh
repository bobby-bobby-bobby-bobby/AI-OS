#!/usr/bin/env bash
set -euo pipefail

disk=${1:?disk required}

[[ -b "$disk" ]] || { echo "not a block device: $disk" >&2; exit 1; }

partprobe "$disk" || true

if [[ "${AIOS_CONFIRM_DESTRUCTIVE:-0}" != "1" ]]; then
  echo "refusing destructive partitioning; set AIOS_CONFIRM_DESTRUCTIVE=1" >&2
  exit 1
fi

sgdisk --zap-all "$disk"
sgdisk -n 1:1MiB:+512MiB -t 1:ef00 -c 1:AIOS_EFI "$disk"
sgdisk -n 2:0:0 -t 2:8300 -c 2:AIOS_ROOT "$disk"
partprobe "$disk"

printf '%s\n' "partitioning complete for $disk"
