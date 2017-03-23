/*
 * MATLAB Compiler: 2.0.1
 * Date: Thu Mar 30 15:24:24 2000
 * Arguments: "-xw" "GetJosefDataBase" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#include "matlab.h"
#include "textread.h"
#include "LoadStringList.h"
#include "LoadPar1.h"
#include "LoadPar.h"
#include "FileExists.h"
#include "GetJosefDataBase.h"

static mlfFunctionTableEntry function_table[1]
  = { { "GetJosefDataBase", mlxGetJosefDataBase, 0, 1 } };

static mxArray * Mtextread(int nargout_, mxArray * varargin) {
    mxArray * varargout = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 1, &varargout, NULL),
      "textread",
      mlfIndexRef(varargin, "{?}", mlfCreateColonIndex()), NULL);
    return varargout;
}

static mxArray * MLoadStringList(int nargout_, mxArray * FileName) {
    mxArray * StringList = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &StringList, NULL),
      "LoadStringList",
      FileName, NULL);
    return StringList;
}

static mxArray * MLoadPar1(int nargout_, mxArray * FileName) {
    mxArray * Par = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &Par, NULL), "LoadPar1", FileName, NULL);
    return Par;
}

static mxArray * MLoadPar(int nargout_, mxArray * FileName) {
    mxArray * Par = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &Par, NULL), "LoadPar", FileName, NULL);
    return Par;
}

static mxArray * MFileExists(int nargout_, mxArray * FileName) {
    mxArray * exists = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &exists, NULL), "FileExists", FileName, NULL);
    return exists;
}

/*
 * The function "mexFunction" is a Compiler-generated mex wrapper, suitable for
 * building a MEX-function. It initializes any persistent variables as well as
 * a function table for use by the feval function. It then calls the function
 * "mlxGetJosefDataBase". Finally, it clears the feval table and exits.
 */
void mexFunction(int nlhs, mxArray * * plhs, int nrhs, mxArray * * prhs) {
    mlfTry {
        mlfFunctionTableSetup(1, function_table);
        mclImportGlobal(0, NULL);
        mlxGetJosefDataBase(nlhs, plhs, nrhs, prhs);
        mlfFunctionTableTakedown(1, function_table);
    } mlfCatch {
        mlfFunctionTableTakedown(1, function_table);
        mclMexError();
    } mlfEndCatch
}

void mlxTextread(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    mlfEnterNewContext(0, 0);
    mprhs[0] = NULL;
    mlfAssign(&mprhs[0], mclCreateVararginCell(nrhs, prhs));
    mplhs[0] = Mtextread(nlhs, mprhs[0]);
    mclAssignVarargoutCell(nlhs, plhs, mplhs[0]);
    mlfRestorePreviousContext(0, 0);
    mxDestroyArray(mprhs[0]);
}

mxArray * mlfNTextread(int nargout, mlfVarargoutList * varargout, ...) {
    mxArray * varargin = mclUnassigned();
    mlfVarargin(&varargin, varargout, 0);
    mlfEnterNewContext(0, -1, varargin);
    nargout += mlfNargout(varargout);
    *mlfGetVarargoutCellPtr(varargout) = Mtextread(nargout, varargin);
    mlfRestorePreviousContext(0, 0);
    mxDestroyArray(varargin);
    return mlfAssignOutputs(varargout);
}

mxArray * mlfTextread(mlfVarargoutList * varargout, ...) {
    mxArray * varargin = mclUnassigned();
    int nargout = 0;
    mlfVarargin(&varargin, varargout, 0);
    mlfEnterNewContext(0, -1, varargin);
    nargout += mlfNargout(varargout);
    *mlfGetVarargoutCellPtr(varargout) = Mtextread(nargout, varargin);
    mlfRestorePreviousContext(0, 0);
    mxDestroyArray(varargin);
    return mlfAssignOutputs(varargout);
}

void mlfVTextread(mxArray * synthetic_varargin_argument, ...) {
    mxArray * varargin = mclUnassigned();
    mxArray * varargout = mclUnassigned();
    mlfVarargin(&varargin, synthetic_varargin_argument, 1);
    mlfEnterNewContext(0, -1, varargin);
    varargout = Mtextread(0, synthetic_varargin_argument);
    mlfRestorePreviousContext(0, 0);
    mxDestroyArray(varargin);
}

void mlxLoadStringList(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: LoadStringList Line: 1 Colum"
            "n: 0 The function \"LoadStringList\" was called wi"
            "th more than the declared number of outputs (1)"));
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: LoadStringList Line: 1 Colum"
            "n: 0 The function \"LoadStringList\" was called wi"
            "th more than the declared number of inputs (1)"));
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
    mplhs[0] = MLoadStringList(nlhs, mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
}

mxArray * mlfLoadStringList(mxArray * FileName) {
    int nargout = 1;
    mxArray * StringList = mclGetUninitializedArray();
    mlfEnterNewContext(0, 1, FileName);
    StringList = MLoadStringList(nargout, FileName);
    mlfRestorePreviousContext(0, 1, FileName);
    return mlfReturnValue(StringList);
}

void mlxLoadPar1(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: LoadPar1 Line: 1 Column:"
            " 0 The function \"LoadPar1\" was called with m"
            "ore than the declared number of outputs (1)"));
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: LoadPar1 Line: 1 Column:"
            " 0 The function \"LoadPar1\" was called with m"
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
    mplhs[0] = MLoadPar1(nlhs, mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
}

mxArray * mlfLoadPar1(mxArray * FileName) {
    int nargout = 1;
    mxArray * Par = mclGetUninitializedArray();
    mlfEnterNewContext(0, 1, FileName);
    Par = MLoadPar1(nargout, FileName);
    mlfRestorePreviousContext(0, 1, FileName);
    return mlfReturnValue(Par);
}

void mlxLoadPar(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: LoadPar Line: 1 Column: "
            "0 The function \"LoadPar\" was called with mor"
            "e than the declared number of outputs (1)"));
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: LoadPar Line: 1 Column:"
            " 0 The function \"LoadPar\" was called with m"
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
    mplhs[0] = MLoadPar(nlhs, mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
}

mxArray * mlfLoadPar(mxArray * FileName) {
    int nargout = 1;
    mxArray * Par = mclGetUninitializedArray();
    mlfEnterNewContext(0, 1, FileName);
    Par = MLoadPar(nargout, FileName);
    mlfRestorePreviousContext(0, 1, FileName);
    return mlfReturnValue(Par);
}

void mlxFileExists(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: FileExists Line: 1 Column:"
            " 0 The function \"FileExists\" was called with m"
            "ore than the declared number of outputs (1)"));
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: FileExists Line: 1 Column"
            ": 0 The function \"FileExists\" was called with"
            " more than the declared number of inputs (1)"));
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
    mplhs[0] = MFileExists(nlhs, mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
}

mxArray * mlfFileExists(mxArray * FileName) {
    int nargout = 1;
    mxArray * exists = mclGetUninitializedArray();
    mlfEnterNewContext(0, 1, FileName);
    exists = MFileExists(nargout, FileName);
    mlfRestorePreviousContext(0, 1, FileName);
    return mlfReturnValue(exists);
}
