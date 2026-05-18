#!/bin/sh
set -eu
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
host=$(uname -m)
target="${TARGET_ARCH:-$host}"
if [ "$host" = "$target" ]; then
  echo "native arch ($host): qemu optional, skipping by default"
  exit 0
fi
echo "emulation required host=$host target=$target"
