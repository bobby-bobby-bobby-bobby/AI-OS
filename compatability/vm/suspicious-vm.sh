#!/bin/sh
# AI-OS Suspicious File VM — Disposable sandbox

set -e

VM_DIR="${HOME}/.aios/vms/suspicious"
BASE_DISK="${VM_DIR}/base.qcow2"
DISK_SIZE="8G"
VM_MEM="${VM_MEM:-1024}"

usage() {
    echo "Usage: suspicious-vm [setup|run [file]|clean]"
    echo ""
    echo "Disposable VM for analyzing suspicious files."
    echo "Each run starts fresh — no state is preserved."
    echo ""
    echo "  setup       Create base VM image"
    echo "  run [file]  Start disposable VM (optionally with a file to examine)"
    echo "  clean       Remove all VM data"
}

vm_setup() {
    mkdir -p "${VM_DIR}"
    if [ ! -f "${BASE_DISK}" ]; then
        qemu-img create -f qcow2 "${BASE_DISK}" "${DISK_SIZE}"
        echo "Suspicious File VM base disk created."
        echo "Install a minimal OS in it using:"
        echo "  suspicious-vm run --install /path/to/os.iso"
    fi
}

vm_run() {
    local file="${1:-}"
    local tmp_disk="${VM_DIR}/session-$$.qcow2"

    echo "Starting disposable Suspicious File VM..."
    echo "  (all changes will be DISCARDED when closed)"

    # Create a temporary overlay disk
    if command -v qemu-img >/dev/null 2>&1 && [ -f "${BASE_DISK}" ]; then
        qemu-img create -f qcow2 -b "${BASE_DISK}" -F qcow2 "${tmp_disk}"
        trap 'rm -f "${tmp_disk}"' EXIT
    fi

    local disk_opt="-drive file=${BASE_DISK},format=qcow2,snapshot=on"
    local share_opt=""
    if [ -n "${file}" ] && [ -f "${file}" ]; then
        share_opt="-virtfs local,path=$(dirname "${file}"),mount_tag=shared,security_model=none,id=shared0"
        echo "  File shared: ${file}"
    fi

    qemu-system-x86_64 \
        -name "Suspicious File VM [DISPOSABLE]" \
        -m "${VM_MEM}" \
        -smp 2 \
        -enable-kvm \
        ${disk_opt} \
        ${share_opt} \
        -vga virtio \
        -nic "user,restrict=yes" \
        -display gtk 2>/dev/null || \
    qemu-system-x86_64 \
        -name "Suspicious File VM [DISPOSABLE]" \
        -m "${VM_MEM}" \
        ${disk_opt} \
        -vga std \
        -nic "user,restrict=yes"

    echo "Session ended. All VM data discarded."
}

case "${1:-help}" in
    setup) vm_setup ;;
    run)   vm_run "${2:-}" ;;
    clean) rm -rf "${VM_DIR}" && echo "Cleaned." ;;
    help|"") usage ;;
    *)     echo "Unknown: $1" >&2; exit 1 ;;
esac
