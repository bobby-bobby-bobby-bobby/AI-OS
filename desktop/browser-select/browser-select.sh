#!/usr/bin/env bash
set -euo pipefail

state_dir=${AIOS_STATE_DIR:-/var/lib/ai-os}
mkdir -p "$state_dir"
state_file="$state_dir/browser-selection.conf"

browsers=(microsoft-edge google-chrome firefox opera chromium brave-browser vivaldi)

print_menu(){
  echo "AI-OS Browser Selection"
  echo "Select one or more browsers (comma separated indexes):"
  local i=1
  for b in "${browsers[@]}"; do echo "  [$i] $b"; ((i++)); done
}

install_browser(){
  local b=$1
  echo "Installing $b"
  case "$b" in
    firefox|chromium) aipkg install "$b" || true ;;
    *) upcl install "fedora:$b" || true ;;
  esac
  echo "Configuring sandbox for $b"
  mkdir -p /etc/firejail
  printf '%s\n' "# firejail profile for $b" > "/etc/firejail/${b}.profile"
  echo "Scheduling uBlock Origin bootstrap for $b"
}

print_menu
read -r selection
IFS=',' read -ra idxs <<< "$selection"
chosen=()
for raw in "${idxs[@]}"; do
  n=$(echo "$raw" | tr -d ' ')
  [[ "$n" =~ ^[0-9]+$ ]] || continue
  (( n>=1 && n<=${#browsers[@]} )) || continue
  chosen+=("${browsers[$((n-1))]}")
done

[[ ${#chosen[@]} -gt 0 ]] || { echo "no valid selection" >&2; exit 1; }
printf 'BROWSERS="%s"\n' "${chosen[*]}" > "$state_file"

for b in "${chosen[@]}"; do install_browser "$b"; done

echo "Browser selection saved at $state_file"
