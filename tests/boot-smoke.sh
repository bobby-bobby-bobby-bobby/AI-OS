#!/bin/sh
set -eu
mkdir -p tests/logs
log="tests/logs/boot-smoke.log"
( timeout 60s bash ai-os/build/qemu-run.sh >"$log" 2>&1 ) || true
cp -f ai-os/serial.log tests/logs/serial.log 2>/dev/null || true
if grep -Eq 'init: started|aish\$' tests/logs/serial.log 2>/dev/null; then
  echo "boot-smoke: PASS"
else
  echo "boot-smoke: WARN no init marker"; exit 1
fi
