/*
 * MATLAB Compiler: 2.2
 * Date: Wed Dec 12 11:05:47 2001
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "-h" "-w" "CircAnova" 
 */
#include "circmean.h"
#include "angle.h"
#include "libmatlbm.h"

static mxChar _array1_[134] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'c', 'i', 'r', 'c', 'm',
                                'e', 'a', 'n', ' ', 'L', 'i', 'n', 'e', ':',
                                ' ', '7', ' ', 'C', 'o', 'l', 'u', 'm', 'n',
                                ':', ' ', '1', ' ', 'T', 'h', 'e', ' ', 'f',
                                'u', 'n', 'c', 't', 'i', 'o', 'n', ' ', '"',
                                'c', 'i', 'r', 'c', 'm', 'e', 'a', 'n', '"',
                                ' ', 'w', 'a', 's', ' ', 'c', 'a', 'l', 'l',
                                'e', 'd', ' ', 'w', 'i', 't', 'h', ' ', 'm',
                                'o', 'r', 'e', ' ', 't', 'h', 'a', 'n', ' ',
                                't', 'h', 'e', ' ', 'd', 'e', 'c', 'l', 'a',
                                'r', 'e', 'd', ' ', 'n', 'u', 'm', 'b', 'e',
                                'r', ' ', 'o', 'f', ' ', 'o', 'u', 't', 'p',
                                'u', 't', 's', ' ', '(', '2', ')', '.' };
static mxArray * _mxarray0_;

static mxChar _array3_[133] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'c', 'i', 'r', 'c', 'm',
                                'e', 'a', 'n', ' ', 'L', 'i', 'n', 'e', ':',
                                ' ', '7', ' ', 'C', 'o', 'l', 'u', 'm', 'n',
                                ':', ' ', '1', ' ', 'T', 'h', 'e', ' ', 'f',
                                'u', 'n', 'c', 't', 'i', 'o', 'n', ' ', '"',
                                'c', 'i', 'r', 'c', 'm', 'e', 'a', 'n', '"',
                                ' ', 'w', 'a', 's', ' ', 'c', 'a', 'l', 'l',
                                'e', 'd', ' ', 'w', 'i', 't', 'h', ' ', 'm',
                                'o', 'r', 'e', ' ', 't', 'h', 'a', 'n', ' ',
                                't', 'h', 'e', ' ', 'd', 'e', 'c', 'l', 'a',
                                'r', 'e', 'd', ' ', 'n', 'u', 'm', 'b', 'e',
                                'r', ' ', 'o', 'f', ' ', 'i', 'n', 'p', 'u',
                                't', 's', ' ', '(', '1', ')', '.' };
static mxArray * _mxarray2_;
static mxArray * _mxarray4_;
static mxArray * _mxarray5_;

void InitializeModule_circmean(void) {
    _mxarray0_ = mclInitializeString(134, _array1_);
    _mxarray2_ = mclInitializeString(133, _array3_);
    _mxarray4_ = mclInitializeDouble(0.0);
    _mxarray5_ = mclInitializeComplex(0.0, 1.0);
}

void TerminateModule_circmean(void) {
    mxDestroyArray(_mxarray5_);
    mxDestroyArray(_mxarray4_);
    mxDestroyArray(_mxarray2_);
    mxDestroyArray(_mxarray0_);
}

static mxArray * Mcircmean(mxArray * * r, int nargout_, mxArray * data_rad);

_mexLocalFunctionTable _local_function_table_circmean
  = { 0, (mexFunctionTableEntry *)NULL };

/*
 * The function "mlfCircmean" contains the normal interface for the "circmean"
 * M-function from file "/u5/b/ken/matlab/DogFood/circmean.m" (lines 1-25).
 * This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfCircmean(mxArray * * r, mxArray * data_rad) {
    int nargout = 1;
    mxArray * theta = mclGetUninitializedArray();
    mxArray * r__ = mclGetUninitializedArray();
    mlfEnterNewContext(1, 1, r, data_rad);
    if (r != NULL) {
        ++nargout;
    }
    theta = Mcircmean(&r__, nargout, data_rad);
    mlfRestorePreviousContext(1, 1, r, data_rad);
    if (r != NULL) {
        mclCopyOutputArg(r, r__);
    } else {
        mxDestroyArray(r__);
    }
    return mlfReturnValue(theta);
}

/*
 * The function "mlxCircmean" contains the feval interface for the "circmean"
 * M-function from file "/u5/b/ken/matlab/DogFood/circmean.m" (lines 1-25). The
 * feval function calls the implementation version of circmean through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxCircmean(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    mxArray * mplhs[2];
    int i;
    if (nlhs > 2) {
        mlfError(_mxarray0_);
    }
    if (nrhs > 1) {
        mlfError(_mxarray2_);
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
    mplhs[0] = Mcircmean(&mplhs[1], nlhs, mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 2 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 2; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "Mcircmean" is the implementation version of the "circmean"
 * M-function from file "/u5/b/ken/matlab/DogFood/circmean.m" (lines 1-25). It
 * contains the actual compiled code for that M-function. It is a static
 * function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * % cirmean - calculates mean phase and radius of a given
 * %           circular statistics
 * %
 * % function [theta, r]  = circmean(data);
 * % (data has to be in the unit of radians)
 * 
 * function [theta, r]  = circmean(data_rad);
 */
static mxArray * Mcircmean(mxArray * * r, int nargout_, mxArray * data_rad) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_circmean);
    mxArray * theta = mclGetUninitializedArray();
    mxArray * datas = mclGetUninitializedArray();
    mxArray * datai = mclGetUninitializedArray();
    mxArray * data = mclGetUninitializedArray();
    mclCopyArray(&data_rad);
    /*
     * 
     * % convert the data into complex represenation
     * 
     * if length(data_rad)==0
     */
    if (mclLengthInt(mclVa(data_rad, "data_rad")) == 0) {
        /*
         * theta = 0;
         */
        mlfAssign(&theta, _mxarray4_);
        /*
         * r = 0;
         */
        mlfAssign(r, _mxarray4_);
        /*
         * return;
         */
        goto return_;
    /*
     * end
     */
    }
    /*
     * 
     * data = data_rad(find(~isnan(data_rad)));
     */
    mlfAssign(
      &data,
      mclArrayRef1(
        mclVsa(data_rad, "data_rad"),
        mlfFind(
          NULL, NULL, mclNot(mclVe(mlfIsnan(mclVa(data_rad, "data_rad")))))));
    /*
     * 
     * datai = exp(data * i);
     */
    mlfAssign(&datai, mlfExp(mclMtimes(mclVv(data, "data"), _mxarray5_)));
    /*
     * 
     * datas = sum(datai);
     */
    mlfAssign(&datas, mlfSum(mclVv(datai, "datai"), NULL));
    /*
     * r = abs(datas)/length(data);
     */
    mlfAssign(
      r,
      mclMrdivide(
        mclVe(mlfAbs(mclVv(datas, "datas"))),
        mlfScalar(mclLengthInt(mclVv(data, "data")))));
    /*
     * theta = angle(datas);
     */
    mlfAssign(&theta, mlfAngle(mclVv(datas, "datas")));
    /*
     * 
     */
    return_:
    mclValidateOutput(theta, 1, nargout_, "theta", "circmean");
    mclValidateOutput(*r, 2, nargout_, "r", "circmean");
    mxDestroyArray(data);
    mxDestroyArray(datai);
    mxDestroyArray(datas);
    mxDestroyArray(data_rad);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return theta;
}
