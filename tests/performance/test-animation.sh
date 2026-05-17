#!/bin/sh
set -eu
mkdir -p tests/logs
ANIM_QUALITY=smooth ./desktop/animation/engine.sh open > tests/logs/perf-animation.log
./desktop/animation/integrate.sh >> tests/logs/perf-animation.log
grep -q 'animation=open' tests/logs/perf-animation.log
echo "perf-animation-test: PASS"
