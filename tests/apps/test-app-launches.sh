#!/bin/sh
set -eu
mkdir -p tests/logs
fail=0
while read -r app; do
  [ -n "$app" ] || continue
  if ! apps/$app/app.sh test > "tests/logs/app-${app}-launch.log" 2>&1; then
    echo "FAIL launch $app"; fail=1
  fi
done < apps/app-registry.txt
[ "$fail" -eq 0 ] && echo "apps-launch-test: PASS"
