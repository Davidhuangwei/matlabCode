/*
 * MATLAB Compiler: 2.2
 * Date: Wed Jun  9 16:08:34 2004
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "Wavelet" 
 */
#include "Wavelet.h"
#include "DefaultArgs.h"
#include "FreeMemory.h"
#include "WaveletSampling.h"
#include "WaveletTimeSplit.h"
#include "libmatlbm.h"
#include "mean.h"
#include "repmat.h"
#include "wave_bases.h"

extern mxArray * memcont;

static mxChar _array1_[133] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'W', 'a', 'v', 'e', 'l',
                                'e', 't', ' ', 'L', 'i', 'n', 'e', ':', ' ',
                                '1', '6', ' ', 'C', 'o', 'l', 'u', 'm', 'n',
                                ':', ' ', '1', ' ', 'T', 'h', 'e', ' ', 'f',
                                'u', 'n', 'c', 't', 'i', 'o', 'n', ' ', '"',
                                'W', 'a', 'v', 'e', 'l', 'e', 't', '"', ' ',
                                'w', 'a', 's', ' ', 'c', 'a', 'l', 'l', 'e',
                                'd', ' ', 'w', 'i', 't', 'h', ' ', 'm', 'o',
                                'r', 'e', ' ', 't', 'h', 'a', 'n', ' ', 't',
                                'h', 'e', ' ', 'd', 'e', 'c', 'l', 'a', 'r',
                                'e', 'd', ' ', 'n', 'u', 'm', 'b', 'e', 'r',
                                ' ', 'o', 'f', ' ', 'o', 'u', 't', 'p', 'u',
                                't', 's', ' ', '(', '5', ')', '.' };
static mxArray * _mxarray0_;

static double _array5_[2] = { 1.0, 250.0 };
static mxArray * _mxarray4_;
static mxArray * _mxarray6_;
static mxArray * _mxarray7_;
static mxArray * _mxarray8_;
static mxArray * _mxarray9_;
static mxArray * _mxarray10_;

static mxArray * _array3_[6] = { NULL /*_mxarray4_*/, NULL /*_mxarray6_*/,
                                 NULL /*_mxarray7_*/, NULL /*_mxarray8_*/,
                                 NULL /*_mxarray9_*/, NULL /*_mxarray10_*/ };
static mxArray * _mxarray2_;

static mxChar _array12_[6] = { 'M', 'O', 'R', 'L', 'E', 'T' };
static mxArray * _mxarray11_;
static mxArray * _mxarray13_;
static mxArray * _mxarray14_;
static mxArray * _mxarray15_;

static mxChar _array17_[14] = { 's', 'p', 'l', 'i', 't', 't', 'i', 'n',
                                'g', '.', '.', '.', 0x005c, 'n' };
static mxArray * _mxarray16_;
static mxArray * _mxarray18_;
static mxArray * _mxarray19_;
static mxArray * _mxarray20_;

static double _array22_[3] = { 3.0, 1.0, 2.0 };
static mxArray * _mxarray21_;

static double _array24_[3] = { 2.0, 1.0, 3.0 };
static mxArray * _mxarray23_;

void InitializeModule_Wavelet(void) {
    _mxarray0_ = mclInitializeString(133, _array1_);
    _mxarray4_ = mclInitializeDoubleVector(1, 2, _array5_);
    _array3_[0] = _mxarray4_;
    _mxarray6_ = mclInitializeDouble(1250.0);
    _array3_[1] = _mxarray6_;
    _mxarray7_ = mclInitializeDouble(6.0);
    _array3_[2] = _mxarray7_;
    _mxarray8_ = mclInitializeDouble(1.0);
    _array3_[3] = _mxarray8_;
    _mxarray9_ = mclInitializeDouble(0.0);
    _array3_[4] = _mxarray9_;
    _mxarray10_ = mclInitializeDoubleVector(0, 0, (double *)NULL);
    _array3_[5] = _mxarray10_;
    _mxarray2_ = mclInitializeCellVector(1, 6, _array3_);
    _mxarray11_ = mclInitializeString(6, _array12_);
    _mxarray13_ = mclInitializeDouble(2.0);
    _mxarray14_ = mclInitializeDouble(1000.0);
    _mxarray15_ = mclInitializeDouble(16.0);
    _mxarray16_ = mclInitializeString(14, _array17_);
    _mxarray18_ = mclInitializeDouble(.4999);
    _mxarray19_ = mclInitializeDouble(6.283185307179586);
    _mxarray20_ = mclInitializeDouble(-1.0);
    _mxarray21_ = mclInitializeDoubleVector(1, 3, _array22_);
    _mxarray23_ = mclInitializeDoubleVector(1, 3, _array24_);
}

void TerminateModule_Wavelet(void) {
    mxDestroyArray(_mxarray23_);
    mxDestroyArray(_mxarray21_);
    mxDestroyArray(_mxarray20_);
    mxDestroyArray(_mxarray19_);
    mxDestroyArray(_mxarray18_);
    mxDestroyArray(_mxarray16_);
    mxDestroyArray(_mxarray15_);
    mxDestroyArray(_mxarray14_);
    mxDestroyArray(_mxarray13_);
    mxDestroyArray(_mxarray11_);
    mxDestroyArray(_mxarray2_);
    mxDestroyArray(_mxarray10_);
    mxDestroyArray(_mxarray9_);
    mxDestroyArray(_mxarray8_);
    mxDestroyArray(_mxarray7_);
    mxDestroyArray(_mxarray6_);
    mxDestroyArray(_mxarray4_);
    mxDestroyArray(_mxarray0_);
}

static mxArray * MWavelet(mxArray * * f,
                          mxArray * * t,
                          mxArray * * s,
                          mxArray * * wb,
                          int nargout_,
                          mxArray * x,
                          mxArray * varargin);

_mexLocalFunctionTable _local_function_table_Wavelet
  = { 0, (mexFunctionTableEntry *)NULL };

/*
 * The function "mlfWavelet" contains the normal interface for the "Wavelet"
 * M-function from file "/u12/antsiro/matlab/draft/Wavelet.m" (lines 1-100).
 * This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfWavelet(mxArray * * f,
                     mxArray * * t,
                     mxArray * * s,
                     mxArray * * wb,
                     mxArray * x,
                     ...) {
    mxArray * varargin = NULL;
    int nargout = 1;
    mxArray * wave = mclGetUninitializedArray();
    mxArray * f__ = mclGetUninitializedArray();
    mxArray * t__ = mclGetUninitializedArray();
    mxArray * s__ = mclGetUninitializedArray();
    mxArray * wb__ = mclGetUninitializedArray();
    mlfVarargin(&varargin, x, 0);
    mlfEnterNewContext(4, -2, f, t, s, wb, x, varargin);
    if (f != NULL) {
        ++nargout;
    }
    if (t != NULL) {
        ++nargout;
    }
    if (s != NULL) {
        ++nargout;
    }
    if (wb != NULL) {
        ++nargout;
    }
    wave = MWavelet(&f__, &t__, &s__, &wb__, nargout, x, varargin);
    mlfRestorePreviousContext(4, 1, f, t, s, wb, x);
    mxDestroyArray(varargin);
    if (f != NULL) {
        mclCopyOutputArg(f, f__);
    } else {
        mxDestroyArray(f__);
    }
    if (t != NULL) {
        mclCopyOutputArg(t, t__);
    } else {
        mxDestroyArray(t__);
    }
    if (s != NULL) {
        mclCopyOutputArg(s, s__);
    } else {
        mxDestroyArray(s__);
    }
    if (wb != NULL) {
        mclCopyOutputArg(wb, wb__);
    } else {
        mxDestroyArray(wb__);
    }
    return mlfReturnValue(wave);
}

/*
 * The function "mlxWavelet" contains the feval interface for the "Wavelet"
 * M-function from file "/u12/antsiro/matlab/draft/Wavelet.m" (lines 1-100).
 * The feval function calls the implementation version of Wavelet through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxWavelet(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[5];
    int i;
    if (nlhs > 5) {
        mlfError(_mxarray0_);
    }
    for (i = 0; i < 5; ++i) {
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
    mplhs[0]
      = MWavelet(
          &mplhs[1],
          &mplhs[2],
          &mplhs[3],
          &mplhs[4],
          nlhs,
          mprhs[0],
          mprhs[1]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 5 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 5; ++i) {
        mxDestroyArray(mplhs[i]);
    }
    mxDestroyArray(mprhs[1]);
}

/*
 * The function "MWavelet" is the implementation version of the "Wavelet"
 * M-function from file "/u12/antsiro/matlab/draft/Wavelet.m" (lines 1-100). It
 * contains the actual compiled code for that M-function. It is a static
 * function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * %[wave,f,t,s,wb] = Wavelet(x,FreqRange,Fs, w0, IsLogSc, wb)
 * % computes the scalogram for the signal x (Time by Channels)
 * % FreqRange  -- range of frequencies [Fmin Fmax]
 * % Fs         -- sampling rate
 * % w0         -- center freq.(dimensionless) of 
 * %               mother (Morlet) wavelet
 * % IsLogSc -- 0 - even, 1 - logorythmic(default)	
 * % wb - matrix of wave_base computed on previous step
 * % Output:
 * % wavelet decomposition wave (freq/scale by time)
 * % t-time(sec), f - freq.(Hz),
 * % s- scale, p -period (sec)
 * % function is rewritten after Cristopher Torrence and
 * % Gilbert Compo (see their paper for details)
 * 
 * function [wave,f,t,s,wb] = Wavelet(x,varargin)
 */
static mxArray * MWavelet(mxArray * * f,
                          mxArray * * t,
                          mxArray * * s,
                          mxArray * * wb,
                          int nargout_,
                          mxArray * x,
                          mxArray * varargin) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_Wavelet);
    mxArray * wave = mclGetUninitializedArray();
    mxArray * dofmin = mclGetUninitializedArray();
    mxArray * coi = mclGetUninitializedArray();
    mxArray * fourier_factor = mclGetUninitializedArray();
    mxArray * fftX = mclGetUninitializedArray();
    mxArray * k = mclGetUninitializedArray();
    mxArray * base2 = mclGetUninitializedArray();
    mxArray * waveBlock = mclGetUninitializedArray();
    mxArray * segment = mclGetUninitializedArray();
    mxArray * segind = mclGetUninitializedArray();
    mxArray * j = mclGetUninitializedArray();
    mxArray * BlockSize = mclGetUninitializedArray();
    mxArray * nBlocks = mclGetUninitializedArray();
    mxArray * avmemory = mclGetUninitializedArray();
    mxArray * n = mclGetUninitializedArray();
    mxArray * nChannels = mclGetUninitializedArray();
    mxArray * nSamples = mclGetUninitializedArray();
    mxArray * nFBins = mclGetUninitializedArray();
    mxArray * p = mclGetUninitializedArray();
    mxArray * mother = mclGetUninitializedArray();
    mxArray * pad = mclGetUninitializedArray();
    mxArray * Split = mclGetUninitializedArray();
    mxArray * WhatBlock = mclGetUninitializedArray();
    mxArray * IsLogSc = mclGetUninitializedArray();
    mxArray * w0 = mclGetUninitializedArray();
    mxArray * Fs = mclGetUninitializedArray();
    mxArray * FreqRange = mclGetUninitializedArray();
    mxArray * ans = mclGetUninitializedArray();
    mclCopyArray(&x);
    mclCopyArray(&varargin);
    /*
     * global memcont;
     * %set defaults
     * [FreqRange, Fs,   w0, IsLogSc, WhatBlock, wb] = ...
     * DefaultArgs(varargin,{[1 250],  1250, 6,  1,       0, []}); 
     */
    mlfNDefaultArgs(
      0,
      mlfVarargout(&FreqRange, &Fs, &w0, &IsLogSc, &WhatBlock, wb, NULL),
      mclVa(varargin, "varargin"),
      _mxarray2_);
    /*
     * Split = 0; %don't split by default
     */
    mlfAssign(&Split, _mxarray9_);
    /*
     * pad = 1; % will pad to nearest power of 2
     */
    mlfAssign(&pad, _mxarray8_);
    /*
     * mother = 'MORLET'; % so far it is fixed
     */
    mlfAssign(&mother, _mxarray11_);
    /*
     * 
     * % compute the req. axis sampling
     * [f,s,p] = WaveletSampling(Fs,FreqRange,IsLogSc, w0);
     */
    mlfAssign(
      f,
      mlfWaveletSampling(
        s,
        &p,
        mclVv(Fs, "Fs"),
        mclVv(FreqRange, "FreqRange"),
        mclVv(IsLogSc, "IsLogSc"),
        mclVv(w0, "w0"),
        NULL));
    /*
     * nFBins = length(f);
     */
    mlfAssign(&nFBins, mlfScalar(mclLengthInt(mclVv(*f, "f"))));
    /*
     * if size(x,1)<size(x,2)
     */
    if (mclLtBool(
          mclVe(mlfSize(mclValueVarargout(), mclVa(x, "x"), _mxarray8_)),
          mclVe(mlfSize(mclValueVarargout(), mclVa(x, "x"), _mxarray13_)))) {
        /*
         * x =x';
         */
        mlfAssign(&x, mlfCtranspose(mclVa(x, "x")));
    /*
     * end
     */
    }
    /*
     * nSamples = size(x,1);
     */
    mlfAssign(
      &nSamples, mlfSize(mclValueVarargout(), mclVa(x, "x"), _mxarray8_));
    /*
     * nChannels =size(x,2);
     */
    mlfAssign(
      &nChannels, mlfSize(mclValueVarargout(), mclVa(x, "x"), _mxarray13_));
    /*
     * n = size(x,1);
     */
    mlfAssign(&n, mlfSize(mclValueVarargout(), mclVa(x, "x"), _mxarray8_));
    /*
     * % if will take more than available memory - exit
     * avmemory = FreeMemory*1000;
     */
    mlfAssign(&avmemory, mclMtimes(mclVe(mlfFreeMemory()), _mxarray14_));
    /*
     * if (n*nChannels*nFBins*2*16 > avmemory)
     */
    if (mclGtBool(
          mclMtimes(
            mclMtimes(
              mclMtimes(
                mclMtimes(mclVv(n, "n"), mclVv(nChannels, "nChannels")),
                mclVv(nFBins, "nFBins")),
              _mxarray13_),
            _mxarray15_),
          mclVv(avmemory, "avmemory"))) {
        /*
         * %error('It will take more memory then available');
         * Split=1;
         */
        mlfAssign(&Split, _mxarray8_);
    /*
     * end
     */
    }
    /*
     * memcont(end+1) =FreeMemory;
     */
    mlfIndexAssign(
      mclPrepareGlobal(&memcont),
      "(?)",
      mclPlus(
        mlfEnd(mclVg(&memcont, "memcont"), _mxarray8_, _mxarray8_), _mxarray8_),
      mlfFreeMemory());
    /*
     * 
     * wave = zeros(nSamples, nFBins);
     */
    mlfAssign(
      &wave,
      mlfZeros(mclVv(nSamples, "nSamples"), mclVv(nFBins, "nFBins"), NULL));
    /*
     * if Split
     */
    if (mlfTobool(mclVv(Split, "Split"))) {
        /*
         * fprintf('splitting...\n');
         */
        mclAssignAns(&ans, mlfNFprintf(0, _mxarray16_, NULL));
        /*
         * 
         * [nBlocks, BlockSize] = WaveletTimeSplit(x,Fs,FreqRange,IsLogSc);
         */
        mlfAssign(
          &nBlocks,
          mlfWaveletTimeSplit(
            &BlockSize,
            mclVa(x, "x"),
            mclVv(Fs, "Fs"),
            mclVv(FreqRange, "FreqRange"),
            mclVv(IsLogSc, "IsLogSc"),
            NULL));
        /*
         * for j=1:nBlocks
         */
        {
            int v_ = mclForIntStart(1);
            int e_ = mclForIntEnd(mclVv(nBlocks, "nBlocks"));
            if (v_ > e_) {
                mlfAssign(&j, _mxarray10_);
            } else {
                /*
                 * segind = [((j-1)*BlockSize+1) : min(nSamples,j*BlockSize)];
                 * segment = x(segind,:);  
                 * [waveBlock, t, f, s, wb] = Wavelet(segment,FreqRange,Fs, w0, IsLogSc, wb);
                 * wave(segind,:) =  waveBlock;
                 * end
                 */
                for (; ; ) {
                    mlfAssign(
                      &segind,
                      mlfColon(
                        mclPlus(
                          mclMtimes(
                            mlfScalar(v_ - 1), mclVv(BlockSize, "BlockSize")),
                          _mxarray8_),
                        mclVe(
                          mlfMin(
                            NULL,
                            mclVv(nSamples, "nSamples"),
                            mclMtimes(
                              mlfScalar(v_), mclVv(BlockSize, "BlockSize")),
                            NULL)),
                        NULL));
                    mlfAssign(
                      &segment,
                      mclArrayRef2(
                        mclVsa(x, "x"),
                        mclVsv(segind, "segind"),
                        mlfCreateColonIndex()));
                    mlfAssign(
                      &waveBlock,
                      mlfWavelet(
                        t,
                        f,
                        s,
                        wb,
                        mclVv(segment, "segment"),
                        mclVv(FreqRange, "FreqRange"),
                        mclVv(Fs, "Fs"),
                        mclVv(w0, "w0"),
                        mclVv(IsLogSc, "IsLogSc"),
                        mclVv(*wb, "wb"),
                        NULL));
                    mclArrayAssign2(
                      &wave,
                      mclVsv(waveBlock, "waveBlock"),
                      mclVsv(segind, "segind"),
                      mlfCreateColonIndex());
                    if (v_ == e_) {
                        break;
                    }
                    ++v_;
                }
                mlfAssign(&j, mlfScalar(v_));
            }
        }
        /*
         * memcont(end+1) =FreeMemory;
         */
        mlfIndexAssign(
          mclPrepareGlobal(&memcont),
          "(?)",
          mclPlus(
            mlfEnd(mclVg(&memcont, "memcont"), _mxarray8_, _mxarray8_),
            _mxarray8_),
          mlfFreeMemory());
    /*
     * else
     */
    } else {
        /*
         * 
         * % zero center
         * x = x - repmat(mean(x),nSamples,1);
         */
        mlfAssign(
          &x,
          mclMinus(
            mclVa(x, "x"),
            mclVe(
              mlfRepmat(
                mclVe(mlfMean(mclVa(x, "x"), NULL)),
                mclVv(nSamples, "nSamples"),
                _mxarray8_))));
        /*
         * if (pad == 1 & ~mod(nSamples,2))
         */
        {
            mxArray * a_ = mclInitialize(mclEq(mclVv(pad, "pad"), _mxarray8_));
            if (mlfTobool(a_)
                && mlfTobool(
                     mclAnd(
                       a_,
                       mclNot(
                         mclVe(
                           mlfMod(
                             mclVv(nSamples, "nSamples"), _mxarray13_)))))) {
                mxDestroyArray(a_);
                /*
                 * base2 = fix(log2(nSamples) + 0.4999);   % power of 2 nearest to nSamples
                 */
                mlfAssign(
                  &base2,
                  mlfFix(
                    mclPlus(
                      mclVe(mlfLog2(NULL, mclVv(nSamples, "nSamples"))),
                      _mxarray18_)));
                /*
                 * x = [x;zeros(2^(base2+1)-nSamples, nChannels)];
                 */
                mlfAssign(
                  &x,
                  mlfVertcat(
                    mclVa(x, "x"),
                    mclVe(
                      mlfZeros(
                        mclMinus(
                          mclMpower(
                            _mxarray13_,
                            mclPlus(mclVv(base2, "base2"), _mxarray8_)),
                          mclVv(nSamples, "nSamples")),
                        mclVv(nChannels, "nChannels"),
                        NULL)),
                    NULL));
            } else {
                mxDestroyArray(a_);
            }
        /*
         * end
         */
        }
        /*
         * 
         * n = size(x,1);
         */
        mlfAssign(&n, mlfSize(mclValueVarargout(), mclVa(x, "x"), _mxarray8_));
        /*
         * %....construct freq. vector for fft transform [Eqn(5)]
         * k = [1:fix(n/2)];
         */
        mlfAssign(
          &k,
          mlfColon(
            _mxarray8_,
            mclVe(mlfFix(mclMrdivide(mclVv(n, "n"), _mxarray13_))),
            NULL));
        /*
         * k = k.*((2.*pi)/(n/Fs));
         */
        mlfAssign(
          &k,
          mclTimes(
            mclVv(k, "k"),
            mclMrdivide(
              _mxarray19_, mclMrdivide(mclVv(n, "n"), mclVv(Fs, "Fs")))));
        /*
         * k = [0., k, -k(fix((n-1)/2):-1:1)];
         */
        mlfAssign(
          &k,
          mlfHorzcat(
            _mxarray9_,
            mclVv(k, "k"),
            mclUminus(
              mclVe(
                mclArrayRef1(
                  mclVsv(k, "k"),
                  mlfColon(
                    mclVe(
                      mlfFix(
                        mclMrdivide(
                          mclMinus(mclVv(n, "n"), _mxarray8_), _mxarray13_))),
                    _mxarray20_,
                    _mxarray8_)))),
            NULL));
        /*
         * 
         * %....compute FFT of the (padded) time series
         * fftX = fft(x);    % [Eqn(3)]
         */
        mlfAssign(&fftX, mlfFft(mclVa(x, "x"), NULL, NULL));
        /*
         * 
         * %attempt to save memory: use (nChannels+1)*n*nFBins*16 bytes
         * if isempty(wb) | size(wb,2)~=n
         */
        {
            mxArray * a_ = mclInitialize(mclVe(mlfIsempty(mclVv(*wb, "wb"))));
            if (mlfTobool(a_)
                || mlfTobool(
                     mclOr(
                       a_,
                       mclNe(
                         mclVe(
                           mlfSize(
                             mclValueVarargout(),
                             mclVv(*wb, "wb"),
                             _mxarray13_)),
                         mclVv(n, "n"))))) {
                mxDestroyArray(a_);
                /*
                 * [wb,fourier_factor,coi,dofmin] = wave_bases(mother,k,s,w0);
                 */
                mlfAssign(
                  wb,
                  mlfWave_bases(
                    &fourier_factor,
                    &coi,
                    &dofmin,
                    mclVv(mother, "mother"),
                    mclVv(k, "k"),
                    mclVv(*s, "s"),
                    mclVv(w0, "w0")));
            } else {
                mxDestroyArray(a_);
            }
        /*
         * end
         */
        }
        /*
         * memcont(end+1) =FreeMemory;
         */
        mlfIndexAssign(
          mclPrepareGlobal(&memcont),
          "(?)",
          mclPlus(
            mlfEnd(mclVg(&memcont, "memcont"), _mxarray8_, _mxarray8_),
            _mxarray8_),
          mlfFreeMemory());
        /*
         * wave = repmat(wb,[1, 1, nChannels]);
         */
        mlfAssign(
          &wave,
          mlfRepmat(
            mclVv(*wb, "wb"),
            mlfHorzcat(
              _mxarray8_, _mxarray8_, mclVv(nChannels, "nChannels"), NULL),
            NULL));
        /*
         * wave = wave .*permute(repmat(fftX, [1,1,nFBins]), [3 1 2]);
         */
        mlfAssign(
          &wave,
          mclTimes(
            mclVv(wave, "wave"),
            mclVe(
              mlfPermute(
                mclVe(
                  mlfRepmat(
                    mclVv(fftX, "fftX"),
                    mlfHorzcat(
                      _mxarray8_, _mxarray8_, mclVv(nFBins, "nFBins"), NULL),
                    NULL)),
                _mxarray21_))));
        /*
         * wave = permute( ifft(wave,[],2), [2 1 3]);
         */
        mlfAssign(
          &wave,
          mlfPermute(
            mclVe(mlfIfft(mclVv(wave, "wave"), _mxarray10_, _mxarray13_)),
            _mxarray23_));
        /*
         * 
         * % for si = 1:nFBins
         * % 	[daughter,fourier_factor,coi,dofmin]=wave_bases(mother,k,scale(si),w0);	
         * % 	wave(si,:) = ifft(fftX.*daughter);  % wavelet transform[Eqn(4)]
         * % end
         * 
         * %coi = coi*[1E-5,1:((nSamples+1)/2-1),fliplr((1:(nSamples/2-1))),1E-5]/Fs;  % COI [Sec.3g]
         * wave = wave(1:nSamples,:,:);  % get rid of padding before returning
         */
        mlfAssign(
          &wave,
          mlfIndexRef(
            mclVsv(wave, "wave"),
            "(?,?,?)",
            mlfColon(_mxarray8_, mclVv(nSamples, "nSamples"), NULL),
            mlfCreateColonIndex(),
            mlfCreateColonIndex()));
        /*
         * t = [1:nSamples]/Fs;
         */
        mlfAssign(
          t,
          mclMrdivide(
            mlfColon(_mxarray8_, mclVv(nSamples, "nSamples"), NULL),
            mclVv(Fs, "Fs")));
        /*
         * t=t(:); p=p(:);f=f(:);s=s(:);
         */
        mlfAssign(t, mclArrayRef1(mclVsv(*t, "t"), mlfCreateColonIndex()));
        mlfAssign(&p, mclArrayRef1(mclVsv(p, "p"), mlfCreateColonIndex()));
        mlfAssign(f, mclArrayRef1(mclVsv(*f, "f"), mlfCreateColonIndex()));
        mlfAssign(s, mclArrayRef1(mclVsv(*s, "s"), mlfCreateColonIndex()));
    /*
     * end
     */
    }
    /*
     * t = [1:nSamples]/Fs;t=t(:);
     */
    mlfAssign(
      t,
      mclMrdivide(
        mlfColon(_mxarray8_, mclVv(nSamples, "nSamples"), NULL),
        mclVv(Fs, "Fs")));
    mlfAssign(t, mclArrayRef1(mclVsv(*t, "t"), mlfCreateColonIndex()));
    mclValidateOutput(wave, 1, nargout_, "wave", "Wavelet");
    mclValidateOutput(*f, 2, nargout_, "f", "Wavelet");
    mclValidateOutput(*t, 3, nargout_, "t", "Wavelet");
    mclValidateOutput(*s, 4, nargout_, "s", "Wavelet");
    mclValidateOutput(*wb, 5, nargout_, "wb", "Wavelet");
    mxDestroyArray(ans);
    mxDestroyArray(FreqRange);
    mxDestroyArray(Fs);
    mxDestroyArray(w0);
    mxDestroyArray(IsLogSc);
    mxDestroyArray(WhatBlock);
    mxDestroyArray(Split);
    mxDestroyArray(pad);
    mxDestroyArray(mother);
    mxDestroyArray(p);
    mxDestroyArray(nFBins);
    mxDestroyArray(nSamples);
    mxDestroyArray(nChannels);
    mxDestroyArray(n);
    mxDestroyArray(avmemory);
    mxDestroyArray(nBlocks);
    mxDestroyArray(BlockSize);
    mxDestroyArray(j);
    mxDestroyArray(segind);
    mxDestroyArray(segment);
    mxDestroyArray(waveBlock);
    mxDestroyArray(base2);
    mxDestroyArray(k);
    mxDestroyArray(fftX);
    mxDestroyArray(fourier_factor);
    mxDestroyArray(coi);
    mxDestroyArray(dofmin);
    mxDestroyArray(varargin);
    mxDestroyArray(x);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return wave;
    /*
     * 
     * % save('wavtmp.mat','wave','t','f','s','wb');
     * % clear
     * % load('wavtmp.mat','wave','t','f','s','wb');
     * % system('rm wavtmp.mat');
     * %memcont(end+1) =FreeMemory;
     * return 
     * 
     */
}
