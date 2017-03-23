/*
 * MATLAB Compiler: 2.2
 * Date: Wed Dec 12 11:34:20 2001
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "-h" "-w" "CircAnova" 
 */
#include "randperm.h"
#include "libmatlbm.h"

static mxChar _array1_[134] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'r', 'a', 'n', 'd', 'p',
                                'e', 'r', 'm', ' ', 'L', 'i', 'n', 'e', ':',
                                ' ', '1', ' ', 'C', 'o', 'l', 'u', 'm', 'n',
                                ':', ' ', '1', ' ', 'T', 'h', 'e', ' ', 'f',
                                'u', 'n', 'c', 't', 'i', 'o', 'n', ' ', '"',
                                'r', 'a', 'n', 'd', 'p', 'e', 'r', 'm', '"',
                                ' ', 'w', 'a', 's', ' ', 'c', 'a', 'l', 'l',
                                'e', 'd', ' ', 'w', 'i', 't', 'h', ' ', 'm',
                                'o', 'r', 'e', ' ', 't', 'h', 'a', 'n', ' ',
                                't', 'h', 'e', ' ', 'd', 'e', 'c', 'l', 'a',
                                'r', 'e', 'd', ' ', 'n', 'u', 'm', 'b', 'e',
                                'r', ' ', 'o', 'f', ' ', 'o', 'u', 't', 'p',
                                'u', 't', 's', ' ', '(', '1', ')', '.' };
static mxArray * _mxarray0_;

static mxChar _array3_[133] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'r', 'a', 'n', 'd', 'p',
                                'e', 'r', 'm', ' ', 'L', 'i', 'n', 'e', ':',
                                ' ', '1', ' ', 'C', 'o', 'l', 'u', 'm', 'n',
                                ':', ' ', '1', ' ', 'T', 'h', 'e', ' ', 'f',
                                'u', 'n', 'c', 't', 'i', 'o', 'n', ' ', '"',
                                'r', 'a', 'n', 'd', 'p', 'e', 'r', 'm', '"',
                                ' ', 'w', 'a', 's', ' ', 'c', 'a', 'l', 'l',
                                'e', 'd', ' ', 'w', 'i', 't', 'h', ' ', 'm',
                                'o', 'r', 'e', ' ', 't', 'h', 'a', 'n', ' ',
                                't', 'h', 'e', ' ', 'd', 'e', 'c', 'l', 'a',
                                'r', 'e', 'd', ' ', 'n', 'u', 'm', 'b', 'e',
                                'r', ' ', 'o', 'f', ' ', 'i', 'n', 'p', 'u',
                                't', 's', ' ', '(', '1', ')', '.' };
static mxArray * _mxarray2_;
static mxArray * _mxarray4_;

void InitializeModule_randperm(void) {
    _mxarray0_ = mclInitializeString(134, _array1_);
    _mxarray2_ = mclInitializeString(133, _array3_);
    _mxarray4_ = mclInitializeDouble(1.0);
}

void TerminateModule_randperm(void) {
    mxDestroyArray(_mxarray4_);
    mxDestroyArray(_mxarray2_);
    mxDestroyArray(_mxarray0_);
}

static mxArray * Mrandperm(int nargout_, mxArray * n);

_mexLocalFunctionTable _local_function_table_randperm
  = { 0, (mexFunctionTableEntry *)NULL };

/*
 * The function "mlfRandperm" contains the normal interface for the "randperm"
 * M-function from file "/u2/local/matlab6.1/toolbox/matlab/sparfun/randperm.m"
 * (lines 1-14). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
mxArray * mlfRandperm(mxArray * n) {
    int nargout = 1;
    mxArray * p = mclGetUninitializedArray();
    mlfEnterNewContext(0, 1, n);
    p = Mrandperm(nargout, n);
    mlfRestorePreviousContext(0, 1, n);
    return mlfReturnValue(p);
}

/*
 * The function "mlxRandperm" contains the feval interface for the "randperm"
 * M-function from file "/u2/local/matlab6.1/toolbox/matlab/sparfun/randperm.m"
 * (lines 1-14). The feval function calls the implementation version of
 * randperm through this function. This function processes any input arguments
 * and passes them to the implementation version of the function, appearing
 * above.
 */
void mlxRandperm(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
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
    mplhs[0] = Mrandperm(nlhs, mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
}

/*
 * The function "Mrandperm" is the implementation version of the "randperm"
 * M-function from file "/u2/local/matlab6.1/toolbox/matlab/sparfun/randperm.m"
 * (lines 1-14). It contains the actual compiled code for that M-function. It
 * is a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function p = randperm(n);
 */
static mxArray * Mrandperm(int nargout_, mxArray * n) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_randperm);
    mxArray * p = mclGetUninitializedArray();
    mxArray * ignore = mclGetUninitializedArray();
    mclCopyArray(&n);
    /*
     * %RANDPERM Random permutation.
     * %   RANDPERM(n) is a random permutation of the integers from 1 to n.
     * %   For example, RANDPERM(6) might be [2 4 5 6 1 3].
     * %   
     * %   Note that RANDPERM calls RAND and therefore changes RAND's state.
     * %
     * %   See also PERMUTE.
     * 
     * %   Copyright 1984-2001 The MathWorks, Inc.
     * %   $Revision: 5.9 $  $Date: 2001/04/15 12:00:18 $
     * 
     * [ignore,p] = sort(rand(1,n));
     */
    mlfAssign(
      &ignore,
      mlfSort(&p, mclVe(mlfNRand(1, _mxarray4_, mclVa(n, "n"), NULL)), NULL));
    mclValidateOutput(p, 1, nargout_, "p", "randperm");
    mxDestroyArray(ignore);
    mxDestroyArray(n);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return p;
}
