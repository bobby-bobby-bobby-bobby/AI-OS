#!/bin/sh
set -eu
echo "Select browser: firefox chromium brave"
choice="${1:-firefox}"
"$(dirname "$0")/installers/${choice}.sh"
