#ifndef BUILTINS_H
#define BUILTINS_H

#include "parser.h"

void builtins_init(void);
int  execute_builtin(const char *name, char **argv, int argc);
int  is_builtin(const char *name);

/* Individual builtins */
int builtin_cd(char **argv, int argc);
int builtin_exit(char **argv, int argc);
int builtin_export(char **argv, int argc);
int builtin_unset(char **argv, int argc);
int builtin_alias(char **argv, int argc);
int builtin_history(char **argv, int argc);
int builtin_help(char **argv, int argc);
int builtin_echo(char **argv, int argc);
int builtin_pwd(char **argv, int argc);
int builtin_type(char **argv, int argc);
int builtin_jobs(char **argv, int argc);
int builtin_fg(char **argv, int argc);
int builtin_bg(char **argv, int argc);
int builtin_source(char **argv, int argc);

#endif
