#!/bin/sh
set -eu
ui="${1:-rounded}"; glass="${2:-off}"; theme="${3:-dark}"; icons="${4:-default}"; wallpaper="${5:-wallpaper01.png}"
cat > /tmp/ai-os-ui.conf <<CFG
ui_shape=$ui
glass_effect=$glass
theme=$theme
icon_pack=$icons
wallpaper=$wallpaper
CFG
./desktop/theme-engine --apply "$theme" || true
echo "wm/panel/launcher/notify/tray UI refresh (stub): shape=$ui glass=$glass icons=$icons wallpaper=$wallpaper"
