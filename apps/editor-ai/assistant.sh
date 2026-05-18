#!/bin/sh
set -eu
cmd="${1:-autocomplete}"; shift || true
case "$cmd" in
  autocomplete) ai/core/api/ai-api.sh suggest "${*:-code}" ;;
  rewrite) ai/core/api/ai-api.sh summarize "${*:-text}" ;;
esac
