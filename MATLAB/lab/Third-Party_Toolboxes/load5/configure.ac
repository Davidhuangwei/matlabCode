dnl  configure.ac
dnl
dnl  NOTE:  Process this file with GNU autoconf to produce a configure script.

AC_INIT([load5],[1.1.2],[cch@isl-inc.com],[])
AC_CONFIG_SRCDIR([libmexsys/mexstd.c])
AC_CONFIG_AUX_DIR(config)
dnl AM_INIT_AUTOMAKE([-no-undefined])
AM_INIT_AUTOMAKE
AM_MAINTAINER_MODE
MEX_INIT([LOAD5],[1],[1],[2])
PACKAGE_RELEASE_DATE="11 August 2005"
AC_SUBST(PACKAGE_RELEASE_DATE)

dnl 
dnl  Build programs, C compiler, F77 compiler, make, install, etc.
dnl

AC_PROG_CC([gcc cc])

AC_PROG_MAKE_SET
AC_PROG_INSTALL
AC_PROG_RANLIB

dnl 
dnl  Libraries
dnl

AC_CHECK_LIB([m],[pow])

dnl
dnl  Headers
dnl

AC_STDC_HEADERS

linux="no"
winnt="no"
sun="no"
case $build_os in
*linux*)
    linux="yes"
    EXEEXT=.mexglx
    AC_DEFINE_UNQUOTED(LINUX);;
*mingw*)
    winnt="yes"
    EXEEXT=.dll
    AC_DEFINE_UNQUOTED(WINNT);;
*cygwin*)
    winnt="yes"
    EXEEXT=.dll
    AC_DEFINE_UNQUOTED(WINNT);;
*sun*)
    sun="yes"
    EXEEXT=.mexsol
    AC_DEFINE_UNQUOTED(SUN);;
*solaris*)
    sun="yes"
    EXEEXT=.mexsol
    AC_DEFINE_UNQUOTED(SUN);;
esac

AM_CONDITIONAL(LINUX, test "$linux" = "yes")
AM_CONDITIONAL(WINNT, test "$winnt" = "yes")
AM_CONDITIONAL(SUN,   test "x$sun"  = "xyes")

dnl
dnl Matlab Library
dnl
CHECK_MATLAB

dnl PKG_CHECK_MODULES(SCATS, [sbr geo scats io ])
PKG_CHECK_MODULES(MATIO, [matio])

AC_SUBST(MATIO_CFLAGS)
AC_SUBST(MATIO_LIBS)

AC_CONFIG_FILES([Makefile \
                 libmexsys/Makefile \
                 libmexio/Makefile])
AC_OUTPUT
