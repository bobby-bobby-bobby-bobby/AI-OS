#!/bin/sh
set -eu
q="${1:-}"
rg -n "$q" apps config settings 2>/dev/null | awk 'NR<=15{print $0" rank="(100-NR)}'
