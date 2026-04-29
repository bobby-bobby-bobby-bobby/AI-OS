/*
 * aish — Built-in commands
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/stat.h>

#include "builtins.h"
#include "history.h"
#include "job_control.h"

typedef struct {
    const char *name;
    int (*func)(char **argv, int argc);
    const char *help;
} builtin_t;

static builtin_t builtins_table[] = {
    { "cd",      builtin_cd,      "Change directory: cd [dir]" },
    { "exit",    builtin_exit,    "Exit the shell: exit [status]" },
    { "export",  builtin_export,  "Export variable: export NAME=VALUE" },
    { "unset",   builtin_unset,   "Unset variable: unset NAME" },
    { "alias",   builtin_alias,   "Set alias: alias name='command'" },
    { "history", builtin_history, "Show command history" },
    { "help",    builtin_help,    "Show this help" },
    { "echo",    builtin_echo,    "Print text: echo [args]" },
    { "pwd",     builtin_pwd,     "Print working directory" },
    { "type",    builtin_type,    "Show command type: type name" },
    { "jobs",    builtin_jobs,    "List background jobs" },
    { "fg",      builtin_fg,      "Bring job to foreground: fg [%n]" },
    { "bg",      builtin_bg,      "Resume job in background: bg [%n]" },
    { "source",  builtin_source,  "Execute script in current shell: source file" },
    { ".",       builtin_source,  "Alias for source" },
    { NULL, NULL, NULL }
};

/* Simple alias table */
#define MAX_ALIASES 64
static struct { char name[64]; char value[256]; } alias_table[MAX_ALIASES];
static int alias_count = 0;

void builtins_init(void) {
    /* Default aliases */
    strcpy(alias_table[0].name,  "ll");
    strcpy(alias_table[0].value, "ls -la");
    strcpy(alias_table[1].name,  "la");
    strcpy(alias_table[1].value, "ls -a");
    strcpy(alias_table[2].name,  "grep");
    strcpy(alias_table[2].value, "grep --color=auto");
    alias_count = 3;
}

int is_builtin(const char *name) {
    for (int i = 0; builtins_table[i].name; i++)
        if (strcmp(builtins_table[i].name, name) == 0)
            return 1;
    return 0;
}

int execute_builtin(const char *name, char **argv, int argc) {
    for (int i = 0; builtins_table[i].name; i++)
        if (strcmp(builtins_table[i].name, name) == 0)
            return builtins_table[i].func(argv, argc);
    return 127;
}

int builtin_cd(char **argv, int argc) {
    const char *dir;
    if (argc < 2) {
        dir = getenv("HOME");
        if (!dir) dir = "/";
    } else if (strcmp(argv[1], "-") == 0) {
        dir = getenv("OLDPWD");
        if (!dir) { fprintf(stderr, "cd: OLDPWD not set\n"); return 1; }
        printf("%s\n", dir);
    } else {
        dir = argv[1];
    }
    char old[4096];
    getcwd(old, sizeof(old));
    if (chdir(dir) != 0) {
        fprintf(stderr, "cd: %s: %s\n", dir, strerror(errno));
        return 1;
    }
    setenv("OLDPWD", old, 1);
    char cwd[4096];
    if (getcwd(cwd, sizeof(cwd)))
        setenv("PWD", cwd, 1);
    return 0;
}

int builtin_exit(char **argv, int argc) {
    int status = 0;
    if (argc >= 2) status = atoi(argv[1]);
    exit(status);
    return 0; /* unreachable */
}

int builtin_export(char **argv, int argc) {
    if (argc < 2) {
        /* Print all environment variables */
        extern char **environ;
        for (char **e = environ; *e; e++)
            printf("export %s\n", *e);
        return 0;
    }
    for (int i = 1; i < argc; i++) {
        char *eq = strchr(argv[i], '=');
        if (eq) {
            putenv(argv[i]); /* Note: argv[i] must stay valid */
        } else {
            /* Export existing variable */
            const char *val = getenv(argv[i]);
            if (val) {
                setenv(argv[i], val, 1);
            }
        }
    }
    return 0;
}

int builtin_unset(char **argv, int argc) {
    for (int i = 1; i < argc; i++)
        unsetenv(argv[i]);
    return 0;
}

int builtin_alias(char **argv, int argc) {
    if (argc < 2) {
        for (int i = 0; i < alias_count; i++)
            printf("alias %s='%s'\n", alias_table[i].name, alias_table[i].value);
        return 0;
    }
    char *eq = strchr(argv[1], '=');
    if (!eq) {
        /* Print specific alias */
        for (int i = 0; i < alias_count; i++)
            if (strcmp(alias_table[i].name, argv[1]) == 0) {
                printf("alias %s='%s'\n", alias_table[i].name, alias_table[i].value);
                return 0;
            }
        fprintf(stderr, "alias: %s not found\n", argv[1]);
        return 1;
    }
    /* Set alias */
    *eq = '\0';
    const char *name  = argv[1];
    const char *value = eq + 1;
    /* Remove surrounding quotes */
    if ((*value == '\'' || *value == '"') && value[strlen(value)-1] == *value) {
        value++;
        /* strip trailing quote (we'd need to modify the string) */
    }
    for (int i = 0; i < alias_count; i++) {
        if (strcmp(alias_table[i].name, name) == 0) {
            strncpy(alias_table[i].value, value, 255);
            return 0;
        }
    }
    if (alias_count < MAX_ALIASES) {
        strncpy(alias_table[alias_count].name,  name,  63);
        strncpy(alias_table[alias_count].value, value, 255);
        alias_count++;
    }
    return 0;
}

int builtin_history(char **argv, int argc) {
    (void)argv; (void)argc;
    history_print();
    return 0;
}

int builtin_help(char **argv, int argc) {
    (void)argv; (void)argc;
    printf("\033[1;36maish\033[0m built-in commands:\n\n");
    for (int i = 0; builtins_table[i].name; i++) {
        if (builtins_table[i].help)
            printf("  %-12s  %s\n", builtins_table[i].name, builtins_table[i].help);
    }
    printf("\nFor external commands, type 'man <command>' or '<command> --help'.\n");
    return 0;
}

int builtin_echo(char **argv, int argc) {
    int newline = 1;
    int start   = 1;
    if (argc >= 2 && strcmp(argv[1], "-n") == 0) {
        newline = 0;
        start   = 2;
    }
    for (int i = start; i < argc; i++) {
        if (i > start) putchar(' ');
        fputs(argv[i], stdout);
    }
    if (newline) putchar('\n');
    return 0;
}

int builtin_pwd(char **argv, int argc) {
    (void)argv; (void)argc;
    char cwd[4096];
    if (getcwd(cwd, sizeof(cwd))) {
        printf("%s\n", cwd);
        return 0;
    }
    perror("pwd");
    return 1;
}

int builtin_type(char **argv, int argc) {
    if (argc < 2) {
        fprintf(stderr, "type: missing argument\n");
        return 1;
    }
    for (int i = 1; i < argc; i++) {
        if (is_builtin(argv[i])) {
            printf("%s is a shell builtin\n", argv[i]);
        } else {
            /* Search in PATH */
            const char *path_env = getenv("PATH");
            if (!path_env) path_env = "/usr/bin:/bin";
            char path_copy[4096];
            strncpy(path_copy, path_env, sizeof(path_copy) - 1);
            char *dir = strtok(path_copy, ":");
            int found = 0;
            while (dir) {
                char full[4096];
                snprintf(full, sizeof(full), "%s/%s", dir, argv[i]);
                struct stat st;
                if (stat(full, &st) == 0 && (st.st_mode & S_IXUSR)) {
                    printf("%s is %s\n", argv[i], full);
                    found = 1;
                    break;
                }
                dir = strtok(NULL, ":");
            }
            if (!found)
                fprintf(stderr, "%s: not found\n", argv[i]);
        }
    }
    return 0;
}

int builtin_jobs(char **argv, int argc) {
    (void)argv; (void)argc;
    jobs_print();
    return 0;
}

int builtin_fg(char **argv, int argc) {
    int job = -1;
    if (argc >= 2 && argv[1][0] == '%')
        job = atoi(argv[1] + 1);
    return job_fg(job);
}

int builtin_bg(char **argv, int argc) {
    int job = -1;
    if (argc >= 2 && argv[1][0] == '%')
        job = atoi(argv[1] + 1);
    return job_bg(job);
}

int builtin_source(char **argv, int argc) {
    if (argc < 2) {
        fprintf(stderr, "source: missing file argument\n");
        return 1;
    }
    FILE *f = fopen(argv[1], "r");
    if (!f) {
        fprintf(stderr, "source: %s: %s\n", argv[1], strerror(errno));
        return 1;
    }
    char line[4096];
    int status = 0;
    extern command_t *parse_line(const char *);
    extern int execute_command(command_t *);
    extern void command_free(command_t *);
    while (fgets(line, sizeof(line), f)) {
        line[strcspn(line, "\n")] = '\0';
        if (line[0] == '\0' || line[0] == '#') continue;
        command_t *cmd = parse_line(line);
        if (cmd) {
            status = execute_command(cmd);
            command_free(cmd);
        }
    }
    fclose(f);
    return status;
}
