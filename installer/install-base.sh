#!/usr/bin/env bash
set -euo pipefail

root_mnt=${1:?root}; hostname=${2:-ai-os}; timezone=${3:-UTC}
mkdir -p "$root_mnt"/{etc,var,usr/bin,root,home,tmp}
chmod 1777 "$root_mnt/tmp"

echo "$hostname" > "$root_mnt/etc/hostname"
cat > "$root_mnt/etc/hosts" <<HOSTS
127.0.0.1 localhost
127.0.1.1 $hostname.localdomain $hostname
::1 localhost
HOSTS
ln -snf "/usr/share/zoneinfo/$timezone" "$root_mnt/etc/localtime" || true

if [[ -d /workspace/AI-OS/rootfs ]]; then
  cp -a /workspace/AI-OS/rootfs/. "$root_mnt/" 2>/dev/null || true
fi

echo "base layout installed"
