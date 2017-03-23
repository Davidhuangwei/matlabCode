/*
 * MATLAB Compiler: 2.2
 * Date: Wed Dec 12 11:34:20 2001
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "-h" "-w" "CircAnova" 
 */
#include "mean.h"
#include "libmatlbm.h"

static mxChar _array1_[126] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'm', 'e', 'a', 'n', ' ',
                                'L', 'i', 'n', 'e', ':', ' ', '1', ' ', 'C',
                                'o', 'l', 'u', 'm', 'n', ':', ' ', '1', ' ',
                                'T', 'h', 'e', ' ', 'f', 'u', 'n', 'c', 't',
                                'i', 'o', 'n', ' ', '"', 'm', 'e', 'a', 'n',
                                '"', ' ', 'w', 'a', 's', ' ', 'c', 'a', 'l',
                                'l', 'e', 'd', ' ', 'w', 'i', 't', 'h', ' ',
                                'm', 'o', 'r', 'e', ' ', 't', 'h', 'a', 'n',
                                ' ', 't', 'h', 'e', ' ', 'd', 'e', 'c', 'l',
                                'a', 'r', 'e', 'd', ' ', 'n', 'u', 'm', 'b',
                                'e', 'r', ' ', 'o', 'f', ' ', 'o', 'u', 't',
                                'p', 'u', 't', 's', ' ', '(', '1', ')', '.' };
static mxArray * _mxarray0_;

static mxChar _array3_[125] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'm', 'e', 'a', 'n', ' ',
                                'L', 'i', 'n', 'e', ':', ' ', '1', ' ', 'C',
                                'o', 'l', 'u', 'm', 'n', ':', ' ', '1', ' ',
                                'T', 'h', 'e', ' ', 'f', 'u', 'n', 'c', 't',
                                'i', 'o', 'n', ' ', '"', 'm', 'e', 'a', 'n',
                                '"', ' ', 'w', 'a', 's', ' ', 'c', 'a', 'l',
                                'l', 'e', 'd', ' ', 'w', 'i', 't', 'h', ' ',
                                'm', 'o', 'r', 'e', ' ', 't', 'h', 'a', 'n',
                                ' ', 't', 'h', 'e', ' ', 'd', 'e', 'c', 'l',
                                'a', 'r', 'e', 'd', ' ', 'n', 'u', 'm', 'b',
                                'e', 'r', ' ', 'o', 'f', ' ', 'i', 'n', 'p',
                                'u', 't', 's', ' ', '(', '2', ')', '.' };
static mxArray * _mxarray2_;
static mxArray * _mxarray4_;

void InitializeModule_mean(void) {
    _mxarray0_ = mclInitializeString(126, _array1_);
    _mxarray2_ = mclInitializeString(125, _array3_);
    _mxarray4_ = mclInitializeDouble(1.0);
}

void TerminateModule_mean(void) {
    mxDestroyArray(_mxarray4_);
    mxDestroyArray(_mxarray2_);
    mxDestroyArray(_mxarray0_);
}

static mxArray * Mmean(int nargout_, mxArray * x, mxArray * dim);

_mexLocalFunctionTable _local_function_table_mean
  = { 0, (mexFunctionTableEntry *)NULL };

/*
 * The function "mlfMean" contains the normal interface for the "mean"
 * M-function from file "/u2/local/matlab6.1/toolbox/matlab/datafun/mean.m"
 * (lines 1-30). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
mxArray * mlfMean(mxArray * x, mxArray * dim) {
    int nargout = 1;
    mxArray * y = mclGetUninitializedArray();
    mlfEnterNewContext(0, 2, x, dim);
    y = Mmean(nargout, x, dim);
    mlfRestorePreviousContext(0, 2, x, dim);
    return mlfReturnValue(y);
}

/*
 * The function "mlxMean" contains the feval interface for the "mean"
 * M-function from file "/u2/local/matlab6.1/toolbox/matlab/datafun/mean.m"
 * (lines 1-30). The feval function calls the implementation version of mean
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxMean(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(_mxarray0_);
    }
    if (nrhs > 2) {
        mlfError(_mxarray2_);
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = mclGetUninitializedArray();
    }
    for (i = 0; i < 2 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 2; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 2, mprhs[0], mprhs[1]);
    mplhs[0] = Mmean(nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
    plhs[0] = mplhs[0];
}

/*
 * The function "Mmean" is the implementation version of the "mean" M-function
 * from file "/u2/local/matlab6.1/toolbox/matlab/datafun/mean.m" (lines 1-30).
 * It contains the actual compiled code for that M-function. It is a static
 * function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function y = mean(x,dim)
 */
static mxArray * Mmean(int nargout_, mxArray * x, mxArray * dim) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_mean);
    int nargin_ = mclNargin(2, x, dim, NULL);
    mxArray * y = mclGetUninitializedArray();
    mclCopyArray(&x);
    mclCopyArray(&dim);
    /*
     * %MEAN   Average or mean value.
     * %   For vectors, MEAN(X) is the mean value of the elements in X. For
     * %   matrices, MEAN(X) is a row vector containing the mean value of
     * %   each column.  For N-D arrays, MEAN(X) is the mean value of the
     * %   elements along the first non-singleton dimension of X.
     * %
     * %   MEAN(X,DIM) takes the mean along the dimension DIM of X. 
     * %
     * %   Example: If X = [0 1 2
     * %                    3 4 5]
     * %
     * %   then mean(X,1) is [1.5 2.5 3.5] and mean(X,2) is [1
     * %                                                     4]
     * %
     * %   See also MEDIAN, STD, MIN, MAX, COV.
     * 
     * %   Copyright 1984-2001 The MathWorks, Inc. 
     * %   $Revision: 5.16 $  $Date: 2001/04/15 12:01:26 $
     * 
     * if nargin==1, 
     */
    if (nargin_ == 1) {
        /*
         * % Determine which dimension SUM will use
         * dim = min(find(size(x)~=1));
         */
        mlfAssign(
          &dim,
          mlfMin(
            NULL,
            mclVe(
              mlfFind(
                NULL,
                NULL,
                mclNe(
                  mclVe(mlfSize(mclValueVarargout(), mclVa(x, "x"), NULL)),
                  _mxarray4_))),
            NULL,
            NULL));
        /*
         * if isempty(dim), dim = 1; end
         */
        if (mlfTobool(mclVe(mlfIsempty(mclVa(dim, "dim"))))) {
            mlfAssign(&dim, _mxarray4_);
        }
        /*
         * 
         * y = sum(x)/size(x,dim);
         */
        mlfAssign(
          &y,
          mclMrdivide(
            mclVe(mlfSum(mclVa(x, "x"), NULL)),
            mclVe(
              mlfSize(mclValueVarargout(), mclVa(x, "x"), mclVa(dim, "dim")))));
    /*
     * else
     */
    } else {
        /*
         * y = sum(x,dim)/size(x,dim);
         */
        mlfAssign(
          &y,
          mclMrdivide(
            mclVe(mlfSum(mclVa(x, "x"), mclVa(dim, "dim"))),
            mclVe(
              mlfSize(mclValueVarargout(), mclVa(x, "x"), mclVa(dim, "dim")))));
    /*
     * end
     */
    }
    mclValidateOutput(y, 1, nargout_, "y", "mean");
    mxDestroyArray(dim);
    mxDestroyArray(x);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return y;
}
