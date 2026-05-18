#!/bin/sh
set -eu
ai/ui/ai-sidebar.sh | grep -q 'AI Sidebar'
echo "sidebar-integration: PASS"
