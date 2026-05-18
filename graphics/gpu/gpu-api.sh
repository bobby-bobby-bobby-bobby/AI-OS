#!/bin/sh
set -eu
vendor=$(./graphics/gpu/gpu-detect.sh)
cmd="${1:-status}"
case "$cmd" in
  status) echo "gpu=$vendor acceleration=$( [ "$vendor" = software ] && echo off || echo on )" ;;
  composite) echo "composite via $vendor" ;;
  animate) echo "animate via $vendor" ;;
  render) echo "render via $vendor" ;;
  fallback) echo "software fallback renderer active" ;;
  *) echo "usage: gpu-api.sh {status|composite|animate|render|fallback}"; exit 1;;
esac
