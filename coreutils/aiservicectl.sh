#!/bin/sh
set -eu
action="${1:-status}"; svc="${2:-all}"
echo "aiservicectl $action $svc (init wrapper stub)"
