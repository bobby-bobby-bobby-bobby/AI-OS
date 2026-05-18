#!/bin/sh
set -eu
state_dir="${AIOS_PRIVACY_STATE:-/var/lib/aios-privacy}"
log="${AIOS_PRIVACY_LOG:-/var/log/privacy-daemon.log}"
ipc="${AIOS_PRIVACY_FIFO:-/tmp/privacy-daemon.fifo}"
mkdir -p "$state_dir" "$(dirname "$log")"
[ -p "$ipc" ] || mkfifo "$ipc"
for k in camera microphone location clipboard_privacy local_only_ai offline_ai ephemeral_memory no_telemetry; do
  [ -f "$state_dir/$k" ] || echo off > "$state_dir/$k"
done
echo "privacy-daemon:start" >> "$log"
while read -r line < "$ipc"; do
  cmd=$(printf '%s' "$line" | cut -d' ' -f1)
  arg1=$(printf '%s' "$line" | cut -d' ' -f2)
  case "$cmd" in
    set)
      key="$arg1"; val=$(printf '%s' "$line" | cut -d' ' -f3)
      echo "$val" > "$state_dir/$key"
      echo "set:$key=$val" >> "$log" ;;
    access)
      app="$arg1"; path=$(printf '%s' "$line" | cut -d' ' -f3-)
      echo "$(date -u +%FT%TZ) app=$app path=$path" >> "$state_dir/file-access.log"
      echo "access:$app" >> "$log" ;;
    enforce)
      cam=$(cat "$state_dir/camera"); mic=$(cat "$state_dir/microphone")
      [ "$cam" = off ] && security/sandbox/sandboxctl set camera-app deny 2>/dev/null || true
      [ "$mic" = off ] && security/sandbox/sandboxctl set mic-app deny 2>/dev/null || true
      echo "enforced" >> "$log" ;;
    stop) echo "privacy-daemon:stop" >> "$log"; break ;;
  esac
done
