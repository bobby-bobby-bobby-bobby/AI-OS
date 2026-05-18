#!/bin/sh
set -eu
tools/arch-detect/arch-detect.sh | grep -Eq 'arch=|optimize='
echo "arm-detection: PASS"
