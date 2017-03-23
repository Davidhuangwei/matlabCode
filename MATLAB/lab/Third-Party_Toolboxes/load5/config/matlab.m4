dnl  ====================================================
dnl             MATLAB library macros
dnl  ====================================================

dnl
dnl  CHECK_MATLAB - find Matlab libraries
dnl  ----------------------------------------------------
AC_DEFUN([CHECK_MATLAB],
[
AC_ARG_WITH(matlab,
[  --with-matlab=DIR	the directory where Matlab is installed ],
MATLAB_DIR=${withval},
MATLAB_DIR=)

if test -n "${MATLAB_DIR}"
then
    AC_MSG_CHECKING(for Matlab software)

    case $build_os in
    *linux*)
dnl     64-bit
dnl        MATLAB_FLAGS="-I${MATLAB_DIR}/extern/include -I${MATLAB_DIR}/simulink/include -DMATLAB_MEX_FILE -fPIC -fexceptions -ansi -D_GNU_SOURCE -pthread -DNDEBUG";
dnl        MATLAB_LINK="-pthread -shared -Wl,--version-script,${MATLAB_DIR}/extern/lib/glnxa64/mexFunction.map";
dnl        MATLAB_LIB="-Wl,--rpath-link,${MATLAB_DIR}/extern/lib/glnxa64,--rpath-link,${MATLAB_DIR}/bin/glnxa64 -L${MATLAB_DIR}/bin/glnxa64 -lmx -lmex -lmat -lm";
dnl        MEX_WRAPS="-Wl,--wrap,malloc,--wrap,free,--wrap,calloc,--wrap,realloc,--wrap,assert,--wrap,strdup"
dnl        MEXEXT=mexa64;;
dnl     32-bit
        MATLAB_FLAGS="-I${MATLAB_DIR}/extern/include -I${MATLAB_DIR}/simulink/include -DMATLAB_MEX_FILE -fPIC -fexceptions -ansi -D_GNU_SOURCE -pthread -DNDEBUG";
        MATLAB_LINK="-pthread -shared -Wl,--version-script,${MATLAB_DIR}/extern/lib/glnx86/mexFunction.map";
        MATLAB_LIB="-Wl,--rpath-link,${MATLAB_DIR}/extern/lib/glnx86,--rpath-link,${MATLAB_DIR}/bin/glnx86 -L${MATLAB_DIR}/bin/glnx86 -lmx -lmex -lmat -lm";
        MEX_WRAPS="-Wl,--wrap,malloc,--wrap,free,--wrap,calloc,--wrap,realloc,--wrap,assert,--wrap,strdup"
        MEXEXT=mexglx;;
    *solaris*)
        MATLAB_FLAGS="-I${MATLAB_DIR}/extern/include -I${MATLAB_DIR}/simulink/include -DMATLAB_MEX_FILE -fPIC -fexceptions -O2 -DNDEBUG";
        MATLAB_LINK="-shared -Wl,-M,${MATLAB_DIR}/extern/lib/sol2/mexFunction.map";
        MATLAB_LIB="-Wl,-R,${MATLAB_DIR}/extern/lib/sol2 -L${MATLAB_DIR}/bin/sol2 -lmx -lmex -lmat -lm";
        dnl Solaris linker doesn't support the --wrap option
        MEX_WRAPS=
        MEXEXT=mexsol;;
    *cygwin*)
        MATLAB_FLAGS="-I${MATLAB_DIR}/extern/include -I${MATLAB_DIR}/simulink/include -fno-exceptions -mno-cygwin -DMATLAB_MEX_FILE -DNDEBUG";
        MATLAB_LINK="-shared -mno-cygwin -L${MATLAB_DIR}/bin/win32";
        MATLAB_LIB="-lmx -lmex -lmat -lm";
        MEX_WRAPS="-Wl,--wrap,malloc,--wrap,free,--wrap,calloc,--wrap,realloc,--wrap,assert,--wrap,strdup"
        MEXEXT=dll;
        if test ! -e "${MATLAB_DIR}/bin/win32/libmx.a"
        then
            cd ${MATLAB_DIR}/bin/win32
            libmx=`dlltool -llibmx.a -d${MATLAB_DIR}/extern/include/libmx.def -Dlibmx.dll`
            cd -
        fi
        if test ! -e "${MATLAB_DIR}/bin/win32/libmex.a"
        then
            cd ${MATLAB_DIR}/bin/win32
            libmex=`dlltool -llibmex.a -d${MATLAB_DIR}/extern/include/libmex.def -Dlibmex.dll`
            cd -
        fi
        if test ! -e "${MATLAB_DIR}/bin/win32/libmex.a"
        then
            cd ${MATLAB_DIR}/bin/win32
            libmat=`dlltool -llibmat.a -d${MATLAB_DIR}/extern/include/libmat.def -Dlibmat.dll`
            cd -
        fi;;
    *mingw*)
        MATLAB_FLAGS="-I${MATLAB_DIR}/extern/include -I${MATLAB_DIR}/simulink/include -fno-exceptions -DMATLAB_MEX_FILE -DNDEBUG";
        MATLAB_LINK="-shared -L${MATLAB_DIR}/bin/win32";
        MATLAB_LIB="-lmx -lmex -lmat -lm";
        MEXEXT=dll;
        if test ! -e "${MATLAB_DIR}/bin/win32/libmx.a"
        then
            cd ${MATLAB_DIR}/bin/win32
            libmx=`dlltool -llibmx.a -d${MATLAB_DIR}/extern/include/libmx.def -Dlibmx.dll`
            cd -
        fi
        if test ! -e "${MATLAB_DIR}/bin/win32/libmex.a"
        then
            cd ${MATLAB_DIR}/bin/win32
            libmex=`dlltool -llibmex.a -d${MATLAB_DIR}/extern/include/libmex.def -Dlibmex.dll`
            cd -
        fi
        if test ! -e "${MATLAB_DIR}/bin/win32/libmex.a"
        then
            cd ${MATLAB_DIR}/bin/win32
            libmat=`dlltool -llibmat.a -d${MATLAB_DIR}/extern/include/libmat.def -Dlibmat.dll`
            cd -
        fi;;
    esac
    AC_MSG_RESULT($MATLAB_LINK $MATLAB_LIB)
    AC_SUBST(MATLAB_DIR)
    AC_SUBST(MATLAB_LIB)
    AC_SUBST(MATLAB_LINK)
    AC_SUBST(MATLAB_FLAGS)
    AC_SUBST(MEX_WRAPS)
    AC_SUBST(MEXEXT)
    AC_SUBST(MEXVERSION)
    AM_CONDITIONAL(HAVE_MATLAB, test "xyes" = "xyes" )
    have_matlab=yes
else
    AM_CONDITIONAL(HAVE_MATLAB, test "xno" = "xyes" )
    have_matlab=no
fi
])
