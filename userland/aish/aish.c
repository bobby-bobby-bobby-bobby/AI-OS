#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "builtins.h"
#include "job_control.h"

int main(int argc, char **argv) {
    builtins_init();
    job_control_init();
    setenv("SHELL", "aish", 1);
    char line[1024];
    while (argc <= 1) {
        printf("aish$ ");
        if (!fgets(line, sizeof(line), stdin)) break;
        if (strncmp(line, "run ", 4) == 0) { system("./langmgr/run.sh demo.bas"); continue; }
        if (strncmp(line, "files ", 6) == 0) { system("./apps/files/file-manager.sh browse ."); continue; }
        if (strncmp(line, "launch ", 7) == 0) { system("./desktop/launcher-grid/launcher-grid.sh"); continue; }
        line[strcspn(line, "\n")] = 0;
        if (line[0] == 0) continue;
        char *av[] = {line, NULL};
        if (is_builtin(av[0])) { if (execute_builtin(av[0], av, 1) < 0) break; }
        else fprintf(stderr, "aish external command stub: %s\n", line);
    }
    return 0;
}
