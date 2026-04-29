/*
 * AI-OS Init — TTY management
 * Spawns getty on TTY1-TTY6.
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <sys/wait.h>

#include "tty.h"
#include "log.h"

#define NUM_TTYS 6

static pid_t tty_pids[NUM_TTYS] = {-1, -1, -1, -1, -1, -1};

static void spawn_getty(int tty_num) {
    char dev[32];
    snprintf(dev, sizeof(dev), "/dev/tty%d", tty_num);

    pid_t pid = fork();
    if (pid < 0) {
        log_err("fork getty for tty%d: %s", tty_num, strerror(errno));
        return;
    }
    if (pid == 0) {
        /* Set controlling terminal */
        int fd = open(dev, O_RDWR);
        if (fd >= 0) {
            dup2(fd, 0);
            dup2(fd, 1);
            dup2(fd, 2);
            close(fd);
        }
        execl("/sbin/agetty", "agetty", "--noclear", dev, "linux", NULL);
        /* Fallback to busybox getty */
        execl("/bin/getty", "getty", "38400", dev, NULL);
        _exit(1);
    }
    tty_pids[tty_num - 1] = pid;
    log_info("Spawned getty on tty%d (pid %d)", tty_num, pid);
}

void tty_init(void) {
    for (int i = 1; i <= NUM_TTYS; i++) {
        spawn_getty(i);
    }
}

void tty_respawn(int tty_num) {
    if (tty_num < 1 || tty_num > NUM_TTYS) return;
    tty_pids[tty_num - 1] = -1;
    spawn_getty(tty_num);
}
