#!/bin/sh
set -eu
log=/var/log/perf-daemon.log
fifo=/tmp/perf-daemon.fifo
resp=/tmp/perf-daemon.resp
state=/tmp/perf-profile.state
mkdir -p /var/log /tmp
: > "$log"
[ -p "$fifo" ] || mkfifo "$fifo"
[ -f "$state" ] || echo balanced > "$state"
echo "perf-daemon: start" >> "$log"
while true; do
  if read -r cmd < "$fifo"; then
    case "$cmd" in
      status)
        prof=$(cat "$state")
        cpu=$(awk '/cpu /{print 100-($5*100/($2+$3+$4+$5))}' /proc/stat 2>/dev/null | cut -d. -f1)
        mem=$(awk '/MemTotal|MemAvailable/{print $2}' /proc/meminfo 2>/dev/null | tr '\n' ' ')
        echo "profile=$prof cpu=${cpu:-na} mem='$mem' io=stub" > "$resp"
        echo "perf-daemon: status" >> "$log" ;;
      set:*) p=${cmd#set:}; echo "$p" > "$state"; echo "ok" > "$resp"; echo "perf-daemon: set $p" >> "$log" ;;
      stop) echo "perf-daemon: stop" >> "$log"; rm -f "$fifo"; exit 0 ;;
      *) echo "unknown" > "$resp" ;;
    esac
  fi
done
