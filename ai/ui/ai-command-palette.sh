#!/bin/sh
set -eu
query="${*:-help}"
ai/core/api/ai-api.sh suggest "$query"
