#!/bin/sh
set -eu
exec ./security/sandbox/sandbox-launch.sh browser "${1:-/bin/sh}"
