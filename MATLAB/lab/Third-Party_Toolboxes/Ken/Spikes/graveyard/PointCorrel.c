/*
 * MATLAB Compiler: 2.0.1
 * Date: Wed Jan 26 11:51:55 2000
 * Arguments: "-xw" "PointCorrel" 
 */
#include "PointCorrel.h"
#include "bar.h"
#include "hist.h"
#include "xlabel.h"
#include "ylabel.h"

/*
 * The function "MPointCorrel" is the implementation version of the
 * "PointCorrel" M-function from file "/u5/b/ken/matlab/Spikes/PointCorrel.m"
 * (lines 1-119). It contains the actual compiled code for that M-function. It
 * is a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * % PointCorrel(T1, T2, BinSize, HalfBins, isauto, SampleRate, Normalization)
 * %
 * % Plots a cross-correlogram of 2 series
 * % The output has 2*HalfBins+1 bins
 * %
 * % Input time series may be in any units and don't need to be sorted
 * % BinSize gives the size of a bin in input units
 * % if isauto is set, the central bin will be zeroed
 * % SampleRate is for y scaling only, and gives the conversion between input units and Hz
 * % Normalization indicates the type of y-axis normalization to be used.  
 * % 'count' indicates that the y axis should show the raw spike count in each bin.
 * % 'hz' will normalize to give the conditional intensity of cell 2 given that cell 1 fired a spike (default)
 * % 'hz2' will give the joint intensity, measured in hz^2.
 * % 'scale' will scale by both firing rates so the asymptotic value is 1
 * %
 * % [Out t] = PointCorrel(...) will return 2 arguments: the height of the correlogram
 * % and the x axis label.
 * 
 * function [Out, t] = PointCorrel(T1, T2, BinSize, HalfBins, isauto, SampleRate, Normalization);
 */
static mxArray * MPointCorrel(mxArray * * t,
                              int nargout_,
                              mxArray * T1,
                              mxArray * T2,
                              mxArray * BinSize,
                              mxArray * HalfBins,
                              mxArray * isauto,
                              mxArray * SampleRate,
                              mxArray * Normalization) {
    mxArray * Out = mclGetUninitializedArray();
    mxArray * AxisUnit = mclGetUninitializedArray();
    mxArray * Bins = mclGetUninitializedArray();
    mxArray * HalfSize = mclGetUninitializedArray();
    mxArray * Histo = mclGetUninitializedArray();
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
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * nargout = mclInitialize(mlfScalar(nargout_));
    mxArray * t1 = mclGetUninitializedArray();
    mlfAssign(
      &nargin_,
      mlfNargin(
        0, T1, T2, BinSize, HalfBins, isauto, SampleRate, Normalization, NULL));
    mclValidateInputs(
      "PointCorrel",
      7,
      &T1,
      &T2,
      &BinSize,
      &HalfBins,
      &isauto,
      &SampleRate,
      &Normalization);
    mclCopyArray(&T1);
    mclCopyArray(&T2);
    mclCopyArray(&Normalization);
    /*
     * 
     * if (nargin<7) Normalization = 'hz'; end;
     */
    if (mlfTobool(mlfLt(nargin_, mlfScalar(7.0)))) {
        mlfAssign(&Normalization, mxCreateString("hz"));
    }
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
     * Trange = max(T1(end), T2(end)) - min(T1(1), T2(1)); % total time
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
     * switch Normalization
     * case 'hz'
     */
    if (mclSwitchCompare(Normalization, mxCreateString("hz"))) {
        /*
         * Histo = Histo * SampleRate / (BinSize * length(T1));
         */
        mlfAssign(
          &Histo,
          mlfMrdivide(
            mlfMtimes(Histo, SampleRate), mlfMtimes(BinSize, mlfLength(T1))));
        /*
         * AxisUnit = '(Hz)';
         */
        mlfAssign(&AxisUnit, mxCreateString("(Hz)"));
    /*
     * case 'hz2'
     */
    } else if (mclSwitchCompare(Normalization, mxCreateString("hz2"))) {
        /*
         * Histo = Histo *SampleRate * SampleRate / (Trange*BinSize);
         */
        mlfAssign(
          &Histo,
          mlfMrdivide(
            mlfMtimes(mlfMtimes(Histo, SampleRate), SampleRate),
            mlfMtimes(Trange, BinSize)));
        /*
         * AxisUnit = '(Hz^2)';
         */
        mlfAssign(&AxisUnit, mxCreateString("(Hz^2)"));
    /*
     * case 'count';
     */
    } else if (mclSwitchCompare(Normalization, mxCreateString("count"))) {
        /*
         * AxisUnit = '(Spikes)';
         */
        mlfAssign(&AxisUnit, mxCreateString("(Spikes)"));
    /*
     * case 'scale'
     */
    } else if (mclSwitchCompare(Normalization, mxCreateString("scale"))) {
        /*
         * Histo = Histo * Trange / (BinSize * length(T1) * length(T2));
         */
        mlfAssign(
          &Histo,
          mlfMrdivide(
            mlfMtimes(Histo, Trange),
            mlfMtimes(mlfMtimes(BinSize, mlfLength(T1)), mlfLength(T2))));
        /*
         * AxisUnit = '(Scaled)';
         */
        mlfAssign(&AxisUnit, mxCreateString("(Scaled)"));
    /*
     * otherwise
     */
    } else {
        /*
         * warning(['Unknown Normalization method ', Normalization]);
         */
        mclAssignAns(
          &ans,
          mlfWarning(
            NULL,
            mlfHorzcat(
              mxCreateString("Unknown Normalization method "),
              Normalization,
              NULL)));
    /*
     * end;
     */
    }
    /*
     * 
     * if (nargout <1)
     */
    if (mlfTobool(mlfLt(nargout, mlfScalar(1.0)))) {
        /*
         * 
         * % plot graph
         * bar(1000*(-HalfBins:HalfBins)*BinSize/SampleRate, Histo);
         */
        mclAssignAns(
          &ans,
          mlfNBar(
            0,
            NULL,
            mlfMrdivide(
              mlfMtimes(
                mlfMtimes(
                  mlfScalar(1000.0),
                  mlfColon(mlfUminus(HalfBins), HalfBins, NULL)),
                BinSize),
              SampleRate),
            Histo,
            NULL));
        /*
         * xlabel('ms');
         */
        mclAssignAns(&ans, mlfNXlabel(0, mxCreateString("ms"), NULL));
        /*
         * 
         * % label y axis
         * if isauto
         */
        if (mlfTobool(isauto)) {
            /*
             * ylabel(['ACG ', AxisUnit])
             */
            mclPrintAns(
              &ans,
              mlfNYlabel(
                0, mlfHorzcat(mxCreateString("ACG "), AxisUnit, NULL), NULL));
        /*
         * else
         */
        } else {
            /*
             * ylabel(['CCG ', AxisUnit])
             */
            mclPrintAns(
              &ans,
              mlfNYlabel(
                0, mlfHorzcat(mxCreateString("CCG "), AxisUnit, NULL), NULL));
        /*
         * end
         */
        }
        /*
         * 
         * axis tight
         */
        mclPrintAns(
          &ans, mlfNAxis(0, NULL, NULL, mxCreateString("tight"), NULL));
    /*
     * else
     */
    } else {
        /*
         * Out = Histo;
         */
        mlfAssign(&Out, Histo);
        /*
         * t = 1000*(-HalfBins:HalfBins)*BinSize/SampleRate;
         */
        mlfAssign(
          t,
          mlfMrdivide(
            mlfMtimes(
              mlfMtimes(
                mlfScalar(1000.0),
                mlfColon(mlfUminus(HalfBins), HalfBins, NULL)),
              BinSize),
            SampleRate));
    /*
     * end;
     */
    }
    mclValidateOutputs("PointCorrel", 2, nargout_, &Out, t);
    mxDestroyArray(AxisUnit);
    mxDestroyArray(Bins);
    mxDestroyArray(HalfSize);
    mxDestroyArray(Histo);
    mxDestroyArray(Normalization);
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
    mxDestroyArray(nargin_);
    mxDestroyArray(nargout);
    mxDestroyArray(t1);
    return Out;
}

/*
 * The function "mlfNPointCorrel" contains the nargout interface for the
 * "PointCorrel" M-function from file "/u5/b/ken/matlab/Spikes/PointCorrel.m"
 * (lines 1-119). This interface is only produced if the M-function uses the
 * special variable "nargout". The nargout interface allows the number of
 * requested outputs to be specified via the nargout argument, as opposed to
 * the normal interface which dynamically calculates the number of outputs
 * based on the number of non-NULL inputs it receives. This function processes
 * any input arguments and passes them to the implementation version of the
 * function, appearing above.
 */
mxArray * mlfNPointCorrel(int nargout,
                          mxArray * * t,
                          mxArray * T1,
                          mxArray * T2,
                          mxArray * BinSize,
                          mxArray * HalfBins,
                          mxArray * isauto,
                          mxArray * SampleRate,
                          mxArray * Normalization) {
    mxArray * Out = mclGetUninitializedArray();
    mxArray * t__ = mclGetUninitializedArray();
    mlfEnterNewContext(
      1, 7, t, T1, T2, BinSize, HalfBins, isauto, SampleRate, Normalization);
    Out
      = MPointCorrel(
          &t__,
          nargout,
          T1,
          T2,
          BinSize,
          HalfBins,
          isauto,
          SampleRate,
          Normalization);
    mlfRestorePreviousContext(
      1, 7, t, T1, T2, BinSize, HalfBins, isauto, SampleRate, Normalization);
    if (t != NULL) {
        mclCopyOutputArg(t, t__);
    } else {
        mxDestroyArray(t__);
    }
    return mlfReturnValue(Out);
}

/*
 * The function "mlfPointCorrel" contains the normal interface for the
 * "PointCorrel" M-function from file "/u5/b/ken/matlab/Spikes/PointCorrel.m"
 * (lines 1-119). This function processes any input arguments and passes them
 * to the implementation version of the function, appearing above.
 */
mxArray * mlfPointCorrel(mxArray * * t,
                         mxArray * T1,
                         mxArray * T2,
                         mxArray * BinSize,
                         mxArray * HalfBins,
                         mxArray * isauto,
                         mxArray * SampleRate,
                         mxArray * Normalization) {
    int nargout = 1;
    mxArray * Out = mclGetUninitializedArray();
    mxArray * t__ = mclGetUninitializedArray();
    mlfEnterNewContext(
      1, 7, t, T1, T2, BinSize, HalfBins, isauto, SampleRate, Normalization);
    if (t != NULL) {
        ++nargout;
    }
    Out
      = MPointCorrel(
          &t__,
          nargout,
          T1,
          T2,
          BinSize,
          HalfBins,
          isauto,
          SampleRate,
          Normalization);
    mlfRestorePreviousContext(
      1, 7, t, T1, T2, BinSize, HalfBins, isauto, SampleRate, Normalization);
    if (t != NULL) {
        mclCopyOutputArg(t, t__);
    } else {
        mxDestroyArray(t__);
    }
    return mlfReturnValue(Out);
}

/*
 * The function "mlfVPointCorrel" contains the void interface for the
 * "PointCorrel" M-function from file "/u5/b/ken/matlab/Spikes/PointCorrel.m"
 * (lines 1-119). The void interface is only produced if the M-function uses
 * the special variable "nargout", and has at least one output. The void
 * interface function specifies zero output arguments to the implementation
 * version of the function, and in the event that the implementation version
 * still returns an output (which, in MATLAB, would be assigned to the "ans"
 * variable), it deallocates the output. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
void mlfVPointCorrel(mxArray * T1,
                     mxArray * T2,
                     mxArray * BinSize,
                     mxArray * HalfBins,
                     mxArray * isauto,
                     mxArray * SampleRate,
                     mxArray * Normalization) {
    mxArray * Out = mclUnassigned();
    mxArray * t = mclUnassigned();
    mlfEnterNewContext(
      0, 7, T1, T2, BinSize, HalfBins, isauto, SampleRate, Normalization);
    Out
      = MPointCorrel(
          &t, 0, T1, T2, BinSize, HalfBins, isauto, SampleRate, Normalization);
    mlfRestorePreviousContext(
      0, 7, T1, T2, BinSize, HalfBins, isauto, SampleRate, Normalization);
    mxDestroyArray(Out);
    mxDestroyArray(t);
}

/*
 * The function "mlxPointCorrel" contains the feval interface for the
 * "PointCorrel" M-function from file "/u5/b/ken/matlab/Spikes/PointCorrel.m"
 * (lines 1-119). The feval function calls the implementation version of
 * PointCorrel through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
void mlxPointCorrel(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[7];
    mxArray * mplhs[2];
    int i;
    if (nlhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: PointCorrel Line: 19 Column"
            ": 0 The function \"PointCorrel\" was called with "
            "more than the declared number of outputs (2)"));
    }
    if (nrhs > 7) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: PointCorrel Line: 19 Colum"
            "n: 0 The function \"PointCorrel\" was called wit"
            "h more than the declared number of inputs (7)"));
    }
    for (i = 0; i < 2; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 7 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 7; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(
      0,
      7,
      mprhs[0],
      mprhs[1],
      mprhs[2],
      mprhs[3],
      mprhs[4],
      mprhs[5],
      mprhs[6]);
    mplhs[0]
      = MPointCorrel(
          &mplhs[1],
          nlhs,
          mprhs[0],
          mprhs[1],
          mprhs[2],
          mprhs[3],
          mprhs[4],
          mprhs[5],
          mprhs[6]);
    mlfRestorePreviousContext(
      0,
      7,
      mprhs[0],
      mprhs[1],
      mprhs[2],
      mprhs[3],
      mprhs[4],
      mprhs[5],
      mprhs[6]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 2 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 2; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}
