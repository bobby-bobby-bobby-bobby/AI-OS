PREFIX ?= /usr/local
DATADIR ?= /usr/share/langmgr
BINDIR  ?= $(PREFIX)/bin
LIBDIR  ?= /var/lib/langmgr

install:
	install -Dm755 lang $(DESTDIR)$(BINDIR)/lang
	install -Dm755 run  $(DESTDIR)$(BINDIR)/run
	install -Dm644 registry.yaml $(DESTDIR)$(DATADIR)/registry.yaml
	install -dm755 $(DESTDIR)$(LIBDIR)
	install -dm755 $(DESTDIR)$(DATADIR)/handlers
	install -Dm755 handlers/*.sh $(DESTDIR)$(DATADIR)/handlers/

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/lang $(DESTDIR)$(BINDIR)/run
	rm -rf $(DESTDIR)$(DATADIR)

.PHONY: install uninstall
