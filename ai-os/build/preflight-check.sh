#!/bin/sh
set -eu
mkdir -p tests/logs
report=tests/report-summary.txt
: > "$report"
run(){
  t="$1"
  if bash "$t" >"tests/logs/$(basename "$t").log" 2>&1; then
    echo "PASS $t" | tee -a "$report"
  else
    echo "FAIL $t" | tee -a "$report"
    return 1
  fi
}
critical_fail=0
for t in tests/tests-time.sh tests/tests-locale.sh tests/tests-accessibility.sh tests/tests-installer.sh tests/tests-network.sh tests/tests-hardware-hooks.sh tests/boot-smoke.sh; do
  run "$t" || critical_fail=1
done
if [ "$critical_fail" -ne 0 ]; then
  tar -czf diagnostics/collect-logs.tar.gz tests/logs 2>/dev/null || true
  echo "CRITICAL FAIL" >> "$report"
  exit 1
fi
echo "ALL CRITICAL TESTS PASSED" >> "$report"
