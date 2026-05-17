#!/usr/bin/env bash
set -euo pipefail

vm_dir=${AIOS_VM_DIR:-$HOME/.local/share/ai-os/vms}
mkdir -p "$vm_dir"

usage(){ echo "usage: vm-manager <list|run> [profile]"; }
run_profile(){
  case "$1" in
    windows-legacy|banking-vm|suspicious-vm|dev-vm|browser-vm)
      "$(dirname "$0")/$1.sh"
      ;;
    *) echo "unknown profile: $1" >&2; exit 1;;
  esac
}

case "${1:-}" in
  list) printf '%s\n' windows-legacy banking-vm suspicious-vm dev-vm browser-vm ;;
  run) run_profile "${2:-}" ;;
  *) usage; exit 1 ;;
esac
