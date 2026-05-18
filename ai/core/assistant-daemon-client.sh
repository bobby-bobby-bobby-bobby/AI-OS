#!/bin/sh
set -eu
req="${1:?}"; shift || true
msg="$req ${*:-}"
resp=/tmp/ai-assistant.resp
fifo="${AIOS_AI_FIFO:-/tmp/ai-assistant.fifo}"
[ -p "$fifo" ] || { echo "daemon not running"; exit 1; }
: > "$resp"
printf '%s
' "$msg" > "$fifo"
sleep 0.1
tail -n1 "$resp"
