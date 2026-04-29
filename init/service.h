#ifndef SERVICE_H
#define SERVICE_H

#define SERVICE_NAME_MAX 64
#define SERVICE_CMD_MAX  256

typedef enum {
    SVC_STOPPED = 0,
    SVC_STARTING,
    SVC_RUNNING,
    SVC_STOPPING,
    SVC_FAILED
} svc_state_t;

typedef struct service {
    char name[SERVICE_NAME_MAX];
    char description[256];
    char exec_start[SERVICE_CMD_MAX];
    char after[SERVICE_NAME_MAX];    /* dependency: start after this */
    char wants[SERVICE_NAME_MAX];    /* optional dependency */
    int  restart_on_failure;
    svc_state_t state;
    pid_t pid;
    struct service *next;
} service_t;

int  service_init(const char *units_dir);
int  service_start(const char *name);
int  service_stop(const char *name);
int  service_restart(const char *name);
int  service_status(const char *name);
int  service_start_target(const char *target);
void service_stop_all(void);
service_t *service_find(const char *name);

#endif /* SERVICE_H */
