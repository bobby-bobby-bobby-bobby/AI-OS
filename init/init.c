/*
 * AI-OS Init System — PID 1
 * Minimal init daemon: mounts filesystems, starts services, manages TTYs.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <sys/reboot.h>
#include <errno.h>

#include "mount.h"
#include "service.h"
#include "log.h"
#include "tty.h"

#define INIT_VERSION "0.1.0"

static volatile int g_shutdown = 0;
static volatile int g_reboot   = 0;

static void signal_handler(int sig) {
    switch (sig) {
    case SIGTERM:
        g_shutdown = 1;
        break;
    case SIGINT:
        g_reboot = 1;
        break;
    case SIGCHLD:
        /* Reap zombie children */
        while (waitpid(-1, NULL, WNOHANG) > 0)
            ;
        break;
    default:
        break;
    }
}

static void setup_signals(void) {
    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sa.sa_handler = signal_handler;
    sigemptyset(&sa.sa_mask);

    sigaction(SIGTERM, &sa, NULL);
    sigaction(SIGINT,  &sa, NULL);
    sigaction(SIGCHLD, &sa, NULL);

    /* Ignore SIGHUP and SIGPIPE */
    sa.sa_handler = SIG_IGN;
    sigaction(SIGHUP,  &sa, NULL);
    sigaction(SIGPIPE, &sa, NULL);
}

int main(int argc, char *argv[]) {
    (void)argc;
    (void)argv;

    if (getpid() != 1) {
        fprintf(stderr, "init: must be run as PID 1\n");
        return 1;
    }

    /* Set up signal handlers before anything else */
    setup_signals();

    /* Initialize logging first so we can log mount/service errors */
    log_init("/var/log/init.log");
    log_info("AI-OS init v%s starting", INIT_VERSION);

    /* Mount essential filesystems */
    if (mount_early() != 0) {
        log_err("Failed to mount essential filesystems — continuing anyway");
    }

    /* Start service manager */
    if (service_init("/etc/init/units") != 0) {
        log_err("Service manager init failed");
    }

    /* Start TTYs */
    tty_init();

    /* Start default target services */
    service_start_target("default");

    log_info("Boot complete — entering main loop");

    /* Main reap loop */
    while (!g_shutdown && !g_reboot) {
        pause(); /* wait for signals */
        /* Reap any dead children */
        while (waitpid(-1, NULL, WNOHANG) > 0)
            ;
    }

    if (g_reboot) {
        log_info("Rebooting...");
        service_stop_all();
        sync();
        reboot(RB_AUTOBOOT);
    } else {
        log_info("Shutting down...");
        service_stop_all();
        sync();
        reboot(RB_POWER_OFF);
    }

    return 0; /* unreachable */
}
