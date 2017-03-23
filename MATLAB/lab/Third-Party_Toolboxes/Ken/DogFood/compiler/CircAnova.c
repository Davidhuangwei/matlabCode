/*
 * MATLAB Compiler: 2.2
 * Date: Wed Dec 12 11:34:20 2001
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "-h" "-w" "CircAnova" 
 */
#include "CircAnova.h"
#include "Quantile.h"
#include "iscell.h"
#include "libmatlbm.h"
#include "mean.h"
#include "randperm.h"

static mxChar _array1_[137] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'C', 'i', 'r', 'c', 'A',
                                'n', 'o', 'v', 'a', ' ', 'L', 'i', 'n', 'e',
                                ':', ' ', '1', '5', ' ', 'C', 'o', 'l', 'u',
                                'm', 'n', ':', ' ', '1', ' ', 'T', 'h', 'e',
                                ' ', 'f', 'u', 'n', 'c', 't', 'i', 'o', 'n',
                                ' ', '"', 'C', 'i', 'r', 'c', 'A', 'n', 'o',
                                'v', 'a', '"', ' ', 'w', 'a', 's', ' ', 'c',
                                'a', 'l', 'l', 'e', 'd', ' ', 'w', 'i', 't',
                                'h', ' ', 'm', 'o', 'r', 'e', ' ', 't', 'h',
                                'a', 'n', ' ', 't', 'h', 'e', ' ', 'd', 'e',
                                'c', 'l', 'a', 'r', 'e', 'd', ' ', 'n', 'u',
                                'm', 'b', 'e', 'r', ' ', 'o', 'f', ' ', 'o',
                                'u', 't', 'p', 'u', 't', 's', ' ', '(', '1',
                                ')', '.' };
static mxArray * _mxarray0_;

static mxChar _array3_[136] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'C', 'i', 'r', 'c', 'A',
                                'n', 'o', 'v', 'a', ' ', 'L', 'i', 'n', 'e',
                                ':', ' ', '1', '5', ' ', 'C', 'o', 'l', 'u',
                                'm', 'n', ':', ' ', '1', ' ', 'T', 'h', 'e',
                                ' ', 'f', 'u', 'n', 'c', 't', 'i', 'o', 'n',
                                ' ', '"', 'C', 'i', 'r', 'c', 'A', 'n', 'o',
                                'v', 'a', '"', ' ', 'w', 'a', 's', ' ', 'c',
                                'a', 'l', 'l', 'e', 'd', ' ', 'w', 'i', 't',
                                'h', ' ', 'm', 'o', 'r', 'e', ' ', 't', 'h',
                                'a', 'n', ' ', 't', 'h', 'e', ' ', 'd', 'e',
                                'c', 'l', 'a', 'r', 'e', 'd', ' ', 'n', 'u',
                                'm', 'b', 'e', 'r', ' ', 'o', 'f', ' ', 'i',
                                'n', 'p', 'u', 't', 's', ' ', '(', '3', ')',
                                '.' };
static mxArray * _mxarray2_;

static mxChar _array5_[149] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'C', 'i', 'r', 'c', 'A',
                                'n', 'o', 'v', 'a', '/', 'r', 'e', 's', 'i',
                                'd', ' ', 'L', 'i', 'n', 'e', ':', ' ', '5',
                                '4', ' ', 'C', 'o', 'l', 'u', 'm', 'n', ':',
                                ' ', '1', ' ', 'T', 'h', 'e', ' ', 'f', 'u',
                                'n', 'c', 't', 'i', 'o', 'n', ' ', '"', 'C',
                                'i', 'r', 'c', 'A', 'n', 'o', 'v', 'a', '/',
                                'r', 'e', 's', 'i', 'd', '"', ' ', 'w', 'a',
                                's', ' ', 'c', 'a', 'l', 'l', 'e', 'd', ' ',
                                'w', 'i', 't', 'h', ' ', 'm', 'o', 'r', 'e',
                                ' ', 't', 'h', 'a', 'n', ' ', 't', 'h', 'e',
                                ' ', 'd', 'e', 'c', 'l', 'a', 'r', 'e', 'd',
                                ' ', 'n', 'u', 'm', 'b', 'e', 'r', ' ', 'o',
                                'f', ' ', 'o', 'u', 't', 'p', 'u', 't', 's',
                                ' ', '(', '1', ')', '.' };
static mxArray * _mxarray4_;

static mxChar _array7_[148] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'C', 'i', 'r', 'c', 'A',
                                'n', 'o', 'v', 'a', '/', 'r', 'e', 's', 'i',
                                'd', ' ', 'L', 'i', 'n', 'e', ':', ' ', '5',
                                '4', ' ', 'C', 'o', 'l', 'u', 'm', 'n', ':',
                                ' ', '1', ' ', 'T', 'h', 'e', ' ', 'f', 'u',
                                'n', 'c', 't', 'i', 'o', 'n', ' ', '"', 'C',
                                'i', 'r', 'c', 'A', 'n', 'o', 'v', 'a', '/',
                                'r', 'e', 's', 'i', 'd', '"', ' ', 'w', 'a',
                                's', ' ', 'c', 'a', 'l', 'l', 'e', 'd', ' ',
                                'w', 'i', 't', 'h', ' ', 'm', 'o', 'r', 'e',
                                ' ', 't', 'h', 'a', 'n', ' ', 't', 'h', 'e',
                                ' ', 'd', 'e', 'c', 'l', 'a', 'r', 'e', 'd',
                                ' ', 'n', 'u', 'm', 'b', 'e', 'r', ' ', 'o',
                                'f', ' ', 'i', 'n', 'p', 'u', 't', 's', ' ',
                                '(', '2', ')', '.' };
static mxArray * _mxarray6_;
static mxArray * _mxarray8_;
static mxArray * _mxarray9_;
static mxArray * _mxarray10_;
static mxArray * _mxarray11_;
static mxArray * _mxarray12_;

void InitializeModule_CircAnova(void) {
    _mxarray0_ = mclInitializeString(137, _array1_);
    _mxarray2_ = mclInitializeString(136, _array3_);
    _mxarray4_ = mclInitializeString(149, _array5_);
    _mxarray6_ = mclInitializeString(148, _array7_);
    _mxarray8_ = mclInitializeDouble(1000.0);
    _mxarray9_ = mclInitializeDoubleVector(0, 0, (double *)NULL);
    _mxarray10_ = mclInitializeDouble(1.0);
    _mxarray11_ = mclInitializeComplex(0.0, 1.0);
    _mxarray12_ = mclInitializeDouble(0.0);
}

void TerminateModule_CircAnova(void) {
    mxDestroyArray(_mxarray12_);
    mxDestroyArray(_mxarray11_);
    mxDestroyArray(_mxarray10_);
    mxDestroyArray(_mxarray9_);
    mxDestroyArray(_mxarray8_);
    mxDestroyArray(_mxarray6_);
    mxDestroyArray(_mxarray4_);
    mxDestroyArray(_mxarray2_);
    mxDestroyArray(_mxarray0_);
}

static mxArray * mlfCircAnova_resid(mxArray * ExpAng, mxArray * Gp);
static void mlxCircAnova_resid(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]);
static mxArray * MCircAnova(int nargout_,
                            mxArray * Arg1,
                            mxArray * Arg2,
                            mxArray * Arg3);
static mxArray * MCircAnova_resid(int nargout_, mxArray * ExpAng, mxArray * Gp);

static mexFunctionTableEntry local_function_table_[1]
  = { { "resid", mlxCircAnova_resid, 2, 1, NULL } };

_mexLocalFunctionTable _local_function_table_CircAnova
  = { 1, local_function_table_ };

/*
 * The function "mlfCircAnova" contains the normal interface for the
 * "CircAnova" M-function from file
 * "/u12/ken/matlab/DogFood/compiler/CircAnova.m" (lines 1-54). This function
 * processes any input arguments and passes them to the implementation version
 * of the function, appearing above.
 */
mxArray * mlfCircAnova(mxArray * Arg1, mxArray * Arg2, mxArray * Arg3) {
    int nargout = 1;
    mxArray * p = mclGetUninitializedArray();
    mlfEnterNewContext(0, 3, Arg1, Arg2, Arg3);
    p = MCircAnova(nargout, Arg1, Arg2, Arg3);
    mlfRestorePreviousContext(0, 3, Arg1, Arg2, Arg3);
    return mlfReturnValue(p);
}

/*
 * The function "mlxCircAnova" contains the feval interface for the "CircAnova"
 * M-function from file "/u12/ken/matlab/DogFood/compiler/CircAnova.m" (lines
 * 1-54). The feval function calls the implementation version of CircAnova
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxCircAnova(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
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
    mplhs[0] = MCircAnova(nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
}

/*
 * The function "mlfCircAnova_resid" contains the normal interface for the
 * "CircAnova/resid" M-function from file
 * "/u12/ken/matlab/DogFood/compiler/CircAnova.m" (lines 54-61). This function
 * processes any input arguments and passes them to the implementation version
 * of the function, appearing above.
 */
static mxArray * mlfCircAnova_resid(mxArray * ExpAng, mxArray * Gp) {
    int nargout = 1;
    mxArray * r = mclGetUninitializedArray();
    mlfEnterNewContext(0, 2, ExpAng, Gp);
    r = MCircAnova_resid(nargout, ExpAng, Gp);
    mlfRestorePreviousContext(0, 2, ExpAng, Gp);
    return mlfReturnValue(r);
}

/*
 * The function "mlxCircAnova_resid" contains the feval interface for the
 * "CircAnova/resid" M-function from file
 * "/u12/ken/matlab/DogFood/compiler/CircAnova.m" (lines 54-61). The feval
 * function calls the implementation version of CircAnova/resid through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
static void mlxCircAnova_resid(int nlhs,
                               mxArray * plhs[],
                               int nrhs,
                               mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(_mxarray4_);
    }
    if (nrhs > 2) {
        mlfError(_mxarray6_);
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
    mplhs[0] = MCircAnova_resid(nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
    plhs[0] = mplhs[0];
}

/*
 * The function "MCircAnova" is the implementation version of the "CircAnova"
 * M-function from file "/u12/ken/matlab/DogFood/compiler/CircAnova.m" (lines
 * 1-54). It contains the actual compiled code for that M-function. It is a
 * static function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * % Circular ANOVA with significance calculated from 
 * % randomization method
 * % 
 * % p = CircAnova(Th, Gp)
 * % or 
 * % p = CircAnova({Th1, Th2, Th3, ...})
 * %
 * % computes mean angles for each group and residual sum as
 * % sum(cos(th-pred))
 * %
 * % significance is calculated by randomizing groups
 * %
 * % CircAnova(..., nRands) specifies number of randomizations.
 * 
 * function p = CircAnova(Arg1, Arg2, Arg3)
 */
static mxArray * MCircAnova(int nargout_,
                            mxArray * Arg1,
                            mxArray * Arg2,
                            mxArray * Arg3) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_CircAnova);
    int nargin_ = mclNargin(3, Arg1, Arg2, Arg3, NULL);
    mxArray * p = mclGetUninitializedArray();
    mxArray * r = mclGetUninitializedArray();
    mxArray * i = mclGetUninitializedArray();
    mxArray * N = mclGetUninitializedArray();
    mxArray * r0 = mclGetUninitializedArray();
    mxArray * ExpAng = mclGetUninitializedArray();
    mxArray * g = mclGetUninitializedArray();
    mxArray * Gp = mclGetUninitializedArray();
    mxArray * Th = mclGetUninitializedArray();
    mxArray * nGps = mclGetUninitializedArray();
    mxArray * nRands = mclGetUninitializedArray();
    mclCopyArray(&Arg1);
    mclCopyArray(&Arg2);
    mclCopyArray(&Arg3);
    /*
     * 
     * nRands = 1000; % default value
     */
    mlfAssign(&nRands, _mxarray8_);
    /*
     * 
     * % deal with argument form 2
     * if iscell(Arg1)
     */
    if (mlfTobool(mclVe(mlfIscell(mclVa(Arg1, "Arg1"))))) {
        /*
         * nGps = length(Arg1);
         */
        mlfAssign(&nGps, mlfScalar(mclLengthInt(mclVa(Arg1, "Arg1"))));
        /*
         * 
         * Th = []; Gp = [];
         */
        mlfAssign(&Th, _mxarray9_);
        mlfAssign(&Gp, _mxarray9_);
        /*
         * for g=1:nGps
         */
        {
            int v_ = mclForIntStart(1);
            int e_ = mclForIntEnd(mclVv(nGps, "nGps"));
            if (v_ > e_) {
                mlfAssign(&g, _mxarray9_);
            } else {
                /*
                 * Th = [Th ; Arg1{g}(:)];
                 * Gp = [Gp ; g*ones(length(Arg1{g}),1)];
                 * end
                 */
                for (; ; ) {
                    mlfAssign(
                      &Th,
                      mlfVertcat(
                        mclVv(Th, "Th"),
                        mclVe(
                          mlfIndexRef(
                            mclVsa(Arg1, "Arg1"),
                            "{?}(?)",
                            mlfScalar(v_),
                            mlfCreateColonIndex())),
                        NULL));
                    mlfAssign(
                      &Gp,
                      mlfVertcat(
                        mclVv(Gp, "Gp"),
                        mclMtimes(
                          mlfScalar(v_),
                          mclVe(
                            mlfOnes(
                              mclVe(
                                mclFeval(
                                  mclValueVarargout(),
                                  mlxLength,
                                  mclVe(
                                    mlfIndexRef(
                                      mclVsa(Arg1, "Arg1"),
                                      "{?}",
                                      mlfScalar(v_))),
                                  NULL)),
                              _mxarray10_,
                              NULL))),
                        NULL));
                    if (v_ == e_) {
                        break;
                    }
                    ++v_;
                }
                mlfAssign(&g, mlfScalar(v_));
            }
        }
        /*
         * if nargin==2
         */
        if (nargin_ == 2) {
            /*
             * nRands = Arg2;
             */
            mlfAssign(&nRands, mclVsa(Arg2, "Arg2"));
        /*
         * end
         */
        }
    /*
     * else
     */
    } else {
        /*
         * Th = Arg1;
         */
        mlfAssign(&Th, mclVsa(Arg1, "Arg1"));
        /*
         * Gp = Arg2;
         */
        mlfAssign(&Gp, mclVsa(Arg2, "Arg2"));
        /*
         * nGps = max(Gp);
         */
        mlfAssign(&nGps, mlfMax(NULL, mclVv(Gp, "Gp"), NULL, NULL));
        /*
         * if nargin==3
         */
        if (nargin_ == 3) {
            /*
             * nRands = Arg3;
             */
            mlfAssign(&nRands, mclVsa(Arg3, "Arg3"));
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
     * ExpAng = exp(j*Th);
     */
    mlfAssign(&ExpAng, mlfExp(mclMtimes(_mxarray11_, mclVv(Th, "Th"))));
    /*
     * 
     * r0 = resid(ExpAng, Gp);
     */
    mlfAssign(
      &r0, mlfCircAnova_resid(mclVv(ExpAng, "ExpAng"), mclVv(Gp, "Gp")));
    /*
     * N = length(Th);
     */
    mlfAssign(&N, mlfScalar(mclLengthInt(mclVv(Th, "Th"))));
    /*
     * for i=1:nRands
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVv(nRands, "nRands"));
        if (v_ > e_) {
            mlfAssign(&i, _mxarray9_);
        } else {
            /*
             * p = randperm(N);
             * r(i) = resid(ExpAng, Gp(p));
             * end
             */
            for (; ; ) {
                mlfAssign(&p, mlfRandperm(mclVv(N, "N")));
                mclIntArrayAssign1(
                  &r,
                  mlfCircAnova_resid(
                    mclVv(ExpAng, "ExpAng"),
                    mclVe(mclArrayRef1(mclVsv(Gp, "Gp"), mclVsv(p, "p")))),
                  v_);
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
     * p = 1-Quantile(r, r0);
     */
    mlfAssign(
      &p,
      mclMinus(
        _mxarray10_, mclVe(mlfQuantile(mclVv(r, "r"), mclVv(r0, "r0")))));
    mclValidateOutput(p, 1, nargout_, "p", "CircAnova");
    mxDestroyArray(nRands);
    mxDestroyArray(nGps);
    mxDestroyArray(Th);
    mxDestroyArray(Gp);
    mxDestroyArray(g);
    mxDestroyArray(ExpAng);
    mxDestroyArray(r0);
    mxDestroyArray(N);
    mxDestroyArray(i);
    mxDestroyArray(r);
    mxDestroyArray(Arg3);
    mxDestroyArray(Arg2);
    mxDestroyArray(Arg1);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return p;
    /*
     * 
     * % hold off; hist(r, 100);
     * % hold on; plot([r0 r0], ylim, 'r');
     * 
     */
}

/*
 * The function "MCircAnova_resid" is the implementation version of the
 * "CircAnova/resid" M-function from file
 * "/u12/ken/matlab/DogFood/compiler/CircAnova.m" (lines 54-61). It contains
 * the actual compiled code for that M-function. It is a static function and
 * must only be called from one of the interface functions, appearing below.
 */
/*
 * function r = resid(ExpAng, Gp)
 */
static mxArray * MCircAnova_resid(int nargout_,
                                  mxArray * ExpAng,
                                  mxArray * Gp) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_CircAnova);
    mxArray * r = mclGetUninitializedArray();
    mxArray * mu0 = mclGetUninitializedArray();
    mxArray * mu = mclGetUninitializedArray();
    mxArray * My = mclGetUninitializedArray();
    mxArray * g = mclGetUninitializedArray();
    mclCopyArray(&ExpAng);
    mclCopyArray(&Gp);
    /*
     * 
     * r = 0;
     */
    mlfAssign(&r, _mxarray12_);
    /*
     * for g=1:max(Gp)
     */
    {
        int v_ = mclForIntStart(1);
        int e_ = mclForIntEnd(mclVe(mlfMax(NULL, mclVa(Gp, "Gp"), NULL, NULL)));
        if (v_ > e_) {
            mlfAssign(&g, _mxarray9_);
        } else {
            /*
             * My = ExpAng(find(Gp==g));
             * mu = mean(My); mu0 = mu/abs(mu);
             * r = r + sum(real(My./mu0));
             * end
             */
            for (; ; ) {
                mlfAssign(
                  &My,
                  mclArrayRef1(
                    mclVsa(ExpAng, "ExpAng"),
                    mlfFind(
                      NULL, NULL, mclEq(mclVa(Gp, "Gp"), mlfScalar(v_)))));
                mlfAssign(&mu, mlfMean(mclVv(My, "My"), NULL));
                mlfAssign(
                  &mu0,
                  mclMrdivide(mclVv(mu, "mu"), mclVe(mlfAbs(mclVv(mu, "mu")))));
                mlfAssign(
                  &r,
                  mclPlus(
                    mclVv(r, "r"),
                    mclVe(
                      mlfSum(
                        mclVe(
                          mlfReal(
                            mclRdivide(mclVv(My, "My"), mclVv(mu0, "mu0")))),
                        NULL))));
                if (v_ == e_) {
                    break;
                }
                ++v_;
            }
            mlfAssign(&g, mlfScalar(v_));
        }
    }
    mclValidateOutput(r, 1, nargout_, "r", "CircAnova/resid");
    mxDestroyArray(g);
    mxDestroyArray(My);
    mxDestroyArray(mu);
    mxDestroyArray(mu0);
    mxDestroyArray(Gp);
    mxDestroyArray(ExpAng);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
    return r;
}
