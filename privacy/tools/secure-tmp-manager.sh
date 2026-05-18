#!/bin/sh
set -eu
dir="${1:-/tmp/aios-secure-tmp}"
mkdir -p "$dir"
chmod 700 "$dir"
echo "secure-tmp:$dir"
