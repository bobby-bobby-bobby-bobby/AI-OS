#!/bin/sh
set -eu
state_dir="${AIOS_MODEL_STATE:-/var/lib/aios-models}"
mkdir -p "$state_dir"
arch=$(uname -m)
gpu=$(lspci 2>/dev/null | awk '/VGA|3D|Display/{print tolower($0)}' | head -n1)
[ -n "$gpu" ] || gpu="unknown"
case "$gpu" in
  *nvidia*|*amd*|*radeon*) tier=high ;;
  *intel*|*mali*) tier=mid ;;
  *) tier=low ;;
esac
case "$arch:$tier" in
  x86_64:high) model=large ;;
  x86_64:mid) model=medium ;;
  aarch64:high|arm64:high) model=medium ;;
  aarch64:*|arm64:*) model=small ;;
  *) model=small ;;
esac
cmd="${1:-select}"
case "$cmd" in
  detect) echo "arch=$arch gpu=$gpu tier=$tier" ;;
  select) echo "$model" > "$state_dir/current-model"; echo "selected=$model" ;;
  swap) new="${2:?}"; echo "$new" > "$state_dir/current-model"; echo "hot-swapped=$new" ;;
  current) cat "$state_dir/current-model" 2>/dev/null || echo "$model" ;;
  *) exit 1 ;;
esac
