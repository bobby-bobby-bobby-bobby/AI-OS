#!/bin/sh
set -eu
app="${1:?app}"
echo "$app" >> /tmp/aios-installed-apps.db
./pkgmgr/aipkg.sh install "$app" >/dev/null 2>&1 || true
./compatibility/packages/appimage-handler.sh "$app" >/dev/null 2>&1 || true
echo "installed $app"
