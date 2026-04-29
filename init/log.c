/*
 * AI-OS Init — Logging
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <time.h>
#include <string.h>

#include "log.h"

static FILE *log_file = NULL;

int log_init(const char *path) {
    if (path) {
        log_file = fopen(path, "a");
        if (!log_file) {
            log_file = stderr;
        }
    } else {
        log_file = stderr;
    }
    return 0;
}

static void log_write(const char *level, const char *fmt, va_list ap) {
    if (!log_file) log_file = stderr;

    time_t now = time(NULL);
    struct tm *tm_info = localtime(&now);
    char timebuf[32];
    strftime(timebuf, sizeof(timebuf), "%Y-%m-%d %H:%M:%S", tm_info);

    fprintf(log_file, "[%s] [%s] ", timebuf, level);
    vfprintf(log_file, fmt, ap);
    fprintf(log_file, "\n");
    fflush(log_file);
}

void log_info(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    log_write("INFO", fmt, ap);
    va_end(ap);
}

void log_warn(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    log_write("WARN", fmt, ap);
    va_end(ap);
}

void log_err(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    log_write("ERR ", fmt, ap);
    va_end(ap);
}

void log_close(void) {
    if (log_file && log_file != stderr) {
        fclose(log_file);
        log_file = NULL;
    }
}
