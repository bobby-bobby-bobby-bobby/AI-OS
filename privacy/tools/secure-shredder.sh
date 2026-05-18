#!/bin/sh
set -eu
f="${1:?file required}"
[ -f "$f" ] || exit 1
size=$(wc -c < "$f")
head -c "$size" /dev/zero > "$f"
rm -f "$f"
echo "shredded:$f"
