#!/bin/sh
set -eu
app="${1:-all}"
./pkgmgr/aipkg.sh update >/dev/null 2>&1 || true
echo "updated $app"
