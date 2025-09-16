#!/bin/bash
#
set -euxo pipefail

git clone -b devel-paratools https://github.com/ParaToolsInc/Spindle.git /home/fluxuser/Spindle
mkdir -p /home/fluxuser/Spindle-build
cd /home/fluxuser/Spindle-build
/home/fluxuser/Spindle/configure --prefix=/home/fluxuser/Spindle-inst --enable-sec-munge --with-rm=flux --enable-flux-plugin --with-localstorage=/tmp CFLAGS="-Og -g" CXXFLAGS="-Og -g"
make -j8
make install
