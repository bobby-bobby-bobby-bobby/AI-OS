#!/usr/bin/env bash
set -euo pipefail
root_mnt=${1:?root}; username=${2:-aiuser}
mkdir -p "$root_mnt/etc/ai-os"
cat > "$root_mnt/etc/ai-os/encryption.conf" <<EOF2
ENABLE_ENCRYPTED_HOME=${AIOS_ENABLE_ENCRYPTED_HOME:-0}
METHOD=${AIOS_ENCRYPTION_METHOD:-fscrypt}
USER=$username
EOF2
echo "encrypted home configuration generated"
