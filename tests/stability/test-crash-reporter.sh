#!/bin/sh
set -eu
services/crash-reporter.sh "test crash"
grep -q "test crash" /var/log/aios-crash/reports.log
echo "crash-reporter: PASS"
