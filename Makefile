#
# Makefile:
# 	Make CleanArchiver application
#

XFLAGS=		-activeconfiguration

.PHONY: build installsrc install clean

build:
	xcodebuild ${XFLAGS}

installsrc:
	xcodebuild ${XFLAGS} installsrc

install:
	xcodebuild ${XFLAGS} install

clean:
	xcodebuild ${XFLAGS} clean
