#ifndef LOG_H
#define LOG_H

int  log_init(const char *path);
void log_info(const char *fmt, ...);
void log_warn(const char *fmt, ...);
void log_err(const char *fmt, ...);
void log_close(void);

#endif /* LOG_H */
