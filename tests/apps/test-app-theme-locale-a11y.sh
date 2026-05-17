#!/bin/sh
set -eu
mkdir -p tests/logs
mkdir -p /etc/ai-os
cat > /etc/ai-os/ui.conf <<CFG
ui_shape=square
glass_effect=on
CFG
echo 'LANG=fr_FR.UTF-8' > /etc/locale.conf
echo 'A11Y_HIGH_CONTRAST=on' > /etc/firstboot.conf
FONT_SCALE=1.4 apps/calculator/app.sh probe > tests/logs/app-theme-locale-a11y.log
grep -q 'ui=square' tests/logs/app-theme-locale-a11y.log
grep -q 'glass=on' tests/logs/app-theme-locale-a11y.log
grep -q 'lang=fr_FR.UTF-8' tests/logs/app-theme-locale-a11y.log
grep -q 'high_contrast=on' tests/logs/app-theme-locale-a11y.log
echo "apps-theme-locale-a11y-test: PASS"
