CC ?= cc
CFLAGS ?= -Wall -Wextra -O2
SRC := aish.c builtins.c parser.c executor.c
all: aish

aish: $(SRC)
	$(CC) $(CFLAGS) -o $@ $(SRC)

clean:
	rm -f aish
