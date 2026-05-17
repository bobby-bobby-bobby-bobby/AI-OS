CC ?= cc
CFLAGS ?= -Wall -Wextra -O2
BIN := wm panel launcher settings theme-engine
all: $(BIN)
$(BIN): %: %.c
	$(CC) $(CFLAGS) -o $@ $<
check:
	@test -x ../desktop/theme-engine.sh
clean:
	rm -f $(BIN)
