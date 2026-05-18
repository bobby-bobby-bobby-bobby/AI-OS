#!/bin/sh
set -eu
target="${1:-latest}"
AIOS_INSTALL_ROOT="${AIOS_INSTALL_ROOT:-/tmp/aios-install-root}" recovery/ui/snapshot-restore.sh "$target"
