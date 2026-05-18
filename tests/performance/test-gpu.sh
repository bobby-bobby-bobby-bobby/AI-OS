#!/bin/sh
set -eu
mkdir -p tests/logs
./tools/gpu-diagnose/gpu-diagnose.sh > tests/logs/perf-gpu.log
grep -q 'detected_gpu=' tests/logs/perf-gpu.log
grep -q 'acceleration_status=' tests/logs/perf-gpu.log
echo "perf-gpu-test: PASS"
