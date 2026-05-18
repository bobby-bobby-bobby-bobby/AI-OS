#!/bin/sh
set -eu
cmd="${1:-list}"; vm="${2:-}"; cfg=/tmp/aios-vms.db
case "$cmd" in
  list) cat "$cfg" 2>/dev/null || echo "(no vms)" ;;
  create) echo "$vm cpu=2 ram=2048 disk=20G" >> "$cfg"; echo "created $vm" ;;
  delete) grep -v "^$vm " "$cfg" 2>/dev/null > "$cfg.tmp" || true; mv "$cfg.tmp" "$cfg" 2>/dev/null || true; echo "deleted $vm" ;;
  launch) ./compatibility/vm/vm-common.sh "$vm" ;;
  config) echo "$vm cpu=${3:-2} ram=${4:-2048}" ;;
  *) echo "usage: vm-manager.sh {list|create|delete|launch|config}"; exit 1 ;;
esac
