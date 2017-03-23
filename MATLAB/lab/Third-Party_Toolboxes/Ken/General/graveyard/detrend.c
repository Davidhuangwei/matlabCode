/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:20 2000
 * Arguments: "-mw" "mtcsd" 
 */
#include "detrend.h"

static double __Array0_r[1] = { 0.0 };

/*
 * The function "Mdetrend" is the implementation version of the "detrend"
 * M-function from file "/u4/local/matlab/toolbox/matlab/datafun/detrend.m"
 * (lines 1-56). It contains the actual compiled code for that M-function. It
 * is a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function y = detrend(x,o,bp)
 */
static mxArray * Mdetrend(int nargout_,
                          mxArray * x,
                          mxArray * o,
                          mxArray * bp) {
    mxArray * y = mclGetUninitializedArray();
    mxArray * M = mclGetUninitializedArray();
    mxArray * N = mclGetUninitializedArray();
    mxArray * a = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mclForLoopIterator iterator_0;
    mxArray * kb = mclGetUninitializedArray();
    mxArray * lb = mclGetUninitializedArray();
    mxArray * n = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, x, o, bp, NULL));
    mclValidateInputs("detrend", 3, &x, &o, &bp);
    mclCopyArray(&x);
    mclCopyArray(&o);
    mclCopyArray(&bp);
    /*
     * %DETREND Remove a linear trend from a vector, usually for FFT processing.
     * %   Y = DETREND(X) removes the best straight-line fit linear trend from 
     * %   the data in vector X and returns it in vector Y.  If X is a matrix,
     * %   DETREND removes the trend from each column of the matrix.
     * %
     * %   Y = DETREND(X,'constant') removes just the mean value from the vector X,
     * %   or the mean value from each column, if X is a matrix.
     * %
     * %   Y = DETREND(X,'linear',BP) removes a continuous, piecewise linear trend.
     * %   Breakpoint indices for the linear trend are contained in the vector BP.
     * %   The default is no breakpoints, such that one single straight line is
     * %   removed from each column of X.
     * %
     * %   See also MEAN
     * 
     * %   Author(s): J.N. Little, 6-08-86
     * %   	   J.N. Little, 2-29-88, revised
     * %   	   G. Wolodkin, 2-02-98, added piecewise linear fit of L. Ljung
     * %   Copyright (c) 1984-98 by The MathWorks, Inc.
     * %   $Revision: 1.4 $  $Date: 1998/06/08 21:34:05 $
     * 
     * if nargin < 2, o  = 1; end
     */
    if (mlfTobool(mlfLt(nargin_, mlfScalar(2.0)))) {
        mlfAssign(&o, mlfScalar(1.0));
    }
    /*
     * if nargin < 3, bp = 0; end
     */
    if (mlfTobool(mlfLt(nargin_, mlfScalar(3.0)))) {
        mlfAssign(&bp, mlfScalar(0.0));
    }
    /*
     * 
     * n = size(x,1);
     */
    mlfAssign(&n, mlfSize(mclValueVarargout(), x, mlfScalar(1.0)));
    /*
     * if n == 1,
     */
    if (mlfTobool(mlfEq(n, mlfScalar(1.0)))) {
        /*
         * x = x(:);			% If a row, turn into column vector
         */
        mlfAssign(&x, mlfIndexRef(x, "(?)", mlfCreateColonIndex()));
    /*
     * end
     */
    }
    /*
     * N = size(x,1);
     */
    mlfAssign(&N, mlfSize(mclValueVarargout(), x, mlfScalar(1.0)));
    /*
     * 
     * switch o
     * case {0,'c','constant'}
     */
    if (mclSwitchCompare(
          o,
          mlfCellhcat(
            mlfScalar(0.0),
            mxCreateString("c"),
            mxCreateString("constant"),
            NULL))) {
        /*
         * y = x - ones(N,1)*mean(x);	% Remove just mean from each column
         */
        mlfAssign(
          &y,
          mlfMinus(
            x, mlfMtimes(mlfOnes(N, mlfScalar(1.0), NULL), mlfMean(x, NULL))));
    /*
     * 
     * case {1,'l','linear'}
     */
    } else if (mclSwitchCompare(
                 o,
                 mlfCellhcat(
                   mlfScalar(1.0),
                   mxCreateString("l"),
                   mxCreateString("linear"),
                   NULL))) {
        /*
         * bp = unique([0;bp(:);N-1]);	% Include both endpoints
         */
        mlfAssign(
          &bp,
          mlfNUnique(
            1,
            NULL,
            NULL,
            mlfVertcat(
              mlfDoubleMatrix(1, 1, __Array0_r, NULL),
              mlfHorzcat(mlfIndexRef(bp, "(?)", mlfCreateColonIndex()), NULL),
              mlfHorzcat(mlfMinus(N, mlfScalar(1.0)), NULL),
              NULL),
            NULL));
        /*
         * lb = length(bp)-1;
         */
        mlfAssign(&lb, mlfMinus(mlfLength(bp), mlfScalar(1.0)));
        /*
         * a  = [zeros(N,lb) ones(N,1)];	% Build regressor with linear pieces + DC
         */
        mlfAssign(
          &a,
          mlfHorzcat(
            mlfZeros(N, lb, NULL), mlfOnes(N, mlfScalar(1.0), NULL), NULL));
        /*
         * for kb = 1:lb
         */
        for (mclForStart(&iterator_0, mlfScalar(1.0), lb, NULL);
             mclForNext(&iterator_0, &kb);
             ) {
            /*
             * M = N - bp(kb);
             */
            mlfAssign(&M, mlfMinus(N, mlfIndexRef(bp, "(?)", kb)));
            /*
             * a([1:M]+bp(kb),kb) = [1:M]'/M;
             */
            mlfIndexAssign(
              &a,
              "(?,?)",
              mlfPlus(
                mlfHorzcat(mlfColon(mlfScalar(1.0), M, NULL), NULL),
                mlfIndexRef(bp, "(?)", kb)),
              kb,
              mlfMrdivide(
                mlfCtranspose(
                  mlfHorzcat(mlfColon(mlfScalar(1.0), M, NULL), NULL)),
                M));
        /*
         * end
         */
        }
        /*
         * y = x - a*(a\x);		% Remove best fit
         */
        mlfAssign(&y, mlfMinus(x, mlfMtimes(a, mlfMldivide(a, x))));
    /*
     * 
     * otherwise
     */
    } else {
        /*
         * % This should eventually become an error.
         * warning(['Invalid trend type ''' num2str(o) '''.. assuming ''linear''.']);
         */
        mclAssignAns(
          &ans,
          mlfWarning(
            NULL,
            mlfHorzcat(
              mxCreateString("Invalid trend type '"),
              mlfNum2str(o, NULL),
              mxCreateString("'.. assuming 'linear'."),
              NULL)));
        /*
         * y = detrend(x,1,bp); 
         */
        mlfAssign(&y, mlfDetrend(x, mlfScalar(1.0), bp));
    /*
     * 
     * end
     */
    }
    /*
     * 
     * if n == 1
     */
    if (mlfTobool(mlfEq(n, mlfScalar(1.0)))) {
        /*
         * y = y.';
         */
        mlfAssign(&y, mlfTranspose(y));
    /*
     * end
     */
    }
    mclValidateOutputs("detrend", 1, nargout_, &y);
    mxDestroyArray(M);
    mxDestroyArray(N);
    mxDestroyArray(a);
    mxDestroyArray(ans);
    mxDestroyArray(bp);
    mxDestroyArray(kb);
    mxDestroyArray(lb);
    mxDestroyArray(n);
    mxDestroyArray(nargin_);
    mxDestroyArray(o);
    mxDestroyArray(x);
    return y;
}

/*
 * The function "mlfDetrend" contains the normal interface for the "detrend"
 * M-function from file "/u4/local/matlab/toolbox/matlab/datafun/detrend.m"
 * (lines 1-56). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
mxArray * mlfDetrend(mxArray * x, mxArray * o, mxArray * bp) {
    int nargout = 1;
    mxArray * y = mclGetUninitializedArray();
    mlfEnterNewContext(0, 3, x, o, bp);
    y = Mdetrend(nargout, x, o, bp);
    mlfRestorePreviousContext(0, 3, x, o, bp);
    return mlfReturnValue(y);
}

/*
 * The function "mlxDetrend" contains the feval interface for the "detrend"
 * M-function from file "/u4/local/matlab/toolbox/matlab/datafun/detrend.m"
 * (lines 1-56). The feval function calls the implementation version of detrend
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxDetrend(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: detrend Line: 1 Column: "
            "0 The function \"detrend\" was called with mor"
            "e than the declared number of outputs (1)"));
    }
    if (nrhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: detrend Line: 1 Column:"
            " 0 The function \"detrend\" was called with m"
            "ore than the declared number of inputs (3)"));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 3 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 3; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    mplhs[0] = Mdetrend(nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
}
