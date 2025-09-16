#!/bin/bash

set -euxo pipefail

git clone -b devel-paratools https://github.com/ParaToolsInc/Spindle.git /home/$USER/Spindle
mkdir -p /home/$USER/Spindle-build
cd /home/$USER/Spindle-build
/home/$USER/Spindle/configure --prefix=/home/$USER/Spindle-inst --enable-sec-munge --with-rm=serial --with-localstorage=/tmp CFLAGS="-Og -g" CXXFLAGS="-Og -g"
make -j8
make install

