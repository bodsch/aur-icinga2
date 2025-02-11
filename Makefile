#

.PHONY: geninteg build srcinfo

default: geninteg

geninteg:
	makepkg --geninteg

build:
	makepkg --cleanbuild --syncdeps --force

srcinfo:
	makepkg --printsrcinfo > .SRCINFO

clean:
	rm -f *.deb
