/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:20 2000
 * Arguments: "-mw" "mtcsd" 
 */
#include "complex.h"

/*
 * The function "Mcomplex" is the implementation version of the "complex"
 * M-function from file "/u4/local/matlab/toolbox/matlab/elfun/complex.m"
 * (lines 1-22). It contains the actual compiled code for that M-function. It
 * is a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function C = complex(A,B)
 */
static mxArray * Mcomplex(int nargout_, mxArray * A, mxArray * B) {
    mxArray * C = mclGetUninitializedArray();
    mclValidateInputs("complex", 2, &A, &B);
    /*
     * %   COMPLEX Construct complex data from real and imaginary parts.
     * %   COMPLEX(A,B) returns the complex result A + Bi, where A and B
     * %   are identically sized real arrays or scalars of the same data
     * %   type.
     * %
     * %   COMPLEX(A) returns the complex result A + 0i, where A must
     * %   be real.
     * %
     * %   Note that the expression A+i*B or A+j*B will give identical
     * %   results if A and B are double-precision and i or j has not been
     * %   assigned.  Use COMPLEX if ambiguity in the variables "i" or "j"
     * %   might arise, or if A and B are not double-precision.
     * %
     * %   See also  I, J, IMAG, CONJ, ANGLE, ABS, REAL, ISREAL.
     * 
     * %   Author(s): R. Firtion, D. Orofino
     * %   Copyright (c) 1984-98 by The MathWorks, Inc.
     * %   $Revision: 1.2 $  $Date: 1998/08/07 11:57:50 $
     * 
     * error('MEX file not present');
     */
    mlfError(mxCreateString("MEX file not present"));
    mclValidateOutputs("complex", 1, nargout_, &C);
    return C;
}

/*
 * The function "mlfComplex" contains the normal interface for the "complex"
 * M-function from file "/u4/local/matlab/toolbox/matlab/elfun/complex.m"
 * (lines 1-22). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
mxArray * mlfComplex(mxArray * A, mxArray * B) {
    int nargout = 1;
    mxArray * C = mclGetUninitializedArray();
    mlfEnterNewContext(0, 2, A, B);
    C = Mcomplex(nargout, A, B);
    mlfRestorePreviousContext(0, 2, A, B);
    return mlfReturnValue(C);
}

/*
 * The function "mlxComplex" contains the feval interface for the "complex"
 * M-function from file "/u4/local/matlab/toolbox/matlab/elfun/complex.m"
 * (lines 1-22). The feval function calls the implementation version of complex
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxComplex(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: complex Line: 1 Column: "
            "0 The function \"complex\" was called with mor"
            "e than the declared number of outputs (1)"));
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: complex Line: 1 Column:"
            " 0 The function \"complex\" was called with m"
            "ore than the declared number of inputs (2)"));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 2 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 2; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 2, mprhs[0], mprhs[1]);
    mplhs[0] = Mcomplex(nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
    plhs[0] = mplhs[0];
}
