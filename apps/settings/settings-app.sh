#!/bin/sh
set -eu
section="${1:-system}"; arg="${2:-}"
case "$section" in
  system) echo "system settings stub" ;;
  privacy|security) ./security/firewall-defaults.sh; ./security/encrypted-home.sh ;;
  vm) ./compatibility/vm/vm-common.sh dev ;;
  lang) ./langmgr/lang.sh "${arg:-BASIC}" ;;
  updates) echo "update system stub" ;;
  theme|ui) ./apps/ui-picker/ui-picker.sh rounded off dark default wallpaper01.png ;;
  network) ./network/netmgr.sh gui-hook ;;
  browser) ./apps/browser-picker/browser-picker.sh "${arg:-firefox}" sandbox ;;
  power) ./power/power-profile.sh "${arg:-balanced}" ;;
  accessibility) ./settings/accessibility/endpoints.sh ;;
  locale) ./locale/syslocale set "${arg:-en_US.UTF-8}" ;;
  input) ./input/ibus-hook.sh ;;
  *) echo "usage: settings-app.sh {system|privacy|security|vm|lang|updates|theme|ui|network|browser|power|accessibility|locale|input}"; exit 1 ;;
esac
