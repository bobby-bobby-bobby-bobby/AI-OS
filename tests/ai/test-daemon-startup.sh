#!/bin/sh
set -eu
rm -f /tmp/ai-assistant.fifo /tmp/ai-assistant.resp
ai/core/assistant-daemon.sh &
pid=$!
sleep 0.2
[ -p /tmp/ai-assistant.fifo ]
ai/core/assistant-daemon-client.sh summarize "hello world" | grep -q '^summary:'
printf 'stop\n' > /tmp/ai-assistant.fifo
wait "$pid"
echo "ai-daemon-startup: PASS"
