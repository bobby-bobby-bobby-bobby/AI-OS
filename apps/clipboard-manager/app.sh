#!/bin/sh
set -eu
app_name=$(basename "$(dirname "$0")")
theme_file=/etc/ai-os/ui.conf
locale_file=/etc/locale.conf
a11y_file=/etc/firstboot.conf
shape=rounded; glass=off; lang=en_US.UTF-8; font_scale=1.0; high_contrast=off
[ -f "$theme_file" ] && shape=$(grep '^ui_shape=' "$theme_file"|cut -d= -f2) && glass=$(grep '^glass_effect=' "$theme_file"|cut -d= -f2)
[ -f "$locale_file" ] && lang=$(grep '^LANG=' "$locale_file"|cut -d= -f2)
[ -f "$a11y_file" ] && high_contrast=$(grep '^A11Y_HIGH_CONTRAST=' "$a11y_file"|cut -d= -f2)
font_scale=${FONT_SCALE:-1.0}
echo "$app_name launch ui=$shape glass=$glass lang=$lang font_scale=$font_scale high_contrast=$high_contrast args=$*"
case "$app_name" in
  archive-manager) echo "archive actions: zip/unzip/tar (stub)" ;;
  weather) echo "weather api stub endpoint" ;;
  clock) echo "clock: alarms timers stopwatch (stub)" ;;
  system-monitor) echo "system monitor cpu/ram/processes (stub)" ;;
  disk-usage) echo "disk usage analyzer (stub)" ;;
  bluetooth-manager) echo "bluetooth manager UI (stub)" ;;
  wifi-manager) echo "wifi manager UI (stub)" ;;
  notifications-center) echo "notifications center UI (stub)" ;;
  clipboard-manager) echo "clipboard manager UI (stub)" ;;
  color-picker) echo "color picker ui stub" ;;
  *) : ;;
esac
