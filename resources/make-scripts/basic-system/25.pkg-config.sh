#!/bin/bash

set -e

tar xf pkg.tar.gz
cd pkg

./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.2

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf pkg