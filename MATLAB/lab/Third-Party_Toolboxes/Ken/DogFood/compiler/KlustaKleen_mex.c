/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Jan 28 12:40:52 2000
 * Arguments: "-xwv" "KlustaKleen" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#include "matlab.h"
#include "tabulate.h"
#include "chi2inv.h"
#include "SaveClu.h"
#include "LoadFet.h"
#include "LoadClu.h"
#include "KlustaKleen.h"

static mlfFunctionTableEntry function_table[1]
  = { { "KlustaKleen", mlxKlustaKleen, 2, 0 } };

static mxArray * Mtabulate(int nargout_, mxArray * x) {
    mxArray * table = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &table, NULL), "tabulate", x, NULL);
    return table;
}

static mxArray * Mchi2inv(int nargout_, mxArray * p, mxArray * v) {
    mxArray * x = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &x, NULL), "chi2inv", p, v, NULL);
    return x;
}

static void MSaveClu(mxArray * FileName, mxArray * Clu) {
    mclFevalCallMATLAB(mclAnsVarargout(), "SaveClu", FileName, Clu, NULL);
}

static mxArray * MLoadFet(int nargout_, mxArray * FileName) {
    mxArray * Fet = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &Fet, NULL), "LoadFet", FileName, NULL);
    return Fet;
}

static mxArray * MLoadClu(int nargout_, mxArray * FileName) {
    mxArray * Clu = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &Clu, NULL), "LoadClu", FileName, NULL);
    return Clu;
}

/*
 * The function "mexFunction" is a Compiler-generated mex wrapper, suitable for
 * building a MEX-function. It initializes any persistent variables as well as
 * a function table for use by the feval function. It then calls the function
 * "mlxKlustaKleen". Finally, it clears the feval table and exits.
 */
void mexFunction(int nlhs, mxArray * * plhs, int nrhs, mxArray * * prhs) {
    mlfTry {
        mlfFunctionTableSetup(1, function_table);
        mclImportGlobal(0, NULL);
        mlxKlustaKleen(nlhs, plhs, nrhs, prhs);
        mlfFunctionTableTakedown(1, function_table);
    } mlfCatch {
        mlfFunctionTableTakedown(1, function_table);
        mclMexError();
    } mlfEndCatch
}

void mlxTabulate(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: tabulate Line: 1 Column:"
            " 0 The function \"tabulate\" was called with m"
            "ore than the declared number of outputs (1)"));
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: tabulate Line: 1 Column:"
            " 0 The function \"tabulate\" was called with m"
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
    mplhs[0] = Mtabulate(nlhs, mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
}

mxArray * mlfNTabulate(int nargout, mxArray * x) {
    mxArray * table = mclGetUninitializedArray();
    mlfEnterNewContext(0, 1, x);
    table = Mtabulate(nargout, x);
    mlfRestorePreviousContext(0, 1, x);
    return mlfReturnValue(table);
}

mxArray * mlfTabulate(mxArray * x) {
    int nargout = 1;
    mxArray * table = mclGetUninitializedArray();
    mlfEnterNewContext(0, 1, x);
    table = Mtabulate(nargout, x);
    mlfRestorePreviousContext(0, 1, x);
    return mlfReturnValue(table);
}

void mlfVTabulate(mxArray * x) {
    mxArray * table = mclUnassigned();
    mlfEnterNewContext(0, 1, x);
    table = Mtabulate(0, x);
    mlfRestorePreviousContext(0, 1, x);
    mxDestroyArray(table);
}

void mlxChi2inv(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: chi2inv Line: 1 Column: "
            "0 The function \"chi2inv\" was called with mor"
            "e than the declared number of outputs (1)"));
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: chi2inv Line: 1 Column:"
            " 0 The function \"chi2inv\" was called with m"
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
    mplhs[0] = Mchi2inv(nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
    plhs[0] = mplhs[0];
}

mxArray * mlfChi2inv(mxArray * p, mxArray * v) {
    int nargout = 1;
    mxArray * x = mclGetUninitializedArray();
    mlfEnterNewContext(0, 2, p, v);
    x = Mchi2inv(nargout, p, v);
    mlfRestorePreviousContext(0, 2, p, v);
    return mlfReturnValue(x);
}

void mlxSaveClu(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    int i;
    if (nlhs > 0) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: SaveClu Line: 1 Column: "
            "0 The function \"SaveClu\" was called with mor"
            "e than the declared number of outputs (0)"));
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: SaveClu Line: 1 Column:"
            " 0 The function \"SaveClu\" was called with m"
            "ore than the declared number of inputs (2)"));
    }
    for (i = 0; i < 2 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 2; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 2, mprhs[0], mprhs[1]);
    MSaveClu(mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
}

void mlfSaveClu(mxArray * FileName, mxArray * Clu) {
    mlfEnterNewContext(0, 2, FileName, Clu);
    MSaveClu(FileName, Clu);
    mlfRestorePreviousContext(0, 2, FileName, Clu);
}

void mlxLoadFet(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: LoadFet Line: 1 Column: "
            "0 The function \"LoadFet\" was called with mor"
            "e than the declared number of outputs (1)"));
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: LoadFet Line: 1 Column:"
            " 0 The function \"LoadFet\" was called with m"
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
    mplhs[0] = MLoadFet(nlhs, mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
}

mxArray * mlfLoadFet(mxArray * FileName) {
    int nargout = 1;
    mxArray * Fet = mclGetUninitializedArray();
    mlfEnterNewContext(0, 1, FileName);
    Fet = MLoadFet(nargout, FileName);
    mlfRestorePreviousContext(0, 1, FileName);
    return mlfReturnValue(Fet);
}

void mlxLoadClu(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: LoadClu Line: 1 Column: "
            "0 The function \"LoadClu\" was called with mor"
            "e than the declared number of outputs (1)"));
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: LoadClu Line: 1 Column:"
            " 0 The function \"LoadClu\" was called with m"
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
    mplhs[0] = MLoadClu(nlhs, mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
}

mxArray * mlfLoadClu(mxArray * FileName) {
    int nargout = 1;
    mxArray * Clu = mclGetUninitializedArray();
    mlfEnterNewContext(0, 1, FileName);
    Clu = MLoadClu(nargout, FileName);
    mlfRestorePreviousContext(0, 1, FileName);
    return mlfReturnValue(Clu);
}
