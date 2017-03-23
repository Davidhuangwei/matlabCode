/*
 * MATLAB Compiler: 2.1
 * Date: Wed Apr 11 10:31:27 2001
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "-w" "LocalMinima" 
 */
#include "LocalMinima.h"
#include "libmatlbm.h"
#include "libmatlbmx.h"

static mxChar _array1_[141] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'L', 'o', 'c', 'a', 'l',
                                'M', 'i', 'n', 'i', 'm', 'a', ' ', 'L', 'i',
                                'n', 'e', ':', ' ', '1', '6', ' ', 'C', 'o',
                                'l', 'u', 'm', 'n', ':', ' ', '1', ' ', 'T',
                                'h', 'e', ' ', 'f', 'u', 'n', 'c', 't', 'i',
                                'o', 'n', ' ', '"', 'L', 'o', 'c', 'a', 'l',
                                'M', 'i', 'n', 'i', 'm', 'a', '"', ' ', 'w',
                                'a', 's', ' ', 'c', 'a', 'l', 'l', 'e', 'd',
                                ' ', 'w', 'i', 't', 'h', ' ', 'm', 'o', 'r',
                                'e', ' ', 't', 'h', 'a', 'n', ' ', 't', 'h',
                                'e', ' ', 'd', 'e', 'c', 'l', 'a', 'r', 'e',
                                'd', ' ', 'n', 'u', 'm', 'b', 'e', 'r', ' ',
                                'o', 'f', ' ', 'o', 'u', 't', 'p', 'u', 't',
                                's', ' ', '(', '1', ')', '.' };
static mxArray * _mxarray0_;

static mxChar _array3_[140] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'L', 'o', 'c', 'a', 'l',
                                'M', 'i', 'n', 'i', 'm', 'a', ' ', 'L', 'i',
                                'n', 'e', ':', ' ', '1', '6', ' ', 'C', 'o',
                                'l', 'u', 'm', 'n', ':', ' ', '1', ' ', 'T',
                                'h', 'e', ' ', 'f', 'u', 'n', 'c', 't', 'i',
                                'o', 'n', ' ', '"', 'L', 'o', 'c', 'a', 'l',
                                'M', 'i', 'n', 'i', 'm', 'a', '"', ' ', 'w',
                                'a', 's', ' ', 'c', 'a', 'l', 'l', 'e', 'd',
                                ' ', 'w', 'i', 't', 'h', ' ', 'm', 'o', 'r',
                                'e', ' ', 't', 'h', 'a', 'n', ' ', 't', 'h',
                                'e', ' ', 'd', 'e', 'c', 'l', 'a', 'r', 'e',
                                'd', ' ', 'n', 'u', 'm', 'b', 'e', 'r', ' ',
                                'o', 'f', ' ', 'i', 'n', 'p', 'u', 't', 's',
                                ' ', '(', '3', ')', '.' };
static mxArray * _mxarray2_;
static double _ieee_plusinf_;
static mxArray * _mxarray4_;
static mxArray * _mxarray5_;
static mxArray * _mxarray6_;
static mxArray * _mxarray7_;
static mxArray * _mxarray8_;
static mxArray * _mxarray9_;

static double _array11_[2] = { -1.0, 1.0 };
static mxArray * _mxarray10_;

void InitializeModule_LocalMinima(void) {
    _mxarray0_ = mclInitializeString(141, _array1_);
    _mxarray2_ = mclInitializeString(140, _array3_);
    _ieee_plusinf_ = mclGetInf();
    _mxarray4_ = mclInitializeDouble(_ieee_plusinf_);
    _mxarray5_ = mclInitializeDouble(0.0);
    _mxarray6_ = mclInitializeDouble(10.0);
    _mxarray7_ = mclInitializeDouble(1.0);
    _mxarray8_ = mclInitializeDoubleVector(0, 0, (double *)NULL);
    _mxarray9_ = mclInitializeDouble(2.0);
    _mxarray10_ = mclInitializeDoubleVector(1, 2, _array11_);
}

void TerminateModule_LocalMinima(void) {
    mxDestroyArray(_mxarray10_);
    mxDestroyArray(_mxarray9_);
    mxDestroyArray(_mxarray8_);
    mxDestroyArray(_mxarray7_);
    mxDestroyArray(_mxarray6_);
    mxDestroyArray(_mxarray5_);
    mxDestroyArray(_mxarray4_);
    mxDestroyArray(_mxarray2_);
    mxDestroyArray(_mxarray0_);
}

static mxArray * MLocalMinima(int nargout_,
                              mxArray * x,
                              mxArray * NotCloserThan,
                              mxArray * LessThan);

_mexLocalFunctionTable _local_function_table_LocalMinima
  = { 0, (mexFunctionTableEntry *)NULL };

/*
 * The function "mlfLocalMinima" contains the normal interface for the
 * "LocalMinima" M-function from file "/u5/b/ken/matlab/General/LocalMinima.m"
 * (lines 1-95). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
mxArray * mlfLocalMinima(mxArray * x,
                         mxArray * NotCloserThan,
                         mxArray * LessThan) {
    int nargout = 1;
    mxArray * Mins = mclGetUninitializedArray();
    mlfEnterNewContext(0, 3, x, NotCloserThan, LessThan);
    Mins = MLocalMinima(nargout, x, NotCloserThan, LessThan);
    mlfRestorePreviousContext(0, 3, x, NotCloserThan, LessThan);
    return mlfReturnValue(Mins);
}

/*
 * The function "mlxLocalMinima" contains the feval interface for the
 * "LocalMinima" M-function from file "/u5/b/ken/matlab/General/LocalMinima.m"
 * (lines 1-95). The feval function calls the implementation version of
 * LocalMinima through this function. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
void mlxLocalMinima(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(_mxarray0_);
    }
    if (nrhs > 3) {
        mlfError(_mxarray2_);
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
    mplhs[0] = MLocalMinima(nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
}

/*
 * The function "MLocalMinima" is the implementation version of the
 * "LocalMinima" M-function from file "/u5/b/ken/matlab/General/LocalMinima.m"
 * (lines 1-95). It contains the actual compiled code for that M-function. It
 * is a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * % mins = LocalMinima(x, NotCloserThan, LessThan)
 * %
 * % finds positions of all local minima in input array
 * % in the case that it goes down, stays level, then goes up,
 * % the function finds the earliest point of equality
 * %
 * % second optional argument gives minimum distance between
 * % two minima - if 2 are closer than this, it choses the lower between them.
 * %
 * % 3rd optional argument lets you only have minima less than a certain number
 * % use this option if you are computing minima of a long array - it'll take way
 * % less time and memory.
 * 
 * % This program is the curse of my life.  Why can't things be simple?
 * 
 * function Mins = LocalMinima(x, NotCloserThan, LessThan)
 */
static mxArray * MLocalMinima(int nargout_,
                              mxArray * x,
                              mxArray * NotCloserThan,
                              mxArray * LessThan) {
    mexLocalFunctionTable save_local_function_table_ = mclSetCurrentLocalFunctionTable(
                                                         &_local_function_table_LocalMinima);
    int nargin_ = mclNargin(3, x, NotCloserThan, LessThan, NULL);
    mxArray * Mins = mclGetUninitializedArray();
    mxArray * mins = mclGetUninitializedArray();
    mxArray * NonZeros = mclGetUninitializedArray();
    mxArray * Zeros = mclGetUninitializedArray();
    mxArray * s = mclGetUninitializedArray();
    mxArray * Delete = mclGetUninitializedArray();
    mxArray * Offset = mclGetUninitializedArray();
    mxArray * dummy = mclGetUninitializedArray();
    mxArray * Vals = mclGetUninitializedArray();
    mxArray * TooClose = mclGetUninitializedArray();
    mxArray * NextSign = mclGetUninitializedArray();
    mxArray * i = mclGetUninitializedArray();
    mxArray * PrevSign = mclGetUninitializedArray();
    mxArray * ArraySize = mclGetUninitializedArray();
    mxArray * nMins = mclGetUninitializedArray();
    mxArray * nPoints = mclGetUninitializedArray();
    mclCopyArray(&x);
    mclCopyArray(&NotCloserThan);
    mclCopyArray(&LessThan);
    /*
     * 
     * if nargin<3
     */
    if (nargin_ < 3) {
        /*
         * LessThan = inf;
         */
        mlfAssign(&LessThan, _mxarray4_);
    /*
     * end
     */
    }
    /*
     * 
     * nPoints = length(x);
     */
    mlfAssign(&nPoints, mlfScalar(mclLengthInt(mclVa(x, "x"))));
    /*
     * nMins = 0;
     */
    mlfAssign(&nMins, _mxarray5_);
    /*
     * ArraySize = floor(nPoints/10);
     */
    mlfAssign(
      &ArraySize, mlfFloor(mclMrdivide(mclVv(nPoints, "nPoints"), _mxarray6_)));
    /*
     * Mins = zeros(ArraySize,1);
     */
    mlfAssign(&Mins, mlfZeros(mclVv(ArraySize, "ArraySize"), _mxarray7_, NULL));
    /*
     * PrevSign = 1;
     */
    mlfAssign(&PrevSign, _mxarray7_);
    /*
     * for i=1:length(x)-1
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mlfScalar(mclLengthInt(mclVa(x, "x")) - 1));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray8_);
        } else {
            /*
             * NextSign = sign(x(i+1)-x(i));
             * 
             * % do we have a minimum?
             * if (PrevSign<0 & NextSign>0 & x(i)<LessThan)
             * nMins = nMins+1;
             * Mins(nMins) = i;
             * end
             * 
             * % reset PrevSign, if we are not in equality situation
             * if NextSign
             * PrevSign=NextSign;
             * end
             * end
             */
            for (; ; ) {
                mlfAssign(
                  &NextSign,
                  mlfSign(
                    mclMinus(
                      mclVe(mclIntArrayRef1(mclVsa(x, "x"), v_ + 1)),
                      mclVe(mclIntArrayRef1(mclVsa(x, "x"), v_)))));
                {
                    mxArray * a_ = mclInitialize(
                                     mclLt(
                                       mclVv(PrevSign, "PrevSign"),
                                       _mxarray5_));
                    if (mlfTobool(a_)) {
                        mlfAssign(
                          &a_,
                          mclAnd(
                            a_,
                            mclGt(mclVv(NextSign, "NextSign"), _mxarray5_)));
                    } else {
                        mlfAssign(&a_, mlfScalar(0));
                    }
                    if (mlfTobool(a_)
                        && mlfTobool(
                             mclAnd(
                               a_,
                               mclLt(
                                 mclVe(mclIntArrayRef1(mclVsa(x, "x"), v_)),
                                 mclVa(LessThan, "LessThan"))))) {
                        mxDestroyArray(a_);
                        mlfAssign(
                          &nMins, mclPlus(mclVv(nMins, "nMins"), _mxarray7_));
                        mclArrayAssign1(
                          &Mins, mlfScalar(v_), mclVsv(nMins, "nMins"));
                    } else {
                        mxDestroyArray(a_);
                    }
                }
                if (mlfTobool(mclVv(NextSign, "NextSign"))) {
                    mlfAssign(&PrevSign, mclVsv(NextSign, "NextSign"));
                }
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&i, mlfScalar(v_));
        }
    }
    /*
     * 
     * % use only those we have
     * if nMins<ArraySize
     */
    if (mclLtBool(mclVv(nMins, "nMins"), mclVv(ArraySize, "ArraySize"))) {
        /*
         * Mins(nMins+1:ArraySize) = [];
         */
        mlfIndexDelete(
          &Mins,
          "(?)",
          mlfColon(
            mclPlus(mclVv(nMins, "nMins"), _mxarray7_),
            mclVv(ArraySize, "ArraySize"),
            NULL));
    /*
     * end
     */
    }
    /*
     * 
     * % look for duplicates    
     * 
     * if nargin>=2
     */
    if (nargin_ >= 2) {
        /*
         * while 1
         */
        while (mlfTobool(_mxarray7_)) {
            /*
             * TooClose = find(diff(Mins)<NotCloserThan);
             */
            mlfAssign(
              &TooClose,
              mlfFind(
                NULL,
                NULL,
                mclLt(
                  mclVe(mlfDiff(mclVv(Mins, "Mins"), NULL, NULL)),
                  mclVa(NotCloserThan, "NotCloserThan"))));
            /*
             * if isempty(TooClose)
             */
            if (mlfTobool(mclVe(mlfIsempty(mclVv(TooClose, "TooClose"))))) {
                /*
                 * break;
                 */
                break;
            /*
             * end
             */
            }
            /*
             * Vals = x(Mins(TooClose:TooClose+1));
             */
            mlfAssign(
              &Vals,
              mclArrayRef1(
                mclVsa(x, "x"),
                mclArrayRef1(
                  mclVsv(Mins, "Mins"),
                  mlfColon(
                    mclVv(TooClose, "TooClose"),
                    mclPlus(mclVv(TooClose, "TooClose"), _mxarray7_),
                    NULL))));
            /*
             * [dummy Offset] = max(Vals,[],2);
             */
            mlfAssign(
              &dummy,
              mlfMax(&Offset, mclVv(Vals, "Vals"), _mxarray8_, _mxarray9_));
            /*
             * Delete = TooClose + Offset -1;
             */
            mlfAssign(
              &Delete,
              mclMinus(
                mclPlus(mclVv(TooClose, "TooClose"), mclVv(Offset, "Offset")),
                _mxarray7_));
            /*
             * Mins(unique(Delete)) = [];
             */
            mlfIndexDelete(
              &Mins,
              "(?)",
              mlfNUnique(1, NULL, NULL, mclVv(Delete, "Delete"), NULL));
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
     * return
     */
    goto return_;
    /*
     * 
     * 
     * nPoints = length(x);
     * 
     * % use a trick to save memory - with findstr
     * s = int8([1 sign(diff(x))]);
     * 
     * 
     * Zeros = find(s==0);
     * NonZeros = uint32(find(s~=0));
     * 
     * % wipe zeros ... 
     * s(Zeros) = [];
     * 
     * %mins = find(s(1:nPoints-1)==-1 & s(2:end)==1);
     * mins = double(NonZeros(findstr(s, [-1 1])));
     * 
     * if nargin>=3
     * mins = mins(find(x(mins)<LessThan));
     * end
     * 
     * if nargin>=2
     * while 1
     * TooClose = find(diff(mins)<NotCloserThan);
     * if isempty(TooClose)
     * break;
     * end
     * Vals = x(mins(TooClose:TooClose+1));
     * [dummy Offset] = max(Vals,[],2);
     * Delete = TooClose + Offset -1;
     * mins(unique(Delete)) = [];
     * end
     * end
     */
    return_:
    mclValidateOutput(Mins, 1, nargout_, "Mins", "LocalMinima");
    mxDestroyArray(nPoints);
    mxDestroyArray(nMins);
    mxDestroyArray(ArraySize);
    mxDestroyArray(PrevSign);
    mxDestroyArray(i);
    mxDestroyArray(NextSign);
    mxDestroyArray(TooClose);
    mxDestroyArray(Vals);
    mxDestroyArray(dummy);
    mxDestroyArray(Offset);
    mxDestroyArray(Delete);
    mxDestroyArray(s);
    mxDestroyArray(Zeros);
    mxDestroyArray(NonZeros);
    mxDestroyArray(mins);
    mxDestroyArray(LessThan);
    mxDestroyArray(NotCloserThan);
    mxDestroyArray(x);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return Mins;
}
