#!/bin/sh
set -eu
mkdir -p tests/logs
fail=0
while read -r app; do
  [ -f "apps/$app/launcher.desktop" ] || { echo "missing launcher $app"; fail=1; }
done < apps/app-registry.txt
cp apps/app-registry.txt tests/logs/apps-registry.log
[ "$fail" -eq 0 ] && echo "apps-launcher-registry-test: PASS"
