#!/usr/bin/env bash
set -euo pipefail
root_mnt=${1:?root}
mkdir -p "$root_mnt/etc"
cat > "$root_mnt/etc/resolv.conf" <<'DNS'
nameserver 1.1.1.1
nameserver 9.9.9.9
DNS
cat > "$root_mnt/etc/network.conf" <<'NET'
AUTO_DHCP=1
PREFERRED_STACK=dual
NET
echo "network defaults written"
