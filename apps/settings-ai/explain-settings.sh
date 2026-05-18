#!/bin/sh
set -eu
setting="${*:-general settings}"
ai/core/api/ai-api.sh summarize "$setting"
