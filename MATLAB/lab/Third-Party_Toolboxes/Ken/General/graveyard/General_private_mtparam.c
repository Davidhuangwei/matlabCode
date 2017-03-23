/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:21 2000
 * Arguments: "-mw" "mtcsd" 
 */
#include "General_private_mtparam.h"

/*
 * The function "MGeneral_private_mtparam" is the implementation version of the
 * "General/private/mtparam" M-function from file
 * "/u5/b/ken/matlab/General/private/mtparam.m" (lines 1-47). It contains the
 * actual compiled code for that M-function. It is a static function and must
 * only be called from one of the interface functions, appearing below.
 */
/*
 * % helper function to do argument defaults etc for mt functions
 * function [x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,nChannels,nSamples,nFFTChunks,winstep,select,nFreqBins,f,t] = mtparam(P)
 */
static mxArray * MGeneral_private_mtparam(mxArray * * nFFT,
                                          mxArray * * Fs,
                                          mxArray * * WinLength,
                                          mxArray * * nOverlap,
                                          mxArray * * NW,
                                          mxArray * * Detrend,
                                          mxArray * * nTapers,
                                          mxArray * * nChannels,
                                          mxArray * * nSamples,
                                          mxArray * * nFFTChunks,
                                          mxArray * * winstep,
                                          mxArray * * select,
                                          mxArray * * nFreqBins,
                                          mxArray * * f,
                                          mxArray * * t,
                                          int nargout_,
                                          mxArray * P) {
    mxArray * x = mclGetUninitializedArray();
    mxArray * nargs = mclGetUninitializedArray();
    mclValidateInputs("General/private/mtparam", 1, &P);
    /*
     * 
     * nargs = length(P);
     */
    mlfAssign(&nargs, mlfLength(P));
    /*
     * 
     * x = P{1};
     */
    mlfAssign(&x, mlfIndexRef(P, "{?}", mlfScalar(1.0)));
    /*
     * if (nargs<2 | isempty(P{2})) nFFT = 1024; else nFFT = P{2}; end;
     */
    {
        mxArray * a_ = mclInitialize(mlfLt(nargs, mlfScalar(2.0)));
        if (mlfTobool(a_)
            || mlfTobool(
                 mlfOr(
                   a_,
                   mlfFeval(
                     mclValueVarargout(),
                     mlxIsempty,
                     mlfIndexRef(P, "{?}", mlfScalar(2.0)),
                     NULL)))) {
            mxDestroyArray(a_);
            mlfAssign(nFFT, mlfScalar(1024.0));
        } else {
            mxDestroyArray(a_);
            mlfAssign(nFFT, mlfIndexRef(P, "{?}", mlfScalar(2.0)));
        }
    }
    /*
     * if (nargs<3 | isempty(P{3})) Fs = 2; else Fs = P{3}; end;
     */
    {
        mxArray * a_ = mclInitialize(mlfLt(nargs, mlfScalar(3.0)));
        if (mlfTobool(a_)
            || mlfTobool(
                 mlfOr(
                   a_,
                   mlfFeval(
                     mclValueVarargout(),
                     mlxIsempty,
                     mlfIndexRef(P, "{?}", mlfScalar(3.0)),
                     NULL)))) {
            mxDestroyArray(a_);
            mlfAssign(Fs, mlfScalar(2.0));
        } else {
            mxDestroyArray(a_);
            mlfAssign(Fs, mlfIndexRef(P, "{?}", mlfScalar(3.0)));
        }
    }
    /*
     * if (nargs<4 | isempty(P{4})) WinLength = nFFT; else WinLength = P{4}; end;
     */
    {
        mxArray * a_ = mclInitialize(mlfLt(nargs, mlfScalar(4.0)));
        if (mlfTobool(a_)
            || mlfTobool(
                 mlfOr(
                   a_,
                   mlfFeval(
                     mclValueVarargout(),
                     mlxIsempty,
                     mlfIndexRef(P, "{?}", mlfScalar(4.0)),
                     NULL)))) {
            mxDestroyArray(a_);
            mlfAssign(WinLength, *nFFT);
        } else {
            mxDestroyArray(a_);
            mlfAssign(WinLength, mlfIndexRef(P, "{?}", mlfScalar(4.0)));
        }
    }
    /*
     * if (nargs<5 | isempty(P{5})) nOverlap = WinLength/2; else nOverlap = P{5}; end;
     */
    {
        mxArray * a_ = mclInitialize(mlfLt(nargs, mlfScalar(5.0)));
        if (mlfTobool(a_)
            || mlfTobool(
                 mlfOr(
                   a_,
                   mlfFeval(
                     mclValueVarargout(),
                     mlxIsempty,
                     mlfIndexRef(P, "{?}", mlfScalar(5.0)),
                     NULL)))) {
            mxDestroyArray(a_);
            mlfAssign(nOverlap, mlfMrdivide(*WinLength, mlfScalar(2.0)));
        } else {
            mxDestroyArray(a_);
            mlfAssign(nOverlap, mlfIndexRef(P, "{?}", mlfScalar(5.0)));
        }
    }
    /*
     * if (nargs<6 | isempty(P{6})) NW = 3; else NW = P{6}; end;
     */
    {
        mxArray * a_ = mclInitialize(mlfLt(nargs, mlfScalar(6.0)));
        if (mlfTobool(a_)
            || mlfTobool(
                 mlfOr(
                   a_,
                   mlfFeval(
                     mclValueVarargout(),
                     mlxIsempty,
                     mlfIndexRef(P, "{?}", mlfScalar(6.0)),
                     NULL)))) {
            mxDestroyArray(a_);
            mlfAssign(NW, mlfScalar(3.0));
        } else {
            mxDestroyArray(a_);
            mlfAssign(NW, mlfIndexRef(P, "{?}", mlfScalar(6.0)));
        }
    }
    /*
     * if (nargs<7 | isempty(P{7})) Detrend = ''; else Detrend = P{7}; end;
     */
    {
        mxArray * a_ = mclInitialize(mlfLt(nargs, mlfScalar(7.0)));
        if (mlfTobool(a_)
            || mlfTobool(
                 mlfOr(
                   a_,
                   mlfFeval(
                     mclValueVarargout(),
                     mlxIsempty,
                     mlfIndexRef(P, "{?}", mlfScalar(7.0)),
                     NULL)))) {
            mxDestroyArray(a_);
            mlfAssign(Detrend, mxCreateString(""));
        } else {
            mxDestroyArray(a_);
            mlfAssign(Detrend, mlfIndexRef(P, "{?}", mlfScalar(7.0)));
        }
    }
    /*
     * if (nargs<8 | isempty(P{8})) nTapers = 2*NW -1; else nTapers = P{8}; end;
     */
    {
        mxArray * a_ = mclInitialize(mlfLt(nargs, mlfScalar(8.0)));
        if (mlfTobool(a_)
            || mlfTobool(
                 mlfOr(
                   a_,
                   mlfFeval(
                     mclValueVarargout(),
                     mlxIsempty,
                     mlfIndexRef(P, "{?}", mlfScalar(8.0)),
                     NULL)))) {
            mxDestroyArray(a_);
            mlfAssign(
              nTapers,
              mlfMinus(mlfMtimes(mlfScalar(2.0), *NW), mlfScalar(1.0)));
        } else {
            mxDestroyArray(a_);
            mlfAssign(nTapers, mlfIndexRef(P, "{?}", mlfScalar(8.0)));
        }
    }
    /*
     * 
     * % Now do some compuatations that are common to all spectrogram functions
     * 
     * winstep = WinLength - nOverlap;
     */
    mlfAssign(winstep, mlfMinus(*WinLength, *nOverlap));
    /*
     * 
     * 
     * nChannels = size(x, 2);
     */
    mlfAssign(nChannels, mlfSize(mclValueVarargout(), x, mlfScalar(2.0)));
    /*
     * nSamples = size(x,1);
     */
    mlfAssign(nSamples, mlfSize(mclValueVarargout(), x, mlfScalar(1.0)));
    /*
     * 
     * % check for column vector input
     * if nSamples == 1 
     */
    if (mlfTobool(mlfEq(*nSamples, mlfScalar(1.0)))) {
        /*
         * x = x';
         */
        mlfAssign(&x, mlfCtranspose(x));
        /*
         * nSamples = size(x,1);
         */
        mlfAssign(nSamples, mlfSize(mclValueVarargout(), x, mlfScalar(1.0)));
        /*
         * nChannels = 1;
         */
        mlfAssign(nChannels, mlfScalar(1.0));
    /*
     * end;
     */
    }
    /*
     * 
     * % calculate number of FFTChunks per channel
     * nFFTChunks = round(((nSamples-WinLength)/winstep));
     */
    mlfAssign(
      nFFTChunks,
      mlfRound(mlfMrdivide(mlfMinus(*nSamples, *WinLength), *winstep)));
    /*
     * % turn this into time, using the sample frequency
     * t = winstep*(0:(nFFTChunks-1))'/Fs;
     */
    mlfAssign(
      t,
      mlfMrdivide(
        mlfMtimes(
          *winstep,
          mlfCtranspose(
            mlfColon(
              mlfScalar(0.0), mlfMinus(*nFFTChunks, mlfScalar(1.0)), NULL))),
        *Fs));
    /*
     * 
     * % set up f and t arrays
     * if ~any(any(imag(x)))    % x purely real
     */
    if (mlfTobool(mlfNot(mlfAny(mlfAny(mlfImag(x), NULL), NULL)))) {
        /*
         * if rem(nFFT,2),    % nfft odd
         */
        if (mlfTobool(mlfRem(*nFFT, mlfScalar(2.0)))) {
            /*
             * select = [1:(nFFT+1)/2];
             */
            mlfAssign(
              select,
              mlfHorzcat(
                mlfColon(
                  mlfScalar(1.0),
                  mlfMrdivide(mlfPlus(*nFFT, mlfScalar(1.0)), mlfScalar(2.0)),
                  NULL),
                NULL));
        /*
         * else
         */
        } else {
            /*
             * select = [1:nFFT/2+1];
             */
            mlfAssign(
              select,
              mlfHorzcat(
                mlfColon(
                  mlfScalar(1.0),
                  mlfPlus(mlfMrdivide(*nFFT, mlfScalar(2.0)), mlfScalar(1.0)),
                  NULL),
                NULL));
        /*
         * end
         */
        }
        /*
         * nFreqBins = length(select);
         */
        mlfAssign(nFreqBins, mlfLength(*select));
    /*
     * else
     */
    } else {
        /*
         * select = 1:nFFT;
         */
        mlfAssign(select, mlfColon(mlfScalar(1.0), *nFFT, NULL));
    /*
     * end
     */
    }
    /*
     * f = (select - 1)'*Fs/nFFT;
     */
    mlfAssign(
      f,
      mlfMrdivide(
        mlfMtimes(mlfCtranspose(mlfMinus(*select, mlfScalar(1.0))), *Fs),
        *nFFT));
    mclValidateOutputs(
      "General/private/mtparam",
      16,
      nargout_,
      &x,
      nFFT,
      Fs,
      WinLength,
      nOverlap,
      NW,
      Detrend,
      nTapers,
      nChannels,
      nSamples,
      nFFTChunks,
      winstep,
      select,
      nFreqBins,
      f,
      t);
    mxDestroyArray(nargs);
    return x;
}

/*
 * The function "mlfGeneral_private_mtparam" contains the normal interface for
 * the "General/private/mtparam" M-function from file
 * "/u5/b/ken/matlab/General/private/mtparam.m" (lines 1-47). This function
 * processes any input arguments and passes them to the implementation version
 * of the function, appearing above.
 */
mxArray * mlfGeneral_private_mtparam(mxArray * * nFFT,
                                     mxArray * * Fs,
                                     mxArray * * WinLength,
                                     mxArray * * nOverlap,
                                     mxArray * * NW,
                                     mxArray * * Detrend,
                                     mxArray * * nTapers,
                                     mxArray * * nChannels,
                                     mxArray * * nSamples,
                                     mxArray * * nFFTChunks,
                                     mxArray * * winstep,
                                     mxArray * * select,
                                     mxArray * * nFreqBins,
                                     mxArray * * f,
                                     mxArray * * t,
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
    mxArray * nChannels__ = mclGetUninitializedArray();
    mxArray * nSamples__ = mclGetUninitializedArray();
    mxArray * nFFTChunks__ = mclGetUninitializedArray();
    mxArray * winstep__ = mclGetUninitializedArray();
    mxArray * select__ = mclGetUninitializedArray();
    mxArray * nFreqBins__ = mclGetUninitializedArray();
    mxArray * f__ = mclGetUninitializedArray();
    mxArray * t__ = mclGetUninitializedArray();
    mlfEnterNewContext(
      15,
      1,
      nFFT,
      Fs,
      WinLength,
      nOverlap,
      NW,
      Detrend,
      nTapers,
      nChannels,
      nSamples,
      nFFTChunks,
      winstep,
      select,
      nFreqBins,
      f,
      t,
      P);
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
    if (nChannels != NULL) {
        ++nargout;
    }
    if (nSamples != NULL) {
        ++nargout;
    }
    if (nFFTChunks != NULL) {
        ++nargout;
    }
    if (winstep != NULL) {
        ++nargout;
    }
    if (select != NULL) {
        ++nargout;
    }
    if (nFreqBins != NULL) {
        ++nargout;
    }
    if (f != NULL) {
        ++nargout;
    }
    if (t != NULL) {
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
          &nChannels__,
          &nSamples__,
          &nFFTChunks__,
          &winstep__,
          &select__,
          &nFreqBins__,
          &f__,
          &t__,
          nargout,
          P);
    mlfRestorePreviousContext(
      15,
      1,
      nFFT,
      Fs,
      WinLength,
      nOverlap,
      NW,
      Detrend,
      nTapers,
      nChannels,
      nSamples,
      nFFTChunks,
      winstep,
      select,
      nFreqBins,
      f,
      t,
      P);
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
    if (nChannels != NULL) {
        mclCopyOutputArg(nChannels, nChannels__);
    } else {
        mxDestroyArray(nChannels__);
    }
    if (nSamples != NULL) {
        mclCopyOutputArg(nSamples, nSamples__);
    } else {
        mxDestroyArray(nSamples__);
    }
    if (nFFTChunks != NULL) {
        mclCopyOutputArg(nFFTChunks, nFFTChunks__);
    } else {
        mxDestroyArray(nFFTChunks__);
    }
    if (winstep != NULL) {
        mclCopyOutputArg(winstep, winstep__);
    } else {
        mxDestroyArray(winstep__);
    }
    if (select != NULL) {
        mclCopyOutputArg(select, select__);
    } else {
        mxDestroyArray(select__);
    }
    if (nFreqBins != NULL) {
        mclCopyOutputArg(nFreqBins, nFreqBins__);
    } else {
        mxDestroyArray(nFreqBins__);
    }
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
    return mlfReturnValue(x);
}

/*
 * The function "mlxGeneral_private_mtparam" contains the feval interface for
 * the "General/private/mtparam" M-function from file
 * "/u5/b/ken/matlab/General/private/mtparam.m" (lines 1-47). The feval
 * function calls the implementation version of General/private/mtparam through
 * this function. This function processes any input arguments and passes them
 * to the implementation version of the function, appearing above.
 */
void mlxGeneral_private_mtparam(int nlhs,
                                mxArray * plhs[],
                                int nrhs,
                                mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[16];
    int i;
    if (nlhs > 16) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: General/private/mtparam Line: 2 Col"
            "umn: 0 The function \"General/private/mtparam\" was calle"
            "d with more than the declared number of outputs (16)"));
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: General/private/mtparam Line: 2 Co"
            "lumn: 0 The function \"General/private/mtparam\" was cal"
            "led with more than the declared number of inputs (1)"));
    }
    for (i = 0; i < 16; ++i) {
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
          &mplhs[8],
          &mplhs[9],
          &mplhs[10],
          &mplhs[11],
          &mplhs[12],
          &mplhs[13],
          &mplhs[14],
          &mplhs[15],
          nlhs,
          mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 16 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 16; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}
