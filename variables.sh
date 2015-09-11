if [ -z "${prepdir}" ]
then
    echo 'Expected prepdir variable to be set' >&2
    exit 1
fi

ogldir="${1}"
if [ -z "${ogldir}" ]
then
    echo 'Expected a directory as a first parameter' >&2
    exit 1
fi

if [ "${prepdir:0:1}" != "/" ]
then
    prepdir="${PWD}/${prepdir}"
fi
if [ "${ogldir:0:1}" != "/" ]
then
    ogldir="${PWD}/${ogldir}"
fi

mesadir="${ogldir}/mesa"
vmesadir="${ogldir}/vanilla_mesa"
gludir="${ogldir}/glu"
piglitdir="${ogldir}/piglit"
jhbuilddir="${ogldir}/jhbuild"

# without braces, as it usually is placed in .bash_profile
rawbindir='$HOME/bin'
eval bindir=\""${rawbindir}"\"
bprof="${HOME}/.bash_profile"

usrdir="${HOME}/oglusr"
