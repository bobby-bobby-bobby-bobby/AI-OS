#!/bin/sh
set -eu
AIOS_MODEL_STATE=/tmp/ai-model-state ai/model-manager/model-selector.sh swap medium | grep -q 'hot-swapped=medium'
AIOS_MODEL_STATE=/tmp/ai-model-state ai/model-manager/model-ui.sh accuracy | grep -q 'ui=accuracy'
echo "ai-model-hot-swap: PASS"
