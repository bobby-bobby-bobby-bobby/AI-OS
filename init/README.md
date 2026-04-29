# Init System

The AI-OS init system is a minimal PID 1 implementation written in C.
It handles early boot, filesystem mounting, service management, TTY spawning,
and clean shutdown.

## Components

- `init.c` — PID 1 entry point
- `mount.c` / `mount.h` — early filesystem mounting
- `service.c` / `service.h` — service manager
- `log.c` / `log.h` — logging system
- `tty.c` / `tty.h` — TTY/getty management
- `shutdown.c` — shutdown/reboot
- `units/` — service unit files
- `rc.d/` — runlevel scripts

## Service Unit Format

Units live in `/etc/init/units/` and use a simple INI-like format:

```
[Unit]
Name=syslog
Description=System Logging Daemon
After=mount

[Service]
Type=simple
ExecStart=/sbin/syslogd -n
Restart=on-failure

[Install]
WantedBy=default
```

## Building

```sh
make -C init
```
