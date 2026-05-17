#!/bin/sh
set -eu
lang="${1:-}"; [ -n "$lang" ] || { echo "usage: lang.sh <language>"; exit 1; }
entry=$(awk -v l="$lang" 'tolower($0) ~ "name: " tolower(l) {getline; print $2}' langmgr/registry.yaml || true)
if [ -z "$entry" ]; then echo "unknown language: $lang"; exit 1; fi
echo "install runtime for $lang via $entry (stub)"
case "$lang" in BASIC) echo "DOSBox integration point";; COBOL|Fortran) echo "native toolchain integration point";; esac
