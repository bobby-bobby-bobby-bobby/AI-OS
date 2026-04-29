#!/usr/bin/env bash
set -euo pipefail
op=${1:?}; arg=${2:?}
case "$op" in
  install) echo "integration target: $arg" ;;
  *) exit 1 ;;
esac
