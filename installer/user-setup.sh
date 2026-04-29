#!/usr/bin/env bash
set -euo pipefail

root_mnt=${1:?root}; username=${2:-aiuser}

mkdir -p "$root_mnt/home/$username" "$root_mnt/etc"
if ! grep -q "^$username:" "$root_mnt/etc/passwd" 2>/dev/null; then
  echo "$username:x:1000:1000:AI User:/home/$username:/bin/aish" >> "$root_mnt/etc/passwd"
  echo "$username:x:1000:" >> "$root_mnt/etc/group"
  echo "$username:!:20000:0:99999:7:::" >> "$root_mnt/etc/shadow"
fi
chown -R 1000:1000 "$root_mnt/home/$username" 2>/dev/null || true
echo "user $username prepared"
