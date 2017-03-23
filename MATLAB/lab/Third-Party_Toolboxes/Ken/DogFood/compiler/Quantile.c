/*
 * MATLAB Compiler: 2.2
 * Date: Wed Dec 12 11:34:20 2001
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "-h" "-w" "CircAnova" 
 */
#include "Quantile.h"
#include "libmatlbm.h"

static mxChar _array1_[134] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'Q', 'u', 'a', 'n', 't',
                                'i', 'l', 'e', ' ', 'L', 'i', 'n', 'e', ':',
                                ' ', '7', ' ', 'C', 'o', 'l', 'u', 'm', 'n',
                                ':', ' ', '1', ' ', 'T', 'h', 'e', ' ', 'f',
                                'u', 'n', 'c', 't', 'i', 'o', 'n', ' ', '"',
                                'Q', 'u', 'a', 'n', 't', 'i', 'l', 'e', '"',
                                ' ', 'w', 'a', 's', ' ', 'c', 'a', 'l', 'l',
                                'e', 'd', ' ', 'w', 'i', 't', 'h', ' ', 'm',
                                'o', 'r', 'e', ' ', 't', 'h', 'a', 'n', ' ',
                                't', 'h', 'e', ' ', 'd', 'e', 'c', 'l', 'a',
                                'r', 'e', 'd', ' ', 'n', 'u', 'm', 'b', 'e',
                                'r', ' ', 'o', 'f', ' ', 'o', 'u', 't', 'p',
                                'u', 't', 's', ' ', '(', '1', ')', '.' };
static mxArray * _mxarray0_;

static mxChar _array3_[133] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'Q', 'u', 'a', 'n', 't',
                                'i', 'l', 'e', ' ', 'L', 'i', 'n', 'e', ':',
                                ' ', '7', ' ', 'C', 'o', 'l', 'u', 'm', 'n',
                                ':', ' ', '1', ' ', 'T', 'h', 'e', ' ', 'f',
                                'u', 'n', 'c', 't', 'i', 'o', 'n', ' ', '"',
                                'Q', 'u', 'a', 'n', 't', 'i', 'l', 'e', '"',
                                ' ', 'w', 'a', 's', ' ', 'c', 'a', 'l', 'l',
                                'e', 'd', ' ', 'w', 'i', 't', 'h', ' ', 'm',
                                'o', 'r', 'e', ' ', 't', 'h', 'a', 'n', ' ',
                                't', 'h', 'e', ' ', 'd', 'e', 'c', 'l', 'a',
                                'r', 'e', 'd', ' ', 'n', 'u', 'm', 'b', 'e',
                                'r', ' ', 'o', 'f', ' ', 'i', 'n', 'p', 'u',
                                't', 's', ' ', '(', '2', ')', '.' };
static mxArray * _mxarray2_;
static mxArray * _mxarray4_;
static double _ieee_nan_;
static mxArray * _mxarray5_;

void InitializeModule_Quantile(void) {
    _mxarray0_ = mclInitializeString(134, _array1_);
    _mxarray2_ = mclInitializeString(133, _array3_);
    _mxarray4_ = mclInitializeDouble(1.0);
    _ieee_nan_ = mclGetNaN();
    _mxarray5_ = mclInitializeDouble(_ieee_nan_);
}

void TerminateModule_Quantile(void) {
    mxDestroyArray(_mxarray5_);
    mxDestroyArray(_mxarray4_);
    mxDestroyArray(_mxarray2_);
    mxDestroyArray(_mxarray0_);
}

static mxArray * MQuantile(int nargout_, mxArray * X, mxArray * y);

_mexLocalFunctionTable _local_function_table_Quantile
  = { 0, (mexFunctionTableEntry *)NULL };

/*
 * The function "mlfQuantile" contains the normal interface for the "Quantile"
 * M-function from file "/u5/b/ken/matlab/General/Quantile.m" (lines 1-28).
 * This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfQuantile(mxArray * X, mxArray * y) {
    int nargout = 1;
    mxArray * q = mclGetUninitializedArray();
    mlfEnterNewContext(0, 2, X, y);
    q = MQuantile(nargout, X, y);
    mlfRestorePreviousContext(0, 2, X, y);
    return mlfReturnValue(q);
}

/*
 * The function "mlxQuantile" contains the feval interface for the "Quantile"
 * M-function from file "/u5/b/ken/matlab/General/Quantile.m" (lines 1-28). The
 * feval function calls the implementation version of Quantile through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxQuantile(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(_mxarray0_);
    }
    if (nrhs > 2) {
        mlfError(_mxarray2_);
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
    mplhs[0] = MQuantile(nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
    plhs[0] = mplhs[0];
}

/*
 * The function "MQuantile" is the implementation version of the "Quantile"
 * M-function from file "/u5/b/ken/matlab/General/Quantile.m" (lines 1-28). It
 * contains the actual compiled code for that M-function. It is a static
 * function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * % Quantile(X, y)
 * %
 * % Computes the quantiles that show how the values in y are distributed 
 * % relative to the distribution of X.  So if X was a sample from N(0,1),
 * % and y was 0, the answer would be 0.5.
 * 
 * function q = Quantile(X, y)
 */
static mxArray * MQuantile(int nargout_, mxArray * X, mxArray * y) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_Quantile);
    mxArray * q = mclGetUninitializedArray();
    mxArray * qAll = mclGetUninitializedArray();
    mxArray * CumDist = mclGetUninitializedArray();
    mxArray * Index = mclGetUninitializedArray();
    mxArray * Sorted = mclGetUninitializedArray();
    mxArray * Label = mclGetUninitializedArray();
    mxArray * ToSort = mclGetUninitializedArray();
    mxArray * ny = mclGetUninitializedArray();
    mxArray * nX = mclGetUninitializedArray();
    mclCopyArray(&X);
    mclCopyArray(&y);
    /*
     * 
     * % remove Nans from X
     * X(find(isnan(X))) = [];
     */
    mlfIndexDelete(
      &X, "(?)", mlfFind(NULL, NULL, mclVe(mlfIsnan(mclVa(X, "X")))));
    /*
     * 
     * nX = length(X);
     */
    mlfAssign(&nX, mlfScalar(mclLengthInt(mclVa(X, "X"))));
    /*
     * ny = length(y);
     */
    mlfAssign(&ny, mlfScalar(mclLengthInt(mclVa(y, "y"))));
    /*
     * 
     * ToSort = [X(:) ; y(:)];
     */
    mlfAssign(
      &ToSort,
      mlfVertcat(
        mclVe(mclArrayRef1(mclVsa(X, "X"), mlfCreateColonIndex())),
        mclVe(mclArrayRef1(mclVsa(y, "y"), mlfCreateColonIndex())),
        NULL));
    /*
     * 
     * Label = [ones(nX,1) ; zeros(ny,1)];
     */
    mlfAssign(
      &Label,
      mlfVertcat(
        mclVe(mlfOnes(mclVv(nX, "nX"), _mxarray4_, NULL)),
        mclVe(mlfZeros(mclVv(ny, "ny"), _mxarray4_, NULL)),
        NULL));
    /*
     * 
     * [Sorted Index] = sort(ToSort);
     */
    mlfAssign(&Sorted, mlfSort(&Index, mclVv(ToSort, "ToSort"), NULL));
    /*
     * 
     * CumDist = cumsum(Label(Index));
     */
    mlfAssign(
      &CumDist,
      mlfCumsum(
        mclVe(mclArrayRef1(mclVsv(Label, "Label"), mclVsv(Index, "Index"))),
        NULL));
    /*
     * 
     * qAll(Index) = CumDist/nX;
     */
    mclArrayAssign1(
      &qAll,
      mclMrdivide(mclVv(CumDist, "CumDist"), mclVv(nX, "nX")),
      mclVsv(Index, "Index"));
    /*
     * 
     * q = qAll(nX+1:end);
     */
    mlfAssign(
      &q,
      mclArrayRef1(
        mclVsv(qAll, "qAll"),
        mlfColon(
          mclPlus(mclVv(nX, "nX"), _mxarray4_),
          mlfEnd(mclVv(qAll, "qAll"), _mxarray4_, _mxarray4_),
          NULL)));
    /*
     * 
     * % don't allow NaNs through
     * q(find(isnan(y))) = NaN;
     */
    mclArrayAssign1(
      &q, _mxarray5_, mlfFind(NULL, NULL, mclVe(mlfIsnan(mclVa(y, "y")))));
    mclValidateOutput(q, 1, nargout_, "q", "Quantile");
    mxDestroyArray(nX);
    mxDestroyArray(ny);
    mxDestroyArray(ToSort);
    mxDestroyArray(Label);
    mxDestroyArray(Sorted);
    mxDestroyArray(Index);
    mxDestroyArray(CumDist);
    mxDestroyArray(qAll);
    mxDestroyArray(y);
    mxDestroyArray(X);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return q;
}
