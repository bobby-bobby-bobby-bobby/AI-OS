#!/bin/sh
set -eu
AIOS_MODEL_STATE=/tmp/ai-model-state ai/model-manager/model-selector.sh select | grep -q 'selected='
AIOS_MODEL_STATE=/tmp/ai-model-state ai/model-manager/model-selector.sh current | grep -Eq 'small|medium|large'
echo "ai-model-selection: PASS"
