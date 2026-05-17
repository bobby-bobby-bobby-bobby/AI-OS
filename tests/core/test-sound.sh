#!/bin/sh
set -eu
mkdir -p tests/logs
./sound/sound-settings.sh > tests/logs/core-sound.log
./sound/audio-device-selector.sh headphones >> tests/logs/core-sound.log
./sound/volume-osd.sh 42 >> tests/logs/core-sound.log
./sound/microphone-controls.sh 80 off >> tests/logs/core-sound.log
./sound/mute-indicator.sh on >> tests/logs/core-sound.log
grep -q 'sound settings' tests/logs/core-sound.log
echo "core-sound-test: PASS"
