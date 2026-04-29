#ifndef JOB_CONTROL_H
#define JOB_CONTROL_H

#include <sys/types.h>

typedef struct job {
    int   id;
    pid_t pid;
    char  cmd[128];
    int   stopped;
    struct job *next;
} job_t;

void   job_control_init(void);
void   job_add(pid_t pid, const char *cmd);
void   job_remove(pid_t pid);
void   jobs_print(void);
int    job_fg(int id);
int    job_bg(int id);
job_t *job_find_pid(pid_t pid);

#endif
