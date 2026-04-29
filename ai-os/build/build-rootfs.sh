#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
OUT_ROOT="$PROJECT_ROOT/ai-os/rootfs"

# ensure core binaries exist
[ -x "$PROJECT_ROOT/init/init" ] || make -C "$PROJECT_ROOT/init" all
[ -x "$PROJECT_ROOT/userland/aish/aish" ] || make -C "$PROJECT_ROOT/userland/aish" all
[ -x "$PROJECT_ROOT/desktop/wm" ] || make -C "$PROJECT_ROOT/desktop" all

rm -rf "$OUT_ROOT"
mkdir -p "$OUT_ROOT"/{bin,sbin,etc,proc,sys,dev,tmp,var,usr/bin,usr/sbin,usr/lib,usr/share,home,boot}
mkdir -p "$OUT_ROOT"/etc/ai-os/units "$OUT_ROOT"/usr/share/ai-os

install -m 755 "$PROJECT_ROOT/init/init" "$OUT_ROOT/sbin/init"
install -m 755 "$PROJECT_ROOT/userland/aish/aish" "$OUT_ROOT/usr/bin/aish"
install -m 755 "$PROJECT_ROOT/pkgmgr/aipkg.sh" "$OUT_ROOT/usr/bin/aipkg"
install -m 755 "$PROJECT_ROOT/langmgr/lang.sh" "$OUT_ROOT/usr/bin/lang"
install -m 755 "$PROJECT_ROOT/langmgr/run.sh" "$OUT_ROOT/usr/bin/run"

for s in "$PROJECT_ROOT"/compatibility/packages/*.sh "$PROJECT_ROOT"/compatibility/vm/*.sh; do
  install -Dm755 "$s" "$OUT_ROOT/usr/lib/ai-os/compat/$(basename "$s")"
done
for s in "$PROJECT_ROOT"/installer/*.sh; do
  install -Dm755 "$s" "$OUT_ROOT/usr/lib/ai-os/installer/$(basename "$s")"
done
for s in "$PROJECT_ROOT"/security/*.sh; do
  install -Dm755 "$s" "$OUT_ROOT/usr/lib/ai-os/security/$(basename "$s")"
done

install -Dm644 "$PROJECT_ROOT"/init/units/*.unit "$OUT_ROOT/etc/ai-os/units/"
install -Dm644 "$PROJECT_ROOT"/desktop/themes/default/theme.conf "$OUT_ROOT/usr/share/ai-os/theme.conf"
install -Dm644 "$PROJECT_ROOT"/security/adblock/dns-blocking.conf "$OUT_ROOT/etc/ai-os/dns-blocking.conf"
install -Dm644 "$PROJECT_ROOT"/security/apparmor/aish.profile "$OUT_ROOT/etc/apparmor.d/aish.profile"
install -Dm644 "$PROJECT_ROOT"/security/firejail/aish.profile "$OUT_ROOT/etc/firejail/aish.profile"
install -Dm644 "$PROJECT_ROOT"/security/flatpak/default-overrides.conf "$OUT_ROOT/etc/flatpak/default-overrides.conf"

for b in wm panel launcher settings theme-engine; do
  install -Dm755 "$PROJECT_ROOT/desktop/$b" "$OUT_ROOT/usr/bin/$b"
done
install -Dm755 "$PROJECT_ROOT/desktop/session-manager.sh" "$OUT_ROOT/usr/bin/ai-session"
install -Dm755 "$PROJECT_ROOT/desktop/panel-launch.sh" "$OUT_ROOT/usr/bin/panel-launch"

# install system configs
for c in "$PROJECT_ROOT"/config/associations/* "$PROJECT_ROOT"/config/ui/* "$PROJECT_ROOT"/config/theme/* "$PROJECT_ROOT"/config/security/*; do
  [ -f "$c" ] && install -Dm644 "$c" "$OUT_ROOT/etc/ai-os/$(basename "$c")"
done


# install app layer
for app in media editor files browser-picker ui-picker settings; do
  for f in "$PROJECT_ROOT"/apps/$app/*.sh; do
    [ -f "$f" ] && install -Dm755 "$f" "$OUT_ROOT/usr/lib/ai-os/apps/$app/$(basename "$f")"
  done
  for f in "$PROJECT_ROOT"/apps/$app/*.{json,yaml,conf}; do
    [ -f "$f" ] && install -Dm644 "$f" "$OUT_ROOT/usr/share/ai-os/apps/$app/$(basename "$f")"
  done
done
install -Dm755 "$PROJECT_ROOT/desktop/notifications/notifyd.sh" "$OUT_ROOT/usr/bin/notifyd"
install -Dm755 "$PROJECT_ROOT/desktop/tray/trayd.sh" "$OUT_ROOT/usr/bin/trayd"
install -Dm755 "$PROJECT_ROOT/desktop/launcher-grid/launcher-grid.sh" "$OUT_ROOT/usr/bin/launcher-grid"
install -Dm644 "$PROJECT_ROOT/branding/wallpapers/index.json" "$OUT_ROOT/usr/share/ai-os/wallpapers/index.json"
for w in "$PROJECT_ROOT"/branding/wallpapers/wallpaper*.png; do
  [ -f "$w" ] && install -Dm644 "$w" "$OUT_ROOT/usr/share/ai-os/wallpapers/$(basename "$w")"
done
install -Dm644 "$PROJECT_ROOT/branding/icons/index.yaml" "$OUT_ROOT/usr/share/ai-os/icons/index.yaml"
for i in "$PROJECT_ROOT"/branding/icons/*.svg; do
  [ -f "$i" ] && install -Dm644 "$i" "$OUT_ROOT/usr/share/ai-os/icons/$(basename "$i")"
done

echo "rootfs assembled at $OUT_ROOT"
