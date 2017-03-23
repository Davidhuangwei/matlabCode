/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:22 2000
 * Arguments: "-mw" "mtcsd" 
 */
#include "sinc.h"

/*
 * The function "Msinc" is the implementation version of the "sinc" M-function
 * from file "/u4/local/matlab/toolbox/signal/signal/sinc.m" (lines 1-20). It
 * contains the actual compiled code for that M-function. It is a static
 * function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function y=sinc(x)
 */
static mxArray * Msinc(int nargout_, mxArray * x) {
    mxArray * y = mclGetUninitializedArray();
    mxArray * i = mclGetUninitializedArray();
    mclValidateInputs("sinc", 1, &x);
    /*
     * %SINC Sin(pi*x)/(pi*x) function.
     * %   SINC(X) returns a matrix whose elements are the sinc of the elements 
     * %   of X, i.e.
     * %        y = sin(pi*x)/(pi*x)    if x ~= 0
     * %          = 1                   if x == 0
     * %   where x is an element of the input matrix and y is the resultant
     * %   output element.
     * %
     * %   See also SQUARE, SIN, COS, CHIRP, DIRIC, GAUSPULS, PULSTRAN, RECTPULS,
     * %   and TRIPULS.
     * 
     * %   Author(s): T. Krauss, 1-14-93
     * %   Copyright (c) 1988-1999 The MathWorks, Inc. All Rights Reserved.
     * %       $Revision: 1.4 $  $Date: 1999/01/11 19:05:06 $
     * 
     * y=ones(size(x));
     */
    mlfAssign(&y, mlfOnes(mlfSize(mclValueVarargout(), x, NULL), NULL));
    /*
     * i=find(x);
     */
    mlfAssign(&i, mlfFind(NULL, NULL, x));
    /*
     * y(i)=sin(pi*x(i))./(pi*x(i));
     */
    mlfIndexAssign(
      &y,
      "(?)",
      i,
      mlfRdivide(
        mlfSin(mlfMtimes(mlfPi(), mlfIndexRef(x, "(?)", i))),
        mlfMtimes(mlfPi(), mlfIndexRef(x, "(?)", i))));
    mclValidateOutputs("sinc", 1, nargout_, &y);
    mxDestroyArray(i);
    return y;
}

/*
 * The function "mlfSinc" contains the normal interface for the "sinc"
 * M-function from file "/u4/local/matlab/toolbox/signal/signal/sinc.m" (lines
 * 1-20). This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfSinc(mxArray * x) {
    int nargout = 1;
    mxArray * y = mclGetUninitializedArray();
    mlfEnterNewContext(0, 1, x);
    y = Msinc(nargout, x);
    mlfRestorePreviousContext(0, 1, x);
    return mlfReturnValue(y);
}

/*
 * The function "mlxSinc" contains the feval interface for the "sinc"
 * M-function from file "/u4/local/matlab/toolbox/signal/signal/sinc.m" (lines
 * 1-20). The feval function calls the implementation version of sinc through
 * this function. This function processes any input arguments and passes them
 * to the implementation version of the function, appearing above.
 */
void mlxSinc(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: sinc Line: 1 Column: 0 The function \"sinc\""
            " was called with more than the declared number of outputs (1)"));
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: sinc Line: 1 Column: 0 The function \"sinc"
            "\" was called with more than the declared number of inputs (1)"));
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
    mplhs[0] = Msinc(nlhs, mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
}
