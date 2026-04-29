/*
 * aish — Command parser
 * Parses a shell command line into a pipeline of simple commands.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/wait.h>

#include "parser.h"
#include "builtins.h"
#include "job_control.h"

static char *strdup_safe(const char *s) {
    size_t len = strlen(s) + 1;
    char *p = malloc(len);
    if (p) memcpy(p, s, len);
    return p;
}

/* Tokenize a single command (no pipe), handling quotes */
static int tokenize(const char *s, char **tokens, int max_tokens) {
    int ntok = 0;
    char buf[4096];
    int  bi  = 0;
    int  in_single = 0, in_double = 0;

    while (*s && ntok < max_tokens - 1) {
        char c = *s++;
        if (c == '\'' && !in_double) {
            in_single = !in_single;
        } else if (c == '"' && !in_single) {
            in_double = !in_double;
        } else if (c == '\\' && !in_single && *s) {
            buf[bi++] = *s++;
        } else if ((c == ' ' || c == '\t') && !in_single && !in_double) {
            if (bi > 0) {
                buf[bi] = '\0';
                tokens[ntok++] = strdup_safe(buf);
                bi = 0;
            }
        } else {
            buf[bi++] = c;
        }
    }
    if (bi > 0) {
        buf[bi] = '\0';
        tokens[ntok++] = strdup_safe(buf);
    }
    tokens[ntok] = NULL;
    return ntok;
}

command_t *parse_line(const char *line) {
    if (!line || line[0] == '\0') return NULL;

    command_t *cmd = calloc(1, sizeof(command_t));
    if (!cmd) return NULL;

    /* Split on pipes first */
    char linecopy[4096];
    strncpy(linecopy, line, sizeof(linecopy) - 1);

    char *p = linecopy;
    int   ncmds = 0;
    int   in_sq = 0, in_dq = 0;
    char *start = p;

    for (; *p && ncmds < MAX_CMDS - 1; p++) {
        if (*p == '\'' && !in_dq) in_sq = !in_sq;
        else if (*p == '"' && !in_sq) in_dq = !in_dq;
        else if (*p == '|' && !in_sq && !in_dq) {
            *p = '\0';
            /* Parse segment */
            char *toks[MAX_ARGS + 1];
            int   n = tokenize(start, toks, MAX_ARGS + 1);
            simple_cmd_t *sc = &cmd->cmds[ncmds];
            /* Handle redirections */
            for (int i = 0; i < n; i++) {
                if (strcmp(toks[i], "<") == 0 && i + 1 < n) {
                    sc->redirect_in = toks[i+1]; toks[i+1] = NULL;
                    i++;
                } else if (strcmp(toks[i], ">>") == 0 && i + 1 < n) {
                    sc->redirect_append = toks[i+1]; toks[i+1] = NULL;
                    i++;
                } else if (strcmp(toks[i], ">") == 0 && i + 1 < n) {
                    sc->redirect_out = toks[i+1]; toks[i+1] = NULL;
                    i++;
                } else {
                    sc->argv[sc->argc++] = toks[i];
                }
            }
            ncmds++;
            start = p + 1;
        }
    }

    /* Last (or only) segment */
    {
        char *toks[MAX_ARGS + 1];
        int   n = tokenize(start, toks, MAX_ARGS + 1);
        simple_cmd_t *sc = &cmd->cmds[ncmds];

        /* Check for background & */
        if (n > 0 && strcmp(toks[n-1], "&") == 0) {
            cmd->background = 1;
            free(toks[n-1]);
            toks[n-1] = NULL;
            n--;
        }

        for (int i = 0; i < n; i++) {
            if (!toks[i]) continue;
            if (strcmp(toks[i], "<") == 0 && i + 1 < n && toks[i+1]) {
                sc->redirect_in = toks[i+1]; toks[i+1] = NULL; i++;
            } else if (strcmp(toks[i], ">>") == 0 && i + 1 < n && toks[i+1]) {
                sc->redirect_append = toks[i+1]; toks[i+1] = NULL; i++;
            } else if (strcmp(toks[i], ">") == 0 && i + 1 < n && toks[i+1]) {
                sc->redirect_out = toks[i+1]; toks[i+1] = NULL; i++;
            } else {
                sc->argv[sc->argc++] = toks[i];
            }
        }
        ncmds++;
    }

    cmd->ncmds = ncmds;
    if (cmd->ncmds == 0 || cmd->cmds[0].argc == 0) {
        command_free(cmd);
        return NULL;
    }
    return cmd;
}

void command_free(command_t *cmd) {
    if (!cmd) return;
    for (int i = 0; i < cmd->ncmds; i++) {
        simple_cmd_t *sc = &cmd->cmds[i];
        for (int j = 0; j < sc->argc; j++)
            free(sc->argv[j]);
        free(sc->redirect_in);
        free(sc->redirect_out);
        free(sc->redirect_append);
    }
    free(cmd);
}

static int execute_simple(simple_cmd_t *sc) {
    if (sc->argc == 0) return 0;

    const char *prog = sc->argv[0];

    /* Check builtins */
    if (is_builtin(prog))
        return execute_builtin(prog, sc->argv, sc->argc);

    pid_t pid = fork();
    if (pid < 0) {
        perror("fork");
        return 1;
    }
    if (pid == 0) {
        /* Child */
        if (sc->redirect_in) {
            int fd = open(sc->redirect_in, O_RDONLY);
            if (fd < 0) { perror(sc->redirect_in); _exit(1); }
            dup2(fd, STDIN_FILENO); close(fd);
        }
        if (sc->redirect_out) {
            int fd = open(sc->redirect_out, O_WRONLY | O_CREAT | O_TRUNC, 0644);
            if (fd < 0) { perror(sc->redirect_out); _exit(1); }
            dup2(fd, STDOUT_FILENO); close(fd);
        }
        if (sc->redirect_append) {
            int fd = open(sc->redirect_append, O_WRONLY | O_CREAT | O_APPEND, 0644);
            if (fd < 0) { perror(sc->redirect_append); _exit(1); }
            dup2(fd, STDOUT_FILENO); close(fd);
        }
        execvp(prog, sc->argv);
        fprintf(stderr, "aish: %s: %s\n", prog, strerror(errno));
        _exit(127);
    }

    /* Parent */
    int status;
    waitpid(pid, &status, 0);
    return WIFEXITED(status) ? WEXITSTATUS(status) : 1;
}

int execute_command(command_t *cmd) {
    if (!cmd || cmd->ncmds == 0) return 0;

    if (cmd->ncmds == 1) {
        if (cmd->background) {
            pid_t pid = fork();
            if (pid == 0) {
                /* Child: execute in background */
                execute_simple(&cmd->cmds[0]);
                _exit(0);
            }
            if (pid > 0) {
                job_add(pid, cmd->cmds[0].argv[0]);
                printf("[bg] %d\n", pid);
            }
            return 0;
        }
        return execute_simple(&cmd->cmds[0]);
    }

    /* Pipeline */
    int pipes[MAX_CMDS - 1][2];
    int status = 0;

    for (int i = 0; i < cmd->ncmds - 1; i++) {
        if (pipe(pipes[i]) < 0) {
            perror("pipe");
            return 1;
        }
    }

    pid_t pids[MAX_CMDS];
    for (int i = 0; i < cmd->ncmds; i++) {
        pids[i] = fork();
        if (pids[i] < 0) { perror("fork"); return 1; }
        if (pids[i] == 0) {
            /* Set up pipes */
            if (i > 0) {
                dup2(pipes[i-1][0], STDIN_FILENO);
            }
            if (i < cmd->ncmds - 1) {
                dup2(pipes[i][1], STDOUT_FILENO);
            }
            /* Close all pipe fds */
            for (int j = 0; j < cmd->ncmds - 1; j++) {
                close(pipes[j][0]);
                close(pipes[j][1]);
            }

            simple_cmd_t *sc = &cmd->cmds[i];
            if (is_builtin(sc->argv[0])) {
                _exit(execute_builtin(sc->argv[0], sc->argv, sc->argc));
            }
            execvp(sc->argv[0], sc->argv);
            fprintf(stderr, "aish: %s: %s\n", sc->argv[0], strerror(errno));
            _exit(127);
        }
    }

    /* Close all pipe fds in parent */
    for (int i = 0; i < cmd->ncmds - 1; i++) {
        close(pipes[i][0]);
        close(pipes[i][1]);
    }

    /* Wait for all children */
    for (int i = 0; i < cmd->ncmds; i++) {
        int s;
        waitpid(pids[i], &s, 0);
        if (i == cmd->ncmds - 1)
            status = WIFEXITED(s) ? WEXITSTATUS(s) : 1;
    }

    return status;
}
