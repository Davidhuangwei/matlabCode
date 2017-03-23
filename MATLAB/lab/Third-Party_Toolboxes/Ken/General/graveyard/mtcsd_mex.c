/*
 * MATLAB Compiler: 2.0.1
 * Date: Mon Jan  3 17:38:12 2000
 * Arguments: "-xwv" "mtcsd" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#include "matlab.h"
#include "ylabel.h"
#include "xlabel.h"
#include "subplot.h"
#include "squeeze.h"
#include "General_private_mtparam.h"
#include "grid.h"
#include "dpss.h"
#include "detrend.h"
#include "complex.h"
#include "mtcsd.h"

static mlfFunctionTableEntry function_table[1]
  = { { "mtcsd", mlxMtcsd, -1, 2 } };

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

static mxArray * Msubplot(int nargout_,
                          mxArray * nrows,
                          mxArray * ncols,
                          mxArray * thisPlot) {
    mxArray * theAxis = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &theAxis, NULL),
      "subplot",
      nrows, ncols, thisPlot, NULL);
    return theAxis;
}

static mxArray * Msqueeze(int nargout_, mxArray * a) {
    mxArray * b = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &b, NULL), "squeeze", a, NULL);
    return b;
}

static mxArray * MGeneral_private_mtparam(mxArray * * nFFT,
                                          mxArray * * Fs,
                                          mxArray * * WinLength,
                                          mxArray * * nOverlap,
                                          mxArray * * NW,
                                          mxArray * * Detrend,
                                          mxArray * * nTapers,
                                          int nargout_,
                                          mxArray * P) {
    mxArray * x = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(
        nargout_,
        0,
        &x, nFFT, Fs, WinLength, nOverlap, NW, Detrend, nTapers, NULL),
      "mtparam",
      P, NULL);
    return x;
}

static void Mgrid(mxArray * opt_grid) {
    mclFevalCallMATLAB(mclAnsVarargout(), "grid", opt_grid, NULL);
}

static mxArray * Mdpss(mxArray * * V,
                       int nargout_,
                       mxArray * N,
                       mxArray * NW,
                       mxArray * varargin) {
    mxArray * E = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &E, V, NULL),
      "dpss",
      N, NW, mlfIndexRef(varargin, "{?}", mlfCreateColonIndex()), NULL);
    return E;
}

static mxArray * Mdetrend(int nargout_,
                          mxArray * x,
                          mxArray * o,
                          mxArray * bp) {
    mxArray * y = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &y, NULL), "detrend", x, o, bp, NULL);
    return y;
}

static mxArray * Mcomplex(int nargout_, mxArray * A, mxArray * B) {
    mxArray * C = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &C, NULL), "complex", A, B, NULL);
    return C;
}

/*
 * The function "mexFunction" is a Compiler-generated mex wrapper, suitable for
 * building a MEX-function. It initializes any persistent variables as well as
 * a function table for use by the feval function. It then calls the function
 * "mlxMtcsd". Finally, it clears the feval table and exits.
 */
void mexFunction(int nlhs, mxArray * * plhs, int nrhs, mxArray * * prhs) {
    mlfTry {
        mlfFunctionTableSetup(1, function_table);
        mclImportGlobal(0, NULL);
        mlxMtcsd(nlhs, plhs, nrhs, prhs);
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

void mlxSubplot(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: subplot Line: 1 Column: "
            "0 The function \"subplot\" was called with mor"
            "e than the declared number of outputs (1)"));
    }
    if (nrhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: subplot Line: 1 Column:"
            " 0 The function \"subplot\" was called with m"
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
    mplhs[0] = Msubplot(nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
}

mxArray * mlfNSubplot(int nargout,
                      mxArray * nrows,
                      mxArray * ncols,
                      mxArray * thisPlot) {
    mxArray * theAxis = mclGetUninitializedArray();
    mlfEnterNewContext(0, 3, nrows, ncols, thisPlot);
    theAxis = Msubplot(nargout, nrows, ncols, thisPlot);
    mlfRestorePreviousContext(0, 3, nrows, ncols, thisPlot);
    return mlfReturnValue(theAxis);
}

mxArray * mlfSubplot(mxArray * nrows, mxArray * ncols, mxArray * thisPlot) {
    int nargout = 1;
    mxArray * theAxis = mclGetUninitializedArray();
    mlfEnterNewContext(0, 3, nrows, ncols, thisPlot);
    theAxis = Msubplot(nargout, nrows, ncols, thisPlot);
    mlfRestorePreviousContext(0, 3, nrows, ncols, thisPlot);
    return mlfReturnValue(theAxis);
}

void mlfVSubplot(mxArray * nrows, mxArray * ncols, mxArray * thisPlot) {
    mxArray * theAxis = mclUnassigned();
    mlfEnterNewContext(0, 3, nrows, ncols, thisPlot);
    theAxis = Msubplot(0, nrows, ncols, thisPlot);
    mlfRestorePreviousContext(0, 3, nrows, ncols, thisPlot);
    mxDestroyArray(theAxis);
}

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

mxArray * mlfSqueeze(mxArray * a) {
    int nargout = 1;
    mxArray * b = mclGetUninitializedArray();
    mlfEnterNewContext(0, 1, a);
    b = Msqueeze(nargout, a);
    mlfRestorePreviousContext(0, 1, a);
    return mlfReturnValue(b);
}

void mlxGeneral_private_mtparam(int nlhs,
                                mxArray * plhs[],
                                int nrhs,
                                mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[8];
    int i;
    if (nlhs > 8) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: General/private/mtparam Line: 1 Co"
            "lumn: 0 The function \"General/private/mtparam\" was cal"
            "led with more than the declared number of outputs (8)"));
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: General/private/mtparam Line: 1 Co"
            "lumn: 0 The function \"General/private/mtparam\" was cal"
            "led with more than the declared number of inputs (1)"));
    }
    for (i = 0; i < 8; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 1 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 1; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 1, mprhs[0]);
    mplhs[0]
      = MGeneral_private_mtparam(
          &mplhs[1],
          &mplhs[2],
          &mplhs[3],
          &mplhs[4],
          &mplhs[5],
          &mplhs[6],
          &mplhs[7],
          nlhs,
          mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 8 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 8; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

mxArray * mlfGeneral_private_mtparam(mxArray * * nFFT,
                                     mxArray * * Fs,
                                     mxArray * * WinLength,
                                     mxArray * * nOverlap,
                                     mxArray * * NW,
                                     mxArray * * Detrend,
                                     mxArray * * nTapers,
                                     mxArray * P) {
    int nargout = 1;
    mxArray * x = mclGetUninitializedArray();
    mxArray * nFFT__ = mclGetUninitializedArray();
    mxArray * Fs__ = mclGetUninitializedArray();
    mxArray * WinLength__ = mclGetUninitializedArray();
    mxArray * nOverlap__ = mclGetUninitializedArray();
    mxArray * NW__ = mclGetUninitializedArray();
    mxArray * Detrend__ = mclGetUninitializedArray();
    mxArray * nTapers__ = mclGetUninitializedArray();
    mlfEnterNewContext(
      7, 1, nFFT, Fs, WinLength, nOverlap, NW, Detrend, nTapers, P);
    if (nFFT != NULL) {
        ++nargout;
    }
    if (Fs != NULL) {
        ++nargout;
    }
    if (WinLength != NULL) {
        ++nargout;
    }
    if (nOverlap != NULL) {
        ++nargout;
    }
    if (NW != NULL) {
        ++nargout;
    }
    if (Detrend != NULL) {
        ++nargout;
    }
    if (nTapers != NULL) {
        ++nargout;
    }
    x
      = MGeneral_private_mtparam(
          &nFFT__,
          &Fs__,
          &WinLength__,
          &nOverlap__,
          &NW__,
          &Detrend__,
          &nTapers__,
          nargout,
          P);
    mlfRestorePreviousContext(
      7, 1, nFFT, Fs, WinLength, nOverlap, NW, Detrend, nTapers, P);
    if (nFFT != NULL) {
        mclCopyOutputArg(nFFT, nFFT__);
    } else {
        mxDestroyArray(nFFT__);
    }
    if (Fs != NULL) {
        mclCopyOutputArg(Fs, Fs__);
    } else {
        mxDestroyArray(Fs__);
    }
    if (WinLength != NULL) {
        mclCopyOutputArg(WinLength, WinLength__);
    } else {
        mxDestroyArray(WinLength__);
    }
    if (nOverlap != NULL) {
        mclCopyOutputArg(nOverlap, nOverlap__);
    } else {
        mxDestroyArray(nOverlap__);
    }
    if (NW != NULL) {
        mclCopyOutputArg(NW, NW__);
    } else {
        mxDestroyArray(NW__);
    }
    if (Detrend != NULL) {
        mclCopyOutputArg(Detrend, Detrend__);
    } else {
        mxDestroyArray(Detrend__);
    }
    if (nTapers != NULL) {
        mclCopyOutputArg(nTapers, nTapers__);
    } else {
        mxDestroyArray(nTapers__);
    }
    return mlfReturnValue(x);
}

void mlxGrid(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    int i;
    if (nlhs > 0) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: grid Line: 1 Column: 0 The function \"grid\""
            " was called with more than the declared number of outputs (0)"));
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: grid Line: 1 Column: 0 The function \"grid"
            "\" was called with more than the declared number of inputs (1)"));
    }
    for (i = 0; i < 1 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 1; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 1, mprhs[0]);
    Mgrid(mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
}

void mlfGrid(mxArray * opt_grid) {
    mlfEnterNewContext(0, 1, opt_grid);
    Mgrid(opt_grid);
    mlfRestorePreviousContext(0, 1, opt_grid);
}

void mlxDpss(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[2];
    int i;
    if (nlhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: dpss Line: 1 Column: 0 The function \"dpss\""
            " was called with more than the declared number of outputs (2)"));
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
    mprhs[2] = NULL;
    mlfAssign(&mprhs[2], mclCreateVararginCell(nrhs - 2, prhs + 2));
    mplhs[0] = Mdpss(&mplhs[1], nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 2 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 2; ++i) {
        mxDestroyArray(mplhs[i]);
    }
    mxDestroyArray(mprhs[2]);
}

mxArray * mlfDpss(mxArray * * V, mxArray * N, mxArray * NW, ...) {
    mxArray * varargin = mclUnassigned();
    int nargout = 1;
    mxArray * E = mclGetUninitializedArray();
    mxArray * V__ = mclGetUninitializedArray();
    mlfVarargin(&varargin, NW, 0);
    mlfEnterNewContext(1, -3, V, N, NW, varargin);
    if (V != NULL) {
        ++nargout;
    }
    E = Mdpss(&V__, nargout, N, NW, varargin);
    mlfRestorePreviousContext(1, 2, V, N, NW);
    mxDestroyArray(varargin);
    if (V != NULL) {
        mclCopyOutputArg(V, V__);
    } else {
        mxDestroyArray(V__);
    }
    return mlfReturnValue(E);
}

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

mxArray * mlfDetrend(mxArray * x, mxArray * o, mxArray * bp) {
    int nargout = 1;
    mxArray * y = mclGetUninitializedArray();
    mlfEnterNewContext(0, 3, x, o, bp);
    y = Mdetrend(nargout, x, o, bp);
    mlfRestorePreviousContext(0, 3, x, o, bp);
    return mlfReturnValue(y);
}

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

mxArray * mlfComplex(mxArray * A, mxArray * B) {
    int nargout = 1;
    mxArray * C = mclGetUninitializedArray();
    mlfEnterNewContext(0, 2, A, B);
    C = Mcomplex(nargout, A, B);
    mlfRestorePreviousContext(0, 2, A, B);
    return mlfReturnValue(C);
}
