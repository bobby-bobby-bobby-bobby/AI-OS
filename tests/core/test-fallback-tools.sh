#!/bin/sh
set -eu
mkdir -p tests/logs
for t in terminal file-manager text-editor image-viewer pdf-viewer network-config; do
  ./fallback-tools/$t.sh >> tests/logs/core-fallback.log
done
grep -q 'fallback terminal' tests/logs/core-fallback.log
echo "core-fallback-test: PASS"
