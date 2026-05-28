SUBDIRS := media editor files browser-picker ui-picker settings
all check:
	@for d in $(SUBDIRS); do $(MAKE) -C $$d $@; done
