SUBDIRS := media editor files browser-picker ui-picker settings

.PHONY: all check install
all check install:
	@for d in $(SUBDIRS); do $(MAKE) -C $$d $@; done
