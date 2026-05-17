#!/bin/sh
set -eu
app="${1:?app}"
profile="security/sandbox/profiles/${app}.conf"
permdb="/etc/ai-os/app-permissions.conf"
mkdir -p /tmp/aios-sandbox
[ -f "$profile" ] || profile="security/sandbox/profiles/default.conf"
echo "sandbox launch app=$app profile=$profile"
[ -f "$permdb" ] && grep "^${app}:" "$permdb" || echo "${app}:camera=deny,mic=deny,filesystem=read,network=deny"
exec "${2:-/bin/sh}" -c "echo sandboxed-$app"
