/*
 * aish — AI Shell
 * A POSIX-compatible shell for AI-OS.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <signal.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <termios.h>
#include <fcntl.h>
#include <limits.h>
#include <ctype.h>

#include "builtins.h"
#include "parser.h"
#include "job_control.h"
#include "history.h"
#include "prompt.h"

#define AISH_VERSION    "0.1.0"
#define AISH_HISTFILE   ".aish_history"
#define AISH_HISTSIZE   1000
#define LINE_MAX_LEN    4096

static int interactive = 0;
static int exit_status = 0;

static void aish_banner(void) {
    printf("\033[1;36maish\033[0m %s — AI-OS Shell\n", AISH_VERSION);
    printf("Type 'help' for built-in commands, 'exit' to quit.\n\n");
}

static void aish_sigchld(int sig) {
    (void)sig;
    int saved = errno;
    while (waitpid(-1, NULL, WNOHANG) > 0)
        ;
    errno = saved;
}

static void aish_setup_signals(void) {
    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sigemptyset(&sa.sa_mask);

    if (interactive) {
        sa.sa_handler = SIG_IGN;
        sigaction(SIGINT,  &sa, NULL);
        sigaction(SIGQUIT, &sa, NULL);
        sigaction(SIGTSTP, &sa, NULL);
        sigaction(SIGTTIN, &sa, NULL);
        sigaction(SIGTTOU, &sa, NULL);
    }

    sa.sa_handler = aish_sigchld;
    sa.sa_flags   = SA_RESTART;
    sigaction(SIGCHLD, &sa, NULL);
}

static int run_file(const char *path) {
    FILE *f = fopen(path, "r");
    if (!f) {
        fprintf(stderr, "aish: %s: %s\n", path, strerror(errno));
        return 1;
    }

    char line[LINE_MAX_LEN];
    int status = 0;

    while (fgets(line, sizeof(line), f)) {
        /* Strip newline */
        line[strcspn(line, "\n")] = '\0';
        /* Skip empty lines and comments */
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

static void repl(void) {
    char line[LINE_MAX_LEN];
    char *histfile = NULL;

    /* Load history */
    const char *home = getenv("HOME");
    if (home) {
        size_t len = strlen(home) + strlen(AISH_HISTFILE) + 2;
        histfile = malloc(len);
        if (histfile) {
            snprintf(histfile, len, "%s/%s", home, AISH_HISTFILE);
            history_load(histfile);
        }
    }

    if (interactive) {
        aish_banner();
    }

    while (1) {
        /* Print prompt */
        if (interactive) {
            char *ps1 = prompt_render(exit_status);
            fputs(ps1, stdout);
            fflush(stdout);
        }

        /* Read line (with history support in interactive mode) */
        char *input;
        if (interactive) {
            input = readline_with_history(line, sizeof(line));
        } else {
            input = fgets(line, sizeof(line), stdin);
            if (input) {
                line[strcspn(line, "\n")] = '\0';
            }
        }

        if (!input) {
            /* EOF */
            if (interactive) printf("\nexit\n");
            break;
        }

        /* Skip blank lines */
        if (line[0] == '\0') continue;

        /* Add to history */
        if (interactive && line[0] != ' ') {
            history_add(line);
        }

        /* Parse and execute */
        command_t *cmd = parse_line(line);
        if (cmd) {
            exit_status = execute_command(cmd);
            command_free(cmd);
        }
    }

    /* Save history */
    if (histfile) {
        history_save(histfile, AISH_HISTSIZE);
        free(histfile);
    }
}

int main(int argc, char *argv[]) {
    /* Check if interactive */
    interactive = isatty(STDIN_FILENO);

    /* Environment setup */
    if (!getenv("PATH"))
        putenv("PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin");
    if (!getenv("HOME"))
        putenv("HOME=/root");
    if (!getenv("SHELL"))
        putenv("SHELL=/bin/aish");

    aish_setup_signals();
    builtins_init();
    job_control_init();

    /* Parse arguments */
    if (argc > 1) {
        if (strcmp(argv[1], "-c") == 0 && argc > 2) {
            /* Execute command string */
            command_t *cmd = parse_line(argv[2]);
            if (cmd) {
                exit_status = execute_command(cmd);
                command_free(cmd);
            }
            return exit_status;
        } else if (argv[1][0] != '-') {
            /* Execute script file */
            return run_file(argv[1]);
        } else if (strcmp(argv[1], "--version") == 0 || strcmp(argv[1], "-v") == 0) {
            printf("aish %s\n", AISH_VERSION);
            return 0;
        } else if (strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-h") == 0) {
            printf("Usage: aish [options] [script] [args]\n"
                   "       aish -c 'command'\n"
                   "Options:\n"
                   "  -c <cmd>     Execute command string\n"
                   "  -v           Show version\n"
                   "  -h           Show help\n");
            return 0;
        }
    }

    repl();
    return exit_status;
}
