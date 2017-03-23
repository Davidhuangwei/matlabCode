/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:20 2000
 * Arguments: "-mw" "mtcsd" 
 */
#include "mtcsd.h"
#include "complex.h"
#include "detrend.h"
#include "dpss.h"
#include "grid.h"
#include "General_private_mtparam.h"
#include "squeeze.h"
#include "subplot.h"
#include "xlabel.h"
#include "ylabel.h"

static double __Array0_r[3] = { 1.0, 3.0, 2.0 };

/*
 * The function "Mmtcsd" is the implementation version of the "mtcsd"
 * M-function from file "/u5/b/ken/matlab/General/mtcsd.m" (lines 1-129). It
 * contains the actual compiled code for that M-function. It is a static
 * function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function [yo, fo]=mtcsd(varargin);
 */
static mxArray * Mmtcsd(mxArray * * fo, int nargout_, mxArray * varargin) {
    mxArray * yo = mclGetUninitializedArray();
    mxArray * Ch1 = mclGetUninitializedArray();
    mxArray * Ch2 = mclGetUninitializedArray();
    mxArray * Detrend = mclGetUninitializedArray();
    mxArray * Fs = mclGetUninitializedArray();
    mxArray * NW = mclGetUninitializedArray();
    mxArray * Periodogram = mclGetUninitializedArray();
    mxArray * Segment = mclGetUninitializedArray();
    mxArray * SegmentsArray = mclGetUninitializedArray();
    mxArray * TaperedSegments = mclGetUninitializedArray();
    mxArray * TaperingArray = mclGetUninitializedArray();
    mxArray * Tapers = mclGetUninitializedArray();
    mxArray * Temp1 = mclGetUninitializedArray();
    mxArray * Temp2 = mclGetUninitializedArray();
    mxArray * Temp3 = mclGetUninitializedArray();
    mxArray * V = mclGetUninitializedArray();
    mxArray * WinLength = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * eJ = mclGetUninitializedArray();
    mxArray * f = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mclForLoopIterator iterator_1;
    mclForLoopIterator iterator_2;
    mxArray * j = mclGetUninitializedArray();
    mxArray * nChannels = mclGetUninitializedArray();
    mxArray * nFFT = mclGetUninitializedArray();
    mxArray * nFFTChunks = mclGetUninitializedArray();
    mxArray * nOverlap = mclGetUninitializedArray();
    mxArray * nSamples = mclGetUninitializedArray();
    mxArray * nTapers = mclGetUninitializedArray();
    mxArray * nargout = mclInitialize(mlfScalar(nargout_));
    mxArray * select = mclGetUninitializedArray();
    mxArray * t = mclGetUninitializedArray();
    mxArray * winstep = mclGetUninitializedArray();
    mxArray * x = mclGetUninitializedArray();
    mxArray * y = mclGetUninitializedArray();
    mclCopyArray(&varargin);
    /*
     * %function [yo, fo]=mtcsg(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers);
     * % Multitaper Cross-Spectral Density
     * % function A=mtcsd(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers)
     * % x : input time series
     * % nFFT = number of points of FFT to calculate (default 1024)
     * % Fs = sampling frequency (default 2)
     * % WinLength = length of moving window (default is nFFT)
     * % nOverlap = overlap between successive windows (default is WinLength/2)
     * % NW = time bandwidth parameter (e.g. 3 or 4), default 3
     * % nTapers = number of data tapers kept, default 2*NW -1
     * %
     * % output yo is yo(f)
     * %
     * % If x is a multicolumn matrix, each column will be treated as a time
     * % series and you'll get a matrix of cross-spectra out yo(f, Ch1, Ch2)
     * % NB they are cross-spectra not coherences. If you want coherences use
     * % mtcohere
     * 
     * % Original code by Partha Mitra - modified by Ken Harris
     * % Also containing elements from specgram.m
     * 
     * % default arguments and that
     * [x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers] = mtparam(varargin);
     */
    mlfAssign(
      &x,
      mlfGeneral_private_mtparam(
        &nFFT,
        &Fs,
        &WinLength,
        &nOverlap,
        &NW,
        &Detrend,
        &nTapers,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        varargin));
    /*
     * winstep = WinLength - nOverlap;
     */
    mlfAssign(&winstep, mlfMinus(WinLength, nOverlap));
    /*
     * 
     * clear varargin; % since that was taking up most of the memory!
     */
    mlfClear(&varargin, NULL);
    /*
     * 
     * nChannels = size(x, 2);
     */
    mlfAssign(&nChannels, mlfSize(mclValueVarargout(), x, mlfScalar(2.0)));
    /*
     * nSamples = size(x,1);
     */
    mlfAssign(&nSamples, mlfSize(mclValueVarargout(), x, mlfScalar(1.0)));
    /*
     * 
     * % check for column vector input
     * if nSamples == 1 
     */
    if (mlfTobool(mlfEq(nSamples, mlfScalar(1.0)))) {
        /*
         * x = x';
         */
        mlfAssign(&x, mlfCtranspose(x));
        /*
         * nSamples = size(x,1);
         */
        mlfAssign(&nSamples, mlfSize(mclValueVarargout(), x, mlfScalar(1.0)));
        /*
         * nChannels = 1;
         */
        mlfAssign(&nChannels, mlfScalar(1.0));
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
      &nFFTChunks,
      mlfRound(mlfMrdivide(mlfMinus(nSamples, WinLength), winstep)));
    /*
     * % turn this into time, using the sample frequency
     * t = winstep*(0:(nFFTChunks-1))'/Fs;
     */
    mlfAssign(
      &t,
      mlfMrdivide(
        mlfMtimes(
          winstep,
          mlfCtranspose(
            mlfColon(
              mlfScalar(0.0), mlfMinus(nFFTChunks, mlfScalar(1.0)), NULL))),
        Fs));
    /*
     * 
     * % allocate memory now to avoid nasty surprises later
     * y=complex(zeros(nFFT, nChannels, nChannels)); % output array
     */
    mlfAssign(&y, mlfComplex(mlfZeros(nFFT, nChannels, nChannels, NULL), NULL));
    /*
     * Periodogram = complex(zeros(nFFT, nTapers, nChannels)); % intermediate FFTs
     */
    mlfAssign(
      &Periodogram, mlfComplex(mlfZeros(nFFT, nTapers, nChannels, NULL), NULL));
    /*
     * Temp1 = complex(zeros(nFFT, nTapers));
     */
    mlfAssign(&Temp1, mlfComplex(mlfZeros(nFFT, nTapers, NULL), NULL));
    /*
     * Temp2 = complex(zeros(nFFT, nTapers));
     */
    mlfAssign(&Temp2, mlfComplex(mlfZeros(nFFT, nTapers, NULL), NULL));
    /*
     * Temp3 = complex(zeros(nFFT, nTapers));
     */
    mlfAssign(&Temp3, mlfComplex(mlfZeros(nFFT, nTapers, NULL), NULL));
    /*
     * eJ = complex(zeros(nFFT,1));
     */
    mlfAssign(&eJ, mlfComplex(mlfZeros(nFFT, mlfScalar(1.0), NULL), NULL));
    /*
     * 
     * % calculate Slepian sequences.  Tapers is a matrix of size [WinLength, nTapers]
     * [Tapers V]=dpss(WinLength,NW,nTapers, 'calc');
     */
    mlfAssign(
      &Tapers,
      mlfDpss(&V, WinLength, NW, nTapers, mxCreateString("calc"), NULL));
    /*
     * 
     * % New super duper vectorized alogirthm
     * % compute tapered periodogram with FFT 
     * % This involves lots of wrangling with multidimensional arrays.
     * 
     * TaperingArray = repmat(Tapers, [1 1 nChannels]);
     */
    mlfAssign(
      &TaperingArray,
      mlfRepmat(
        Tapers,
        mlfHorzcat(mlfScalar(1.0), mlfScalar(1.0), nChannels, NULL),
        NULL));
    /*
     * for j=1:nFFTChunks
     */
    for (mclForStart(&iterator_0, mlfScalar(1.0), nFFTChunks, NULL);
         mclForNext(&iterator_0, &j);
         ) {
        /*
         * Segment = x((j-1)*winstep+[1:WinLength], :);
         */
        mlfAssign(
          &Segment,
          mlfIndexRef(
            x,
            "(?,?)",
            mlfPlus(
              mlfMtimes(mlfMinus(j, mlfScalar(1.0)), winstep),
              mlfHorzcat(mlfColon(mlfScalar(1.0), WinLength, NULL), NULL)),
            mlfCreateColonIndex()));
        /*
         * if (~isempty(Detrend))
         */
        if (mlfTobool(mlfNot(mlfIsempty(Detrend)))) {
            /*
             * Segment = detrend(Segment, Detrend);
             */
            mlfAssign(&Segment, mlfDetrend(Segment, Detrend, NULL));
        /*
         * end;
         */
        }
        /*
         * SegmentsArray = permute(repmat(Segment, [1 1 nTapers]), [1 3 2]);
         */
        mlfAssign(
          &SegmentsArray,
          mlfPermute(
            mlfRepmat(
              Segment,
              mlfHorzcat(mlfScalar(1.0), mlfScalar(1.0), nTapers, NULL),
              NULL),
            mlfDoubleMatrix(1, 3, __Array0_r, NULL)));
        /*
         * TaperedSegments = TaperingArray .* SegmentsArray;
         */
        mlfAssign(&TaperedSegments, mlfTimes(TaperingArray, SegmentsArray));
        /*
         * 
         * Periodogram(:,:,:) = fft(TaperedSegments,nFFT)/nFFTChunks;
         */
        mlfIndexAssign(
          &Periodogram,
          "(?,?,?)",
          mlfCreateColonIndex(),
          mlfCreateColonIndex(),
          mlfCreateColonIndex(),
          mlfMrdivide(mlfFft(TaperedSegments, nFFT, NULL), nFFTChunks));
        /*
         * 
         * 
         * % Now make cross-products of them to fill cross-spectrum matrix
         * for Ch1 = 1:nChannels
         */
        for (mclForStart(&iterator_1, mlfScalar(1.0), nChannels, NULL);
             mclForNext(&iterator_1, &Ch1);
             ) {
            /*
             * for Ch2 = Ch1:nChannels % don't compute cross-spectra twice
             */
            for (mclForStart(&iterator_2, Ch1, nChannels, NULL);
                 mclForNext(&iterator_2, &Ch2);
                 ) {
                /*
                 * Temp1 = squeeze(Periodogram(:,:,Ch1));
                 */
                mlfAssign(
                  &Temp1,
                  mlfSqueeze(
                    mlfIndexRef(
                      Periodogram,
                      "(?,?,?)",
                      mlfCreateColonIndex(),
                      mlfCreateColonIndex(),
                      Ch1)));
                /*
                 * Temp2 = squeeze(Periodogram(:,:,Ch2));	
                 */
                mlfAssign(
                  &Temp2,
                  mlfSqueeze(
                    mlfIndexRef(
                      Periodogram,
                      "(?,?,?)",
                      mlfCreateColonIndex(),
                      mlfCreateColonIndex(),
                      Ch2)));
                /*
                 * Temp2 = conj(Temp2);
                 */
                mlfAssign(&Temp2, mlfConj(Temp2));
                /*
                 * Temp3 = Temp1 .* Temp2;
                 */
                mlfAssign(&Temp3, mlfTimes(Temp1, Temp2));
                /*
                 * eJ=sum(Temp3, 2);
                 */
                mlfAssign(&eJ, mlfSum(Temp3, mlfScalar(2.0)));
                /*
                 * y(:,Ch1, Ch2)= y(:,Ch1,Ch2) + eJ/(nTapers*nFFTChunks);
                 */
                mlfIndexAssign(
                  &y,
                  "(?,?,?)",
                  mlfCreateColonIndex(),
                  Ch1,
                  Ch2,
                  mlfPlus(
                    mlfIndexRef(y, "(?,?,?)", mlfCreateColonIndex(), Ch1, Ch2),
                    mlfMrdivide(eJ, mlfMtimes(nTapers, nFFTChunks))));
            /*
             * 
             * end
             */
            }
        /*
         * end
         */
        }
    /*
     * end
     */
    }
    /*
     * 
     * % now fill other half of matrix with complex conjugate
     * for Ch1 = 1:nChannels
     */
    for (mclForStart(&iterator_0, mlfScalar(1.0), nChannels, NULL);
         mclForNext(&iterator_0, &Ch1);
         ) {
        /*
         * for Ch2 = (Ch1+1):nChannels % don't compute cross-spectra twice
         */
        for (mclForStart(
               &iterator_1, mlfPlus(Ch1, mlfScalar(1.0)), nChannels, NULL);
             mclForNext(&iterator_1, &Ch2);
             ) {
            /*
             * y(:, Ch2, Ch1) = conj(y(:,Ch1,Ch2));
             */
            mlfIndexAssign(
              &y,
              "(?,?,?)",
              mlfCreateColonIndex(),
              Ch2,
              Ch1,
              mlfConj(
                mlfIndexRef(y, "(?,?,?)", mlfCreateColonIndex(), Ch1, Ch2)));
        /*
         * end
         */
        }
    /*
     * end
     */
    }
    /*
     * 
     * % set up f array
     * if ~any(any(imag(x)))    % x purely real
     */
    if (mlfTobool(mlfNot(mlfAny(mlfAny(mlfImag(x), NULL), NULL)))) {
        /*
         * if rem(nFFT,2),    % nfft odd
         */
        if (mlfTobool(mlfRem(nFFT, mlfScalar(2.0)))) {
            /*
             * select = [1:(nFFT+1)/2];
             */
            mlfAssign(
              &select,
              mlfHorzcat(
                mlfColon(
                  mlfScalar(1.0),
                  mlfMrdivide(mlfPlus(nFFT, mlfScalar(1.0)), mlfScalar(2.0)),
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
              &select,
              mlfHorzcat(
                mlfColon(
                  mlfScalar(1.0),
                  mlfPlus(mlfMrdivide(nFFT, mlfScalar(2.0)), mlfScalar(1.0)),
                  NULL),
                NULL));
        /*
         * end
         */
        }
        /*
         * y = y(select,:,:,:);
         */
        mlfAssign(
          &y,
          mlfIndexRef(
            y,
            "(?,?,?,?)",
            select,
            mlfCreateColonIndex(),
            mlfCreateColonIndex(),
            mlfCreateColonIndex()));
    /*
     * else
     */
    } else {
        /*
         * select = 1:nFFT;
         */
        mlfAssign(&select, mlfColon(mlfScalar(1.0), nFFT, NULL));
    /*
     * end
     */
    }
    /*
     * 
     * f = (select - 1)'*Fs/nFFT;
     */
    mlfAssign(
      &f,
      mlfMrdivide(
        mlfMtimes(mlfCtranspose(mlfMinus(select, mlfScalar(1.0))), Fs), nFFT));
    /*
     * 
     * % we've now done the computation.  the rest of this code is stolen from
     * % specgram and just deals with the output stage
     * 
     * if nargout == 0
     */
    if (mlfTobool(mlfEq(nargout, mlfScalar(0.0)))) {
        /*
         * % take abs, and plot results
         * newplot;
         */
        mclAssignAns(&ans, mlfNNewplot(0, NULL));
        /*
         * for Ch1=1:nChannels, for Ch2 = 1:nChannels
         */
        for (mclForStart(&iterator_0, mlfScalar(1.0), nChannels, NULL);
             mclForNext(&iterator_0, &Ch1);
             ) {
            for (mclForStart(&iterator_1, mlfScalar(1.0), nChannels, NULL);
                 mclForNext(&iterator_1, &Ch2);
                 ) {
                /*
                 * subplot(nChannels, nChannels, Ch1 + (Ch2-1)*nChannels);
                 */
                mclAssignAns(
                  &ans,
                  mlfNSubplot(
                    0,
                    nChannels,
                    nChannels,
                    mlfPlus(
                      Ch1,
                      mlfMtimes(mlfMinus(Ch2, mlfScalar(1.0)), nChannels))));
                /*
                 * plot(f,20*log10(abs(y(:,Ch1,Ch2))+eps));
                 */
                mclAssignAns(
                  &ans,
                  mlfNPlot(
                    0,
                    f,
                    mlfMtimes(
                      mlfScalar(20.0),
                      mlfLog10(
                        mlfPlus(
                          mlfAbs(
                            mlfIndexRef(
                              y, "(?,?,?)", mlfCreateColonIndex(), Ch1, Ch2)),
                          mlfEps()))),
                    NULL));
                /*
                 * grid on;
                 */
                mlfGrid(mxCreateString("on"));
                /*
                 * if(Ch1==Ch2) 
                 */
                if (mlfTobool(mlfEq(Ch1, Ch2))) {
                    /*
                     * ylabel('psd (dB)'); 
                     */
                    mclAssignAns(
                      &ans, mlfNYlabel(0, mxCreateString("psd (dB)"), NULL));
                /*
                 * else 
                 */
                } else {
                    /*
                     * ylabel('csd (dB)'); 
                     */
                    mclAssignAns(
                      &ans, mlfNYlabel(0, mxCreateString("csd (dB)"), NULL));
                /*
                 * end;
                 */
                }
                /*
                 * xlabel('Frequency');
                 */
                mclAssignAns(
                  &ans, mlfNXlabel(0, mxCreateString("Frequency"), NULL));
            /*
             * end; end;
             */
            }
        }
    /*
     * elseif nargout == 1
     */
    } else if (mlfTobool(mlfEq(nargout, mlfScalar(1.0)))) {
        /*
         * yo = y;
         */
        mlfAssign(&yo, y);
    /*
     * elseif nargout == 2
     */
    } else if (mlfTobool(mlfEq(nargout, mlfScalar(2.0)))) {
        /*
         * yo = y;
         */
        mlfAssign(&yo, y);
        /*
         * fo = f;
         */
        mlfAssign(fo, f);
    /*
     * end
     */
    }
    mclValidateOutputs("mtcsd", 2, nargout_, &yo, fo);
    mxDestroyArray(Ch1);
    mxDestroyArray(Ch2);
    mxDestroyArray(Detrend);
    mxDestroyArray(Fs);
    mxDestroyArray(NW);
    mxDestroyArray(Periodogram);
    mxDestroyArray(Segment);
    mxDestroyArray(SegmentsArray);
    mxDestroyArray(TaperedSegments);
    mxDestroyArray(TaperingArray);
    mxDestroyArray(Tapers);
    mxDestroyArray(Temp1);
    mxDestroyArray(Temp2);
    mxDestroyArray(Temp3);
    mxDestroyArray(V);
    mxDestroyArray(WinLength);
    mxDestroyArray(ans);
    mxDestroyArray(eJ);
    mxDestroyArray(f);
    mxDestroyArray(j);
    mxDestroyArray(nChannels);
    mxDestroyArray(nFFT);
    mxDestroyArray(nFFTChunks);
    mxDestroyArray(nOverlap);
    mxDestroyArray(nSamples);
    mxDestroyArray(nTapers);
    mxDestroyArray(nargout);
    mxDestroyArray(select);
    mxDestroyArray(t);
    mxDestroyArray(varargin);
    mxDestroyArray(winstep);
    mxDestroyArray(x);
    mxDestroyArray(y);
    return yo;
}

/*
 * The function "mlfNMtcsd" contains the nargout interface for the "mtcsd"
 * M-function from file "/u5/b/ken/matlab/General/mtcsd.m" (lines 1-129). This
 * interface is only produced if the M-function uses the special variable
 * "nargout". The nargout interface allows the number of requested outputs to
 * be specified via the nargout argument, as opposed to the normal interface
 * which dynamically calculates the number of outputs based on the number of
 * non-NULL inputs it receives. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
mxArray * mlfNMtcsd(int nargout, mxArray * * fo, ...) {
    mxArray * varargin = mclUnassigned();
    mxArray * yo = mclGetUninitializedArray();
    mxArray * fo__ = mclGetUninitializedArray();
    mlfVarargin(&varargin, fo, 0);
    mlfEnterNewContext(1, -1, fo, varargin);
    yo = Mmtcsd(&fo__, nargout, varargin);
    mlfRestorePreviousContext(1, 0, fo);
    mxDestroyArray(varargin);
    if (fo != NULL) {
        mclCopyOutputArg(fo, fo__);
    } else {
        mxDestroyArray(fo__);
    }
    return mlfReturnValue(yo);
}

/*
 * The function "mlfMtcsd" contains the normal interface for the "mtcsd"
 * M-function from file "/u5/b/ken/matlab/General/mtcsd.m" (lines 1-129). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
mxArray * mlfMtcsd(mxArray * * fo, ...) {
    mxArray * varargin = mclUnassigned();
    int nargout = 1;
    mxArray * yo = mclGetUninitializedArray();
    mxArray * fo__ = mclGetUninitializedArray();
    mlfVarargin(&varargin, fo, 0);
    mlfEnterNewContext(1, -1, fo, varargin);
    if (fo != NULL) {
        ++nargout;
    }
    yo = Mmtcsd(&fo__, nargout, varargin);
    mlfRestorePreviousContext(1, 0, fo);
    mxDestroyArray(varargin);
    if (fo != NULL) {
        mclCopyOutputArg(fo, fo__);
    } else {
        mxDestroyArray(fo__);
    }
    return mlfReturnValue(yo);
}

/*
 * The function "mlfVMtcsd" contains the void interface for the "mtcsd"
 * M-function from file "/u5/b/ken/matlab/General/mtcsd.m" (lines 1-129). The
 * void interface is only produced if the M-function uses the special variable
 * "nargout", and has at least one output. The void interface function
 * specifies zero output arguments to the implementation version of the
 * function, and in the event that the implementation version still returns an
 * output (which, in MATLAB, would be assigned to the "ans" variable), it
 * deallocates the output. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlfVMtcsd(mxArray * synthetic_varargin_argument, ...) {
    mxArray * varargin = mclUnassigned();
    mxArray * yo = mclUnassigned();
    mxArray * fo = mclUnassigned();
    mlfVarargin(&varargin, synthetic_varargin_argument, 1);
    mlfEnterNewContext(0, -1, varargin);
    yo = Mmtcsd(&fo, 0, synthetic_varargin_argument);
    mlfRestorePreviousContext(0, 0);
    mxDestroyArray(varargin);
    mxDestroyArray(yo);
}

/*
 * The function "mlxMtcsd" contains the feval interface for the "mtcsd"
 * M-function from file "/u5/b/ken/matlab/General/mtcsd.m" (lines 1-129). The
 * feval function calls the implementation version of mtcsd through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxMtcsd(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[2];
    int i;
    if (nlhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: mtcsd Line: 1 Column: 0 The function \"mtcsd"
            "\" was called with more than the declared number of outputs (2)"));
    }
    for (i = 0; i < 2; ++i) {
        mplhs[i] = NULL;
    }
    mlfEnterNewContext(0, 0);
    mprhs[0] = NULL;
    mlfAssign(&mprhs[0], mclCreateVararginCell(nrhs, prhs));
    mplhs[0] = Mmtcsd(&mplhs[1], nlhs, mprhs[0]);
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
