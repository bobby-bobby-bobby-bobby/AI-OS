#!/bin/sh
set -eu
log=/var/log/permissions-daemon.log
fifo=/tmp/permissions-daemon.fifo
resp=/tmp/permissions-daemon.resp
db=/etc/ai-os/app-permissions.conf
mkdir -p /var/log /tmp /etc/ai-os
: > "$log"; touch "$db"
[ -p "$fifo" ] || mkfifo "$fifo"
echo "permissions-daemon: start" >> "$log"
while read -r req < "$fifo"; do
  case "$req" in
    request:*)
      app=${req#request:}; app=${app%%:*}; perm=${req##*:}
      echo "prompt $app wants $perm (auto-deny stub)" >> "$log"
      echo "deny" > "$resp" ;;
    grant:*)
      payload=${req#grant:}
      app=${payload%%:*}; rule=${payload#*:}
      ./security/sandbox/sandboxctl set "$app" "$rule"
      echo "granted" > "$resp" ;;
    status) echo "ok" > "$resp" ;;
    stop) echo "permissions-daemon: stop" >> "$log"; rm -f "$fifo"; exit 0 ;;
    *) echo "unknown" > "$resp" ;;
  esac
done
