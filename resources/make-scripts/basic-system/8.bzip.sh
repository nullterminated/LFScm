#!/bin/bash

set -e

tar xf bzip.tar.gz
cd bzip

if [[ -f "../bzip2-1.0.8-install_docs-1.patch" ]]; then
	patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch
fi

sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile

sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

make -f Makefile-libbz2_so
make clean

make -j$(nproc)

make PREFIX=/usr install

cp -v bzip2-shared /bin/bzip2
cp -av libbz2.so* /lib
ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
rm -v /usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 /bin/bunzip2
ln -sv bzip2 /bin/bzcat

cd ../
rm -rf bzip




