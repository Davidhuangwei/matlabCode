/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:21 2000
 * Arguments: "-mw" "mtcsd" 
 */
#include "squeeze.h"

/*
 * The function "Msqueeze" is the implementation version of the "squeeze"
 * M-function from file "/u4/local/matlab/toolbox/matlab/datatypes/squeeze.m"
 * (lines 1-28). It contains the actual compiled code for that M-function. It
 * is a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function b = squeeze(a)
 */
static mxArray * Msqueeze(int nargout_, mxArray * a) {
    mxArray * b = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * siz = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, a, NULL));
    mclValidateInputs("squeeze", 1, &a);
    /*
     * %SQUEEZE Remove singleton dimensions.
     * %   B = SQUEEZE(A) returns an array B with the same elements as
     * %   A but with all the singleton dimensions removed.  A singleton
     * %   is a dimension such that size(A,dim)==1.  2-D arrays are
     * %   unaffected by squeeze so that row vectors remain rows.
     * %
     * %   For example,
     * %       squeeze(rand(2,1,3))
     * %   is 2-by-3.
     * %
     * %   See also SHIFTDIM.
     * 
     * %   Clay M. Thompson 3-15-94
     * %   Copyright (c) 1984-98 by The MathWorks, Inc.
     * %   $Revision: 1.9 $  $Date: 1997/11/21 23:24:36 $
     * 
     * if nargin==0, error('Not enough input arguments.'); end
     */
    if (mlfTobool(mlfEq(nargin_, mlfScalar(0.0)))) {
        mlfError(mxCreateString("Not enough input arguments."));
    }
    /*
     * 
     * if ndims(a)>2,
     */
    if (mlfTobool(mlfGt(mlfNdims(a), mlfScalar(2.0)))) {
        /*
         * siz = size(a);
         */
        mlfAssign(&siz, mlfSize(mclValueVarargout(), a, NULL));
        /*
         * siz(siz==1) = []; % Remove singleton dimensions.
         */
        mlfIndexDelete(&siz, "(?)", mlfEq(siz, mlfScalar(1.0)));
        /*
         * siz = [siz ones(1,2-length(siz))]; % Make sure siz is at least 2-D
         */
        mlfAssign(
          &siz,
          mlfHorzcat(
            siz,
            mlfOnes(
              mlfScalar(1.0), mlfMinus(mlfScalar(2.0), mlfLength(siz)), NULL),
            NULL));
        /*
         * b = reshape(a,siz);
         */
        mlfAssign(&b, mlfReshape(a, siz, NULL));
    /*
     * else
     */
    } else {
        /*
         * b = a;
         */
        mlfAssign(&b, a);
    /*
     * end
     */
    }
    mclValidateOutputs("squeeze", 1, nargout_, &b);
    mxDestroyArray(nargin_);
    mxDestroyArray(siz);
    return b;
}

/*
 * The function "mlfSqueeze" contains the normal interface for the "squeeze"
 * M-function from file "/u4/local/matlab/toolbox/matlab/datatypes/squeeze.m"
 * (lines 1-28). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
mxArray * mlfSqueeze(mxArray * a) {
    int nargout = 1;
    mxArray * b = mclGetUninitializedArray();
    mlfEnterNewContext(0, 1, a);
    b = Msqueeze(nargout, a);
    mlfRestorePreviousContext(0, 1, a);
    return mlfReturnValue(b);
}

/*
 * The function "mlxSqueeze" contains the feval interface for the "squeeze"
 * M-function from file "/u4/local/matlab/toolbox/matlab/datatypes/squeeze.m"
 * (lines 1-28). The feval function calls the implementation version of squeeze
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxSqueeze(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: squeeze Line: 1 Column: "
            "0 The function \"squeeze\" was called with mor"
            "e than the declared number of outputs (1)"));
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: squeeze Line: 1 Column:"
            " 0 The function \"squeeze\" was called with m"
            "ore than the declared number of inputs (1)"));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 1 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 1; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 1, mprhs[0]);
    mplhs[0] = Msqueeze(nlhs, mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
}
