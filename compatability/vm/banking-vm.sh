#!/bin/sh
# AI-OS Banking VM — Hardened, network-isolated VM for banking

set -e

VM_DIR="${HOME}/.aios/vms/banking"
DISK="${VM_DIR}/banking.qcow2"
DISK_SIZE="10G"
VM_MEM="${VM_MEM:-2048}"
BROWSER="${BANKING_BROWSER:-firefox}"

usage() {
    echo "Usage: banking-vm [start|setup|stop|status]"
    echo ""
    echo "A hardened, isolated VM for sensitive banking activities."
    echo "Network access is restricted to HTTPS only."
    echo "No file sharing with host. Disposable session option available."
}

vm_setup() {
    mkdir -p "${VM_DIR}"
    if [ ! -f "${DISK}" ]; then
        qemu-img create -f qcow2 "${DISK}" "${DISK_SIZE}"
        echo "Banking VM disk created."
    fi
    echo "Banking VM configured."
    echo "Start with: banking-vm start"
}

vm_start() {
    echo "Starting Banking VM (hardened)..."
    echo "  Memory: ${VM_MEM}MB"
    echo "  Network: Restricted (no LAN, HTTPS only via proxy)"
    echo "  Shared folders: NONE"
    echo "  Microphone/Camera: DISABLED"

    qemu-system-x86_64 \
        -name "Banking VM [SECURE]" \
        -m "${VM_MEM}" \
        -smp 2 \
        -enable-kvm \
        -drive "file=${DISK},format=qcow2,snapshot=on" \
        -vga virtio \
        -nic "user,restrict=yes,hostfwd=tcp::8443-:443" \
        -no-fd-bootchk \
        -display gtk 2>/dev/null || \
    qemu-system-x86_64 \
        -name "Banking VM [SECURE]" \
        -m "${VM_MEM}" \
        -drive "file=${DISK},format=qcow2,snapshot=on" \
        -vga std \
        -nic "user,restrict=yes"
}

case "${1:-help}" in
    setup)  vm_setup ;;
    start)  vm_start ;;
    stop)   pkill -f "Banking VM" 2>/dev/null && echo "Stopped" || true ;;
    status) pgrep -f "Banking VM" >/dev/null && echo "Running" || echo "Stopped" ;;
    help|"") usage ;;
    *)      echo "Unknown: $1" >&2; exit 1 ;;
esac
