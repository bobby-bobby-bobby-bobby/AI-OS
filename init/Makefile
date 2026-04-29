CC      ?= gcc
CFLAGS  := -Wall -Wextra -std=c11 -Os -static
LDFLAGS :=

SRCS    := init.c mount.c service.c log.c tty.c
OBJS    := $(SRCS:.c=.o)
TARGET  := init

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(OBJS) $(TARGET)

install: $(TARGET)
	install -Dm755 $(TARGET) $(DESTDIR)/sbin/init

.PHONY: all clean install
