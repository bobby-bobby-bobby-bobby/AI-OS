# Tasks for AI — Detailed Ordered Task List

## Phase 0: Repository Setup & Structure
- [x] Define directory structure per SPEC.md
- [ ] Populate all skeleton directories with initial code
- [ ] Create README files in each module directory

## Phase 1: Core Boot & Build System
- [ ] Implement `build/build-rootfs.sh` — assemble minimal root filesystem
- [ ] Implement `build/build-iso.sh` — create bootable ISO with GRUB
- [ ] Implement `build/qemu-run.sh` — boot the ISO in QEMU for testing
- [ ] Implement kernel config wrapper in `build/kernel-config.sh`
- [ ] Generate initramfs build script `build/build-initramfs.sh`
- [ ] Generate GRUB configuration template

## Phase 2: Init System (PID 1)
- [ ] Implement `init/init.c` — minimal PID 1 in C using musl libc
- [ ] Implement `init/mount.c` — mount /proc, /sys, /dev, /tmp at boot
- [ ] Implement `init/service.c` — service manager (start/stop/restart/status)
- [ ] Implement `init/log.c` — logging daemon (syslog-compatible)
- [ ] Implement `init/tty.c` — TTY management (spawning getty on tty1-tty6)
- [ ] Define service unit format in `init/units/README.md`
- [ ] Create default service units: syslog, network, dbus, display-manager
- [ ] Implement `init/rc.d/` runlevel scripts
- [ ] Implement `init/shutdown.c` — clean shutdown/reboot logic
- [ ] Write man page: man 8 init

## Phase 3: Shell (aish)
- [ ] Implement `userland/aish/aish.c` — main shell loop (POSIX-compatible)
- [ ] Implement `userland/aish/builtins.c` — cd, exit, export, alias, history, etc.
- [ ] Implement `userland/aish/parser.c` — command parser (pipes, redirects, globs)
- [ ] Implement `userland/aish/job_control.c` — fg/bg job control
- [ ] Implement `userland/aish/completion.c` — tab completion
- [ ] Implement `userland/aish/prompt.c` — customizable PS1 prompt
- [ ] Write `userland/aish/Makefile`
- [ ] Write man page: man 1 aish

## Phase 4: Core Utilities
- [ ] Implement ls, cp, mv, rm, cat, echo, pwd, mkdir, rmdir
- [ ] Implement ps, kill, top, df, du, free, uname, date
- [ ] Implement grep, sed, awk, find, sort, uniq, head, tail, wc
- [ ] Implement chmod, chown, ln, stat, file, which, env, id
- [ ] Implement mount, umount, fsck wrappers
- [ ] Integrate BusyBox as fallback for missing utilities
- [ ] Write Makefile for all utilities

## Phase 5: Package Manager (aipkg)
- [ ] Implement `pkgmgr/aipkg` — main CLI (install, remove, update, search, list)
- [ ] Implement `pkgmgr/lib/db.sh` — package database (installed packages)
- [ ] Implement `pkgmgr/lib/resolve.sh` — dependency resolver
- [ ] Implement `pkgmgr/lib/fetch.sh` — package fetcher (HTTP/HTTPS)
- [ ] Implement `pkgmgr/lib/install.sh` — package installer/uninstaller
- [ ] Implement `pkgmgr/lib/verify.sh` — signature/checksum verification
- [ ] Define `.aipkg` package format in `pkgmgr/FORMAT.md`
- [ ] Implement package repository format in `pkgmgr/repo/`
- [ ] Write man page: man 8 aipkg

## Phase 6: Universal Package Compatibility Layer (UPCL)
- [ ] Implement `compatibility/packages/upcl` — main UPCL dispatcher
- [ ] Implement `compatibility/packages/handlers/deb.sh` — DEB extractor/installer
- [ ] Implement `compatibility/packages/handlers/rpm.sh` — RPM extractor/installer
- [ ] Implement `compatibility/packages/handlers/pkgbuild.sh` — PKGBUILD builder
- [ ] Implement `compatibility/packages/handlers/appimage.sh` — AppImage runner
- [ ] Implement `compatibility/packages/handlers/flatpak.sh` — Flatpak integration
- [ ] Implement `compatibility/packages/handlers/snap.sh` — Snap integration (optional)
- [ ] Implement `compatibility/packages/handlers/nix.sh` — Nix integration (optional)
- [ ] Implement Kali tools integration in `compatibility/packages/kali.sh`
- [ ] Implement Fedora/openSUSE tools integration
- [ ] Implement MX Tools integration
- [ ] Implement Btrfs snapshot/rollback in `compatibility/btrfs/`

## Phase 7: Installer
- [ ] Implement `installer/install.sh` — main installer entry point
- [ ] Implement `installer/detect-hardware.sh` — hardware detection
- [ ] Implement `installer/partition.sh` — auto-partitioning (GPT/MBR)
- [ ] Implement `installer/format.sh` — filesystem formatting (Btrfs/ext4)
- [ ] Implement `installer/install-base.sh` — base system installation
- [ ] Implement `installer/bootloader.sh` — GRUB/Syslinux setup
- [ ] Implement `installer/user-setup.sh` — user creation and configuration
- [ ] Implement `installer/drivers.sh` — driver auto-installation
- [ ] Implement `installer/network.sh` — network configuration
- [ ] Implement `installer/encrypted-home.sh` — LUKS/fscrypt home setup
- [ ] Generate installer TUI using dialog/whiptail

## Phase 8: Desktop Environment
- [ ] Implement window manager in `desktop/wm/` (Wayland compositor or X11 WM)
- [ ] Implement panel/dock in `desktop/panel/`
- [ ] Implement launcher in `desktop/launcher/`
- [ ] Implement settings app in `desktop/settings/`
- [ ] Implement theme engine in `desktop/themes/`
- [ ] Implement default theme pack (smooth, rounded, modern)
- [ ] Generate wallpapers (SVG-based)
- [ ] Generate icon theme in `branding/icons/`
- [ ] Generate boot splash theme
- [ ] Implement display manager in `desktop/display-manager/`
- [ ] Implement notification daemon in `desktop/notifications/`
- [ ] Implement system tray support

## Phase 9: Browser Selection System
- [ ] Implement `desktop/browser-select/browser-select.sh` — first-boot browser chooser UI
- [ ] Implement browser installer scripts for Edge, Chrome, Firefox, Opera, Chromium, Brave, Vivaldi
- [ ] Implement browser sandboxing wrappers using Firejail
- [ ] Implement uBlock Origin auto-installation for each browser
- [ ] Implement DNS-level ad blocking (hosts file + DoH)
- [ ] Implement browser isolation micro-VM option

## Phase 10: Virtualization & VMs
- [ ] Implement `compatibility/vm/vm-manager.sh` — VM management CLI
- [ ] Implement `compatibility/vm/windows-legacy.sh` — Windows Legacy Mode VM
- [ ] Implement `compatibility/vm/banking-vm.sh` — Hardened Banking VM
- [ ] Implement `compatibility/vm/suspicious-vm.sh` — Disposable Suspicious File VM
- [ ] Implement `compatibility/vm/dev-vm.sh` — Developer VM
- [ ] Implement `compatibility/vm/browser-vm.sh` — Optional Browser Isolation VM
- [ ] Implement VM templates in `compatibility/vm/templates/`
- [ ] Implement VM launcher UI in `desktop/vm-launcher/`

## Phase 11: Android Support
- [ ] Implement `compatibility/android/waydroid-setup.sh` — Waydroid + microG setup
- [ ] Implement `compatibility/android/app-installer.sh` — Android APK/Play Store UI
- [ ] Implement `compatibility/android/sandbox.sh` — Android sandboxing config
- [ ] Implement GPU acceleration config for Waydroid

## Phase 12: Windows Compatibility
- [ ] Implement `compatibility/windows/wine-setup.sh` — Wine/Proton setup
- [ ] Implement `compatibility/windows/run-windows.sh` — Windows app launcher
- [ ] Implement `compatibility/windows/compat-ui.sh` — Compatibility UI
- [ ] Implement `compatibility/windows/sandbox.sh` — Wine sandboxing

## Phase 13: Language Runtime Manager (langmgr)
- [ ] Define language registry format in `langmgr/registry.yaml`
- [ ] Implement `langmgr/lang` — main `lang` CLI
- [ ] Implement `langmgr/run` — universal `run <file>` command
- [ ] Implement `langmgr/handlers/modern.sh` — Python, Rust, Go, Java, C#, etc.
- [ ] Implement `langmgr/handlers/legacy.sh` — BASIC, Fortran, COBOL, Pascal, Ada, Lisp
- [ ] Implement `langmgr/handlers/esoteric.sh` — Brainfuck, Befunge, Piet, Whitespace
- [ ] Implement `langmgr/handlers/academic.sh` — Haskell, OCaml, Erlang, ML
- [ ] Implement `langmgr/handlers/retro.sh` — DOSBox-based: QBasic, GW-BASIC, Turbo Pascal
- [ ] Implement `langmgr/handlers/vm-based.sh` — JVM, .NET, WebAssembly
- [ ] Add 50+ language entries to registry
- [ ] Write man page: man 1 lang, man 1 run

## Phase 14: Privacy & Security
- [ ] Generate AppArmor profiles in `security/apparmor/`
- [ ] Generate Firejail profiles in `security/firejail/`
- [ ] Generate Bubblewrap wrappers in `security/bubblewrap/`
- [ ] Implement firewall setup in `security/firewall.sh`
- [ ] Implement DNS ad-blocking in `security/adblock/`
- [ ] Implement encrypted home setup in `security/encrypted-home.sh`
- [ ] Implement security update automation in `security/auto-update.sh`
- [ ] Implement universal uninstaller in `security/uninstall.sh`
- [ ] Generate SELinux policy stubs (optional)

## Phase 15: Documentation
- [ ] Generate `docs/user-guide.md` — end user documentation
- [ ] Generate `docs/dev-guide.md` — developer/contributor guide
- [ ] Generate `docs/troubleshooting.md` — troubleshooting guide
- [ ] Generate `docs/onboarding.md` — first-boot wizard documentation
- [ ] Generate man pages for: aish, aipkg, lang, run, vm-manager
- [ ] Generate `docs/architecture.md` — system architecture overview
- [ ] Generate `docs/security.md` — security model documentation

## Phase 16: Branding & Theming
- [ ] Generate `branding/logo.svg` — AI-OS logo
- [ ] Generate wallpaper SVGs in `branding/wallpapers/`
- [ ] Generate icon theme in `branding/icons/`
- [ ] Generate color scheme in `branding/colors.conf`
- [ ] Generate font selection in `branding/fonts.conf`
- [ ] Generate boot splash theme in `branding/boot-splash/`

## Maintenance & Ongoing
- [ ] Implement update mechanism for AI-generated components
- [ ] Implement Btrfs rollback CLI tool
- [ ] Implement system health check script
- [ ] Implement AI component self-test suite
