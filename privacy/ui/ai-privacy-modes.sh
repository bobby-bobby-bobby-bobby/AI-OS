#!/bin/sh
set -eu
state_dir="${AIOS_PRIVACY_STATE:-/var/lib/aios-privacy}"
mkdir -p "$state_dir"
cmd="${1:-status}"
case "$cmd" in
  status) for k in local_only_ai offline_ai ephemeral_memory no_telemetry; do echo "$k=$(cat "$state_dir/$k" 2>/dev/null || echo off)"; done ;;
  set) key="${2:?}"; val="${3:?}"; echo "$val" > "$state_dir/$key"; echo "$key=$val" ;;
  *) exit 1 ;;
esac
