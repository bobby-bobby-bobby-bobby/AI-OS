#!/bin/sh
# langmgr — handler for esoteric languages

set -e

ACTION="$1"
LANG="$2"

install_brainfuck() {
    echo "Installing Brainfuck interpreter..."
    # Build a minimal bf interpreter from C
    local tmpdir
    tmpdir="$(mktemp -d /tmp/bf-build-XXXXXX)"
    cat > "${tmpdir}/brainfuck.c" <<'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TAPE_SIZE 30000

int main(int argc, char *argv[]) {
    if (argc < 2) { fprintf(stderr, "Usage: brainfuck <file>\n"); return 1; }

    FILE *f = fopen(argv[1], "r");
    if (!f) { perror(argv[1]); return 1; }
    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    fseek(f, 0, SEEK_SET);
    char *prog = malloc(sz + 1);
    fread(prog, 1, sz, f);
    prog[sz] = '\0';
    fclose(f);

    unsigned char tape[TAPE_SIZE] = {0};
    int ptr = 0;
    int ip  = 0;
    int depth;

    while (ip < sz) {
        switch (prog[ip]) {
        case '>': ptr = (ptr + 1) % TAPE_SIZE; break;
        case '<': ptr = (ptr - 1 + TAPE_SIZE) % TAPE_SIZE; break;
        case '+': tape[ptr]++; break;
        case '-': tape[ptr]--; break;
        case '.': putchar(tape[ptr]); fflush(stdout); break;
        case ',': { int c = getchar(); tape[ptr] = (c == EOF) ? 0 : (unsigned char)c; break; }
        case '[':
            if (!tape[ptr]) {
                depth = 1;
                while (depth && ++ip < sz) {
                    if (prog[ip] == '[') depth++;
                    else if (prog[ip] == ']') depth--;
                }
            }
            break;
        case ']':
            if (tape[ptr]) {
                depth = 1;
                while (depth && --ip >= 0) {
                    if (prog[ip] == ']') depth++;
                    else if (prog[ip] == '[') depth--;
                }
            }
            break;
        }
        ip++;
    }
    free(prog);
    return 0;
}
EOF
    gcc -O2 "${tmpdir}/brainfuck.c" -o "${tmpdir}/brainfuck"
    install -m 755 "${tmpdir}/brainfuck" /usr/local/bin/brainfuck
    rm -rf "${tmpdir}"
    echo "Brainfuck interpreter installed: /usr/local/bin/brainfuck"
}

case "${ACTION}" in
    install)
        case "${LANG}" in
            brainfuck) install_brainfuck ;;
            *)         echo "Note: ${LANG} requires manual installation" ;;
        esac
        ;;
    *)  echo "Unknown action: ${ACTION}" >&2; exit 1 ;;
esac
