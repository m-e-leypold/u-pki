
-include Config.mk
BINDIR ?= $(prefix)/bin


all:
	true

test:
	sh test3.sh

cleaner: clean
	rm Config.mk

clean:
	rm -rf ca2 ca1 org1 org2 SHIPDIR

install:
	install -m 755 u-pki $(BINDIR)

Config.mk:
	./configure
