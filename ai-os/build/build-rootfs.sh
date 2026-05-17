#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
OUT_ROOT="$PROJECT_ROOT/ai-os/rootfs"

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

echo "rootfs assembled at $OUT_ROOT"
