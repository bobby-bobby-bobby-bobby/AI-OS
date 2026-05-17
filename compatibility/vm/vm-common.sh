#!/bin/sh
set -eu
profile="${1:?profile}"; shift
echo "launching VM profile=$profile image=/var/lib/ai-os/vm/${profile}.qcow2"
exec echo "qemu-system-x86_64 stub $*"
