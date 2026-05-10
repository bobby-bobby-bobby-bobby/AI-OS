#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "builtins.h"
#include "job_control.h"

static int run_scripting_mode(const char *path) {
    FILE *fp = fopen(path, "r");
    if (!fp) return 1;
    char line[1024];
    while (fgets(line, sizeof(line), fp)) {
        if (line[0] == '#' && line[1] == '!') continue;
        int argc = 0;
        char *argv[64] = {0};
        char *tok = strtok(line, " \t\r\n");
        while (tok && argc < 63) { argv[argc++] = tok; tok = strtok(NULL, " \t\r\n"); }
        if (argc > 0 && is_builtin(argv[0])) execute_builtin(argv[0], argv, argc);
    }
    fclose(fp);
    return 0;
}

int main(int argc, char **argv) {
    builtins_init();
    job_control_init();
    setenv("SHELL", "aish", 1);

    if (argc > 1) return run_scripting_mode(argv[1]);

    char line[1024];
    while (1) {
        printf("aish$ ");
        if (!fgets(line, sizeof(line), stdin)) break;
        int ac = 0;
        char *av[64] = {0};
        char *tok = strtok(line, " \t\r\n");
        while (tok && ac < 63) { av[ac++] = tok; tok = strtok(NULL, " \t\r\n"); }
        if (ac == 0) continue;
        if (is_builtin(av[0])) {
            if (execute_builtin(av[0], av, ac) < 0) break;
            continue;
        }
        fprintf(stderr, "aish: external exec/path resolution stub for '%s'\n", av[0]);
    }
    return 0;
}
