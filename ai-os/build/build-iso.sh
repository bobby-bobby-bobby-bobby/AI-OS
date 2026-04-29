#!/bin/sh
set -e

ROOTFS=rootfs
ISO=ai-os.iso

echo "[*] Building ISO..."

mkdir -p iso/boot
cp kernel/linux/arch/x86/boot/bzImage iso/boot/vmlinuz || true

# AI will generate initramfs later
touch iso/boot/initramfs.img

# AI will generate GRUB config later
mkdir -p iso/boot/grub
cat <<EOF > iso/boot/grub/grub.cfg
set timeout=5
set default=0

menuentry "AI-Generated OS" {
    linux /boot/vmlinuz
    initrd /boot/initramfs.img
}
EOF

grub-mkrescue -o $ISO iso

echo "[*] ISO created: $ISO"
