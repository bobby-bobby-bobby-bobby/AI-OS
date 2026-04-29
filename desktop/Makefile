CC ?= cc
CFLAGS ?= -Wall -Wextra -O2
BIN := wm panel launcher settings theme-engine

all: $(BIN)

wm: wm.c
	$(CC) $(CFLAGS) -o $@ $<
panel: panel.c
	$(CC) $(CFLAGS) -o $@ $<
launcher: launcher.c
	$(CC) $(CFLAGS) -o $@ $<
settings: settings.c
	$(CC) $(CFLAGS) -o $@ $<
theme-engine: theme-engine.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(BIN)
