/*
 * aish — Job control
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <sys/wait.h>

#include "job_control.h"

static job_t *jobs = NULL;
static int    next_id = 1;

void job_control_init(void) {
    jobs   = NULL;
    next_id = 1;
}

void job_add(pid_t pid, const char *cmd) {
    job_t *j = calloc(1, sizeof(job_t));
    if (!j) return;
    j->id      = next_id++;
    j->pid     = pid;
    j->stopped = 0;
    strncpy(j->cmd, cmd ? cmd : "?", sizeof(j->cmd) - 1);
    j->next = jobs;
    jobs    = j;
}

void job_remove(pid_t pid) {
    job_t **pp = &jobs;
    while (*pp) {
        if ((*pp)->pid == pid) {
            job_t *tmp = *pp;
            *pp = tmp->next;
            free(tmp);
            return;
        }
        pp = &(*pp)->next;
    }
}

void jobs_print(void) {
    for (job_t *j = jobs; j; j = j->next)
        printf("[%d] %s  %s\n", j->id, j->stopped ? "Stopped" : "Running", j->cmd);
}

int job_fg(int id) {
    job_t *j = jobs;
    if (id < 0) {
        /* Find most recent */
        j = jobs;
    } else {
        while (j && j->id != id) j = j->next;
    }
    if (!j) { fprintf(stderr, "fg: no such job\n"); return 1; }

    kill(j->pid, SIGCONT);
    j->stopped = 0;
    int status;
    waitpid(j->pid, &status, 0);
    job_remove(j->pid);
    return WIFEXITED(status) ? WEXITSTATUS(status) : 0;
}

int job_bg(int id) {
    job_t *j = jobs;
    if (id >= 0)
        while (j && j->id != id) j = j->next;
    if (!j) { fprintf(stderr, "bg: no such job\n"); return 1; }
    kill(j->pid, SIGCONT);
    j->stopped = 0;
    printf("[%d] %s &\n", j->id, j->cmd);
    return 0;
}

job_t *job_find_pid(pid_t pid) {
    for (job_t *j = jobs; j; j = j->next)
        if (j->pid == pid) return j;
    return NULL;
}
