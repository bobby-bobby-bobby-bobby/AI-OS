#!/bin/sh
# AI-OS Developer VM

set -e

VM_DIR="${HOME}/.aios/vms/dev"
DISK="${VM_DIR}/dev.qcow2"
DISK_SIZE="40G"
VM_MEM="${VM_MEM:-4096}"
VM_CPUS="${VM_CPUS:-4}"

usage() {
    echo "Usage: dev-vm [setup|start|stop|ssh|status]"
    echo ""
    echo "Developer VM with full network access, SSH, and shared /home folder."
    echo ""
    echo "  setup   Create VM disk"
    echo "  start   Start the developer VM"
    echo "  stop    Stop the VM"
    echo "  ssh     SSH into the running VM"
    echo "  status  Show VM status"
}

vm_setup() {
    mkdir -p "${VM_DIR}"
    [ ! -f "${DISK}" ] && qemu-img create -f qcow2 "${DISK}" "${DISK_SIZE}"
    echo "Developer VM disk created: ${DISK}"
    echo "Install your preferred OS using:"
    echo "  dev-vm start --iso /path/to/distro.iso"
}

vm_start() {
    echo "Starting Developer VM..."
    local iso_opt=""
    [ -n "${ISO:-}" ] && iso_opt="-cdrom ${ISO} -boot order=dc"

    qemu-system-x86_64 \
        -name "Developer VM" \
        -m "${VM_MEM}" \
        -smp "${VM_CPUS}" \
        -enable-kvm \
        -drive "file=${DISK},format=qcow2,if=virtio" \
        ${iso_opt} \
        -vga virtio \
        -nic "user,model=virtio,hostfwd=tcp::2222-:22" \
        -virtfs "local,path=${HOME},mount_tag=home,security_model=none" \
        -display gtk,gl=on \
        -daemonize \
        -pidfile "${VM_DIR}/dev.pid" 2>/dev/null || \
    qemu-system-x86_64 \
        -name "Developer VM" \
        -m "${VM_MEM}" \
        -smp "${VM_CPUS}" \
        -drive "file=${DISK},format=qcow2" \
        ${iso_opt} \
        -nic "user,hostfwd=tcp::2222-:22" \
        -daemonize \
        -pidfile "${VM_DIR}/dev.pid"
    echo "Developer VM started. SSH: ssh -p 2222 user@localhost"
}

while [ $# -gt 0 ]; do
    case "$1" in --iso) ISO="$2"; shift 2 ;; --mem) VM_MEM="$2"; shift 2 ;; *) break ;; esac
done

case "${1:-help}" in
    setup)  vm_setup ;;
    start)  vm_start ;;
    stop)   kill "$(cat "${VM_DIR}/dev.pid" 2>/dev/null)" 2>/dev/null && echo "Stopped" || true ;;
    ssh)    ssh -p 2222 -o StrictHostKeyChecking=no "$(whoami)@localhost" ;;
    status) pgrep -f "Developer VM" >/dev/null && echo "Running" || echo "Stopped" ;;
    help|"") usage ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
esac
