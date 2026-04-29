CC      ?= gcc
CFLAGS  := -Wall -Wextra -std=c11 -Os
LDFLAGS :=

SRCS    := aish.c builtins.c parser.c history.c job_control.c prompt.c
OBJS    := $(SRCS:.c=.o)
TARGET  := aish

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(OBJS) $(TARGET)

install: $(TARGET)
	install -Dm755 $(TARGET) $(DESTDIR)/bin/aish

.PHONY: all clean install
