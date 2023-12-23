# aur build script for icinga

update PKGBUILD

makepkg --cleanbuild --syncdeps --force
makepkg --geninteg
makepkg --printsrcinfo > .SRCINFO
