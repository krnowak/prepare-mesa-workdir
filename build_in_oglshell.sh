#!/usr/bin/bash

# -e -> fail on first error
# -v -> print not expanded commands
# -x -> print expanded commands
set -e -v -x

prepdir="$(dirname $0)"
. "${prepdir}/variables.sh"

# build and install vanilla mesa

pushd "${vmesadir}"
pushd src
NOCONFIGURE=x ./autogen.sh
popd # src
./c.sh
pushd build
make -j4
make install
popd # build
popd # vmesadir

# build and install glu

pushd "${gludir}"
pushd src
NOCONFIGURE=x ./autogen.sh
popd # src
./c.sh
pushd build
make -j4
make install
popd # build
popd # gludir

# build mesa

pushd "${mesadir}"
pushd src
NOCONFIGURE=x ./autogen.sh
popd # src
./c.sh
pushd build
make -j4
popd # build
popd # mesadir

# build piglit

pushd "${piglitdir}"
../piglitconf.sh
make -j4
popd # piglitdir
