/*
 * AI-OS Init — Service Manager
 * Simple unit-based service management.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <errno.h>

#include "service.h"
#include "log.h"

static service_t *services = NULL;

static service_t *service_new(void) {
    service_t *s = calloc(1, sizeof(service_t));
    if (!s) return NULL;
    s->state = SVC_STOPPED;
    s->pid   = -1;
    s->next  = services;
    services = s;
    return s;
}

/* Parse a single unit file */
static int parse_unit(const char *path) {
    FILE *f = fopen(path, "r");
    if (!f) {
        log_err("Cannot open unit file: %s", path);
        return -1;
    }

    service_t *s = service_new();
    if (!s) {
        fclose(f);
        return -1;
    }

    char line[512];
    char section[32] = "";

    while (fgets(line, sizeof(line), f)) {
        /* Strip newline */
        line[strcspn(line, "\r\n")] = '\0';
        /* Skip comments and blank lines */
        if (line[0] == '#' || line[0] == ';' || line[0] == '\0')
            continue;
        /* Section header */
        if (line[0] == '[') {
            char *end = strchr(line, ']');
            if (end) {
                *end = '\0';
                strncpy(section, line + 1, sizeof(section) - 1);
            }
            continue;
        }
        /* Key=Value */
        char *eq = strchr(line, '=');
        if (!eq) continue;
        *eq = '\0';
        char *key = line;
        char *val = eq + 1;

        if (strcmp(section, "Unit") == 0) {
            if (strcmp(key, "Name") == 0)
                strncpy(s->name, val, SERVICE_NAME_MAX - 1);
            else if (strcmp(key, "Description") == 0)
                strncpy(s->description, val, sizeof(s->description) - 1);
            else if (strcmp(key, "After") == 0)
                strncpy(s->after, val, SERVICE_NAME_MAX - 1);
        } else if (strcmp(section, "Service") == 0) {
            if (strcmp(key, "ExecStart") == 0)
                strncpy(s->exec_start, val, SERVICE_CMD_MAX - 1);
            else if (strcmp(key, "Restart") == 0)
                s->restart_on_failure = (strcmp(val, "on-failure") == 0 ||
                                         strcmp(val, "always") == 0);
        }
    }

    fclose(f);

    if (s->name[0] == '\0') {
        log_warn("Unit file %s has no Name, skipping", path);
        /* Remove from list */
        if (services == s) {
            services = s->next;
        } else {
            service_t *p = services;
            while (p && p->next != s) p = p->next;
            if (p) p->next = s->next;
        }
        free(s);
        return -1;
    }

    log_info("Loaded unit: %s", s->name);
    return 0;
}

int service_init(const char *units_dir) {
    DIR *d = opendir(units_dir);
    if (!d) {
        log_warn("Units directory not found: %s", units_dir);
        return 0; /* not fatal */
    }

    struct dirent *ent;
    char path[512];
    while ((ent = readdir(d)) != NULL) {
        if (ent->d_name[0] == '.') continue;
        /* Only process .unit files */
        const char *ext = strrchr(ent->d_name, '.');
        if (!ext || strcmp(ext, ".unit") != 0) continue;

        snprintf(path, sizeof(path), "%s/%s", units_dir, ent->d_name);
        parse_unit(path);
    }
    closedir(d);
    return 0;
}

service_t *service_find(const char *name) {
    for (service_t *s = services; s; s = s->next) {
        if (strcmp(s->name, name) == 0)
            return s;
    }
    return NULL;
}

int service_start(const char *name) {
    service_t *s = service_find(name);
    if (!s) {
        log_err("Service not found: %s", name);
        return -1;
    }
    if (s->state == SVC_RUNNING) {
        log_info("Service already running: %s", name);
        return 0;
    }
    if (s->exec_start[0] == '\0') {
        log_err("Service %s has no ExecStart", name);
        return -1;
    }

    log_info("Starting service: %s", name);
    s->state = SVC_STARTING;

    pid_t pid = fork();
    if (pid < 0) {
        log_err("fork() failed for %s: %s", name, strerror(errno));
        s->state = SVC_FAILED;
        return -1;
    }
    if (pid == 0) {
        /* Child: exec the service */
        execl("/bin/sh", "sh", "-c", s->exec_start, NULL);
        _exit(127);
    }

    s->pid   = pid;
    s->state = SVC_RUNNING;
    log_info("Service %s started (pid %d)", name, pid);
    return 0;
}

int service_stop(const char *name) {
    service_t *s = service_find(name);
    if (!s || s->state != SVC_RUNNING) return 0;

    log_info("Stopping service: %s (pid %d)", name, s->pid);
    s->state = SVC_STOPPING;
    kill(s->pid, SIGTERM);

    /* Wait up to 5 seconds */
    for (int i = 0; i < 50; i++) {
        usleep(100000); /* 100ms */
        if (waitpid(s->pid, NULL, WNOHANG) == s->pid) {
            s->state = SVC_STOPPED;
            s->pid   = -1;
            return 0;
        }
    }

    /* Force kill */
    kill(s->pid, SIGKILL);
    waitpid(s->pid, NULL, 0);
    s->state = SVC_STOPPED;
    s->pid   = -1;
    return 0;
}

int service_restart(const char *name) {
    service_stop(name);
    return service_start(name);
}

int service_status(const char *name) {
    service_t *s = service_find(name);
    if (!s) return -1;
    const char *states[] = {"stopped", "starting", "running", "stopping", "failed"};
    printf("%s: %s\n", s->name, states[s->state]);
    return s->state == SVC_RUNNING ? 0 : 1;
}

int service_start_target(const char *target) {
    (void)target;
    /* Start all units that have WantedBy=default (simplified: start all loaded units) */
    for (service_t *s = services; s; s = s->next) {
        if (s->state == SVC_STOPPED) {
            service_start(s->name);
        }
    }
    return 0;
}

void service_stop_all(void) {
    for (service_t *s = services; s; s = s->next) {
        if (s->state == SVC_RUNNING) {
            service_stop(s->name);
        }
    }
}
