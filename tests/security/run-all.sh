#!/bin/sh
set -eu
bash tests/security/test-sandboxing.sh
bash tests/security/test-permissions-daemon.sh
bash tests/security/test-store.sh
