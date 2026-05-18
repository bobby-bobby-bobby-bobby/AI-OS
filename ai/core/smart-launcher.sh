#!/bin/sh
set -eu
q="${1:-}"
awk -v q="$q" 'BEGIN{IGNORECASE=1} $0~q{print "predicted:"$0}' apps/app-registry.txt | head -n 5
