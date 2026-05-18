#!/bin/sh
set -eu
bash tests/privacy/test-privacy-toggles.sh
bash tests/privacy/test-rollback-integration.sh
bash tests/privacy/test-secure-modes.sh
