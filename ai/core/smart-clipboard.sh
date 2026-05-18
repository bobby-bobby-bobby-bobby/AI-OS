#!/bin/sh
set -eu
db=/tmp/ai-clipboard.hist
cmd="${1:-list}"
case "$cmd" in
  add) echo "$(date +%s)|${2:-}" >> "$db" ;;
  list) tail -n 20 "$db" 2>/dev/null || true ;;
  suggest) last=$(tail -n1 "$db" 2>/dev/null | cut -d'|' -f2-); echo "suggest:${last%% *}" ;;
esac
