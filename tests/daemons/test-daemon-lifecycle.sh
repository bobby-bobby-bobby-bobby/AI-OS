#!/bin/sh
set -eu
mkdir -p tests/logs /etc/ai-os /etc/ai-os/services /var/log
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
cat > /etc/ai-os/ui.conf <<CFG
theme=dark
CFG
echo 'A11Y_HIGH_CONTRAST=on' > /etc/firstboot.conf
fail=0
for s in services/*.sh; do
  n=$(basename "$s" .sh)
  sh "$s" &
  pid=$!
  sleep 0.1
  echo ping > /tmp/$n.fifo
  sleep 0.1
  grep -q 'pong' /tmp/$n.resp || { echo "no pong $n"; fail=1; }
  echo status > /tmp/$n.fifo
  sleep 0.1
  grep -q 'locale=' /tmp/$n.resp || { echo "no status $n"; fail=1; }
  test -f /var/log/$n.log || { echo "no log $n"; fail=1; }
  echo stop > /tmp/$n.fifo
  wait $pid || true
  cp /var/log/$n.log tests/logs/daemon-$n.log
done
[ "$fail" -eq 0 ] && echo "daemon-lifecycle-test: PASS"
