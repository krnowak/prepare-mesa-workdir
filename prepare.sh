#!/usr/bin/bash

# -e -> fail on first error
# -v -> print not expanded commands
# -x -> print expanded commands
set -e -v -x

prepdir="$(dirname $0)"
. "${prepdir}/variables.sh"

sudo dnf install $(cat "${prepdir}/packages")

# clone and copy stuff

mkdir -p "${ogldir}"
for f in "${prepdir}/"*conf.sh
do
    cp "${f}" "${ogldir}"
done
mkdir "${mesadir}"
pushd "${mesadir}"
git clone git://anongit.freedesktop.org/mesa/mesa src
pushd src
git remote add krnowak git@github.com:krnowak/mesa.git
git fetch krnowak
git config sendemail.to 'mesa-dev@lists.freedesktop.org'
popd # src
ln -s ../mesaconf.sh c.sh
popd # mesadir

cp -R "${mesadir}" "${vmesadir}"

mkdir "${gludir}"
pushd "${gludir}"
git clone git://anongit.freedesktop.org/mesa/glu src
ln -s ../gluconf.sh c.sh
popd # gludir

pushd "${ogldir}"
git clone git://anongit.freedesktop.org/piglit piglit
push piglit
git remote add krnowak git@github.com:krnowak/piglit.git
git fetch krnowak
git config sendemail.to 'piglit@lists.freedesktop.org'
popd $ # piglit
popd # ogldir

mkdir "${jhbuilddir}"
pushd "${jhbuilddir}"
git clone ssh://krnowak@git.gnome.org/git/jhbuild src
ln -s ../jhbuildconf.sh c.sh
popd # jhbuilddir

if [ ! -d "${bindir}" ]
then
    mkdir "${bindir}"
fi
cp "${prepdir}/oglshell.sh" "${bindir}"

if grep --silent -e '\(^\|[[:space:]]\)PATH=.*'"${rawbindir}"'\($\|:\)' "${bprof}"
then
    :
else
    echo 'PATH=$PATH:$HOME/bin' >> "${bprof}"
    echo 'export PATH' >> "${bprof}"
fi

# start building stuff
pushd "${jhbuilddir}"
pushd src
NOCONFIGURE=x ./autogen.sh
popd # src
./c.sh
pushd build
make -j4
make install
popd # build
popd # jhbuilddir

cp "${prepdir}/jhbuildrc" "${usrdir}/jhbuildrc"
"${usrdir}/bin/jhbuild" --file "${usrdir}/jhbuildrc" run "${prepdir}/build_in_oglshell.sh" "${ogldir}"
