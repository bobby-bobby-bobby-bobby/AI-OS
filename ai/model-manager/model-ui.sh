#!/bin/sh
set -eu
mode="${1:-status}"
case "$mode" in
  status) ai/model-manager/model-selector.sh detect; echo "current=$(ai/model-manager/model-selector.sh current)" ;;
  performance) ai/model-manager/model-selector.sh swap small ; echo "ui=performance" ;;
  balanced) ai/model-manager/model-selector.sh swap medium ; echo "ui=balanced" ;;
  accuracy) ai/model-manager/model-selector.sh swap large ; echo "ui=accuracy" ;;
esac
