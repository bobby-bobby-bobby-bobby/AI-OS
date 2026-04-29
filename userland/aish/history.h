#ifndef HISTORY_H
#define HISTORY_H

void  history_init(void);
void  history_add(const char *line);
void  history_print(void);
void  history_load(const char *path);
void  history_save(const char *path, int max_entries);
char *history_get(int index); /* 0 = most recent */

char *readline_with_history(char *buf, int size);

#endif
