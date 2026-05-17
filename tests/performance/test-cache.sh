#!/bin/sh
set -eu
mkdir -p tests/logs
./tools/cachectl/cachectl.sh warm > tests/logs/perf-cache.log
./tools/cachectl/cachectl.sh status >> tests/logs/perf-cache.log
grep -q 'icons/index.cache' tests/logs/perf-cache.log
grep -q 'app-launch/index.cache' tests/logs/perf-cache.log
echo "perf-cache-test: PASS"
