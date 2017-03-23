/*
 * MATLAB Compiler: 2.2
 * Date: Wed Jun  9 16:06:04 2004
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-m" "-W" "main" "-L"
 * "C" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "Wavelet" 
 */
#include "WaveletTimeSplit.h"
#include "DefaultArgs.h"
#include "FreeMemory.h"
#include "WaveletSampling.h"
#include "libmatlbm.h"

static mxChar _array1_[150] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'W', 'a', 'v', 'e', 'l',
                                'e', 't', 'T', 'i', 'm', 'e', 'S', 'p', 'l',
                                'i', 't', ' ', 'L', 'i', 'n', 'e', ':', ' ',
                                '5', ' ', 'C', 'o', 'l', 'u', 'm', 'n', ':',
                                ' ', '1', ' ', 'T', 'h', 'e', ' ', 'f', 'u',
                                'n', 'c', 't', 'i', 'o', 'n', ' ', '"', 'W',
                                'a', 'v', 'e', 'l', 'e', 't', 'T', 'i', 'm',
                                'e', 'S', 'p', 'l', 'i', 't', '"', ' ', 'w',
                                'a', 's', ' ', 'c', 'a', 'l', 'l', 'e', 'd',
                                ' ', 'w', 'i', 't', 'h', ' ', 'm', 'o', 'r',
                                'e', ' ', 't', 'h', 'a', 'n', ' ', 't', 'h',
                                'e', ' ', 'd', 'e', 'c', 'l', 'a', 'r', 'e',
                                'd', ' ', 'n', 'u', 'm', 'b', 'e', 'r', ' ',
                                'o', 'f', ' ', 'o', 'u', 't', 'p', 'u', 't',
                                's', ' ', '(', '2', ')', '.' };
static mxArray * _mxarray0_;
static mxArray * _mxarray4_;

static double _array6_[2] = { 1.0, 200.0 };
static mxArray * _mxarray5_;
static mxArray * _mxarray7_;
static mxArray * _mxarray8_;

static mxArray * _array3_[4] = { NULL /*_mxarray4_*/, NULL /*_mxarray5_*/,
                                 NULL /*_mxarray7_*/, NULL /*_mxarray8_*/ };
static mxArray * _mxarray2_;
static mxArray * _mxarray9_;
static mxArray * _mxarray10_;
static mxArray * _mxarray11_;
static mxArray * _mxarray12_;
static mxArray * _mxarray13_;

void InitializeModule_WaveletTimeSplit(void) {
    _mxarray0_ = mclInitializeString(150, _array1_);
    _mxarray4_ = mclInitializeDouble(1250.0);
    _array3_[0] = _mxarray4_;
    _mxarray5_ = mclInitializeDoubleVector(1, 2, _array6_);
    _array3_[1] = _mxarray5_;
    _mxarray7_ = mclInitializeDouble(1.0);
    _array3_[2] = _mxarray7_;
    _mxarray8_ = mclInitializeDouble(.1);
    _array3_[3] = _mxarray8_;
    _mxarray2_ = mclInitializeCellVector(1, 4, _array3_);
    _mxarray9_ = mclInitializeDouble(6.0);
    _mxarray10_ = mclInitializeDouble(2.0);
    _mxarray11_ = mclInitializeDouble(1000.0);
    _mxarray12_ = mclInitializeDouble(16.0);
    _mxarray13_ = mclInitializeDouble(32.0);
}

void TerminateModule_WaveletTimeSplit(void) {
    mxDestroyArray(_mxarray13_);
    mxDestroyArray(_mxarray12_);
    mxDestroyArray(_mxarray11_);
    mxDestroyArray(_mxarray10_);
    mxDestroyArray(_mxarray9_);
    mxDestroyArray(_mxarray2_);
    mxDestroyArray(_mxarray8_);
    mxDestroyArray(_mxarray7_);
    mxDestroyArray(_mxarray5_);
    mxDestroyArray(_mxarray4_);
    mxDestroyArray(_mxarray0_);
}

static mxArray * MWaveletTimeSplit(mxArray * * BlockSize,
                                   int nargout_,
                                   mxArray * x,
                                   mxArray * varargin);

_mexLocalFunctionTable _local_function_table_WaveletTimeSplit
  = { 0, (mexFunctionTableEntry *)NULL };

/*
 * The function "mlfWaveletTimeSplit" contains the normal interface for the
 * "WaveletTimeSplit" M-function from file
 * "/u12/antsiro/matlab/draft/WaveletTimeSplit.m" (lines 1-27). This function
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
 * "/u12/antsiro/matlab/draft/WaveletTimeSplit.m" (lines 1-27). The feval
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
        mlfError(_mxarray0_);
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
 * The function "MWaveletTimeSplit" is the implementation version of the
 * "WaveletTimeSplit" M-function from file
 * "/u12/antsiro/matlab/draft/WaveletTimeSplit.m" (lines 1-27). It contains the
 * actual compiled code for that M-function. It is a static function and must
 * only be called from one of the interface functions, appearing below.
 */
/*
 * %[nBlocks, BlockSize] = WaveletTimeSplit(x,Fs,FreqRange,IsLogSc, MemPart)
 * % computes the number of blocks to split the signal
 * % according to existing memory to use about MemPart 
 * % (from 0 to 1) of freemem , default is 0.5
 * function [nBlocks, BlockSize] = WaveletTimeSplit(x,varargin)
 */
static mxArray * MWaveletTimeSplit(mxArray * * BlockSize,
                                   int nargout_,
                                   mxArray * x,
                                   mxArray * varargin) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(
          &_local_function_table_WaveletTimeSplit);
    mxArray * nBlocks = mclGetUninitializedArray();
    mxArray * avmemory = mclGetUninitializedArray();
    mxArray * nFBins = mclGetUninitializedArray();
    mxArray * p = mclGetUninitializedArray();
    mxArray * s = mclGetUninitializedArray();
    mxArray * f = mclGetUninitializedArray();
    mxArray * nTime = mclGetUninitializedArray();
    mxArray * nChannels = mclGetUninitializedArray();
    mxArray * w0 = mclGetUninitializedArray();
    mxArray * MemPart = mclGetUninitializedArray();
    mxArray * IsLogSc = mclGetUninitializedArray();
    mxArray * FreqRange = mclGetUninitializedArray();
    mxArray * Fs = mclGetUninitializedArray();
    mclCopyArray(&x);
    mclCopyArray(&varargin);
    /*
     * 
     * [Fs,FreqRange,IsLogSc,MemPart] = DefaultArgs(varargin, {1250,[1 200],1, 0.1});
     */
    mlfNDefaultArgs(
      0,
      mlfVarargout(&Fs, &FreqRange, &IsLogSc, &MemPart, NULL),
      mclVa(varargin, "varargin"),
      _mxarray2_);
    /*
     * w0=6; % fixed default for now
     */
    mlfAssign(&w0, _mxarray9_);
    /*
     * nChannels = size(x,2);
     */
    mlfAssign(
      &nChannels, mlfSize(mclValueVarargout(), mclVa(x, "x"), _mxarray10_));
    /*
     * nTime = size(x,1);
     */
    mlfAssign(&nTime, mlfSize(mclValueVarargout(), mclVa(x, "x"), _mxarray7_));
    /*
     * [f,s,p] = WaveletSampling(Fs,FreqRange,IsLogSc, w0);
     */
    mlfAssign(
      &f,
      mlfWaveletSampling(
        &s,
        &p,
        mclVv(Fs, "Fs"),
        mclVv(FreqRange, "FreqRange"),
        mclVv(IsLogSc, "IsLogSc"),
        mclVv(w0, "w0"),
        NULL));
    /*
     * nFBins = length(f);
     */
    mlfAssign(&nFBins, mlfScalar(mclLengthInt(mclVv(f, "f"))));
    /*
     * % is will use more than 80% of available memory -split
     * avmemory = FreeMemory*1000;
     */
    mlfAssign(&avmemory, mclMtimes(mclVe(mlfFreeMemory()), _mxarray11_));
    /*
     * 
     * if (2*nChannels*nTime*nFBins*16 > MemPart*avmemory)
     */
    if (mclGtBool(
          mclMtimes(
            mclMtimes(
              mclMtimes(
                mclMtimes(_mxarray10_, mclVv(nChannels, "nChannels")),
                mclVv(nTime, "nTime")),
              mclVv(nFBins, "nFBins")),
            _mxarray12_),
          mclMtimes(mclVv(MemPart, "MemPart"), mclVv(avmemory, "avmemory")))) {
        /*
         * % find a block size that is power of 2, n=2^m
         * BlockSize = 2^floor(log2(MemPart*avmemory/(2*16*nFBins*nChannels)));
         */
        mlfAssign(
          BlockSize,
          mclMpower(
            _mxarray10_,
            mclVe(
              mlfFloor(
                mclVe(
                  mlfLog2(
                    NULL,
                    mclMrdivide(
                      mclMtimes(
                        mclVv(MemPart, "MemPart"), mclVv(avmemory, "avmemory")),
                      mclMtimes(
                        mclMtimes(_mxarray13_, mclVv(nFBins, "nFBins")),
                        mclVv(nChannels, "nChannels")))))))));
        /*
         * nBlocks = ceil(nTime/BlockSize);
         */
        mlfAssign(
          &nBlocks,
          mlfCeil(
            mclMrdivide(
              mclVv(nTime, "nTime"), mclVv(*BlockSize, "BlockSize"))));
    /*
     * else
     */
    } else {
        /*
         * nBlocks =1;
         */
        mlfAssign(&nBlocks, _mxarray7_);
        /*
         * BlockSize = nTime;
         */
        mlfAssign(BlockSize, mclVsv(nTime, "nTime"));
    /*
     * end
     */
    }
    mclValidateOutput(nBlocks, 1, nargout_, "nBlocks", "WaveletTimeSplit");
    mclValidateOutput(*BlockSize, 2, nargout_, "BlockSize", "WaveletTimeSplit");
    mxDestroyArray(Fs);
    mxDestroyArray(FreqRange);
    mxDestroyArray(IsLogSc);
    mxDestroyArray(MemPart);
    mxDestroyArray(w0);
    mxDestroyArray(nChannels);
    mxDestroyArray(nTime);
    mxDestroyArray(f);
    mxDestroyArray(s);
    mxDestroyArray(p);
    mxDestroyArray(nFBins);
    mxDestroyArray(avmemory);
    mxDestroyArray(varargin);
    mxDestroyArray(x);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return nBlocks;
    /*
     * 
     * 
     * 
     */
}
