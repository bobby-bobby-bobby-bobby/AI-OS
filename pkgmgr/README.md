# aipkg — AI-OS Package Manager

`aipkg` is the native package manager for AI-OS. It manages AI-OS native
packages (`.aipkg` format) and delegates to the UPCL for foreign packages.

## Usage

```
aipkg install <package>     Install a package
aipkg remove <package>      Remove a package
aipkg update                Update package lists
aipkg upgrade               Upgrade installed packages
aipkg search <query>        Search for packages
aipkg list                  List installed packages
aipkg info <package>        Show package information
aipkg clean                 Clean package cache
```

## Package Format

See `FORMAT.md` for the `.aipkg` package format specification.

## Repository

Default repository: `/etc/aipkg/repos.conf`
Package database: `/var/lib/aipkg/`
Cache: `/var/cache/aipkg/`
