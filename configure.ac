#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([prepare-mesa-workdir], [0.1], [qdlacz@gmail.com])

AC_MSG_CHECKING([for os-release file])
os_release=
AS_IF([test -f /etc/os-release],
      [os_release=/etc/os-release],
      [AS_IF([test -f /usr/lib/os-release],
             [os_release=/usr/lib/os-release])])

AS_VAR_IF([os_release],[],
          [AC_MSG_RESULT([not found])
           AC_MSG_ERROR([*** os-release file not found in /etc and /usr/lib])],
          [AC_MSG_RESULT([$os_release])])

os_id=`cat "$os_release" | grep '^ID=' | cut -c 4-`
AS_VAR_IF([os_id],[],
          [os_id=linux])

AC_MSG_CHECKING([for distro name])
distro=
# pipe-separated list of supported distros (like a|b|c)
SUPPORTED_DISTROS=fedora
AS_CASE([$os_id],
        [fedora],
               [distro=$os_id],
        [])
AS_VAR_IF([distro],[],
          [os_id_like=`cat "$os_release" | grep '^ID_LIKE=' | cut -c 9-`
           AS_VAR_IF([os_id_like],[],
                     [AC_MSG_RESULT([$os_id])
                      AC_MSG_ERROR([*** Distro $os_id is not supported])])

           derivative=
           for d in $os_id_like
           do
                   AS_CASE([$d],
                           [$SUPPORTED_DISTROS],
                                   [derivative=$d
                                    break],
                           [])
           done
           AS_VAR_IF([derivative],[],
                     [AC_MSG_RESULT([$os_id (derivative of $os_id_like)])
                      AC_MSG_ERROR([*** Distro $os_id (derivative of $os_id_like) is not supported])],
                     [AC_MSG_RESULT([$os_id (derivative of $os_id_like) supported via $derivative])])
           distro=$derivative],
          [AC_MSG_RESULT([$distro])])

AC_SUBST(DISTRO, [$distro])

AC_ARG_WITH([src-dir],
            [AS_HELP_STRING([--with-src-dir],[directory where the sources will be put])],
	    [AS_VAR_IF([withval],[],
	               [AC_MSG_ERROR([--with-src-dir expects non-empty parameter])])
	     srcdir=$withval],
	    [srcdir="$HOME/projects/opengl"])

AC_ARG_WITH([usr-dir],
            [AS_HELP_STRING([--with-usr-dir],[directory where the binaries will be installed])],
	    [AS_VAR_IF([withval],[],
	               [AC_MSG_ERROR([--with-usr-dir expects non-empty parameter])])
	     usrdir=$withval],
	    [usrdir="$HOME/oglusr"])

abs() {
        AS_IF([AS_ECHO(["$1"]) | grep --silent -e '^/'],
	      [AS_ECHO(["$1"])],
	      [AS_ECHO(["`pwd`/$1"])])
}

AC_SUBST(SRCDIR, [`abs $srcdir`])
AC_SUBST(USRDIR, [`abs $usrdir`])

AC_ARG_WITH([custom-remote-name],
            [AS_HELP_STRING([--with-custom-remote-name], [name of additional git remote repo])],
	    [AS_VAR_IF([withval],[],
	               [AC_MSG_ERROR([--with-custom-remote-name expects non-empty parameter])])
	     remote=$withval],
	    [remote=krnowak])

AC_SUBST(REMOTE_NAME, [$remote])

AC_ARG_WITH([custom-mesa-remote],
            [AS_HELP_STRING([--with-custom-mesa-remote], [additional git remote mesa repo])],
	    [AS_VAR_IF([withval],[],
	               [AC_MSG_ERROR([--with-custom-mesa-remote expects non-empty parameter])])
	     mesa=$withval],
	    [mesa=git@github.com:krnowak/mesa.git])

AC_SUBST(CUSTOM_MESA, [$mesa])

AC_ARG_WITH([custom-piglit-remote],
            [AS_HELP_STRING([--with-custom-piglit-remote], [additional git remote piglit repo])],
	    [AS_VAR_IF([withval],[],
	               [AC_MSG_ERROR([--with-custom-piglit-remote expects non-empty parameter])])
	     piglit=$withval],
	    [piglit=git@github.com:krnowak/piglit.git])

AC_SUBST(CUSTOM_PIGLIT, [$piglit])

AC_CONFIG_FILES([variables.sh jhbuildrc])

AC_OUTPUT
