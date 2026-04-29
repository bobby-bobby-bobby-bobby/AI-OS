#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/reboot.h>
#include <sys/wait.h>
#include <unistd.h>

#include "log.h"
#include "mount.h"
#include "service.h"
#include "tty.h"

static volatile sig_atomic_t g_running = 1;

static void on_signal(int sig) {
    if (sig == SIGINT || sig == SIGTERM) g_running = 0;
}

static void start_network(void) {
    if (service_start("network") != 0)
        log_warn("network service did not start cleanly");
}

static void start_desktop(void) {
    if (service_start("display-manager") != 0)
        log_warn("display manager not available (desktop session deferred)");
}

int main(void) {
    signal(SIGINT, on_signal);
    signal(SIGTERM, on_signal);

    log_init("/run/init.log");
    log_info("ai-os init starting (pid=%d)", getpid());

    mount_early();
    service_init("/etc/ai-os/units");
    service_init("./init/units");

    service_start("syslog");
    start_network();
    tty_init();
    start_desktop();

    while (g_running) {
        int status = 0;
        pid_t dead = waitpid(-1, &status, WNOHANG);
        if (dead > 0) log_info("reaped child pid=%d status=%d", dead, status);
        usleep(200000);
    }

    log_info("shutting down services");
    service_stop_all();
    umount_all();
    log_close();
    reboot(RB_AUTOBOOT);
    return 0;
}
