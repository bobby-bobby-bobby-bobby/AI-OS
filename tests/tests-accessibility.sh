#!/bin/sh
set -eu
mkdir -p tests/logs
for f in accessibility/atspi-bridge.sh accessibility/screen-reader.sh accessibility/osk.sh accessibility/display-a11y.sh settings/accessibility/endpoints.sh; do
  test -x "$f"
done
settings/accessibility/endpoints.sh > tests/logs/accessibility-endpoints.log
echo "a11y-test: PASS"
