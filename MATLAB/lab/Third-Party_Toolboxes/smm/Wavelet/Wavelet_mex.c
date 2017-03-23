/*
 * MATLAB Compiler: 2.2
 * Date: Wed Jun  9 16:08:34 2004
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "Wavelet" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#include "libmatlb.h"
#include "Wavelet.h"
#include "DefaultArgs.h"
#include "FreeMemory.h"
#include "WaveletSampling.h"
#include "WaveletTimeSplit.h"
#include "mean.h"
#include "repmat.h"
#include "wave_bases.h"

mxArray * memcont = NULL;

static mexGlobalTableEntry global_table[1] = { { "memcont", &memcont } };

static mexFunctionTableEntry function_table[1]
  = { { "Wavelet", mlxWavelet, -2, 5, &_local_function_table_Wavelet } };

static _mexInitTermTableEntry init_term_table[1]
  = { { InitializeModule_Wavelet, TerminateModule_Wavelet } };

static _mex_information _mex_info
  = { 1, 1, function_table, 1, global_table, 0, NULL, 1, init_term_table };

/*
 * The function "Mwave_bases" is the MATLAB callback version of the
 * "wave_bases" function from file "/u12/antsiro/matlab/draft/wave_bases.m". It
 * performs a callback to MATLAB to run the "wave_bases" function, and passes
 * any resulting output arguments back to its calling function.
 */
static mxArray * Mwave_bases(mxArray * * fourier_factor,
                             mxArray * * coi,
                             mxArray * * dofmin,
                             int nargout_,
                             mxArray * mother,
                             mxArray * k,
                             mxArray * scale,
                             mxArray * param) {
    mxArray * daughter = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &daughter, fourier_factor, coi, dofmin, NULL),
      "wave_bases",
      mother, k, scale, param, NULL);
    return daughter;
}

/*
 * The function "Mrepmat" is the MATLAB callback version of the "repmat"
 * function from file "/u16/local/matlab6.1/toolbox/matlab/elmat/repmat.m". It
 * performs a callback to MATLAB to run the "repmat" function, and passes any
 * resulting output arguments back to its calling function.
 */
static mxArray * Mrepmat(int nargout_, mxArray * A, mxArray * M, mxArray * N) {
    mxArray * B = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &B, NULL), "repmat", A, M, N, NULL);
    return B;
}

/*
 * The function "Mmean" is the MATLAB callback version of the "mean" function
 * from file "/u16/local/matlab6.1/toolbox/matlab/datafun/mean.m". It performs
 * a callback to MATLAB to run the "mean" function, and passes any resulting
 * output arguments back to its calling function.
 */
static mxArray * Mmean(int nargout_, mxArray * x, mxArray * dim) {
    mxArray * y = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &y, NULL), "mean", x, dim, NULL);
    return y;
}

/*
 * The function "MWaveletTimeSplit" is the MATLAB callback version of the
 * "WaveletTimeSplit" function from file
 * "/u12/antsiro/matlab/draft/WaveletTimeSplit.m". It performs a callback to
 * MATLAB to run the "WaveletTimeSplit" function, and passes any resulting
 * output arguments back to its calling function.
 */
static mxArray * MWaveletTimeSplit(mxArray * * BlockSize,
                                   int nargout_,
                                   mxArray * x,
                                   mxArray * varargin) {
    mxArray * nBlocks = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &nBlocks, BlockSize, NULL),
      "WaveletTimeSplit",
      x, mlfIndexRef(varargin, "{?}", mlfCreateColonIndex()), NULL);
    return nBlocks;
}

/*
 * The function "MWaveletSampling" is the MATLAB callback version of the
 * "WaveletSampling" function from file
 * "/u12/antsiro/matlab/draft/WaveletSampling.m". It performs a callback to
 * MATLAB to run the "WaveletSampling" function, and passes any resulting
 * output arguments back to its calling function.
 */
static mxArray * MWaveletSampling(mxArray * * s,
                                  mxArray * * p,
                                  int nargout_,
                                  mxArray * varargin) {
    mxArray * f = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &f, s, p, NULL),
      "WaveletSampling",
      mlfIndexRef(varargin, "{?}", mlfCreateColonIndex()), NULL);
    return f;
}

/*
 * The function "MFreeMemory" is the MATLAB callback version of the
 * "FreeMemory" function from file "/u12/antsiro/matlab/General/FreeMemory.m".
 * It performs a callback to MATLAB to run the "FreeMemory" function, and
 * passes any resulting output arguments back to its calling function.
 */
static mxArray * MFreeMemory(int nargout_) {
    mxArray * HowMuch = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &HowMuch, NULL), "FreeMemory", NULL);
    return HowMuch;
}

/*
 * The function "MDefaultArgs" is the MATLAB callback version of the
 * "DefaultArgs" function from file
 * "/u12/antsiro/matlab/General/DefaultArgs.m". It performs a callback to
 * MATLAB to run the "DefaultArgs" function, and passes any resulting output
 * arguments back to its calling function.
 */
static mxArray * MDefaultArgs(int nargout_, mxArray * Args, mxArray * DefArgs) {
    mxArray * varargout = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 1, &varargout, NULL),
      "DefaultArgs",
      Args, DefArgs, NULL);
    return varargout;
}

/*
 * The function "mexLibrary" is a Compiler-generated mex wrapper, suitable for
 * building a MEX-function. It initializes any persistent variables as well as
 * a function table for use by the feval function. It then calls the function
 * "mlxWavelet". Finally, it clears the feval table and exits.
 */
mex_information mexLibrary(void) {
    mclMexLibraryInit();
    return &_mex_info;
}

/*
 * The function "mlfWave_bases" contains the normal interface for the
 * "wave_bases" M-function from file "/u12/antsiro/matlab/draft/wave_bases.m"
 * (lines 0-0). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
mxArray * mlfWave_bases(mxArray * * fourier_factor,
                        mxArray * * coi,
                        mxArray * * dofmin,
                        mxArray * mother,
                        mxArray * k,
                        mxArray * scale,
                        mxArray * param) {
    int nargout = 1;
    mxArray * daughter = mclGetUninitializedArray();
    mxArray * fourier_factor__ = mclGetUninitializedArray();
    mxArray * coi__ = mclGetUninitializedArray();
    mxArray * dofmin__ = mclGetUninitializedArray();
    mlfEnterNewContext(
      3, 4, fourier_factor, coi, dofmin, mother, k, scale, param);
    if (fourier_factor != NULL) {
        ++nargout;
    }
    if (coi != NULL) {
        ++nargout;
    }
    if (dofmin != NULL) {
        ++nargout;
    }
    daughter
      = Mwave_bases(
          &fourier_factor__,
          &coi__,
          &dofmin__,
          nargout,
          mother,
          k,
          scale,
          param);
    mlfRestorePreviousContext(
      3, 4, fourier_factor, coi, dofmin, mother, k, scale, param);
    if (fourier_factor != NULL) {
        mclCopyOutputArg(fourier_factor, fourier_factor__);
    } else {
        mxDestroyArray(fourier_factor__);
    }
    if (coi != NULL) {
        mclCopyOutputArg(coi, coi__);
    } else {
        mxDestroyArray(coi__);
    }
    if (dofmin != NULL) {
        mclCopyOutputArg(dofmin, dofmin__);
    } else {
        mxDestroyArray(dofmin__);
    }
    return mlfReturnValue(daughter);
}

/*
 * The function "mlxWave_bases" contains the feval interface for the
 * "wave_bases" M-function from file "/u12/antsiro/matlab/draft/wave_bases.m"
 * (lines 0-0). The feval function calls the implementation version of
 * wave_bases through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
void mlxWave_bases(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[4];
    mxArray * mplhs[4];
    int i;
    if (nlhs > 4) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: wave_bases Line: 1 Column:"
            " 1 The function \"wave_bases\" was called with m"
            "ore than the declared number of outputs (4)."));
    }
    if (nrhs > 4) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: wave_bases Line: 1 Column:"
            " 1 The function \"wave_bases\" was called with m"
            "ore than the declared number of inputs (4)."));
    }
    for (i = 0; i < 4; ++i) {
        mplhs[i] = mclGetUninitializedArray();
    }
    for (i = 0; i < 4 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 4; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 4, mprhs[0], mprhs[1], mprhs[2], mprhs[3]);
    mplhs[0]
      = Mwave_bases(
          &mplhs[1],
          &mplhs[2],
          &mplhs[3],
          nlhs,
          mprhs[0],
          mprhs[1],
          mprhs[2],
          mprhs[3]);
    mlfRestorePreviousContext(0, 4, mprhs[0], mprhs[1], mprhs[2], mprhs[3]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 4 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 4; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "mlfRepmat" contains the normal interface for the "repmat"
 * M-function from file "/u16/local/matlab6.1/toolbox/matlab/elmat/repmat.m"
 * (lines 0-0). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
mxArray * mlfRepmat(mxArray * A, mxArray * M, mxArray * N) {
    int nargout = 1;
    mxArray * B = mclGetUninitializedArray();
    mlfEnterNewContext(0, 3, A, M, N);
    B = Mrepmat(nargout, A, M, N);
    mlfRestorePreviousContext(0, 3, A, M, N);
    return mlfReturnValue(B);
}

/*
 * The function "mlxRepmat" contains the feval interface for the "repmat"
 * M-function from file "/u16/local/matlab6.1/toolbox/matlab/elmat/repmat.m"
 * (lines 0-0). The feval function calls the implementation version of repmat
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxRepmat(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: repmat Line: 1 Column: "
            "1 The function \"repmat\" was called with mor"
            "e than the declared number of outputs (1)."));
    }
    if (nrhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: repmat Line: 1 Column: "
            "1 The function \"repmat\" was called with mor"
            "e than the declared number of inputs (3)."));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = mclGetUninitializedArray();
    }
    for (i = 0; i < 3 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 3; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    mplhs[0] = Mrepmat(nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
}

/*
 * The function "mlfMean" contains the normal interface for the "mean"
 * M-function from file "/u16/local/matlab6.1/toolbox/matlab/datafun/mean.m"
 * (lines 0-0). This function processes any input arguments and passes them to
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
 * M-function from file "/u16/local/matlab6.1/toolbox/matlab/datafun/mean.m"
 * (lines 0-0). The feval function calls the implementation version of mean
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxMean(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: mean Line: 1 Column: 1 The function \"mean\""
            " was called with more than the declared number of outputs (1)."));
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: mean Line: 1 Column: 1 The function \"mean\""
            " was called with more than the declared number of inputs (2)."));
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
 * The function "mlfWaveletTimeSplit" contains the normal interface for the
 * "WaveletTimeSplit" M-function from file
 * "/u12/antsiro/matlab/draft/WaveletTimeSplit.m" (lines 0-0). This function
 * processes any input arguments and passes them to the implementation version
 * of the function, appearing above.
 */
mxArray * mlfWaveletTimeSplit(mxArray * * BlockSize, mxArray * x, ...) {
    mxArray * varargin = NULL;
    int nargout = 1;
    mxArray * nBlocks = mclGetUninitializedArray();
    mxArray * BlockSize__ = mclGetUninitializedArray();
    mlfVarargin(&varargin, x, 0);
    mlfEnterNewContext(1, -2, BlockSize, x, varargin);
    if (BlockSize != NULL) {
        ++nargout;
    }
    nBlocks = MWaveletTimeSplit(&BlockSize__, nargout, x, varargin);
    mlfRestorePreviousContext(1, 1, BlockSize, x);
    mxDestroyArray(varargin);
    if (BlockSize != NULL) {
        mclCopyOutputArg(BlockSize, BlockSize__);
    } else {
        mxDestroyArray(BlockSize__);
    }
    return mlfReturnValue(nBlocks);
}

/*
 * The function "mlxWaveletTimeSplit" contains the feval interface for the
 * "WaveletTimeSplit" M-function from file
 * "/u12/antsiro/matlab/draft/WaveletTimeSplit.m" (lines 0-0). The feval
 * function calls the implementation version of WaveletTimeSplit through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxWaveletTimeSplit(int nlhs,
                         mxArray * plhs[],
                         int nrhs,
                         mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[2];
    int i;
    if (nlhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: WaveletTimeSplit Line: 1 Colum"
            "n: 1 The function \"WaveletTimeSplit\" was called wi"
            "th more than the declared number of outputs (2)."));
    }
    for (i = 0; i < 2; ++i) {
        mplhs[i] = mclGetUninitializedArray();
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
    mplhs[0] = MWaveletTimeSplit(&mplhs[1], nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 2 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 2; ++i) {
        mxDestroyArray(mplhs[i]);
    }
    mxDestroyArray(mprhs[1]);
}

/*
 * The function "mlfWaveletSampling" contains the normal interface for the
 * "WaveletSampling" M-function from file
 * "/u12/antsiro/matlab/draft/WaveletSampling.m" (lines 0-0). This function
 * processes any input arguments and passes them to the implementation version
 * of the function, appearing above.
 */
mxArray * mlfWaveletSampling(mxArray * * s, mxArray * * p, ...) {
    mxArray * varargin = NULL;
    int nargout = 1;
    mxArray * f = mclGetUninitializedArray();
    mxArray * s__ = mclGetUninitializedArray();
    mxArray * p__ = mclGetUninitializedArray();
    mlfVarargin(&varargin, p, 0);
    mlfEnterNewContext(2, -1, s, p, varargin);
    if (s != NULL) {
        ++nargout;
    }
    if (p != NULL) {
        ++nargout;
    }
    f = MWaveletSampling(&s__, &p__, nargout, varargin);
    mlfRestorePreviousContext(2, 0, s, p);
    mxDestroyArray(varargin);
    if (s != NULL) {
        mclCopyOutputArg(s, s__);
    } else {
        mxDestroyArray(s__);
    }
    if (p != NULL) {
        mclCopyOutputArg(p, p__);
    } else {
        mxDestroyArray(p__);
    }
    return mlfReturnValue(f);
}

/*
 * The function "mlxWaveletSampling" contains the feval interface for the
 * "WaveletSampling" M-function from file
 * "/u12/antsiro/matlab/draft/WaveletSampling.m" (lines 0-0). The feval
 * function calls the implementation version of WaveletSampling through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxWaveletSampling(int nlhs,
                        mxArray * plhs[],
                        int nrhs,
                        mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[3];
    int i;
    if (nlhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: WaveletSampling Line: 1 Colum"
            "n: 1 The function \"WaveletSampling\" was called wi"
            "th more than the declared number of outputs (3)."));
    }
    for (i = 0; i < 3; ++i) {
        mplhs[i] = mclGetUninitializedArray();
    }
    mlfEnterNewContext(0, 0);
    mprhs[0] = NULL;
    mlfAssign(&mprhs[0], mclCreateVararginCell(nrhs, prhs));
    mplhs[0] = MWaveletSampling(&mplhs[1], &mplhs[2], nlhs, mprhs[0]);
    mlfRestorePreviousContext(0, 0);
    plhs[0] = mplhs[0];
    for (i = 1; i < 3 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 3; ++i) {
        mxDestroyArray(mplhs[i]);
    }
    mxDestroyArray(mprhs[0]);
}

/*
 * The function "mlfFreeMemory" contains the normal interface for the
 * "FreeMemory" M-function from file "/u12/antsiro/matlab/General/FreeMemory.m"
 * (lines 0-0). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
mxArray * mlfFreeMemory(void) {
    int nargout = 1;
    mxArray * HowMuch = mclGetUninitializedArray();
    mlfEnterNewContext(0, 0);
    HowMuch = MFreeMemory(nargout);
    mlfRestorePreviousContext(0, 0);
    return mlfReturnValue(HowMuch);
}

/*
 * The function "mlxFreeMemory" contains the feval interface for the
 * "FreeMemory" M-function from file "/u12/antsiro/matlab/General/FreeMemory.m"
 * (lines 0-0). The feval function calls the implementation version of
 * FreeMemory through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
void mlxFreeMemory(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: FreeMemory Line: 1 Column:"
            " 1 The function \"FreeMemory\" was called with m"
            "ore than the declared number of outputs (1)."));
    }
    if (nrhs > 0) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: FreeMemory Line: 1 Column:"
            " 1 The function \"FreeMemory\" was called with m"
            "ore than the declared number of inputs (0)."));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = mclGetUninitializedArray();
    }
    mlfEnterNewContext(0, 0);
    mplhs[0] = MFreeMemory(nlhs);
    mlfRestorePreviousContext(0, 0);
    plhs[0] = mplhs[0];
}

/*
 * The function "mlfNDefaultArgs" contains the nargout interface for the
 * "DefaultArgs" M-function from file
 * "/u12/antsiro/matlab/General/DefaultArgs.m" (lines 0-0). This interface is
 * only produced if the M-function uses the special variable "nargout". The
 * nargout interface allows the number of requested outputs to be specified via
 * the nargout argument, as opposed to the normal interface which dynamically
 * calculates the number of outputs based on the number of non-NULL inputs it
 * receives. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfNDefaultArgs(int nargout,
                          mlfVarargoutList * varargout,
                          mxArray * Args,
                          mxArray * DefArgs) {
    mlfEnterNewContext(0, 2, Args, DefArgs);
    nargout += mclNargout(varargout);
    *mlfGetVarargoutCellPtr(varargout) = MDefaultArgs(nargout, Args, DefArgs);
    mlfRestorePreviousContext(0, 2, Args, DefArgs);
    return mlfAssignOutputs(varargout);
}

/*
 * The function "mlfDefaultArgs" contains the normal interface for the
 * "DefaultArgs" M-function from file
 * "/u12/antsiro/matlab/General/DefaultArgs.m" (lines 0-0). This function
 * processes any input arguments and passes them to the implementation version
 * of the function, appearing above.
 */
mxArray * mlfDefaultArgs(mlfVarargoutList * varargout,
                         mxArray * Args,
                         mxArray * DefArgs) {
    int nargout = 0;
    mlfEnterNewContext(0, 2, Args, DefArgs);
    nargout += mclNargout(varargout);
    *mlfGetVarargoutCellPtr(varargout) = MDefaultArgs(nargout, Args, DefArgs);
    mlfRestorePreviousContext(0, 2, Args, DefArgs);
    return mlfAssignOutputs(varargout);
}

/*
 * The function "mlfVDefaultArgs" contains the void interface for the
 * "DefaultArgs" M-function from file
 * "/u12/antsiro/matlab/General/DefaultArgs.m" (lines 0-0). The void interface
 * is only produced if the M-function uses the special variable "nargout", and
 * has at least one output. The void interface function specifies zero output
 * arguments to the implementation version of the function, and in the event
 * that the implementation version still returns an output (which, in MATLAB,
 * would be assigned to the "ans" variable), it deallocates the output. This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
void mlfVDefaultArgs(mxArray * Args, mxArray * DefArgs) {
    mxArray * varargout = NULL;
    mlfEnterNewContext(0, 2, Args, DefArgs);
    varargout = MDefaultArgs(0, Args, DefArgs);
    mlfRestorePreviousContext(0, 2, Args, DefArgs);
    mxDestroyArray(varargout);
}

/*
 * The function "mlxDefaultArgs" contains the feval interface for the
 * "DefaultArgs" M-function from file
 * "/u12/antsiro/matlab/General/DefaultArgs.m" (lines 0-0). The feval function
 * calls the implementation version of DefaultArgs through this function. This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
void mlxDefaultArgs(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[1];
    int i;
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: DefaultArgs Line: 1 Column"
            ": 1 The function \"DefaultArgs\" was called with"
            " more than the declared number of inputs (2)."));
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
    mplhs[0] = MDefaultArgs(nlhs, mprhs[0], mprhs[1]);
    mclAssignVarargoutCell(0, nlhs, plhs, mplhs[0]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
}
