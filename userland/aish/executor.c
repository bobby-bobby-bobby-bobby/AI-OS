#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int aish_resolve_path(const char *cmd, char *out, size_t outsz){
  const char *path=getenv("PATH"); if(!path||strchr(cmd,'/')) return -1;
  char *dup=strdup(path), *save=NULL, *p=strtok_r(dup,":",&save);
  while(p){snprintf(out,outsz,"%s/%s",p,cmd); if(access(out,X_OK)==0){free(dup); return 0;} p=strtok_r(NULL,":",&save);} free(dup); return -1;
}
