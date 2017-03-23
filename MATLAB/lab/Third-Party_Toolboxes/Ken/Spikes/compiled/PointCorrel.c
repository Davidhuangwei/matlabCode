/*
 * MATLAB Compiler: 2.0
 * Date: Tue Jul 20 15:43:34 1999
 * Arguments: "-v" "-x" "PointCorrel.m" "hist.m" 
 */
#include "PointCorrel.h"
#include "bar.h"
#include "hist.h"
#include "ylabel.h"

/*
 * The function "MPointCorrel" is the implementation version of the
 * "PointCorrel" M-function from file "/u5/b/ken/matlab/Spikes/PointCorrel.m"
 * (lines 1-94). It contains the actual compiled code for that M-function. It
 * is a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * % PointCorrel(T1, T2, BinSize, HalfBins, isauto, SampleRate)
 * %
 * % Plots a cross-correlogram of 2 series
 * % The output has 2*HalfBins+1 bins
 * %
 * % Input time series may be in any units and don't need to be sorted
 * % BinSize gives the size of a bin in input units
 * % if isauto is set, the central bin will be zeroed
 * % SampleRate is for y scaling only, and gives the conversion between input units and Hz
 * %
 * 
 * 
 * 
 * function Histo = PointCorrelf(T1, T2, BinSize, HalfBins, isauto, SampleRate)
 */
static mxArray * MPointCorrel(int nargout_,
                              mxArray * T1,
                              mxArray * T2,
                              mxArray * BinSize,
                              mxArray * HalfBins,
                              mxArray * isauto,
                              mxArray * SampleRate) {
    mxArray * Histo = mclGetUninitializedArray();
    mxArray * Bins = mclGetUninitializedArray();
    mxArray * HalfSize = mclGetUninitializedArray();
    mxArray * PartialHisto = mclGetUninitializedArray();
    mxArray * RangeEnd = mclGetUninitializedArray();
    mxArray * RangeStart = mclGetUninitializedArray();
    mxArray * Size1 = mclGetUninitializedArray();
    mxArray * Size2 = mclGetUninitializedArray();
    mxArray * Sp1 = mclGetUninitializedArray();
    mxArray * Times = mclGetUninitializedArray();
    mxArray * Trange = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mclForLoopIterator iterator_0;
    mxArray * nBins = mclGetUninitializedArray();
    mxArray * t1 = mclGetUninitializedArray();
    mclValidateInputs(
      "PointCorrel", 6, &T1, &T2, &BinSize, &HalfBins, &isauto, &SampleRate);
    mclCopyArray(&T1);
    mclCopyArray(&T2);
    /*
     * 
     * % Make T1 and T2 into column vectors, and sort them
     * T1 = sort(T1(:));
     */
    mlfAssign(
      &T1, mlfSort(NULL, mlfIndexRef(T1, "(?)", mlfCreateColonIndex()), NULL));
    /*
     * T2 = sort(T2(:));
     */
    mlfAssign(
      &T2, mlfSort(NULL, mlfIndexRef(T2, "(?)", mlfCreateColonIndex()), NULL));
    /*
     * Size1 = size(T1, 1);
     */
    mlfAssign(&Size1, mlfSize(mclValueVarargout(), T1, mlfScalar(1.0)));
    /*
     * Size2 = size(T2, 1);
     */
    mlfAssign(&Size2, mlfSize(mclValueVarargout(), T2, mlfScalar(1.0)));
    /*
     * 
     * % HalfSize is the size of half the histogram
     * 
     * HalfSize = BinSize*HalfBins;
     */
    mlfAssign(&HalfSize, mlfMtimes(BinSize, HalfBins));
    /*
     * nBins = 2*HalfBins + 1;
     */
    mlfAssign(
      &nBins, mlfPlus(mlfMtimes(mlfScalar(2.0), HalfBins), mlfScalar(1.0)));
    /*
     * Histo = zeros(2*HalfBins + 1, 1);
     */
    mlfAssign(
      &Histo,
      mlfZeros(
        mlfPlus(mlfMtimes(mlfScalar(2.0), HalfBins), mlfScalar(1.0)),
        mlfScalar(1.0),
        NULL));
    /*
     * 
     * % Sp1 is center point, Sp2 is secondary point
     * % t1 is time of Sp1
     * % RangeStart and RangeEnd give the range between
     * % within histo size of Sp1.
     * 
     * 
     * RangeStart = 1;
     */
    mlfAssign(&RangeStart, mlfScalar(1.0));
    /*
     * RangeEnd = 1;
     */
    mlfAssign(&RangeEnd, mlfScalar(1.0));
    /*
     * 
     * for Sp1 = 1:Size1
     */
    for (mclForStart(&iterator_0, mlfScalar(1.0), Size1, NULL);
         mclForNext(&iterator_0, &Sp1);
         ) {
        /*
         * 
         * t1 = T1(Sp1);
         */
        mlfAssign(&t1, mlfIndexRef(T1, "(?)", Sp1));
        /*
         * 
         * % Update range
         * 
         * % RangeStart becomes first spike in train 2 that is no more
         * % than HalfSize before current spike
         * while(RangeStart<Size2 & T2(RangeStart)<t1-HalfSize)
         */
        for (;;) {
            mxArray * a_ = mclInitialize(mlfLt(RangeStart, Size2));
            if (mlfTobool(a_)
                && mlfTobool(
                     mlfAnd(
                       a_,
                       mlfLt(
                         mlfIndexRef(T2, "(?)", RangeStart),
                         mlfMinus(t1, HalfSize))))) {
                mxDestroyArray(a_);
            } else {
                mxDestroyArray(a_);
                break;
            }
            /*
             * RangeStart = RangeStart+1;
             */
            mlfAssign(&RangeStart, mlfPlus(RangeStart, mlfScalar(1.0)));
        /*
         * end;
         */
        }
        /*
         * 
         * % RangeEnd becomes last spike in train 2 that is no more
         * % than HalfSize after current spike
         * while(RangeEnd<Size2 & T2(RangeEnd+1)<t1+HalfSize)
         */
        for (;;) {
            mxArray * a_ = mclInitialize(mlfLt(RangeEnd, Size2));
            if (mlfTobool(a_)
                && mlfTobool(
                     mlfAnd(
                       a_,
                       mlfLt(
                         mlfIndexRef(
                           T2, "(?)", mlfPlus(RangeEnd, mlfScalar(1.0))),
                         mlfPlus(t1, HalfSize))))) {
                mxDestroyArray(a_);
            } else {
                mxDestroyArray(a_);
                break;
            }
            /*
             * RangeEnd = RangeEnd+1;
             */
            mlfAssign(&RangeEnd, mlfPlus(RangeEnd, mlfScalar(1.0)));
        /*
         * end;
         */
        }
        /*
         * 
         * if (RangeStart==RangeEnd & abs(T2(RangeEnd)-T1(Sp1))>=HalfSize)
         */
        {
            mxArray * a_ = mclInitialize(mlfEq(RangeStart, RangeEnd));
            if (mlfTobool(a_)
                && mlfTobool(
                     mlfAnd(
                       a_,
                       mlfGe(
                         mlfAbs(
                           mlfMinus(
                             mlfIndexRef(T2, "(?)", RangeEnd),
                             mlfIndexRef(T1, "(?)", Sp1))),
                         HalfSize)))) {
                mxDestroyArray(a_);
            /*
             * % do nothing
             * else 	      
             */
            } else {
                mxDestroyArray(a_);
                /*
                 * % Add stuff to Histo
                 * 
                 * Times = (T2(RangeStart:RangeEnd) - t1);
                 */
                mlfAssign(
                  &Times,
                  mlfMinus(
                    mlfIndexRef(
                      T2, "(?)", mlfColon(RangeStart, RangeEnd, NULL)),
                    t1));
                /*
                 * 
                 * Bins = HalfBins + 1 + round(Times/BinSize);
                 */
                mlfAssign(
                  &Bins,
                  mlfPlus(
                    mlfPlus(HalfBins, mlfScalar(1.0)),
                    mlfRound(mlfMrdivide(Times, BinSize))));
                /*
                 * 
                 * % Its possible that more than one spike falls in a particular
                 * % bin - so we need to keep count of how many spikes are in which
                 * % bins
                 * PartialHisto = hist(Bins, 1:nBins);
                 */
                mlfAssign(
                  &PartialHisto,
                  mlfNHist(
                    1, NULL, Bins, mlfColon(mlfScalar(1.0), nBins, NULL)));
                /*
                 * 
                 * Histo = Histo + PartialHisto';
                 */
                mlfAssign(&Histo, mlfPlus(Histo, mlfCtranspose(PartialHisto)));
            }
        /*
         * end
         */
        }
    /*
     * end;	
     */
    }
    /*
     * 
     * if isauto
     */
    if (mlfTobool(isauto)) {
        /*
         * Histo(HalfBins+1) = 0;
         */
        mlfIndexAssign(
          &Histo, "(?)", mlfPlus(HalfBins, mlfScalar(1.0)), mlfScalar(0.0));
    /*
     * end
     */
    }
    /*
     * 
     * % scale y axis
     * Trange = max(T1(end), T2(end)) - min(T1(1), T2(1));
     */
    mlfAssign(
      &Trange,
      mlfMinus(
        mlfMax(
          NULL,
          mlfIndexRef(T1, "(?)", mlfEnd(T1, mlfScalar(1), mlfScalar(1))),
          mlfIndexRef(T2, "(?)", mlfEnd(T2, mlfScalar(1), mlfScalar(1))),
          NULL),
        mlfMin(
          NULL,
          mlfIndexRef(T1, "(?)", mlfScalar(1.0)),
          mlfIndexRef(T2, "(?)", mlfScalar(1.0)),
          NULL)));
    /*
     * Histo = Histo *SampleRate * SampleRate / (Trange*BinSize);
     */
    mlfAssign(
      &Histo,
      mlfMrdivide(
        mlfMtimes(mlfMtimes(Histo, SampleRate), SampleRate),
        mlfMtimes(Trange, BinSize)));
    /*
     * 
     * % plot graph
     * bar((-HalfBins:HalfBins)*BinSize/SampleRate, Histo);
     */
    mclAssignAns(
      &ans,
      mlfNBar(
        0,
        NULL,
        mlfMrdivide(
          mlfMtimes(mlfColon(mlfUminus(HalfBins), HalfBins, NULL), BinSize),
          SampleRate),
        Histo,
        NULL));
    /*
     * 
     * % label y axis
     * if isauto
     */
    if (mlfTobool(isauto)) {
        /*
         * ylabel('ACG (Hz^2)')
         */
        mclPrintAns(&ans, mlfNYlabel(0, mxCreateString("ACG (Hz^2)"), NULL));
    /*
     * else
     */
    } else {
        /*
         * ylabel('CCG (Hz^2)')
         */
        mclPrintAns(&ans, mlfNYlabel(0, mxCreateString("CCG (Hz^2)"), NULL));
    /*
     * end
     */
    }
    mclValidateOutputs("PointCorrel", 1, nargout_, &Histo);
    mxDestroyArray(Bins);
    mxDestroyArray(HalfSize);
    mxDestroyArray(PartialHisto);
    mxDestroyArray(RangeEnd);
    mxDestroyArray(RangeStart);
    mxDestroyArray(Size1);
    mxDestroyArray(Size2);
    mxDestroyArray(Sp1);
    mxDestroyArray(T1);
    mxDestroyArray(T2);
    mxDestroyArray(Times);
    mxDestroyArray(Trange);
    mxDestroyArray(ans);
    mxDestroyArray(nBins);
    mxDestroyArray(t1);
    /*
     * 
     * 
     * 
     * 
     */
    return Histo;
}

/*
 * The function "mlfPointCorrel" contains the normal interface for the
 * "PointCorrel" M-function from file "/u5/b/ken/matlab/Spikes/PointCorrel.m"
 * (lines 1-94). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
mxArray * mlfPointCorrel(mxArray * T1,
                         mxArray * T2,
                         mxArray * BinSize,
                         mxArray * HalfBins,
                         mxArray * isauto,
                         mxArray * SampleRate) {
    int nargout = 1;
    mxArray * Histo = mclGetUninitializedArray();
    mlfEnterNewContext(0, 6, T1, T2, BinSize, HalfBins, isauto, SampleRate);
    Histo
      = MPointCorrel(nargout, T1, T2, BinSize, HalfBins, isauto, SampleRate);
    mlfRestorePreviousContext(
      0, 6, T1, T2, BinSize, HalfBins, isauto, SampleRate);
    return mlfReturnValue(Histo);
}

/*
 * The function "mlxPointCorrel" contains the feval interface for the
 * "PointCorrel" M-function from file "/u5/b/ken/matlab/Spikes/PointCorrel.m"
 * (lines 1-94). The feval function calls the implementation version of
 * PointCorrel through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
void mlxPointCorrel(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[6];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: PointCorrel Line: 14 Column"
            ": 0 The function \"PointCorrel\" was called with "
            "more than the declared number of outputs (1)"));
    }
    if (nrhs > 6) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: PointCorrel Line: 14 Colum"
            "n: 0 The function \"PointCorrel\" was called wit"
            "h more than the declared number of inputs (6)"));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 6 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 6; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    mplhs[0]
      = MPointCorrel(
          nlhs, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    mlfRestorePreviousContext(
      0, 6, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4], mprhs[5]);
    plhs[0] = mplhs[0];
}
