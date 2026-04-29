#!/usr/bin/env bash
set -euo pipefail

report_dir=${AIOS_HW_REPORT_DIR:-/tmp/ai-os-installer}
mkdir -p "$report_dir"

lscpu > "$report_dir/cpu.txt" 2>/dev/null || true
lsblk -f > "$report_dir/storage.txt" 2>/dev/null || true
lspci -nn > "$report_dir/pci.txt" 2>/dev/null || true
lsusb > "$report_dir/usb.txt" 2>/dev/null || true

if grep -qi nvidia "$report_dir/pci.txt"; then echo nvidia > "$report_dir/gpu-vendor";
elif grep -Eqi 'amd|ati' "$report_dir/pci.txt"; then echo amd > "$report_dir/gpu-vendor";
else echo intel > "$report_dir/gpu-vendor"; fi

echo "hardware report generated in $report_dir"
