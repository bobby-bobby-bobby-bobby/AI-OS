#ifndef PARSER_H
#define PARSER_H

#define MAX_ARGS   64
#define MAX_CMDS   16

/* A single command with its arguments */
typedef struct {
    char  *argv[MAX_ARGS + 1]; /* NULL-terminated */
    int    argc;
    char  *redirect_in;        /* < filename */
    char  *redirect_out;       /* > filename */
    char  *redirect_append;    /* >> filename */
    int    background;         /* & */
} simple_cmd_t;

/* A pipeline of commands */
typedef struct command {
    simple_cmd_t cmds[MAX_CMDS];
    int          ncmds;
    int          background;
} command_t;

command_t *parse_line(const char *line);
void       command_free(command_t *cmd);
int        execute_command(command_t *cmd);

#endif
