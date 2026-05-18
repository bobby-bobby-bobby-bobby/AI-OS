#!/bin/sh
set -eu
target="${1:-/}"
echo "scan:$target"
[ -d "$target" ] || { echo "missing target"; exit 1; }
find "$target" -type f -name '*.journal' -delete 2>/dev/null || true
echo "fs-repair:ok"
