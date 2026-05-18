#!/bin/sh
set -eu
state_dir="${AIOS_PRIVACY_STATE:-/var/lib/aios-privacy}"
mkdir -p "$state_dir"
for k in camera microphone location clipboard_privacy local_only_ai offline_ai ephemeral_memory no_telemetry; do
  [ -f "$state_dir/$k" ] || echo off > "$state_dir/$k"
done
cmd="${1:-status}"
case "$cmd" in
  status)
    for k in camera microphone location clipboard_privacy local_only_ai offline_ai ephemeral_memory no_telemetry; do
      echo "$k=$(cat "$state_dir/$k")"
    done
    echo "file_access_history=$(wc -l < "$state_dir/file-access.log" 2>/dev/null || echo 0)"
    echo "sandbox_status=$(security/sandbox/sandboxctl list | wc -l 2>/dev/null || echo 0)" ;;
  toggle)
    key="${2:?}"; cur=$(cat "$state_dir/$key" 2>/dev/null || echo off)
    [ "$cur" = on ] && echo off > "$state_dir/$key" || echo on > "$state_dir/$key"
    echo "$key=$(cat "$state_dir/$key")" ;;
  file-access) tail -n 30 "$state_dir/file-access.log" 2>/dev/null || true ;;
  permissions) security/sandbox/sandboxctl list 2>/dev/null || echo "no permissions" ;;
  *) echo "usage: privacy-dashboard.sh {status|toggle <key>|file-access|permissions}"; exit 1 ;;
esac
