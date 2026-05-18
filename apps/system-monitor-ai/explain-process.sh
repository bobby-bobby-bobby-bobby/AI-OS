#!/bin/sh
set -eu
p="${*:-process}"
ai/core/api/ai-api.sh suggest "why is $p running"
