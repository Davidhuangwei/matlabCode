/*
 * MATLAB Compiler: 2.1
 * Date: Mon May  7 15:50:01 2001
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "-w" "ResSubset" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#include "libmatlb.h"
#include "ResSubset.h"
#include "LoadClu.h"
#include "LoadFet.h"
#include "LoadPar.h"
#include "LoadPar1.h"
#include "SaveClu.h"
#include "SaveFet.h"
#include "SaveSpk.h"
#include "WithinRanges.h"
#include "bload.h"
#include "msave.h"
#include "num2str.h"

static mexFunctionTableEntry function_table[12]
  = { { "ResSubset", mlxResSubset, 3, 0, &_local_function_table_ResSubset },
      { "LoadClu", mlxLoadClu, 1, 1, NULL },
      { "LoadFet", mlxLoadFet, 1, 1, NULL },
      { "LoadPar", mlxLoadPar, 1, 1, NULL },
      { "LoadPar1", mlxLoadPar1, 1, 1, NULL },
      { "SaveClu", mlxSaveClu, 2, 0, NULL },
      { "SaveFet", mlxSaveFet, 2, 0, NULL },
      { "SaveSpk", mlxSaveSpk, 2, 0, NULL },
      { "WithinRanges", mlxWithinRanges, 3, 1, NULL },
      { "bload", mlxBload, 5, 1, NULL }, { "msave", mlxMsave, 2, 0, NULL },
      { "num2str", mlxNum2str, 2, 1, NULL } };

static _mexInitTermTableEntry init_term_table[1]
  = { { InitializeModule_ResSubset, TerminateModule_ResSubset } };

static _mex_information _mex_info
  = { 1, 12, function_table, 0, NULL, 0, NULL, 1, init_term_table };

/*
 * The function "Mnum2str" is the MATLAB callback version of the "num2str"
 * function from file "/u2/local/matlab6/toolbox/matlab/strfun/num2str.m". It
 * performs a callback to MATLAB to run the "num2str" function, and passes any
 * resulting output arguments back to its calling function.
 */
static mxArray * Mnum2str(int nargout_, mxArray * x, mxArray * f) {
    mxArray * s = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &s, NULL), "num2str", x, f, NULL);
    return s;
}

/*
 * The function "Mmsave" is the MATLAB callback version of the "msave" function
 * from file "/u5/b/ken/matlab/General/msave.m". It performs a callback to
 * MATLAB to run the "msave" function, and passes any resulting output
 * arguments back to its calling function.
 */
static void Mmsave(mxArray * filename, mxArray * matrix) {
    mclFevalCallMATLAB(mclAnsVarargout(), "msave", filename, matrix, NULL);
}

/*
 * The function "Mbload" is the MATLAB callback version of the "bload" function
 * from file "/u5/b/ken/matlab/General/bload.m". It performs a callback to
 * MATLAB to run the "bload" function, and passes any resulting output
 * arguments back to its calling function.
 */
static mxArray * Mbload(int nargout_,
                        mxArray * fname,
                        mxArray * arg1,
                        mxArray * startpos,
                        mxArray * datasize,
                        mxArray * skip) {
    mxArray * out = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &out, NULL),
      "bload",
      fname, arg1, startpos, datasize, skip, NULL);
    return out;
}

/*
 * The function "MWithinRanges" is the MATLAB callback version of the
 * "WithinRanges" function from file "/u5/b/ken/matlab/General/WithinRanges.m".
 * It performs a callback to MATLAB to run the "WithinRanges" function, and
 * passes any resulting output arguments back to its calling function.
 */
static mxArray * MWithinRanges(int nargout_,
                               mxArray * x,
                               mxArray * Ranges,
                               mxArray * RangeLabel) {
    mxArray * out = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &out, NULL),
      "WithinRanges",
      x, Ranges, RangeLabel, NULL);
    return out;
}

/*
 * The function "MSaveSpk" is the MATLAB callback version of the "SaveSpk"
 * function from file "/u5/b/ken/matlab/Spikes/SaveSpk.m". It performs a
 * callback to MATLAB to run the "SaveSpk" function, and passes any resulting
 * output arguments back to its calling function.
 */
static void MSaveSpk(mxArray * FileName, mxArray * Spk) {
    mclFevalCallMATLAB(mclAnsVarargout(), "SaveSpk", FileName, Spk, NULL);
}

/*
 * The function "MSaveFet" is the MATLAB callback version of the "SaveFet"
 * function from file "/u5/b/ken/matlab/Spikes/SaveFet.m". It performs a
 * callback to MATLAB to run the "SaveFet" function, and passes any resulting
 * output arguments back to its calling function.
 */
static void MSaveFet(mxArray * FileName, mxArray * Fet) {
    mclFevalCallMATLAB(mclAnsVarargout(), "SaveFet", FileName, Fet, NULL);
}

/*
 * The function "MSaveClu" is the MATLAB callback version of the "SaveClu"
 * function from file "/u5/b/ken/matlab/Spikes/SaveClu.m". It performs a
 * callback to MATLAB to run the "SaveClu" function, and passes any resulting
 * output arguments back to its calling function.
 */
static void MSaveClu(mxArray * FileName, mxArray * Clu) {
    mclFevalCallMATLAB(mclAnsVarargout(), "SaveClu", FileName, Clu, NULL);
}

/*
 * The function "MLoadPar1" is the MATLAB callback version of the "LoadPar1"
 * function from file "/u5/b/ken/matlab/Spikes/LoadPar1.m". It performs a
 * callback to MATLAB to run the "LoadPar1" function, and passes any resulting
 * output arguments back to its calling function.
 */
static mxArray * MLoadPar1(int nargout_, mxArray * FileName) {
    mxArray * Par = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &Par, NULL), "LoadPar1", FileName, NULL);
    return Par;
}

/*
 * The function "MLoadPar" is the MATLAB callback version of the "LoadPar"
 * function from file "/u5/b/ken/matlab/Spikes/LoadPar.m". It performs a
 * callback to MATLAB to run the "LoadPar" function, and passes any resulting
 * output arguments back to its calling function.
 */
static mxArray * MLoadPar(int nargout_, mxArray * FileName) {
    mxArray * Par = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &Par, NULL), "LoadPar", FileName, NULL);
    return Par;
}

/*
 * The function "MLoadFet" is the MATLAB callback version of the "LoadFet"
 * function from file "/u5/b/ken/matlab/Spikes/LoadFet.m". It performs a
 * callback to MATLAB to run the "LoadFet" function, and passes any resulting
 * output arguments back to its calling function.
 */
static mxArray * MLoadFet(int nargout_, mxArray * FileName) {
    mxArray * Fet = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &Fet, NULL), "LoadFet", FileName, NULL);
    return Fet;
}

/*
 * The function "MLoadClu" is the MATLAB callback version of the "LoadClu"
 * function from file "/u5/b/ken/matlab/Spikes/LoadClu.m". It performs a
 * callback to MATLAB to run the "LoadClu" function, and passes any resulting
 * output arguments back to its calling function.
 */
static mxArray * MLoadClu(int nargout_, mxArray * FileName) {
    mxArray * Clu = mclGetUninitializedArray();
    mclFevalCallMATLAB(
      mclNVarargout(nargout_, 0, &Clu, NULL), "LoadClu", FileName, NULL);
    return Clu;
}

/*
 * The function "mexLibrary" is a Compiler-generated mex wrapper, suitable for
 * building a MEX-function. It initializes any persistent variables as well as
 * a function table for use by the feval function. It then calls the function
 * "mlxResSubset". Finally, it clears the feval table and exits.
 */
mex_information mexLibrary(void) {
    return &_mex_info;
}

/*
 * The function "mlfNum2str" contains the normal interface for the "num2str"
 * M-function from file "/u2/local/matlab6/toolbox/matlab/strfun/num2str.m"
 * (lines 0-0). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
mxArray * mlfNum2str(mxArray * x, mxArray * f) {
    int nargout = 1;
    mxArray * s = mclGetUninitializedArray();
    mlfEnterNewContext(0, 2, x, f);
    s = Mnum2str(nargout, x, f);
    mlfRestorePreviousContext(0, 2, x, f);
    return mlfReturnValue(s);
}

/*
 * The function "mlxNum2str" contains the feval interface for the "num2str"
 * M-function from file "/u2/local/matlab6/toolbox/matlab/strfun/num2str.m"
 * (lines 0-0). The feval function calls the implementation version of num2str
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxNum2str(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: num2str Line: 1 Column: "
            "1 The function \"num2str\" was called with mor"
            "e than the declared number of outputs (1)."));
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: num2str Line: 1 Column: "
            "1 The function \"num2str\" was called with mor"
            "e than the declared number of inputs (2)."));
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
    mplhs[0] = Mnum2str(nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
    plhs[0] = mplhs[0];
}

/*
 * The function "mlfMsave" contains the normal interface for the "msave"
 * M-function from file "/u5/b/ken/matlab/General/msave.m" (lines 0-0). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
void mlfMsave(mxArray * filename, mxArray * matrix) {
    mlfEnterNewContext(0, 2, filename, matrix);
    Mmsave(filename, matrix);
    mlfRestorePreviousContext(0, 2, filename, matrix);
}

/*
 * The function "mlxMsave" contains the feval interface for the "msave"
 * M-function from file "/u5/b/ken/matlab/General/msave.m" (lines 0-0). The
 * feval function calls the implementation version of msave through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxMsave(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    int i;
    if (nlhs > 0) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: msave Line: 1 Column: 1"
            " The function \"msave\" was called with more "
            "than the declared number of outputs (0)."));
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: msave Line: 1 Column: 1 The function \"msave"
            "\" was called with more than the declared number of inputs (2)."));
    }
    for (i = 0; i < 2 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 2; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 2, mprhs[0], mprhs[1]);
    Mmsave(mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
}

/*
 * The function "mlfBload" contains the normal interface for the "bload"
 * M-function from file "/u5/b/ken/matlab/General/bload.m" (lines 0-0). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
mxArray * mlfBload(mxArray * fname,
                   mxArray * arg1,
                   mxArray * startpos,
                   mxArray * datasize,
                   mxArray * skip) {
    int nargout = 1;
    mxArray * out = mclGetUninitializedArray();
    mlfEnterNewContext(0, 5, fname, arg1, startpos, datasize, skip);
    out = Mbload(nargout, fname, arg1, startpos, datasize, skip);
    mlfRestorePreviousContext(0, 5, fname, arg1, startpos, datasize, skip);
    return mlfReturnValue(out);
}

/*
 * The function "mlxBload" contains the feval interface for the "bload"
 * M-function from file "/u5/b/ken/matlab/General/bload.m" (lines 0-0). The
 * feval function calls the implementation version of bload through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxBload(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[5];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: bload Line: 1 Column: 1"
            " The function \"bload\" was called with more "
            "than the declared number of outputs (1)."));
    }
    if (nrhs > 5) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: bload Line: 1 Column: 1 The function \"bload"
            "\" was called with more than the declared number of inputs (5)."));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = mclGetUninitializedArray();
    }
    for (i = 0; i < 5 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 5; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 5, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    mplhs[0] = Mbload(nlhs, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    mlfRestorePreviousContext(
      0, 5, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    plhs[0] = mplhs[0];
}

/*
 * The function "mlfWithinRanges" contains the normal interface for the
 * "WithinRanges" M-function from file
 * "/u5/b/ken/matlab/General/WithinRanges.m" (lines 0-0). This function
 * processes any input arguments and passes them to the implementation version
 * of the function, appearing above.
 */
mxArray * mlfWithinRanges(mxArray * x, mxArray * Ranges, mxArray * RangeLabel) {
    int nargout = 1;
    mxArray * out = mclGetUninitializedArray();
    mlfEnterNewContext(0, 3, x, Ranges, RangeLabel);
    out = MWithinRanges(nargout, x, Ranges, RangeLabel);
    mlfRestorePreviousContext(0, 3, x, Ranges, RangeLabel);
    return mlfReturnValue(out);
}

/*
 * The function "mlxWithinRanges" contains the feval interface for the
 * "WithinRanges" M-function from file
 * "/u5/b/ken/matlab/General/WithinRanges.m" (lines 0-0). The feval function
 * calls the implementation version of WithinRanges through this function. This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
void mlxWithinRanges(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: WithinRanges Line: 1 Column"
            ": 1 The function \"WithinRanges\" was called with"
            " more than the declared number of outputs (1)."));
    }
    if (nrhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: WithinRanges Line: 1 Column"
            ": 1 The function \"WithinRanges\" was called with"
            " more than the declared number of inputs (3)."));
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
    mplhs[0] = MWithinRanges(nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
}

/*
 * The function "mlfSaveSpk" contains the normal interface for the "SaveSpk"
 * M-function from file "/u5/b/ken/matlab/Spikes/SaveSpk.m" (lines 0-0). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
void mlfSaveSpk(mxArray * FileName, mxArray * Spk) {
    mlfEnterNewContext(0, 2, FileName, Spk);
    MSaveSpk(FileName, Spk);
    mlfRestorePreviousContext(0, 2, FileName, Spk);
}

/*
 * The function "mlxSaveSpk" contains the feval interface for the "SaveSpk"
 * M-function from file "/u5/b/ken/matlab/Spikes/SaveSpk.m" (lines 0-0). The
 * feval function calls the implementation version of SaveSpk through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxSaveSpk(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    int i;
    if (nlhs > 0) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: SaveSpk Line: 1 Column: "
            "1 The function \"SaveSpk\" was called with mor"
            "e than the declared number of outputs (0)."));
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: SaveSpk Line: 1 Column: "
            "1 The function \"SaveSpk\" was called with mor"
            "e than the declared number of inputs (2)."));
    }
    for (i = 0; i < 2 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 2; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 2, mprhs[0], mprhs[1]);
    MSaveSpk(mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
}

/*
 * The function "mlfSaveFet" contains the normal interface for the "SaveFet"
 * M-function from file "/u5/b/ken/matlab/Spikes/SaveFet.m" (lines 0-0). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
void mlfSaveFet(mxArray * FileName, mxArray * Fet) {
    mlfEnterNewContext(0, 2, FileName, Fet);
    MSaveFet(FileName, Fet);
    mlfRestorePreviousContext(0, 2, FileName, Fet);
}

/*
 * The function "mlxSaveFet" contains the feval interface for the "SaveFet"
 * M-function from file "/u5/b/ken/matlab/Spikes/SaveFet.m" (lines 0-0). The
 * feval function calls the implementation version of SaveFet through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxSaveFet(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    int i;
    if (nlhs > 0) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: SaveFet Line: 1 Column: "
            "1 The function \"SaveFet\" was called with mor"
            "e than the declared number of outputs (0)."));
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: SaveFet Line: 1 Column: "
            "1 The function \"SaveFet\" was called with mor"
            "e than the declared number of inputs (2)."));
    }
    for (i = 0; i < 2 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 2; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 2, mprhs[0], mprhs[1]);
    MSaveFet(mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
}

/*
 * The function "mlfSaveClu" contains the normal interface for the "SaveClu"
 * M-function from file "/u5/b/ken/matlab/Spikes/SaveClu.m" (lines 0-0). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
void mlfSaveClu(mxArray * FileName, mxArray * Clu) {
    mlfEnterNewContext(0, 2, FileName, Clu);
    MSaveClu(FileName, Clu);
    mlfRestorePreviousContext(0, 2, FileName, Clu);
}

/*
 * The function "mlxSaveClu" contains the feval interface for the "SaveClu"
 * M-function from file "/u5/b/ken/matlab/Spikes/SaveClu.m" (lines 0-0). The
 * feval function calls the implementation version of SaveClu through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxSaveClu(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    int i;
    if (nlhs > 0) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: SaveClu Line: 1 Column: "
            "1 The function \"SaveClu\" was called with mor"
            "e than the declared number of outputs (0)."));
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: SaveClu Line: 1 Column: "
            "1 The function \"SaveClu\" was called with mor"
            "e than the declared number of inputs (2)."));
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

/*
 * The function "mlfLoadPar1" contains the normal interface for the "LoadPar1"
 * M-function from file "/u5/b/ken/matlab/Spikes/LoadPar1.m" (lines 0-0). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
mxArray * mlfLoadPar1(mxArray * FileName) {
    int nargout = 1;
    mxArray * Par = mclGetUninitializedArray();
    mlfEnterNewContext(0, 1, FileName);
    Par = MLoadPar1(nargout, FileName);
    mlfRestorePreviousContext(0, 1, FileName);
    return mlfReturnValue(Par);
}

/*
 * The function "mlxLoadPar1" contains the feval interface for the "LoadPar1"
 * M-function from file "/u5/b/ken/matlab/Spikes/LoadPar1.m" (lines 0-0). The
 * feval function calls the implementation version of LoadPar1 through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxLoadPar1(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: LoadPar1 Line: 1 Column: "
            "1 The function \"LoadPar1\" was called with mor"
            "e than the declared number of outputs (1)."));
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: LoadPar1 Line: 1 Column:"
            " 1 The function \"LoadPar1\" was called with m"
            "ore than the declared number of inputs (1)."));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = mclGetUninitializedArray();
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

/*
 * The function "mlfLoadPar" contains the normal interface for the "LoadPar"
 * M-function from file "/u5/b/ken/matlab/Spikes/LoadPar.m" (lines 0-0). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
mxArray * mlfLoadPar(mxArray * FileName) {
    int nargout = 1;
    mxArray * Par = mclGetUninitializedArray();
    mlfEnterNewContext(0, 1, FileName);
    Par = MLoadPar(nargout, FileName);
    mlfRestorePreviousContext(0, 1, FileName);
    return mlfReturnValue(Par);
}

/*
 * The function "mlxLoadPar" contains the feval interface for the "LoadPar"
 * M-function from file "/u5/b/ken/matlab/Spikes/LoadPar.m" (lines 0-0). The
 * feval function calls the implementation version of LoadPar through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxLoadPar(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: LoadPar Line: 1 Column: "
            "1 The function \"LoadPar\" was called with mor"
            "e than the declared number of outputs (1)."));
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: LoadPar Line: 1 Column: "
            "1 The function \"LoadPar\" was called with mor"
            "e than the declared number of inputs (1)."));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = mclGetUninitializedArray();
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

/*
 * The function "mlfLoadFet" contains the normal interface for the "LoadFet"
 * M-function from file "/u5/b/ken/matlab/Spikes/LoadFet.m" (lines 0-0). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
mxArray * mlfLoadFet(mxArray * FileName) {
    int nargout = 1;
    mxArray * Fet = mclGetUninitializedArray();
    mlfEnterNewContext(0, 1, FileName);
    Fet = MLoadFet(nargout, FileName);
    mlfRestorePreviousContext(0, 1, FileName);
    return mlfReturnValue(Fet);
}

/*
 * The function "mlxLoadFet" contains the feval interface for the "LoadFet"
 * M-function from file "/u5/b/ken/matlab/Spikes/LoadFet.m" (lines 0-0). The
 * feval function calls the implementation version of LoadFet through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxLoadFet(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: LoadFet Line: 1 Column: "
            "1 The function \"LoadFet\" was called with mor"
            "e than the declared number of outputs (1)."));
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: LoadFet Line: 1 Column: "
            "1 The function \"LoadFet\" was called with mor"
            "e than the declared number of inputs (1)."));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = mclGetUninitializedArray();
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

/*
 * The function "mlfLoadClu" contains the normal interface for the "LoadClu"
 * M-function from file "/u5/b/ken/matlab/Spikes/LoadClu.m" (lines 0-0). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
mxArray * mlfLoadClu(mxArray * FileName) {
    int nargout = 1;
    mxArray * Clu = mclGetUninitializedArray();
    mlfEnterNewContext(0, 1, FileName);
    Clu = MLoadClu(nargout, FileName);
    mlfRestorePreviousContext(0, 1, FileName);
    return mlfReturnValue(Clu);
}

/*
 * The function "mlxLoadClu" contains the feval interface for the "LoadClu"
 * M-function from file "/u5/b/ken/matlab/Spikes/LoadClu.m" (lines 0-0). The
 * feval function calls the implementation version of LoadClu through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxLoadClu(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: LoadClu Line: 1 Column: "
            "1 The function \"LoadClu\" was called with mor"
            "e than the declared number of outputs (1)."));
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: LoadClu Line: 1 Column: "
            "1 The function \"LoadClu\" was called with mor"
            "e than the declared number of inputs (1)."));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = mclGetUninitializedArray();
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
