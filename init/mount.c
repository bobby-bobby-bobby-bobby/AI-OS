/*
 * AI-OS Init — Filesystem mounting
 */

#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <sys/mount.h>
#include <sys/stat.h>

#include "mount.h"
#include "log.h"

struct mount_entry {
    const char *source;
    const char *target;
    const char *fstype;
    unsigned long flags;
    const char *data;
};

static const struct mount_entry early_mounts[] = {
    { "proc",     "/proc",     "proc",     MS_NOEXEC | MS_NOSUID | MS_NODEV, NULL },
    { "sysfs",    "/sys",      "sysfs",    MS_NOEXEC | MS_NOSUID | MS_NODEV, NULL },
    { "devtmpfs", "/dev",      "devtmpfs", MS_NOSUID,                        "mode=0755" },
    { "devpts",   "/dev/pts",  "devpts",   MS_NOSUID | MS_NOEXEC,            "gid=5,mode=0620" },
    { "tmpfs",    "/dev/shm",  "tmpfs",    MS_NOSUID | MS_NODEV,             "mode=1777" },
    { "tmpfs",    "/run",      "tmpfs",    MS_NOSUID | MS_NODEV,             "mode=0755" },
    { "tmpfs",    "/tmp",      "tmpfs",    MS_NOSUID | MS_NODEV,             "mode=1777" },
    { NULL, NULL, NULL, 0, NULL }
};

static int ensure_dir(const char *path) {
    struct stat st;
    if (stat(path, &st) == 0 && S_ISDIR(st.st_mode))
        return 0;
    if (mkdir(path, 0755) != 0 && errno != EEXIST) {
        log_err("mkdir %s: %s", path, strerror(errno));
        return -1;
    }
    return 0;
}

int mount_early(void) {
    int errors = 0;
    for (int i = 0; early_mounts[i].source; i++) {
        const struct mount_entry *m = &early_mounts[i];
        ensure_dir(m->target);
        if (mount(m->source, m->target, m->fstype, m->flags, m->data) != 0) {
            if (errno != EBUSY) {
                log_err("mount %s -> %s: %s", m->source, m->target, strerror(errno));
                errors++;
            }
        } else {
            log_info("Mounted %s on %s", m->source, m->target);
        }
    }
    return errors ? -1 : 0;
}

int mount_late(void) {
    /* TODO: mount fstab entries */
    return 0;
}

int umount_all(void) {
    /* Unmount in reverse order */
    int n = 0;
    while (early_mounts[n].source) n++;
    for (int i = n - 1; i >= 0; i--) {
        if (umount2(early_mounts[i].target, MNT_DETACH) != 0)
            log_err("umount %s: %s", early_mounts[i].target, strerror(errno));
    }
    return 0;
}
