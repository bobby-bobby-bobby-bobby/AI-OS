/*
 * aish — Prompt rendering
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pwd.h>
#include <sys/utsname.h>

#include "prompt.h"

char *prompt_render(int last_status) {
    static char buf[512];
    char cwd[256];
    char user[64];
    char host[64];

    /* Get username */
    struct passwd *pw = getpwuid(getuid());
    if (pw) strncpy(user, pw->pw_name, sizeof(user) - 1);
    else    snprintf(user, sizeof(user), "%d", getuid());

    /* Get hostname */
    if (gethostname(host, sizeof(host)) != 0)
        strncpy(host, "aios", sizeof(host) - 1);

    /* Get cwd (shortened) */
    const char *home = getenv("HOME");
    if (getcwd(cwd, sizeof(cwd))) {
        if (home && strncmp(cwd, home, strlen(home)) == 0) {
            char shortcwd[256];
            snprintf(shortcwd, sizeof(shortcwd), "~%s", cwd + strlen(home));
            strncpy(cwd, shortcwd, sizeof(cwd) - 1);
        }
    } else {
        strncpy(cwd, "?", sizeof(cwd) - 1);
    }

    /* Custom PS1 from environment */
    const char *ps1 = getenv("PS1");
    if (ps1) {
        /* Expand basic escapes */
        const char *p = ps1;
        char *out = buf;
        char *end = buf + sizeof(buf) - 1;
        while (*p && out < end) {
            if (*p == '\\' && *(p+1)) {
                p++;
                switch (*p) {
                case 'u': out += snprintf(out, end - out, "%s", user); break;
                case 'h': out += snprintf(out, end - out, "%s", host); break;
                case 'w': out += snprintf(out, end - out, "%s", cwd); break;
                case '$': *out++ = (getuid() == 0) ? '#' : '$'; break;
                case 'n': *out++ = '\n'; break;
                default:  *out++ = *p; break;
                }
                p++;
            } else {
                *out++ = *p++;
            }
        }
        *out = '\0';
        return buf;
    }

    /* Default colored prompt:
     *   user@host:cwd$ (green for normal, red for root, yellow suffix if last cmd failed)
     */
    int is_root = (getuid() == 0);
    const char *color_user = is_root ? "\033[1;31m" : "\033[1;32m";
    const char *color_host = "\033[1;32m";
    const char *color_cwd  = "\033[1;34m";
    const char *color_prompt = (last_status != 0) ? "\033[1;33m" : "\033[1;37m";
    const char *reset = "\033[0m";
    const char *suffix = is_root ? "#" : "$";

    snprintf(buf, sizeof(buf),
             "%s%s%s@%s%s%s:%s%s%s %s%s%s ",
             color_user, user, reset,
             color_host, host, reset,
             color_cwd, cwd, reset,
             color_prompt, suffix, reset);

    return buf;
}
