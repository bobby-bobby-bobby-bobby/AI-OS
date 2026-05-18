#!/bin/sh
set -eu
vault="${1:-/tmp/aios.vault.tar.enc}"; shift || true
key="${AIOS_VAULT_KEY:-aiosvault}"
cmd="${1:-create}"; shift || true
case "$cmd" in
  create) tar -cf /tmp/aios-vault.tar "${1:-privacy}" 2>/dev/null || tar -cf /tmp/aios-vault.tar privacy; openssl enc -aes-256-cbc -pbkdf2 -pass pass:"$key" -in /tmp/aios-vault.tar -out "$vault" 2>/dev/null; echo "vault:$vault" ;;
  extract) openssl enc -d -aes-256-cbc -pbkdf2 -pass pass:"$key" -in "$vault" -out /tmp/aios-vault.tar 2>/dev/null; mkdir -p /tmp/aios-vault-out; tar -xf /tmp/aios-vault.tar -C /tmp/aios-vault-out; echo "extracted:/tmp/aios-vault-out" ;;
esac
