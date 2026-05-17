#!/bin/sh
set -eu
bash tests/performance/test-gpu.sh
bash tests/performance/test-animation.sh
bash tests/performance/test-profiles.sh
bash tests/performance/test-cache.sh
