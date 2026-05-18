#!/bin/sh
set -eu
name=$(basename "$0" .sh)
log="/var/log/${name}.log"
conf="/etc/ai-os/services/${name}.conf"
ipc_in="/tmp/${name}.fifo"
ipc_out="/tmp/${name}.resp"
mkdir -p /var/log /tmp
[ -f "$conf" ] || true
: > "$log"
echo "$name: start" >> "$log"
[ -p "$ipc_in" ] || mkfifo "$ipc_in"
while true; do
  if read -r cmd < "$ipc_in"; then
    case "$cmd" in
      ping) echo "pong" > "$ipc_out"; echo "$name: ping" >> "$log" ;;
      status) echo "locale=$(grep '^LANG=' /etc/locale.conf 2>/dev/null | cut -d= -f2 || echo C) theme=$(grep '^theme=' /etc/ai-os/ui.conf 2>/dev/null | cut -d= -f2 || echo default) a11y=$(grep '^A11Y_HIGH_CONTRAST=' /etc/firstboot.conf 2>/dev/null | cut -d= -f2 || echo off)" > "$ipc_out"; echo "$name: status" >> "$log" ;;
      stop) echo "$name: stop" >> "$log"; rm -f "$ipc_in"; exit 0 ;;
      *) echo "unknown" > "$ipc_out"; echo "$name: unknown $cmd" >> "$log" ;;
    esac
  fi
done
