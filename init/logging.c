#include <stdio.h>
void ai_log(const char *msg) {
    fprintf(stderr, "[ai-os] %s\n", msg ? msg : "(null)");
}
