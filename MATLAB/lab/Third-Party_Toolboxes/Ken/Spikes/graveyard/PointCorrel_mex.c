/*
 * MATLAB Compiler: 2.0.1
 * Date: Wed Jan 26 11:51:55 2000
 * Arguments: "-xw" "PointCorrel" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#include "matlab.h"
#include "ylabel.h"
#include "xlabel.h"
#include "hist.h"
#include "bar.h"
#include "PointCorrel.h"

static mlfFunctionTableEntry function_table[1]
  = { { "PointCorrel", mlxPointCorrel, 7, 2 } };

static mxArray * Mylabel(int nargout_, mxArray * string, mxArray * varargin) {
    mxArray * hh = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &hh, NULL),
      "ylabel",
      string, mlfIndexRef(varargin, "{?}", mlfCreateColonIndex()), NULL);
    return hh;
}

static mxArray * Mxlabel(int nargout_, mxArray * string, mxArray * varargin) {
    mxArray * hh = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &hh, NULL),
      "xlabel",
      string, mlfIndexRef(varargin, "{?}", mlfCreateColonIndex()), NULL);
    return hh;
}

static mxArray * Mhist(mxArray * * xo, int nargout_, mxArray * y, mxArray * x) {
    mxArray * no = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &no, xo, NULL), "hist", y, x, NULL);
    return no;
}

static mxArray * Mbar(mxArray * * yo, int nargout_, mxArray * varargin) {
    mxArray * xo = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &xo, yo, NULL),
      "bar",
      mlfIndexRef(varargin, "{?}", mlfCreateColonIndex()), NULL);
    return xo;
}

/*
 * The function "mexFunction" is a Compiler-generated mex wrapper, suitable for
 * building a MEX-function. It initializes any persistent variables as well as
 * a function table for use by the feval function. It then calls the function
 * "mlxPointCorrel". Finally, it clears the feval table and exits.
 */
void mexFunction(int nlhs, mxArray * * plhs, int nrhs, mxArray * * prhs) {
    mlfTry {
        mlfFunctionTableSetup(1, function_table);
        mclImportGlobal(0, NULL);
        mlxPointCorrel(nlhs, plhs, nrhs, prhs);
        mlfFunctionTableTakedown(1, function_table);
    } mlfCatch {
        mlfFunctionTableTakedown(1, function_table);
        mclMexError();
    } mlfEndCatch
}

void mlxYlabel(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: ylabel Line: 1 Column: "
            "0 The function \"ylabel\" was called with mor"
            "e than the declared number of outputs (1)"));
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
    mprhs[1] = NULL;
    mlfAssign(&mprhs[1], mclCreateVararginCell(nrhs - 1, prhs + 1));
    mplhs[0] = Mylabel(nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
    mxDestroyArray(mprhs[1]);
}

mxArray * mlfNYlabel(int nargout, mxArray * string, ...) {
    mxArray * varargin = mclUnassigned();
    mxArray * hh = mclGetUninitializedArray();
    mlfVarargin(&varargin, string, 0);
    mlfEnterNewContext(0, -2, string, varargin);
    hh = Mylabel(nargout, string, varargin);
    mlfRestorePreviousContext(0, 1, string);
    mxDestroyArray(varargin);
    return mlfReturnValue(hh);
}

mxArray * mlfYlabel(mxArray * string, ...) {
    mxArray * varargin = mclUnassigned();
    int nargout = 1;
    mxArray * hh = mclGetUninitializedArray();
    mlfVarargin(&varargin, string, 0);
    mlfEnterNewContext(0, -2, string, varargin);
    hh = Mylabel(nargout, string, varargin);
    mlfRestorePreviousContext(0, 1, string);
    mxDestroyArray(varargin);
    return mlfReturnValue(hh);
}

void mlfVYlabel(mxArray * string, ...) {
    mxArray * varargin = mclUnassigned();
    mxArray * hh = mclUnassigned();
    mlfVarargin(&varargin, string, 0);
    mlfEnterNewContext(0, -2, string, varargin);
    hh = Mylabel(0, string, varargin);
    mlfRestorePreviousContext(0, 1, string);
    mxDestroyArray(varargin);
}

void mlxXlabel(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: xlabel Line: 1 Column: "
            "0 The function \"xlabel\" was called with mor"
            "e than the declared number of outputs (1)"));
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
    mprhs[1] = NULL;
    mlfAssign(&mprhs[1], mclCreateVararginCell(nrhs - 1, prhs + 1));
    mplhs[0] = Mxlabel(nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
    mxDestroyArray(mprhs[1]);
}

mxArray * mlfNXlabel(int nargout, mxArray * string, ...) {
    mxArray * varargin = mclUnassigned();
    mxArray * hh = mclGetUninitializedArray();
    mlfVarargin(&varargin, string, 0);
    mlfEnterNewContext(0, -2, string, varargin);
    hh = Mxlabel(nargout, string, varargin);
    mlfRestorePreviousContext(0, 1, string);
    mxDestroyArray(varargin);
    return mlfReturnValue(hh);
}

mxArray * mlfXlabel(mxArray * string, ...) {
    mxArray * varargin = mclUnassigned();
    int nargout = 1;
    mxArray * hh = mclGetUninitializedArray();
    mlfVarargin(&varargin, string, 0);
    mlfEnterNewContext(0, -2, string, varargin);
    hh = Mxlabel(nargout, string, varargin);
    mlfRestorePreviousContext(0, 1, string);
    mxDestroyArray(varargin);
    return mlfReturnValue(hh);
}

void mlfVXlabel(mxArray * string, ...) {
    mxArray * varargin = mclUnassigned();
    mxArray * hh = mclUnassigned();
    mlfVarargin(&varargin, string, 0);
    mlfEnterNewContext(0, -2, string, varargin);
    hh = Mxlabel(0, string, varargin);
    mlfRestorePreviousContext(0, 1, string);
    mxDestroyArray(varargin);
}

void mlxHist(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[2];
    int i;
    if (nlhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hist Line: 1 Column: 0 The function \"hist\""
            " was called with more than the declared number of outputs (2)"));
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hist Line: 1 Column: 0 The function \"hist"
            "\" was called with more than the declared number of inputs (2)"));
    }
    for (i = 0; i < 2; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 2 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 2; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 2, mprhs[0], mprhs[1]);
    mplhs[0] = Mhist(&mplhs[1], nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 2 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 2; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

mxArray * mlfNHist(int nargout, mxArray * * xo, mxArray * y, mxArray * x) {
    mxArray * no = mclGetUninitializedArray();
    mxArray * xo__ = mclGetUninitializedArray();
    mlfEnterNewContext(1, 2, xo, y, x);
    no = Mhist(&xo__, nargout, y, x);
    mlfRestorePreviousContext(1, 2, xo, y, x);
    if (xo != NULL) {
        mclCopyOutputArg(xo, xo__);
    } else {
        mxDestroyArray(xo__);
    }
    return mlfReturnValue(no);
}

mxArray * mlfHist(mxArray * * xo, mxArray * y, mxArray * x) {
    int nargout = 1;
    mxArray * no = mclGetUninitializedArray();
    mxArray * xo__ = mclGetUninitializedArray();
    mlfEnterNewContext(1, 2, xo, y, x);
    if (xo != NULL) {
        ++nargout;
    }
    no = Mhist(&xo__, nargout, y, x);
    mlfRestorePreviousContext(1, 2, xo, y, x);
    if (xo != NULL) {
        mclCopyOutputArg(xo, xo__);
    } else {
        mxDestroyArray(xo__);
    }
    return mlfReturnValue(no);
}

void mlfVHist(mxArray * y, mxArray * x) {
    mxArray * no = mclUnassigned();
    mxArray * xo = mclUnassigned();
    mlfEnterNewContext(0, 2, y, x);
    no = Mhist(&xo, 0, y, x);
    mlfRestorePreviousContext(0, 2, y, x);
    mxDestroyArray(no);
    mxDestroyArray(xo);
}

void mlxBar(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[2];
    int i;
    if (nlhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: bar Line: 1 Column: 0 The function \"bar\""
            " was called with more than the declared number of outputs (2)"));
    }
    for (i = 0; i < 2; ++i) {
        mplhs[i] = NULL;
    }
    mlfEnterNewContext(0, 0);
    mprhs[0] = NULL;
    mlfAssign(&mprhs[0], mclCreateVararginCell(nrhs, prhs));
    mplhs[0] = Mbar(&mplhs[1], nlhs, mprhs[0]);
    mlfRestorePreviousContext(0, 0);
    plhs[0] = mplhs[0];
    for (i = 1; i < 2 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 2; ++i) {
        mxDestroyArray(mplhs[i]);
    }
    mxDestroyArray(mprhs[0]);
}

mxArray * mlfNBar(int nargout, mxArray * * yo, ...) {
    mxArray * varargin = mclUnassigned();
    mxArray * xo = mclGetUninitializedArray();
    mxArray * yo__ = mclGetUninitializedArray();
    mlfVarargin(&varargin, yo, 0);
    mlfEnterNewContext(1, -1, yo, varargin);
    xo = Mbar(&yo__, nargout, varargin);
    mlfRestorePreviousContext(1, 0, yo);
    mxDestroyArray(varargin);
    if (yo != NULL) {
        mclCopyOutputArg(yo, yo__);
    } else {
        mxDestroyArray(yo__);
    }
    return mlfReturnValue(xo);
}

mxArray * mlfBar(mxArray * * yo, ...) {
    mxArray * varargin = mclUnassigned();
    int nargout = 1;
    mxArray * xo = mclGetUninitializedArray();
    mxArray * yo__ = mclGetUninitializedArray();
    mlfVarargin(&varargin, yo, 0);
    mlfEnterNewContext(1, -1, yo, varargin);
    if (yo != NULL) {
        ++nargout;
    }
    xo = Mbar(&yo__, nargout, varargin);
    mlfRestorePreviousContext(1, 0, yo);
    mxDestroyArray(varargin);
    if (yo != NULL) {
        mclCopyOutputArg(yo, yo__);
    } else {
        mxDestroyArray(yo__);
    }
    return mlfReturnValue(xo);
}

void mlfVBar(mxArray * synthetic_varargin_argument, ...) {
    mxArray * varargin = mclUnassigned();
    mxArray * xo = mclUnassigned();
    mxArray * yo = mclUnassigned();
    mlfVarargin(&varargin, synthetic_varargin_argument, 1);
    mlfEnterNewContext(0, -1, varargin);
    xo = Mbar(&yo, 0, synthetic_varargin_argument);
    mlfRestorePreviousContext(0, 0);
    mxDestroyArray(varargin);
    mxDestroyArray(xo);
}
