/*
 * aish — Command history
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>

#include "history.h"

#define MAX_HISTORY 1000

static char *history[MAX_HISTORY];
static int   hist_count = 0;

void history_init(void) {
    memset(history, 0, sizeof(history));
}

void history_add(const char *line) {
    if (!line || line[0] == '\0') return;
    /* Don't add duplicates of the last entry */
    if (hist_count > 0 && strcmp(history[hist_count - 1], line) == 0)
        return;
    if (hist_count == MAX_HISTORY) {
        free(history[0]);
        memmove(history, history + 1, (MAX_HISTORY - 1) * sizeof(char *));
        hist_count--;
    }
    history[hist_count++] = strdup(line);
}

void history_print(void) {
    for (int i = 0; i < hist_count; i++)
        printf("%4d  %s\n", i + 1, history[i]);
}

void history_load(const char *path) {
    FILE *f = fopen(path, "r");
    if (!f) return;
    char line[4096];
    while (fgets(line, sizeof(line), f)) {
        line[strcspn(line, "\n")] = '\0';
        if (line[0]) history_add(line);
    }
    fclose(f);
}

void history_save(const char *path, int max_entries) {
    FILE *f = fopen(path, "w");
    if (!f) return;
    int start = hist_count > max_entries ? hist_count - max_entries : 0;
    for (int i = start; i < hist_count; i++)
        fprintf(f, "%s\n", history[i]);
    fclose(f);
}

char *history_get(int index) {
    int real_idx = hist_count - 1 - index;
    if (real_idx < 0 || real_idx >= hist_count) return NULL;
    return history[real_idx];
}

/* Minimal line editor with history navigation */
char *readline_with_history(char *buf, int size) {
    struct termios old_t, raw_t;
    int fd = STDIN_FILENO;

    if (!isatty(fd)) {
        char *r = fgets(buf, size, stdin);
        if (r) buf[strcspn(buf, "\n")] = '\0';
        return r;
    }

    tcgetattr(fd, &old_t);
    raw_t = old_t;
    raw_t.c_lflag &= ~(ECHO | ICANON);
    raw_t.c_cc[VMIN]  = 1;
    raw_t.c_cc[VTIME] = 0;
    tcsetattr(fd, TCSAFLUSH, &raw_t);

    int pos    = 0;
    int len    = 0;
    int hist_i = -1; /* -1 = current input */
    char saved[4096] = "";

    buf[0] = '\0';

    while (1) {
        unsigned char c;
        if (read(fd, &c, 1) <= 0) break;

        if (c == '\n' || c == '\r') {
            write(fd, "\n", 1);
            break;
        } else if (c == 3) { /* Ctrl-C */
            buf[0] = '\0';
            write(fd, "\n", 1);
            break;
        } else if (c == 4 && len == 0) { /* Ctrl-D on empty line = EOF */
            tcsetattr(fd, TCSAFLUSH, &old_t);
            return NULL;
        } else if (c == 127 || c == 8) { /* Backspace */
            if (pos > 0) {
                memmove(buf + pos - 1, buf + pos, len - pos + 1);
                pos--; len--;
                /* Redraw */
                write(fd, "\r\033[K", 4); /* clear line */
                /* Reprint prompt is done by caller; just reprint buf */
                write(fd, buf, len);
                /* Move cursor to pos */
                char mv[16];
                int n = snprintf(mv, sizeof(mv), "\r\033[%dC", pos);
                write(fd, mv, n);
            }
        } else if (c == 27) { /* Escape sequence */
            unsigned char seq[3];
            if (read(fd, &seq[0], 1) <= 0) break;
            if (read(fd, &seq[1], 1) <= 0) break;
            if (seq[0] == '[') {
                if (seq[1] == 'A') { /* Up arrow */
                    if (hist_i == -1) strncpy(saved, buf, sizeof(saved));
                    int next = hist_i + 1;
                    char *h = history_get(next);
                    if (h) {
                        hist_i = next;
                        strncpy(buf, h, size - 1);
                        len = pos = strlen(buf);
                        write(fd, "\r\033[K", 4);
                        write(fd, buf, len);
                    }
                } else if (seq[1] == 'B') { /* Down arrow */
                    if (hist_i > 0) {
                        hist_i--;
                        char *h = history_get(hist_i);
                        strncpy(buf, h ? h : "", size - 1);
                    } else if (hist_i == 0) {
                        hist_i = -1;
                        strncpy(buf, saved, size - 1);
                    }
                    len = pos = strlen(buf);
                    write(fd, "\r\033[K", 4);
                    write(fd, buf, len);
                } else if (seq[1] == 'C' && pos < len) { /* Right */
                    pos++;
                    write(fd, "\033[C", 3);
                } else if (seq[1] == 'D' && pos > 0) { /* Left */
                    pos--;
                    write(fd, "\033[D", 3);
                }
            }
        } else if (c >= 32 && len < size - 1) { /* Printable */
            memmove(buf + pos + 1, buf + pos, len - pos + 1);
            buf[pos] = c;
            pos++; len++;
            write(fd, buf + pos - 1, len - pos + 1);
            if (pos < len) {
                char mv[16];
                int n = snprintf(mv, sizeof(mv), "\033[%dD", len - pos);
                write(fd, mv, n);
            }
        }
    }

    tcsetattr(fd, TCSAFLUSH, &old_t);
    return buf;
}
