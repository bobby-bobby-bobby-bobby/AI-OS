#!/bin/sh
set -eu
mkdir -p tests/logs
./login/greeter.sh aiuser > tests/logs/core-login.log
./login/lock-screen.sh >> tests/logs/core-login.log
./login/session-switcher.sh default >> tests/logs/core-login.log
grep -q 'Greeter' tests/logs/core-login.log
echo "core-login-test: PASS"
