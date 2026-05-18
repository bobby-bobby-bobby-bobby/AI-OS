#!/bin/sh
set -eu
queue=/tmp/ai-task-queue
cmd="${1:-list}"
case "$cmd" in
  add) echo "${2:-task}" >> "$queue" ;;
  run) head -n1 "$queue" 2>/dev/null || true ;;
  list) cat "$queue" 2>/dev/null || true ;;
  clear) : > "$queue" ;;
esac
