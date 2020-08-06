#!/bin/bash

set -e

tar xf bison-3.5.2.tar.xz
cd bison-3.5.2

./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.5.2

make -j$(nproc)

make install

cd ../
rm -rf bison-3.5.2

