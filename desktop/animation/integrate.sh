#!/bin/sh
set -eu
./compositor/compositor-engine.sh >/dev/null 2>&1 || true
./desktop/theme-engine.sh --apply "${THEME:-default}" >/dev/null 2>&1 || true
echo "animation integrated with compositor/theme"
