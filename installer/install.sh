#!/usr/bin/env bash
set -euo pipefail

ROOT_MNT=${AIOS_ROOT_MNT:-/mnt/ai-os}
TARGET_DISK=${AIOS_TARGET_DISK:-}
TARGET_FS=${AIOS_TARGET_FS:-btrfs}
HOSTNAME=${AIOS_HOSTNAME:-ai-os}
USERNAME=${AIOS_USERNAME:-aiuser}
TIMEZONE=${AIOS_TIMEZONE:-UTC}

log(){ printf '[installer] %s\n' "$*"; }
need(){ command -v "$1" >/dev/null 2>&1 || { echo "missing command: $1" >&2; exit 1; }; }

for cmd in bash lsblk awk sed; do need "$cmd"; done

if [[ -z "$TARGET_DISK" ]]; then
  TARGET_DISK=$(lsblk -dpno NAME,TYPE | awk '$2=="disk"{print $1;exit}')
fi
[[ -n "$TARGET_DISK" ]] || { echo "no disk found" >&2; exit 1; }

log "starting installation to $TARGET_DISK"
"$(dirname "$0")/detect-hardware.sh"
"$(dirname "$0")/partition.sh" "$TARGET_DISK"
"$(dirname "$0")/format.sh" "$TARGET_DISK" "$TARGET_FS" "$ROOT_MNT"
"$(dirname "$0")/install-base.sh" "$ROOT_MNT" "$HOSTNAME" "$TIMEZONE"
"$(dirname "$0")/user-setup.sh" "$ROOT_MNT" "$USERNAME"
"$(dirname "$0")/network.sh" "$ROOT_MNT"
"$(dirname "$0")/drivers.sh" "$ROOT_MNT"
"$(dirname "$0")/encrypted-home.sh" "$ROOT_MNT" "$USERNAME"
"$(dirname "$0")/bootloader.sh" "$ROOT_MNT" "$TARGET_DISK"

log "installation finished successfully"
