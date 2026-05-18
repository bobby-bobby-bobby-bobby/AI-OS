#!/bin/sh
set -eu
conf=/etc/firstboot.conf
mkdir -p /etc
username="${FIRSTBOOT_USER:-aiuser}"
password="${FIRSTBOOT_PASS:-change-me}"
timezone="${FIRSTBOOT_TZ:-UTC}"
locale="${FIRSTBOOT_LOCALE:-en_US.UTF-8}"
keyboard="${FIRSTBOOT_KBD:-us}"
a11y_sr="${FIRSTBOOT_SR:-off}"
a11y_osk="${FIRSTBOOT_OSK:-off}"
a11y_mag="${FIRSTBOOT_MAG:-off}"
a11y_hc="${FIRSTBOOT_HC:-off}"
browser="${FIRSTBOOT_BROWSER:-firefox}"
auto_updates="${FIRSTBOOT_AUTO_UPDATES:-on}"
cat > "$conf" <<CFG
USERNAME=$username
PASSWORD_SET=yes
TIMEZONE=$timezone
LOCALE=$locale
KEYBOARD=$keyboard
A11Y_SCREEN_READER=$a11y_sr
A11Y_OSK=$a11y_osk
A11Y_MAGNIFIER=$a11y_mag
A11Y_HIGH_CONTRAST=$a11y_hc
BROWSER=$browser
AUTO_UPDATES=$auto_updates
CFG
echo "firstboot config written: $conf"
