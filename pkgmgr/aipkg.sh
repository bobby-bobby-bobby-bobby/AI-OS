#!/bin/sh
set -eu
ROOT="${AIOS_ROOT:-/tmp/aios-install-root}"
DB="$ROOT/var/lib/aipkg/installed.db"
UPDATES="$ROOT/var/lib/aipkg/updates.pending"
SNAPDIR="$ROOT/.snapshots"
mkdir -p "$(dirname "$DB")" "$SNAPDIR"
mk_snap(){ id="snap-$(date +%s)"; mkdir -p "$SNAPDIR/$id"; echo "$id" > "$ROOT/var/lib/aipkg/last-snapshot"; echo "$id"; }
case "${1:-help}" in
  install) echo "install ${2:-pkg}" >> "$DB" ;;
  update) echo "pkgA\npkgB" > "$UPDATES"; echo "update metadata refreshed" ;;
  upgrade) sid=$(mk_snap); echo "upgraded at $sid" >> "$ROOT/var/log/aipkg-upgrade.log"; : > "$UPDATES"; echo "upgrade complete snapshot=$sid" ;;
  rollback) test -d "$SNAPDIR/${2:?snapshot}"; echo "rollback stub to ${2}" ;;
  status) echo "pending_updates=$(wc -l < "$UPDATES" 2>/dev/null || echo 0)"; echo "last_snapshot=$(cat "$ROOT/var/lib/aipkg/last-snapshot" 2>/dev/null || echo none)" ;;
  *) echo "usage: aipkg.sh {install|update|upgrade|rollback <snap>|status}";;
esac
