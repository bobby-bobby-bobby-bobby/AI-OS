#!/bin/sh
set -eu
exec firejail --profile=security/firejail/aish.profile "$@"
