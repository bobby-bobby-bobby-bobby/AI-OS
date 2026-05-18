#!/bin/sh
set -eu
bash tests/ai-models/test-model-selection.sh
bash tests/ai-models/test-model-hot-swap.sh
