/*
 * MATLAB Compiler: 2.2
 * Date: Wed Jun  9 16:06:04 2004
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-m" "-W" "main" "-L"
 * "C" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "Wavelet" 
 */
#include "WaveletSampling.h"
#include "DefaultArgs.h"
#include "libmatlbm.h"
#include "libmmfile.h"

static mxChar _array1_[148] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'W', 'a', 'v', 'e', 'l',
                                'e', 't', 'S', 'a', 'm', 'p', 'l', 'i', 'n',
                                'g', ' ', 'L', 'i', 'n', 'e', ':', ' ', '2',
                                ' ', 'C', 'o', 'l', 'u', 'm', 'n', ':', ' ',
                                '1', ' ', 'T', 'h', 'e', ' ', 'f', 'u', 'n',
                                'c', 't', 'i', 'o', 'n', ' ', '"', 'W', 'a',
                                'v', 'e', 'l', 'e', 't', 'S', 'a', 'm', 'p',
                                'l', 'i', 'n', 'g', '"', ' ', 'w', 'a', 's',
                                ' ', 'c', 'a', 'l', 'l', 'e', 'd', ' ', 'w',
                                'i', 't', 'h', ' ', 'm', 'o', 'r', 'e', ' ',
                                't', 'h', 'a', 'n', ' ', 't', 'h', 'e', ' ',
                                'd', 'e', 'c', 'l', 'a', 'r', 'e', 'd', ' ',
                                'n', 'u', 'm', 'b', 'e', 'r', ' ', 'o', 'f',
                                ' ', 'o', 'u', 't', 'p', 'u', 't', 's', ' ',
                                '(', '3', ')', '.' };
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

void InitializeModule_WaveletSampling(void) {
    _mxarray0_ = mclInitializeString(148, _array1_);
    _mxarray4_ = mclInitializeDouble(1250.0);
    _array3_[0] = _mxarray4_;
    _mxarray5_ = mclInitializeDoubleVector(1, 2, _array6_);
    _array3_[1] = _mxarray5_;
    _mxarray7_ = mclInitializeDouble(1.0);
    _array3_[2] = _mxarray7_;
    _mxarray8_ = mclInitializeDouble(6.0);
    _array3_[3] = _mxarray8_;
    _mxarray2_ = mclInitializeCellVector(1, 4, _array3_);
    _mxarray9_ = mclInitializeDouble(.03);
    _mxarray10_ = mclInitializeDouble(12.566370614359172);
    _mxarray11_ = mclInitializeDouble(2.0);
    _mxarray12_ = mclInitializeDouble(0.0);
    _mxarray13_ = mclInitializeDouble(100.0);
}

void TerminateModule_WaveletSampling(void) {
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

static mxArray * MWaveletSampling(mxArray * * s,
                                  mxArray * * p,
                                  int nargout_,
                                  mxArray * varargin);

_mexLocalFunctionTable _local_function_table_WaveletSampling
  = { 0, (mexFunctionTableEntry *)NULL };

/*
 * The function "mlfWaveletSampling" contains the normal interface for the
 * "WaveletSampling" M-function from file
 * "/u12/antsiro/matlab/draft/WaveletSampling.m" (lines 1-34). This function
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
 * "/u12/antsiro/matlab/draft/WaveletSampling.m" (lines 1-34). The feval
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
        mlfError(_mxarray0_);
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
 * The function "MWaveletSampling" is the implementation version of the
 * "WaveletSampling" M-function from file
 * "/u12/antsiro/matlab/draft/WaveletSampling.m" (lines 1-34). It contains the
 * actual compiled code for that M-function. It is a static function and must
 * only be called from one of the interface functions, appearing below.
 */
/*
 * %[f,s,p] = WaveletSampling(Fs,FreqRange,IsLogSc, w0)
 * function [f,s,p] = WaveletSampling(varargin)
 */
static mxArray * MWaveletSampling(mxArray * * s,
                                  mxArray * * p,
                                  int nargout_,
                                  mxArray * varargin) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(
          &_local_function_table_WaveletSampling);
    mxArray * f = mclGetUninitializedArray();
    mxArray * s0 = mclGetUninitializedArray();
    mxArray * J = mclGetUninitializedArray();
    mxArray * nFBins = mclGetUninitializedArray();
    mxArray * fourier_factor = mclGetUninitializedArray();
    mxArray * dt = mclGetUninitializedArray();
    mxArray * dj = mclGetUninitializedArray();
    mxArray * w0 = mclGetUninitializedArray();
    mxArray * IsLogSc = mclGetUninitializedArray();
    mxArray * FreqRange = mclGetUninitializedArray();
    mxArray * Fs = mclGetUninitializedArray();
    mclCopyArray(&varargin);
    /*
     * 
     * [Fs, FreqRange, IsLogSc, w0] = DefaultArgs(varargin, {1250,[1 200],1,6});
     */
    mlfNDefaultArgs(
      0,
      mlfVarargout(&Fs, &FreqRange, &IsLogSc, &w0, NULL),
      mclVa(varargin, "varargin"),
      _mxarray2_);
    /*
     * % fix optional arguments for now
     * %FreqRes =0.1; % for even sampling
     * dj = 0.03; % for logarythmic sampling
     */
    mlfAssign(&dj, _mxarray9_);
    /*
     * dt = 1./Fs;
     */
    mlfAssign(&dt, mclRdivide(_mxarray7_, mclVv(Fs, "Fs")));
    /*
     * fourier_factor = (4*pi)/(w0 + sqrt(2 + w0^2));
     */
    mlfAssign(
      &fourier_factor,
      mclMrdivide(
        _mxarray10_,
        mclPlus(
          mclVv(w0, "w0"),
          mclVe(
            mlfSqrt(
              mclPlus(
                _mxarray11_, mclMpower(mclVv(w0, "w0"), _mxarray11_)))))));
    /*
     * % select the freq. sampling
     * if length(FreqRange)==2 & IsLogSc ==0
     */
    {
        mxArray * a_
          = mclInitialize(
              mclBoolToArray(
                mclLengthInt(mclVv(FreqRange, "FreqRange")) == 2));
        if (mlfTobool(a_)
            && mlfTobool(
                 mclAnd(a_, mclEq(mclVv(IsLogSc, "IsLogSc"), _mxarray12_)))) {
            mxDestroyArray(a_);
            /*
             * %even sampling, not good statistically
             * nFBins = 100;
             */
            mlfAssign(&nFBins, _mxarray13_);
            /*
             * %dF=FreqRange(2)-FreqRange(1);
             * %nFBins = round(dF/FreqRes);
             * f = linspace(FreqRange(1),FreqRange(2),nFBins);
             */
            mlfAssign(
              &f,
              mlfLinspace(
                mclVe(mclIntArrayRef1(mclVsv(FreqRange, "FreqRange"), 1)),
                mclVe(mclIntArrayRef1(mclVsv(FreqRange, "FreqRange"), 2)),
                mclVv(nFBins, "nFBins")));
            /*
             * s = 1./(fourier_factor*f); 
             */
            mlfAssign(
              s,
              mclRdivide(
                _mxarray7_,
                mclMtimes(
                  mclVv(fourier_factor, "fourier_factor"), mclVv(f, "f"))));
        /*
         * elseif length(FreqRange)==2 & IsLogSc ==1
         */
        } else {
            mxDestroyArray(a_);
            {
                mxArray * a_0
                  = mclInitialize(
                      mclBoolToArray(
                        mclLengthInt(mclVv(FreqRange, "FreqRange")) == 2));
                if (mlfTobool(a_0)
                    && mlfTobool(
                         mclAnd(
                           a_0,
                           mclEq(mclVv(IsLogSc, "IsLogSc"), _mxarray7_)))) {
                    mxDestroyArray(a_0);
                    /*
                     * %keyboard
                     * %loghorythmic scaling
                     * J = round(log2(FreqRange(2)/FreqRange(1))/dj);
                     */
                    mlfAssign(
                      &J,
                      mlfRound(
                        mclMrdivide(
                          mclVe(
                            mlfLog2(
                              NULL,
                              mclMrdivide(
                                mclVe(
                                  mclIntArrayRef1(
                                    mclVsv(FreqRange, "FreqRange"), 2)),
                                mclVe(
                                  mclIntArrayRef1(
                                    mclVsv(FreqRange, "FreqRange"), 1))))),
                          mclVv(dj, "dj"))));
                    /*
                     * s0 = 1./(fourier_factor*FreqRange(2)); 
                     */
                    mlfAssign(
                      &s0,
                      mclRdivide(
                        _mxarray7_,
                        mclMtimes(
                          mclVv(fourier_factor, "fourier_factor"),
                          mclVe(
                            mclIntArrayRef1(
                              mclVsv(FreqRange, "FreqRange"), 2)))));
                    /*
                     * s = s0*2.^((0:J)*dj);   
                     */
                    mlfAssign(
                      s,
                      mclMtimes(
                        mclVv(s0, "s0"),
                        mlfPower(
                          _mxarray11_,
                          mclMtimes(
                            mlfColon(_mxarray12_, mclVv(J, "J"), NULL),
                            mclVv(dj, "dj")))));
                    /*
                     * f = 1./(fourier_factor*s); 
                     */
                    mlfAssign(
                      &f,
                      mclRdivide(
                        _mxarray7_,
                        mclMtimes(
                          mclVv(fourier_factor, "fourier_factor"),
                          mclVv(*s, "s"))));
                    /*
                     * f =flipud(f(:));%reverse the order in f
                     */
                    mlfAssign(
                      &f,
                      mlfFlipud(
                        mclVe(
                          mclArrayRef1(
                            mclVsv(f, "f"), mlfCreateColonIndex()))));
                    /*
                     * s =flipud(s(:));% and s accordingly to start at low freq.
                     */
                    mlfAssign(
                      s,
                      mlfFlipud(
                        mclVe(
                          mclArrayRef1(
                            mclVsv(*s, "s"), mlfCreateColonIndex()))));
                    /*
                     * nFBins = length(f);
                     */
                    mlfAssign(&nFBins, mlfScalar(mclLengthInt(mclVv(f, "f"))));
                /*
                 * else
                 */
                } else {
                    mxDestroyArray(a_0);
                    /*
                     * % if freq. scaling is passed
                     * f = FreqRange;
                     */
                    mlfAssign(&f, mclVsv(FreqRange, "FreqRange"));
                    /*
                     * nFBins = length(FreqRange);
                     */
                    mlfAssign(
                      &nFBins,
                      mlfScalar(mclLengthInt(mclVv(FreqRange, "FreqRange"))));
                    /*
                     * s = 1./(fourier_factor*f); 
                     */
                    mlfAssign(
                      s,
                      mclRdivide(
                        _mxarray7_,
                        mclMtimes(
                          mclVv(fourier_factor, "fourier_factor"),
                          mclVv(f, "f"))));
                }
            }
        }
    /*
     * end
     */
    }
    /*
     * p = fourier_factor*s;
     */
    mlfAssign(
      p, mclMtimes(mclVv(fourier_factor, "fourier_factor"), mclVv(*s, "s")));
    mclValidateOutput(f, 1, nargout_, "f", "WaveletSampling");
    mclValidateOutput(*s, 2, nargout_, "s", "WaveletSampling");
    mclValidateOutput(*p, 3, nargout_, "p", "WaveletSampling");
    mxDestroyArray(Fs);
    mxDestroyArray(FreqRange);
    mxDestroyArray(IsLogSc);
    mxDestroyArray(w0);
    mxDestroyArray(dj);
    mxDestroyArray(dt);
    mxDestroyArray(fourier_factor);
    mxDestroyArray(nFBins);
    mxDestroyArray(J);
    mxDestroyArray(s0);
    mxDestroyArray(varargin);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return f;
}
