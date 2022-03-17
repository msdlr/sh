#!/usr/bin/env sh

# Requires package: libncurses-dev

ncver="6.3"

build_ncurses() {
	echo "Building ncurses..."
	wget "http://ftp.gnu.org/gnu/ncurses/ncurses-${ncver}.tar.gz" && tar xf ncurses-${ncver}.tar.gz && rm ncurses-${ncver}.tar.gz
	cd ncurses-${ncver}
	./configure --prefix=${HOME}/.local CXXFLAGS="-fPIC" CFLAGS="-fPIC"
	make -j && make install
}

rm_ncurses() {
	cd ncurses-${ncver}
	make uninstall
	cd ..
	rm -rf ncurses-${ncver}
}

build_zsh() {
	tarfile="/tmp/zsh.tar.xz"
	link="https://sourceforge.net/projects/zsh/files/latest/download"
	srcdir="/tmp/zsh"
	mkdir -p ${srcdir}

	cd /tmp
	[ -f ${tarfile} ] || curl -Lo "${tarfile}" "${link}"
	tar xJvf "${tarfile}" -C "${srcdir}" --strip-components 1 && rm ${tarfile}
	cd ${srcdir}
	./configure --prefix="${HOME}/.local" CPPFLAGS="-I${HOME}/.local/include" LDFLAGS="-L${HOME}/.local/lib" &&	make -j && make install
}



build_ncurses
build_zsh &
wait
rm_ncurses

