/*
 * MATLAB Compiler: 2.2
 * Date: Wed Dec 12 11:34:20 2001
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "-h" "-w" "CircAnova" 
 */
#include "iscell.h"
#include "libmatlbm.h"

static mxChar _array1_[130] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'i', 's', 'c', 'e', 'l',
                                'l', ' ', 'L', 'i', 'n', 'e', ':', ' ', '1',
                                ' ', 'C', 'o', 'l', 'u', 'm', 'n', ':', ' ',
                                '1', ' ', 'T', 'h', 'e', ' ', 'f', 'u', 'n',
                                'c', 't', 'i', 'o', 'n', ' ', '"', 'i', 's',
                                'c', 'e', 'l', 'l', '"', ' ', 'w', 'a', 's',
                                ' ', 'c', 'a', 'l', 'l', 'e', 'd', ' ', 'w',
                                'i', 't', 'h', ' ', 'm', 'o', 'r', 'e', ' ',
                                't', 'h', 'a', 'n', ' ', 't', 'h', 'e', ' ',
                                'd', 'e', 'c', 'l', 'a', 'r', 'e', 'd', ' ',
                                'n', 'u', 'm', 'b', 'e', 'r', ' ', 'o', 'f',
                                ' ', 'o', 'u', 't', 'p', 'u', 't', 's', ' ',
                                '(', '1', ')', '.' };
static mxArray * _mxarray0_;

static mxChar _array3_[129] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'i', 's', 'c', 'e', 'l',
                                'l', ' ', 'L', 'i', 'n', 'e', ':', ' ', '1',
                                ' ', 'C', 'o', 'l', 'u', 'm', 'n', ':', ' ',
                                '1', ' ', 'T', 'h', 'e', ' ', 'f', 'u', 'n',
                                'c', 't', 'i', 'o', 'n', ' ', '"', 'i', 's',
                                'c', 'e', 'l', 'l', '"', ' ', 'w', 'a', 's',
                                ' ', 'c', 'a', 'l', 'l', 'e', 'd', ' ', 'w',
                                'i', 't', 'h', ' ', 'm', 'o', 'r', 'e', ' ',
                                't', 'h', 'a', 'n', ' ', 't', 'h', 'e', ' ',
                                'd', 'e', 'c', 'l', 'a', 'r', 'e', 'd', ' ',
                                'n', 'u', 'm', 'b', 'e', 'r', ' ', 'o', 'f',
                                ' ', 'i', 'n', 'p', 'u', 't', 's', ' ', '(',
                                '1', ')', '.' };
static mxArray * _mxarray2_;

static mxChar _array5_[4] = { 'c', 'e', 'l', 'l' };
static mxArray * _mxarray4_;

void InitializeModule_iscell(void) {
    _mxarray0_ = mclInitializeString(130, _array1_);
    _mxarray2_ = mclInitializeString(129, _array3_);
    _mxarray4_ = mclInitializeString(4, _array5_);
}

void TerminateModule_iscell(void) {
    mxDestroyArray(_mxarray4_);
    mxDestroyArray(_mxarray2_);
    mxDestroyArray(_mxarray0_);
}

static mxArray * Miscell(int nargout_, mxArray * a);

_mexLocalFunctionTable _local_function_table_iscell
  = { 0, (mexFunctionTableEntry *)NULL };

/*
 * The function "mlfIscell" contains the normal interface for the "iscell"
 * M-function from file "/u2/local/matlab6.1/toolbox/matlab/datatypes/iscell.m"
 * (lines 1-11). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
mxArray * mlfIscell(mxArray * a) {
    int nargout = 1;
    mxArray * t = mclGetUninitializedArray();
    mlfEnterNewContext(0, 1, a);
    t = Miscell(nargout, a);
    mlfRestorePreviousContext(0, 1, a);
    return mlfReturnValue(t);
}

/*
 * The function "mlxIscell" contains the feval interface for the "iscell"
 * M-function from file "/u2/local/matlab6.1/toolbox/matlab/datatypes/iscell.m"
 * (lines 1-11). The feval function calls the implementation version of iscell
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxIscell(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(_mxarray0_);
    }
    if (nrhs > 1) {
        mlfError(_mxarray2_);
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = mclGetUninitializedArray();
    }
    for (i = 0; i < 1 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 1; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 1, mprhs[0]);
    mplhs[0] = Miscell(nlhs, mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
}

/*
 * The function "Miscell" is the implementation version of the "iscell"
 * M-function from file "/u2/local/matlab6.1/toolbox/matlab/datatypes/iscell.m"
 * (lines 1-11). It contains the actual compiled code for that M-function. It
 * is a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function t = iscell(a)
 */
static mxArray * Miscell(int nargout_, mxArray * a) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_iscell);
    mxArray * t = mclGetUninitializedArray();
    mclCopyArray(&a);
    /*
     * %ISCELL True for cell array.
     * %   ISCELL(C) returns 1 if C is a cell array and 0 otherwise.
     * %
     * %   See also CELL, PAREN, ISSTRUCT, ISNUMERIC, ISOBJECT, ISLOGICAL.
     * 
     * %   Copyright 1984-2001 The MathWorks, Inc. 
     * %   $Revision: 1.14 $  $Date: 2001/04/15 12:03:41 $
     * 
     * t = isa(a,'cell');
     */
    mlfAssign(&t, mlfIsa(mclVa(a, "a"), _mxarray4_));
    mclValidateOutput(t, 1, nargout_, "t", "iscell");
    mxDestroyArray(a);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return t;
}
