#!/bin/sh
set -eu
cmd="${1:-installed}"; arg="${2:-}"
case "$cmd" in
  installed) ./store/backend/list-installed.sh ;;
  available) ./store/backend/list-available.sh ;;
  install) ./store/backend/install.sh "$arg" ;;
  update) ./store/backend/update.sh "$arg" ;;
  remove) ./store/backend/remove.sh "$arg" ;;
  *) echo "usage: store-ui.sh {installed|available|install|update|remove}"; exit 1 ;;
esac
