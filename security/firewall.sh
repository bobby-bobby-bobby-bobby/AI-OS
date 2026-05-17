#!/usr/bin/env bash
set -euo pipefail

if command -v nft >/dev/null 2>&1; then
  nft -f - <<'NFT'
flush ruleset
table inet filter {
  chain input { type filter hook input priority 0; policy drop;
    iif "lo" accept
    ct state established,related accept
    tcp dport {22,53,80,443} accept
    udp dport {53,67,68} accept
  }
  chain forward { type filter hook forward priority 0; policy drop; }
  chain output { type filter hook output priority 0; policy accept; }
}
NFT
else
  echo "nft command not available" >&2
  exit 1
fi
