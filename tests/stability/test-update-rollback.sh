#!/bin/sh
set -eu
mkdir -p store/repo/updates/changelogs
cat > store/repo/updates/index.csv <<CSV
1.0.1,stable,delta-100-101
1.1.0,beta,delta-101-110
1.2.0,nightly,delta-110-120
CSV
echo "fixes and hardening" > store/repo/updates/changelogs/1.0.1.txt
AIOS_STATE_ROOT=/tmp/aios-update services/update-daemon.sh apply 1.0.1 >/tmp/u.log
AIOS_STATE_ROOT=/tmp/aios-update services/update-daemon.sh rollback >>/tmp/u.log
grep -q "rolled back" /tmp/u.log
echo "update-rollback: PASS"
