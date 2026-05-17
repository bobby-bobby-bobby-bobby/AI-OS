#!/bin/sh
set -eu
wipe=0
[ "${1:-}" = "--wipe" ] && wipe=1
plan=/tmp/install-plan.json
if [ "$wipe" -eq 1 ]; then
  cat > "$plan" <<JSON
{"mode":"wipe","disk":"/dev/sda","layout":["efi","root","home"]}
JSON
else
  cat > "$plan" <<JSON
{"mode":"non-destructive","action":"shrink-free-space","disk":"/dev/sda","layout":["efi","root","home"]}
JSON
fi
echo "partition plan written: $plan"
