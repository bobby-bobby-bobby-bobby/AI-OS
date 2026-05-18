#!/bin/sh
set -eu
echo "AI-OS Recovery Shell"
while :; do
  printf "recovery> "
  read -r cmd args || exit 0
  case "$cmd" in
    fsck) recovery/bin/fs-repair.sh ${args:-/} ;;
    net) recovery/bin/net-repair.sh ;;
    restore) recovery/ui/snapshot-restore.sh "${args:-latest}" ;;
    exit) exit 0 ;;
    *) echo "commands: fsck <mnt>, net, restore <snapshot|latest>, exit" ;;
  esac
done
