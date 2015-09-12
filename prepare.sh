#!/usr/bin/bash

# -e -> fail on first error
# -v -> print not expanded commands
# -x -> print expanded commands
set -e -v -x

prepdir="$(dirname $0)"
. "${prepdir}/variables.sh"

pushd "${distrodir}"
./install_pkgs.sh
popd # distrodir

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
git remote add "${remote_name}" "${custom_mesa}"
git fetch "${remote_name}"
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
pushd piglit
git remote add "${remote_name}" "${custom_piglit}"
git fetch "${remote_name}"
git config sendemail.to 'piglit@lists.freedesktop.org'
popd # piglit
popd # ogldir

mkdir "${jhbuilddir}"
pushd "${jhbuilddir}"
git clone https://git.gnome.org/browse/jhbuild src
ln -s ../jhbuildconf.sh c.sh
popd # jhbuilddir

if [ ! -d "${bindir}" ]
then
    mkdir "${bindir}"
fi
cp "${prepdir}/oglshell.sh" "${bindir}"

check_bash_profile() {
    if grep --silent -e '\(^\|[[:space:]]\)PATH=.*'"${1}"'\($\|:\)' "${bprof}"
    then
        echo 'f'
    fi
}

logout_needed=
if [ -z "$(check_bash_profile "${rawbindir}")$(check_bash_profile "${brawbindir}")" ]
then
    echo 'PATH=$PATH:$HOME/bin' >> "${bprof}"
    echo 'export PATH' >> "${bprof}"
    logout_needed=x
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
"${usrdir}/bin/jhbuild" --file "${usrdir}/jhbuildrc" run "${prepdir}/build_in_oglshell.sh"

# +v -> do not print not expanded commands
# +x -> do not print expanded commands
set +v +x

echo
echo
echo
echo
echo 'Done'

if [ -n "${logout_needed}" ]
then
    echo "Log out and log in again to apply changes in .bash_profile"
fi

echo 'Remember to set up git send-email configuration'
