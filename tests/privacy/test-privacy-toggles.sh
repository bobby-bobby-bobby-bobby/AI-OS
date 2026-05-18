#!/bin/sh
set -eu
st=/tmp/aios-privacy-test
AIOS_PRIVACY_STATE=$st privacy/ui/privacy-dashboard.sh toggle camera | grep -q 'camera='
AIOS_PRIVACY_STATE=$st privacy/ui/ai-privacy-modes.sh set no_telemetry on | grep -q 'no_telemetry=on'
AIOS_PRIVACY_STATE=$st privacy/ui/privacy-dashboard.sh status | grep -q 'camera='
echo "privacy-toggles: PASS"
