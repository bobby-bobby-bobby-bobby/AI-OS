#!/bin/sh
set -eu
./desktop/theme-engine --apply "${AIOS_THEME:-default}" || true
./desktop/settings --load || true
./desktop/notifications/notifyd.sh "Session starting"
./desktop/tray/trayd.sh &
./desktop/launcher-grid/launcher-grid.sh &
./apps/browser-picker/firstboot-hook.sh || true
./apps/ui-picker/ui-picker.sh rounded off dark default wallpaper01.png || true
echo "starting compositor stub"
exec ./desktop/wm
