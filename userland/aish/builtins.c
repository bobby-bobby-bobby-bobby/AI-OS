#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "builtins.h"

void builtins_init(void) {}
int is_builtin(const char *name){
    const char *b[] = {"cd","exit","export","pwd","jobs","fg","bg",NULL};
    for(int i=0;b[i];i++) if(strcmp(name,b[i])==0) return 1;
    return 0;
}
int execute_builtin(const char *name, char **argv, int argc){
    if(strcmp(name,"cd")==0) return builtin_cd(argv,argc);
    if(strcmp(name,"exit")==0) return builtin_exit(argv,argc);
    if(strcmp(name,"export")==0) return builtin_export(argv,argc);
    if(strcmp(name,"pwd")==0) return builtin_pwd(argv,argc);
    if(strcmp(name,"jobs")==0) return builtin_jobs(argv,argc);
    if(strcmp(name,"fg")==0) return builtin_fg(argv,argc);
    if(strcmp(name,"bg")==0) return builtin_bg(argv,argc);
    return 0;
}
int builtin_cd(char **argv,int argc){return chdir(argc>1?argv[1]:getenv("HOME"));}
int builtin_exit(char **argv,int argc){(void)argv;(void)argc;return -1;}
int builtin_export(char **argv,int argc){if(argc>1){char *eq=strchr(argv[1],'='); if(eq){*eq='\0'; setenv(argv[1],eq+1,1);}}return 0;}
int builtin_pwd(char **argv,int argc){(void)argv;(void)argc;char b[512]; if(getcwd(b,sizeof(b))) puts(b); return 0;}
int builtin_jobs(char **a,int c){(void)a;(void)c; puts("jobs stub"); return 0;}
int builtin_fg(char **a,int c){(void)a;(void)c; puts("fg stub"); return 0;}
int builtin_bg(char **a,int c){(void)a;(void)c; puts("bg stub"); return 0;}
int builtin_unset(char **a, int c) { (void)a; (void)c; return 0; }
int builtin_alias(char **a, int c) { (void)a; (void)c; return 0; }
int builtin_history(char **a, int c) { (void)a; (void)c; return 0; }
int builtin_help(char **a, int c) { (void)a; (void)c; return 0; }
int builtin_echo(char **a, int c) { (void)a; (void)c; return 0; }
int builtin_type(char **a, int c) { (void)a; (void)c; return 0; }
int builtin_source(char **a, int c) { (void)a; (void)c; return 0; }
