/*
 * MATLAB Compiler: 2.0.1
 * Date: Tue Feb  1 12:56:03 2000
 * Arguments: "-xw" "TriggeredAv" 
 */
#include "TriggeredAv.h"

/*
 * The function "MTriggeredAv" is the implementation version of the
 * "TriggeredAv" M-function from file "/u5/b/ken/matlab/General/TriggeredAv.m"
 * (lines 1-53). It contains the actual compiled code for that M-function. It
 * is a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * % [Avs StdErr] = TriggeredAv(Trace, nBefore, nAfter, T, G)
 * %
 * % computes triggered averages from Trace at the times given by T.
 * % Trace may be 2D, in which case columns are averaged separately.
 * % The output will then be of the form Avs(Time, Column)
 * % nBefore and nAfter give the number of samples before and after
 * % to use.
 * %
 * % G is a group label for the trigger points T.  In this case the
 * % output will be Avs(Time, Column, Group)
 * %
 * % StdErr gives standard error in the same arrangement
 * 
 * function Avs = TriggeredAv(Trace, nBefore, nAfter, T, G)
 */
static mxArray * MTriggeredAv(int nargout_,
                              mxArray * Trace,
                              mxArray * nBefore,
                              mxArray * nAfter,
                              mxArray * T,
                              mxArray * G) {
    mxArray * Avs = mclGetUninitializedArray();
    mxArray * Block = mclGetUninitializedArray();
    mxArray * BlockSize = mclGetUninitializedArray();
    mxArray * BlockTriggers = mclGetUninitializedArray();
    mxArray * MyTriggers = mclGetUninitializedArray();
    mxArray * StdErr = mclGetUninitializedArray();
    mxArray * Sum = mclGetUninitializedArray();
    mxArray * SumSq = mclGetUninitializedArray();
    mxArray * TimeCenters = mclGetUninitializedArray();
    mxArray * TimeIndex = mclGetUninitializedArray();
    mxArray * TimeOffsets = mclGetUninitializedArray();
    mxArray * Waves = mclGetUninitializedArray();
    mxArray * grp = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mclForLoopIterator iterator_1;
    mxArray * maxTime = mclGetUninitializedArray();
    mxArray * nBlockTriggers = mclGetUninitializedArray();
    mxArray * nColumns = mclGetUninitializedArray();
    mxArray * nGroups = mclGetUninitializedArray();
    mxArray * nSamples = mclGetUninitializedArray();
    mxArray * nTriggers = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * repshape = mclUnassigned();
    mlfAssign(&nargin_, mlfNargin(0, Trace, nBefore, nAfter, T, G, NULL));
    mclValidateInputs("TriggeredAv", 5, &Trace, &nBefore, &nAfter, &T, &G);
    mclCopyArray(&G);
    /*
     * 
     * if (nargin<5 | length(G) == 1)
     */
    {
        mxArray * a_ = mclInitialize(mlfLt(nargin_, mlfScalar(5.0)));
        if (mlfTobool(a_)
            || mlfTobool(mlfOr(a_, mlfEq(mlfLength(G), mlfScalar(1.0))))) {
            mxDestroyArray(a_);
            /*
             * G = ones(length(T), 1);
             */
            mlfAssign(&G, mlfOnes(mlfLength(T), mlfScalar(1.0), NULL));
        } else {
            mxDestroyArray(a_);
        }
    /*
     * end
     */
    }
    /*
     * 
     * nColumns = size(Trace,2);
     */
    mlfAssign(&nColumns, mlfSize(mclValueVarargout(), Trace, mlfScalar(2.0)));
    /*
     * nSamples = nBefore + nAfter + 1;
     */
    mlfAssign(&nSamples, mlfPlus(mlfPlus(nBefore, nAfter), mlfScalar(1.0)));
    /*
     * nGroups = max(G);
     */
    mlfAssign(&nGroups, mlfMax(NULL, G, NULL, NULL));
    /*
     * maxTime = size(Trace, 1);
     */
    mlfAssign(&maxTime, mlfSize(mclValueVarargout(), Trace, mlfScalar(1.0)));
    /*
     * 
     * Avs = zeros(nSamples, nColumns, nGroups);
     */
    mlfAssign(&Avs, mlfZeros(nSamples, nColumns, nGroups, NULL));
    /*
     * 
     * BlockSize = floor(2000000/nSamples); % memory saving parameter
     */
    mlfAssign(
      &BlockSize, mlfFloor(mlfMrdivide(mlfScalar(2000000.0), nSamples)));
    /*
     * 
     * for grp = 1:nGroups
     */
    for (mclForStart(&iterator_0, mlfScalar(1.0), nGroups, NULL);
         mclForNext(&iterator_0, &grp);
         ) {
        /*
         * 
         * Sum = zeros(nSamples, nColumns);
         */
        mlfAssign(&Sum, mlfZeros(nSamples, nColumns, NULL));
        /*
         * SumSq = zeros(nSamples, nColumns);
         */
        mlfAssign(&SumSq, mlfZeros(nSamples, nColumns, NULL));
        /*
         * MyTriggers = find(G==grp & T > nBefore & T <= maxTime-nAfter);
         */
        mlfAssign(
          &MyTriggers,
          mlfFind(
            NULL,
            NULL,
            mlfAnd(
              mlfAnd(mlfEq(G, grp), mlfGt(T, nBefore)),
              mlfLe(T, mlfMinus(maxTime, nAfter)))));
        /*
         * nTriggers = length(MyTriggers);
         */
        mlfAssign(&nTriggers, mlfLength(MyTriggers));
        /*
         * 
         * % go through triggers in groups of BlockSize to save memory
         * for Block = 1:ceil(nTriggers/BlockSize)
         */
        for (mclForStart(
               &iterator_1,
               mlfScalar(1.0),
               mlfCeil(mlfMrdivide(nTriggers, BlockSize)),
               NULL);
             mclForNext(&iterator_1, &Block);
             ) {
            /*
             * BlockTriggers = MyTriggers(1+(Block-1)*BlockSize:min(Block*BlockSize,nTriggers));
             */
            mlfAssign(
              &BlockTriggers,
              mlfIndexRef(
                MyTriggers,
                "(?)",
                mlfColon(
                  mlfPlus(
                    mlfScalar(1.0),
                    mlfMtimes(mlfMinus(Block, mlfScalar(1.0)), BlockSize)),
                  mlfMin(NULL, mlfMtimes(Block, BlockSize), nTriggers, NULL),
                  NULL)));
            /*
             * nBlockTriggers = length(BlockTriggers);
             */
            mlfAssign(&nBlockTriggers, mlfLength(BlockTriggers));
            /*
             * 
             * TimeOffsets = repmat(-nBefore:nAfter, nBlockTriggers, 1);
             */
            mlfAssign(
              &TimeOffsets,
              mlfRepmat(
                mlfColon(mlfUminus(nBefore), nAfter, NULL),
                nBlockTriggers,
                mlfScalar(1.0)));
            /*
             * TimeCenters = repmat(T(BlockTriggers), 1, nSamples);
             */
            mlfAssign(
              &TimeCenters,
              mlfRepmat(
                mlfIndexRef(T, "(?)", BlockTriggers),
                mlfScalar(1.0),
                nSamples));
            /*
             * TimeIndex = TimeOffsets + TimeCenters;
             */
            mlfAssign(&TimeIndex, mlfPlus(TimeOffsets, TimeCenters));
            /*
             * 
             * Waves = Trace(TimeIndex,:);
             */
            mlfAssign(
              &Waves,
              mlfIndexRef(Trace, "(?,?)", TimeIndex, mlfCreateColonIndex()));
            /*
             * Waves = reshape(Waves, [nBlockTriggers, nSamples, nColumns]);
             */
            mlfAssign(
              &Waves,
              mlfReshape(
                Waves,
                mlfHorzcat(nBlockTriggers, nSamples, nColumns, NULL), NULL));
            /*
             * Sum = Sum + reshape(sum(Waves, 1), [nSamples, nColumns]);
             */
            mlfAssign(
              &Sum,
              mlfPlus(
                Sum,
                mlfReshape(
                  mlfSum(Waves, mlfScalar(1.0)),
                  mlfHorzcat(nSamples, nColumns, NULL), NULL)));
            /*
             * SumSq = SumSq + repshape(sum(Waves.^2,1), [nSamples, nColumns]);
             */
            mlfAssign(
              &SumSq,
              mlfPlus(
                SumSq,
                mlfIndexRef(
                  repshape,
                  "(?,?)",
                  mlfSum(mlfPower(Waves, mlfScalar(2.0)), mlfScalar(1.0)),
                  mlfHorzcat(nSamples, nColumns, NULL))));
        /*
         * end
         */
        }
        /*
         * 
         * Avs(:,:,grp) = Sum/nTriggers;
         */
        mlfIndexAssign(
          &Avs,
          "(?,?,?)",
          mlfCreateColonIndex(),
          mlfCreateColonIndex(),
          grp,
          mlfMrdivide(Sum, nTriggers));
        /*
         * StdErr(:,:,grp) = sqrt(SumSq/nTriggers - Avs(:,:,grp).^2) / sqrt(nTriggers);
         */
        mlfIndexAssign(
          &StdErr,
          "(?,?,?)",
          mlfCreateColonIndex(),
          mlfCreateColonIndex(),
          grp,
          mlfMrdivide(
            mlfSqrt(
              mlfMinus(
                mlfMrdivide(SumSq, nTriggers),
                mlfPower(
                  mlfIndexRef(
                    Avs,
                    "(?,?,?)",
                    mlfCreateColonIndex(),
                    mlfCreateColonIndex(),
                    grp),
                  mlfScalar(2.0)))),
            mlfSqrt(nTriggers)));
    /*
     * end
     */
    }
    mclValidateOutputs("TriggeredAv", 1, nargout_, &Avs);
    mxDestroyArray(Block);
    mxDestroyArray(BlockSize);
    mxDestroyArray(BlockTriggers);
    mxDestroyArray(G);
    mxDestroyArray(MyTriggers);
    mxDestroyArray(StdErr);
    mxDestroyArray(Sum);
    mxDestroyArray(SumSq);
    mxDestroyArray(TimeCenters);
    mxDestroyArray(TimeIndex);
    mxDestroyArray(TimeOffsets);
    mxDestroyArray(Waves);
    mxDestroyArray(grp);
    mxDestroyArray(maxTime);
    mxDestroyArray(nBlockTriggers);
    mxDestroyArray(nColumns);
    mxDestroyArray(nGroups);
    mxDestroyArray(nSamples);
    mxDestroyArray(nTriggers);
    mxDestroyArray(nargin_);
    mxDestroyArray(repshape);
    return Avs;
}

/*
 * The function "mlfTriggeredAv" contains the normal interface for the
 * "TriggeredAv" M-function from file "/u5/b/ken/matlab/General/TriggeredAv.m"
 * (lines 1-53). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
mxArray * mlfTriggeredAv(mxArray * Trace,
                         mxArray * nBefore,
                         mxArray * nAfter,
                         mxArray * T,
                         mxArray * G) {
    int nargout = 1;
    mxArray * Avs = mclGetUninitializedArray();
    mlfEnterNewContext(0, 5, Trace, nBefore, nAfter, T, G);
    Avs = MTriggeredAv(nargout, Trace, nBefore, nAfter, T, G);
    mlfRestorePreviousContext(0, 5, Trace, nBefore, nAfter, T, G);
    return mlfReturnValue(Avs);
}

/*
 * The function "mlxTriggeredAv" contains the feval interface for the
 * "TriggeredAv" M-function from file "/u5/b/ken/matlab/General/TriggeredAv.m"
 * (lines 1-53). The feval function calls the implementation version of
 * TriggeredAv through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
void mlxTriggeredAv(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[5];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: TriggeredAv Line: 14 Column"
            ": 0 The function \"TriggeredAv\" was called with "
            "more than the declared number of outputs (1)"));
    }
    if (nrhs > 5) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: TriggeredAv Line: 14 Colum"
            "n: 0 The function \"TriggeredAv\" was called wit"
            "h more than the declared number of inputs (5)"));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 5 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 5; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 5, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    mplhs[0]
      = MTriggeredAv(nlhs, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    mlfRestorePreviousContext(
      0, 5, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    plhs[0] = mplhs[0];
}
