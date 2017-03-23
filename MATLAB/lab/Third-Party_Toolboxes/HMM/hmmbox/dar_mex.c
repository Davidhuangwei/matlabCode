/*
 * MATLAB Compiler: 2.0
 * Date: Sun Dec 17 13:07:34 2000
 * Arguments: "-x" "dar.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#include "matlab.h"
#include "waitbar.h"
#include "gauss.h"
#include "dar.h"

static mlfFunctionTableEntry function_table[1] = { { "dar", mlxDar, 4, 9 } };

static mxArray * Mwaitbar(int nargout_, mxArray * x, mxArray * whichbar) {
    mxArray * fout = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &fout, NULL), "waitbar", x, whichbar, NULL);
    return fout;
}

static mxArray * Mgauss(int nargout_,
                        mxArray * mu,
                        mxArray * covar,
                        mxArray * x) {
    mxArray * y = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &y, NULL), "gauss", mu, covar, x, NULL);
    return y;
}

/*
 * The function "mexFunction" is a Compiler-generated mex wrapper, suitable for
 * building a MEX-function. It initializes any persistent variables as well as
 * a function table for use by the feval function. It then calls the function
 * "mlxDar". Finally, it clears the feval table and exits.
 */
void mexFunction(int nlhs, mxArray * * plhs, int nrhs, mxArray * * prhs) {
    mlfTry {
        mlfFunctionTableSetup(1, function_table);
        mclImportGlobal(0, NULL);
        mlxDar(nlhs, plhs, nrhs, prhs);
        mlfFunctionTableTakedown(1, function_table);
    } mlfCatch {
        mlfFunctionTableTakedown(1, function_table);
        mclMexError();
    } mlfEndCatch
}

void mlxWaitbar(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: waitbar Line: 1 Column: "
            "0 The function \"waitbar\" was called with mor"
            "e than the declared number of outputs (1)"));
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: waitbar Line: 1 Column:"
            " 0 The function \"waitbar\" was called with m"
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
    mplhs[0] = Mwaitbar(nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
    plhs[0] = mplhs[0];
}

mxArray * mlfNWaitbar(int nargout, mxArray * x, mxArray * whichbar) {
    mxArray * fout = mclGetUninitializedArray();
    mlfEnterNewContext(0, 2, x, whichbar);
    fout = Mwaitbar(nargout, x, whichbar);
    mlfRestorePreviousContext(0, 2, x, whichbar);
    return mlfReturnValue(fout);
}

mxArray * mlfWaitbar(mxArray * x, mxArray * whichbar) {
    int nargout = 1;
    mxArray * fout = mclGetUninitializedArray();
    mlfEnterNewContext(0, 2, x, whichbar);
    fout = Mwaitbar(nargout, x, whichbar);
    mlfRestorePreviousContext(0, 2, x, whichbar);
    return mlfReturnValue(fout);
}

void mlfVWaitbar(mxArray * x, mxArray * whichbar) {
    mxArray * fout = mclUnassigned();
    mlfEnterNewContext(0, 2, x, whichbar);
    fout = Mwaitbar(0, x, whichbar);
    mlfRestorePreviousContext(0, 2, x, whichbar);
    mxDestroyArray(fout);
}

void mlxGauss(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: gauss Line: 1 Column: 0 The function \"gauss"
            "\" was called with more than the declared number of outputs (1)"));
    }
    if (nrhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: gauss Line: 1 Column: 0 The function \"gauss"
            "\" was called with more than the declared number of inputs (3)"));
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
    mplhs[0] = Mgauss(nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
}

mxArray * mlfGauss(mxArray * mu, mxArray * covar, mxArray * x) {
    int nargout = 1;
    mxArray * y = mclGetUninitializedArray();
    mlfEnterNewContext(0, 3, mu, covar, x);
    y = Mgauss(nargout, mu, covar, x);
    mlfRestorePreviousContext(0, 3, mu, covar, x);
    return mlfReturnValue(y);
}
