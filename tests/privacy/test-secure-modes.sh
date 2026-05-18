#!/bin/sh
set -eu
AIOS_PRIVACY_STATE=/tmp/aios-privacy-test privacy/ui/ai-privacy-modes.sh set local_only_ai on >/tmp/mode.log
grep -q 'local_only_ai=on' /tmp/mode.log
privacy/tools/secure-tmp-manager.sh /tmp/aios-secure-test | grep -q secure-tmp
echo secret > /tmp/shred.me
privacy/tools/secure-shredder.sh /tmp/shred.me | grep -q shredded
echo "secure-modes: PASS"
