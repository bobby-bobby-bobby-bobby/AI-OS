#!/bin/sh
set -eu
bash tests/core/test-login-lock.sh
bash tests/core/test-compositor.sh
bash tests/core/test-sound.sh
bash tests/core/test-fallback-tools.sh
bash tests/core/test-binaries.sh
