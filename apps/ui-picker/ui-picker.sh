#!/bin/sh
set -eu
cfg=/etc/ai-os/ui.conf
ui="${1:-rounded}"; glass="${2:-off}"; theme="${3:-dark}"; icons="${4:-default}"; wallpaper="${5:-wallpaper01.png}"
mkdir -p /etc/ai-os
cat > "$cfg" <<CFG
ui_shape=$ui
glass_effect=$glass
theme=$theme
icon_pack=$icons
wallpaper=$wallpaper
CFG
cp -f "$cfg" /tmp/ai-os-ui.conf
echo "applied ui=$ui glass=$glass theme=$theme icons=$icons wallpaper=$wallpaper"
