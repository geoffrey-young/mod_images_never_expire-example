
export APACHE_TEST_APXS ?= /usr/local/apache/bin/apxs

all : Makefile
	$(MAKE) -f Makefile cmodules

Makefile :
	perl Makefile.PL

install :
	$(APACHE_TEST_APXS) -iac c-modules/images_never_expire/mod_images_never_expire.c

%: force
	@$(MAKE) -f Makefile $@
force: Makefile;

