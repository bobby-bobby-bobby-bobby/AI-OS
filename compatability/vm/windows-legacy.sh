#!/bin/sh
# AI-OS Windows Legacy Mode VM
# QEMU wrapper for running legacy Windows (evaluation/user-supplied ISO).

set -e

VM_DIR="${HOME}/.aios/vms/windows-legacy"
DISK="${VM_DIR}/windows.qcow2"
DISK_SIZE="60G"
VM_MEM="${VM_MEM:-4096}"
VM_CPUS="${VM_CPUS:-4}"

usage() {
    cat <<EOF
AI-OS Windows Legacy Mode VM

Usage: windows-legacy [command] [options]

Commands:
  setup     Create VM disk and configure (run once)
  start     Start the Windows VM (GUI)
  headless  Start in headless mode (RDP access)
  run <exe> Run a Windows executable in the VM
  stop      Stop the VM
  status    Show VM status

Options:
  --iso <path>    Windows ISO to boot from
  --mem <MB>      RAM in MB (default: 4096)
  --cpus <n>      CPU count (default: 4)

Note: Windows itself is NOT included. You must provide your own ISO.
      Windows evaluation ISOs are available from Microsoft's website.
EOF
}

vm_setup() {
    mkdir -p "${VM_DIR}"
    if [ ! -f "${DISK}" ]; then
        echo "Creating Windows VM disk (${DISK_SIZE})..."
        qemu-img create -f qcow2 "${DISK}" "${DISK_SIZE}"
        echo "Disk created: ${DISK}"
    else
        echo "Disk already exists: ${DISK}"
    fi
    echo ""
    echo "Next steps:"
    echo "  1. Obtain a Windows ISO (evaluation available from Microsoft)"
    echo "  2. Run: windows-legacy start --iso /path/to/windows.iso"
    echo "  3. Install Windows from the ISO"
    echo "  4. After installation, run: windows-legacy start"
}

vm_start() {
    local iso_opt=""
    if [ -n "${ISO:-}" ]; then
        iso_opt="-cdrom ${ISO} -boot order=dc"
    fi

    echo "Starting Windows Legacy VM..."
    qemu-system-x86_64 \
        -name "Windows Legacy" \
        -m "${VM_MEM}" \
        -smp "${VM_CPUS}" \
        -enable-kvm \
        -machine q35 \
        -cpu host \
        -drive "file=${DISK},format=qcow2,if=virtio" \
        ${iso_opt} \
        -vga qxl \
        -device virtio-net-pci,netdev=net0 \
        -netdev "user,id=net0,smb=${HOME}" \
        -usbdevice tablet \
        -rtc "base=localtime,clock=host" \
        -audiodev pa,id=snd0 \
        -device ich9-intel-hda \
        -device hda-duplex,audiodev=snd0 \
        -display gtk,gl=on 2>/dev/null || \
    qemu-system-x86_64 \
        -name "Windows Legacy" \
        -m "${VM_MEM}" \
        -smp "${VM_CPUS}" \
        -drive "file=${DISK},format=qcow2" \
        ${iso_opt} \
        -vga std \
        -nic "user,smb=${HOME}" \
        -display sdl
}

# Parse arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --iso)  ISO="$2"; shift 2 ;;
        --mem)  VM_MEM="$2"; shift 2 ;;
        --cpus) VM_CPUS="$2"; shift 2 ;;
        -h|--help) usage; exit 0 ;;
        --)  shift; break ;;
        *)   break ;;
    esac
done

COMMAND="${1:-help}"
shift || true

case "${COMMAND}" in
    setup)    vm_setup ;;
    start)    vm_start ;;
    stop)     pkill -f "Windows Legacy" 2>/dev/null && echo "Stopped" || echo "Not running" ;;
    status)   pgrep -f "Windows Legacy" >/dev/null && echo "Running" || echo "Stopped" ;;
    run)      echo "TODO: file sharing with running VM for: $1" ;;
    help|"")  usage ;;
    *)        echo "Unknown command: ${COMMAND}" >&2; exit 1 ;;
esac
