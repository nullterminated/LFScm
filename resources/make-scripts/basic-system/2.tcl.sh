#!/bin/bash

set -e

tar xf tcl.tar.gz
cd tcl

if [[ -f "../tcl8.6.10-html.tar.gz" ]]; then
    tar -xf ../tcl8.6.10-html.tar.gz --strip-components=1
fi

SRCDIR=$(pwd)
cd unix
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            $([ "$(uname -m)" = x86_64 ] && echo --enable-64bit)

make -j$(nproc)

sed -e "s|$SRCDIR/unix|/usr/lib|" \
    -e "s|$SRCDIR|/usr/include|"  \
    -i tclConfig.sh

if [[ -f "pkgs/tdbc1.1.1/tdbcConfig.sh" ]]; then
    sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.1|/usr/lib/tdbc1.1.1|" \
        -e "s|$SRCDIR/pkgs/tdbc1.1.1/generic|/usr/include|"    \
        -e "s|$SRCDIR/pkgs/tdbc1.1.1/library|/usr/lib/tcl8.6|" \
        -e "s|$SRCDIR/pkgs/tdbc1.1.1|/usr/include|"            \
        -i pkgs/tdbc1.1.1/tdbcConfig.sh
fi

if [[ -f "pkgs/itcl4.2.0/itclConfig.sh" ]]; then
    sed -e "s|$SRCDIR/unix/pkgs/itcl4.2.0|/usr/lib/itcl4.2.0|" \
        -e "s|$SRCDIR/pkgs/itcl4.2.0/generic|/usr/include|"    \
        -e "s|$SRCDIR/pkgs/itcl4.2.0|/usr/include|"            \
        -i pkgs/itcl4.2.0/itclConfig.sh
fi

unset SRCDIR

#make test -j$(nproc)

make install

chmod -v u+w /usr/lib/libtcl*.so

make install-private-headers

tclver=(/usr/bin/tclsh*)
ln -sfv "${tclver}" /usr/bin/tclsh

cd ../..
rm -rf tcl