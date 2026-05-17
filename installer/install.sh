#!/bin/sh
set -eu
root="${AIOS_INSTALL_ROOT:-/tmp/aios-install-root}"
mkdir -p "$root/etc" "$root/home" "$root/var/log" "$root/var/lib" "$root/aiptmp" "$root/.snapshots"
./installer/auto-partition.sh "${1:-}" >/dev/null || true
./installer/firstboot-wizard.sh
user="${INSTALL_USER:-aiuser}"
pass="${INSTALL_PASS:-change-me}"
locale="${INSTALL_LOCALE:-en_US.UTF-8}"
tz="${INSTALL_TZ:-UTC}"
kbd="${INSTALL_KBD:-us}"
encrypt="${INSTALL_ENCRYPT:-none}"
mkdir -p "$root/home/$user"
printf '%s:%s\n' "$user" "$pass" > "$root/etc/shadow.stub"
printf 'LANG=%s\n' "$locale" > "$root/etc/locale.conf"
printf '%s\n' "$tz" > "$root/etc/timezone"
printf 'XKBLAYOUT=%s\n' "$kbd" > "$root/etc/vconsole.conf"
printf 'ENCRYPTION=%s\n' "$encrypt" > "$root/etc/encryption.conf"
mkdir -p "$root/@" "$root/@home" "$root/@var" "$root/@snapshots"
snap="snap-$(date +%s)"
mkdir -p "$root/.snapshots/$snap"
echo "$snap" > "$root/var/lib/initial-snapshot"
cp -f /etc/firstboot.conf "$root/etc/firstboot.conf" 2>/dev/null || true
echo "install complete root=$root user=$user snapshot=$snap"
