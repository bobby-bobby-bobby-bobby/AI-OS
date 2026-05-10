#!/bin/sh
set -eu
ROOT="${AIOS_ROOT:-/}"
DB="$ROOT/var/lib/aipkg/installed.db"
UPCL_DIR="${UPCL_DIR:-./compatibility/packages}"
SNAPSHOT_DIR="$ROOT/.snapshots"
mkdir -p "$(dirname "$DB")" "$SNAPSHOT_DIR"

snapshot() { echo "snapshot $(date +%s)" > "$SNAPSHOT_DIR/last"; }
resolve() { ./pkgmgr/dependency-resolver.sh "$@"; }
upcl_extract() {
  case "$1" in
    *.deb) "$UPCL_DIR/deb-extract.sh" "$1" ;;
    *.rpm) "$UPCL_DIR/rpm-extract.sh" "$1" ;;
    *.AppImage) "$UPCL_DIR/appimage-handler.sh" "$1" ;;
    *) echo "unknown external format: $1"; return 1 ;;
  esac
}
install_pkg() { snapshot; resolve "$1"; echo "$1 $ROOT/usr" >> "$DB"; echo "installed $1"; }
case "${1:-help}" in
  install) install_pkg "${2:?package}" ;;
  extract) upcl_extract "${2:?file}" ;;
  list) cat "$DB" 2>/dev/null || true ;;
  *) echo "usage: aipkg.sh {install <pkg>|extract <file>|list}" ;;
esac
