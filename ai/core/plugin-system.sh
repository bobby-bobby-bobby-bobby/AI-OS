#!/bin/sh
set -eu
plugdir="${AIOS_AI_PLUGIN_DIR:-ai/core/plugins}"
cmd="${1:-list}"
case "$cmd" in
  list) ls "$plugdir"/*.plugin 2>/dev/null | xargs -n1 basename 2>/dev/null || true ;;
  load)
    p="$plugdir/${2:?}.plugin"
    [ -f "$p" ] || { echo "missing plugin"; exit 1; }
    cat "$p" ;;
  run)
    p="$plugdir/${2:?}.plugin"
    [ -f "$p" ] || { echo "missing plugin"; exit 1; }
    awk -F= '/^handler=/{print $2}' "$p" | sh -s -- "${3:-}" ;;
esac
