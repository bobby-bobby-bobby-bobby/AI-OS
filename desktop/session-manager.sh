#!/bin/sh
set -eu
./desktop/theme-engine --apply "${AIOS_THEME:-default}" || true
./desktop/settings --load || true
echo "starting compositor stub"
exec ./desktop/wm
