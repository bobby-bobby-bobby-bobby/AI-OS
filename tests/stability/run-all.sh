#!/bin/sh
set -eu
bash tests/stability/test-update-rollback.sh
bash tests/stability/test-crash-reporter.sh
bash tests/stability/test-arm-detection.sh
