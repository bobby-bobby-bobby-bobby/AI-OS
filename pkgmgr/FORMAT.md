# .aipkg Package Format

An `.aipkg` file is a gzip-compressed tar archive with the following layout:

```
package.aipkg
├── PKGINFO          # Package metadata (INI format)
├── INSTALL          # Install/post-install script (optional)
├── UNINSTALL        # Uninstall/pre-remove script (optional)
├── CHECKSUMS        # SHA256 checksums of all files
└── data/            # Actual package files (relative to /)
    ├── usr/
    │   ├── bin/
    │   └── lib/
    └── etc/
```

## PKGINFO Format

```ini
[Package]
Name=example
Version=1.0.0
Release=1
Arch=x86_64
Description=Example package for AI-OS
License=MIT
URL=https://example.com
Size=12345

[Dependencies]
Requires=glibc >= 2.17
Requires=libssl >= 1.1

[Optional]
Suggests=vim

[Source]
Maintainer=AI-OS Project
BuildDate=2024-01-01
```
