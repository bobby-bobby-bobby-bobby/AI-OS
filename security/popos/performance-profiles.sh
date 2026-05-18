#!/bin/sh
set -eu
profile="${1:-balanced}"
echo "$profile" > /tmp/aios-performance-profile
echo "performance profile: $profile"
