#!/bin/sh
set -eu
app="${1:?app}"
grep -v "^$app$" /tmp/aios-installed-apps.db 2>/dev/null > /tmp/aios-installed-apps.db.tmp || true
mv /tmp/aios-installed-apps.db.tmp /tmp/aios-installed-apps.db 2>/dev/null || true
echo "removed $app"
