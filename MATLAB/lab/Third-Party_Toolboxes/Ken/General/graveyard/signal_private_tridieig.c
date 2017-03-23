/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:22 2000
 * Arguments: "-mw" "mtcsd" 
 */
#include "signal_private_tridieig.h"

/*
 * The function "Msignal_private_tridieig" is the implementation version of the
 * "signal/private/tridieig" M-function from file
 * "/u4/local/matlab/toolbox/signal/signal/private/tridieig.m" (lines 1-82). It
 * contains the actual compiled code for that M-function. It is a static
 * function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function x = tridieig(c,b,m1,m2,eps1);
 */
static mxArray * Msignal_private_tridieig(int nargout_,
                                          mxArray * c,
                                          mxArray * b,
                                          mxArray * m1,
                                          mxArray * m2,
                                          mxArray * eps1) {
    mxArray * x = mclGetUninitializedArray();
    mxArray * a = mclGetUninitializedArray();
    mxArray * beta = mclGetUninitializedArray();
    mxArray * eps2 = mclGetUninitializedArray();
    mxArray * i = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mclForLoopIterator iterator_1;
    mxArray * k = mclGetUninitializedArray();
    mxArray * n = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * q = mclGetUninitializedArray();
    mxArray * s = mclGetUninitializedArray();
    mxArray * wu = mclGetUninitializedArray();
    mxArray * x0 = mclGetUninitializedArray();
    mxArray * x1 = mclGetUninitializedArray();
    mxArray * xmax = mclGetUninitializedArray();
    mxArray * xmin = mclGetUninitializedArray();
    mxArray * xu = mclGetUninitializedArray();
    mxArray * z = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, c, b, m1, m2, eps1, NULL));
    mclValidateInputs("signal/private/tridieig", 5, &c, &b, &m1, &m2, &eps1);
    mclCopyArray(&b);
    mclCopyArray(&eps1);
    /*
     * %TRIDIEIG  Find a few eigenvalues of a tridiagonal matrix.
     * %   LAMBDA = TRIDIEIG(D,E,M1,M2).  D and E, two vectors of length N,
     * %   define a symmetric, tridiagonal matrix:
     * %      A = diag(E(2:N),-1) + diag(D,0) + diag(E(2:N),1)
     * %   E(1) is ignored.
     * %   TRIDIEIG(D,E,M1,M2) computes the eigenvalues of A with indices
     * %      M1 <= K <= M2.
     * %   TRIDIEIG(D,E,M1,M2,TOL) uses TOL as a tolerance.
     * %
     * %   See also TRIDISOLVE.
     * 
     * %   Author: C. Moler
     * %   Copyright (c) 1988-1999 The MathWorks, Inc. All Rights Reserved.
     * % $Revision: 1.3 $
     * 
     * %   Mex-file version will be called if on the path.
     * 
     * %mbrealvector(c);
     * %mbrealvector(b);
     * %mbintscalar(m1);
     * %mbintscalar(m2);
     * %mbrealscalar(eps1)
     * if nargin < 5, eps1 = 0; end
     */
    if (mlfTobool(mlfLt(nargin_, mlfScalar(5.0)))) {
        mlfAssign(&eps1, mlfScalar(0.0));
    }
    /*
     * n = length(c);
     */
    mlfAssign(&n, mlfLength(c));
    /*
     * b(1) = 0;
     */
    mlfIndexAssign(&b, "(?)", mlfScalar(1.0), mlfScalar(0.0));
    /*
     * beta = b.*b;
     */
    mlfAssign(&beta, mlfTimes(b, b));
    /*
     * xmin = min(c(n) - abs(b(n)),min(c(1:n-1) - abs(b(1:n-1)) - abs(b(2:n))));
     */
    mlfAssign(
      &xmin,
      mlfMin(
        NULL,
        mlfMinus(mlfIndexRef(c, "(?)", n), mlfAbs(mlfIndexRef(b, "(?)", n))),
        mlfMin(
          NULL,
          mlfMinus(
            mlfMinus(
              mlfIndexRef(
                c,
                "(?)",
                mlfColon(mlfScalar(1.0), mlfMinus(n, mlfScalar(1.0)), NULL)),
              mlfAbs(
                mlfIndexRef(
                  b,
                  "(?)",
                  mlfColon(
                    mlfScalar(1.0), mlfMinus(n, mlfScalar(1.0)), NULL)))),
            mlfAbs(mlfIndexRef(b, "(?)", mlfColon(mlfScalar(2.0), n, NULL)))),
          NULL,
          NULL),
        NULL));
    /*
     * xmax = max(c(n) + abs(b(n)),max(c(1:n-1) + abs(b(1:n-1)) + abs(b(2:n))));
     */
    mlfAssign(
      &xmax,
      mlfMax(
        NULL,
        mlfPlus(mlfIndexRef(c, "(?)", n), mlfAbs(mlfIndexRef(b, "(?)", n))),
        mlfMax(
          NULL,
          mlfPlus(
            mlfPlus(
              mlfIndexRef(
                c,
                "(?)",
                mlfColon(mlfScalar(1.0), mlfMinus(n, mlfScalar(1.0)), NULL)),
              mlfAbs(
                mlfIndexRef(
                  b,
                  "(?)",
                  mlfColon(
                    mlfScalar(1.0), mlfMinus(n, mlfScalar(1.0)), NULL)))),
            mlfAbs(mlfIndexRef(b, "(?)", mlfColon(mlfScalar(2.0), n, NULL)))),
          NULL,
          NULL),
        NULL));
    /*
     * eps2 = eps*max(xmax,-xmin);
     */
    mlfAssign(
      &eps2, mlfMtimes(mlfEps(), mlfMax(NULL, xmax, mlfUminus(xmin), NULL)));
    /*
     * if eps1 <= 0, eps1 = eps2; end
     */
    if (mlfTobool(mlfLe(eps1, mlfScalar(0.0)))) {
        mlfAssign(&eps1, eps2);
    }
    /*
     * eps2 = 0.5*eps1 + 7*eps2;
     */
    mlfAssign(
      &eps2,
      mlfPlus(
        mlfMtimes(mlfScalar(0.5), eps1), mlfMtimes(mlfScalar(7.0), eps2)));
    /*
     * 
     * x0 = xmax;
     */
    mlfAssign(&x0, xmax);
    /*
     * x = zeros(n,1);
     */
    mlfAssign(&x, mlfZeros(n, mlfScalar(1.0), NULL));
    /*
     * wu = zeros(n,1);
     */
    mlfAssign(&wu, mlfZeros(n, mlfScalar(1.0), NULL));
    /*
     * x(m1:m2) = xmax(ones(m2-m1+1,1));
     */
    mlfIndexAssign(
      &x,
      "(?)",
      mlfColon(m1, m2, NULL),
      mlfIndexRef(
        xmax,
        "(?)",
        mlfOnes(
          mlfPlus(mlfMinus(m2, m1), mlfScalar(1.0)), mlfScalar(1.0), NULL)));
    /*
     * wu(m1:m2) = xmin(ones(m2-m1+1,1));
     */
    mlfIndexAssign(
      &wu,
      "(?)",
      mlfColon(m1, m2, NULL),
      mlfIndexRef(
        xmin,
        "(?)",
        mlfOnes(
          mlfPlus(mlfMinus(m2, m1), mlfScalar(1.0)), mlfScalar(1.0), NULL)));
    /*
     * z = 0;
     */
    mlfAssign(&z, mlfScalar(0.0));
    /*
     * for k = m2:-1:m1
     */
    for (mclForStart(&iterator_0, m2, mlfScalar(-1.0), m1);
         mclForNext(&iterator_0, &k);
         ) {
        /*
         * xu = xmin;
         */
        mlfAssign(&xu, xmin);
        /*
         * for i = k:-1:m1
         */
        for (mclForStart(&iterator_1, k, mlfScalar(-1.0), m1);
             mclForNext(&iterator_1, &i);
             ) {
            /*
             * if xu < wu(i)
             */
            if (mlfTobool(mlfLt(xu, mlfIndexRef(wu, "(?)", i)))) {
                /*
                 * xu = wu(i);
                 */
                mlfAssign(&xu, mlfIndexRef(wu, "(?)", i));
                /*
                 * break
                 */
                mclDestroyForLoopIterator(&iterator_1);
                break;
            /*
             * end
             */
            }
        /*
         * end
         */
        }
        /*
         * if x0 > x(k), x0 = x(k); end
         */
        if (mlfTobool(mlfGt(x0, mlfIndexRef(x, "(?)", k)))) {
            mlfAssign(&x0, mlfIndexRef(x, "(?)", k));
        }
        /*
         * while 1
         */
        while (mlfTobool(mlfScalar(1.0))) {
            /*
             * x1 = (xu + x0)/2;
             */
            mlfAssign(&x1, mlfMrdivide(mlfPlus(xu, x0), mlfScalar(2.0)));
            /*
             * if x0 - xu <= 2*eps*(abs(xu)+abs(x0)) + eps1
             */
            if (mlfTobool(
                  mlfLe(
                    mlfMinus(x0, xu),
                    mlfPlus(
                      mlfMtimes(
                        mlfMtimes(mlfScalar(2.0), mlfEps()),
                        mlfPlus(mlfAbs(xu), mlfAbs(x0))),
                      eps1)))) {
                /*
                 * break
                 */
                mclDestroyForLoopIterator(&iterator_0);
                break;
            /*
             * end
             */
            }
            /*
             * z = z + 1;
             */
            mlfAssign(&z, mlfPlus(z, mlfScalar(1.0)));
            /*
             * a = 0;
             */
            mlfAssign(&a, mlfScalar(0.0));
            /*
             * q = 1;
             */
            mlfAssign(&q, mlfScalar(1.0));
            /*
             * for i = 1:n
             */
            for (mclForStart(&iterator_1, mlfScalar(1.0), n, NULL);
                 mclForNext(&iterator_1, &i);
                 ) {
                /*
                 * if q ~= 0
                 */
                if (mlfTobool(mlfNe(q, mlfScalar(0.0)))) {
                    /*
                     * s = beta(i)/q;
                     */
                    mlfAssign(&s, mlfMrdivide(mlfIndexRef(beta, "(?)", i), q));
                /*
                 * else
                 */
                } else {
                    /*
                     * s = abs(b(i))/eps;
                     */
                    mlfAssign(
                      &s,
                      mlfMrdivide(mlfAbs(mlfIndexRef(b, "(?)", i)), mlfEps()));
                /*
                 * end
                 */
                }
                /*
                 * q = c(i) - x1 - s;
                 */
                mlfAssign(
                  &q, mlfMinus(mlfMinus(mlfIndexRef(c, "(?)", i), x1), s));
                /*
                 * a = a + (q < 0);
                 */
                mlfAssign(&a, mlfPlus(a, mlfLt(q, mlfScalar(0.0))));
            /*
             * end
             */
            }
            /*
             * if a < k
             */
            if (mlfTobool(mlfLt(a, k))) {
                /*
                 * if a < m1
                 */
                if (mlfTobool(mlfLt(a, m1))) {
                    /*
                     * xu = x1;
                     */
                    mlfAssign(&xu, x1);
                    /*
                     * wu(m1) = x1;
                     */
                    mlfIndexAssign(&wu, "(?)", m1, x1);
                /*
                 * else
                 */
                } else {
                    /*
                     * xu = x1;
                     */
                    mlfAssign(&xu, x1);
                    /*
                     * wu(a+1) = x1;
                     */
                    mlfIndexAssign(&wu, "(?)", mlfPlus(a, mlfScalar(1.0)), x1);
                    /*
                     * if x(a) > x1, x(a) = x1; end
                     */
                    if (mlfTobool(mlfGt(mlfIndexRef(x, "(?)", a), x1))) {
                        mlfIndexAssign(&x, "(?)", a, x1);
                    }
                /*
                 * end
                 */
                }
            /*
             * else
             */
            } else {
                /*
                 * x0 = x1;
                 */
                mlfAssign(&x0, x1);
            /*
             * end
             */
            }
        /*
         * end
         */
        }
        /*
         * x(k) = (x0 + xu)/2;
         */
        mlfIndexAssign(
          &x, "(?)", k, mlfMrdivide(mlfPlus(x0, xu), mlfScalar(2.0)));
    /*
     * end
     */
    }
    /*
     * x = x(m1:m2)';
     */
    mlfAssign(&x, mlfCtranspose(mlfIndexRef(x, "(?)", mlfColon(m1, m2, NULL))));
    mclValidateOutputs("signal/private/tridieig", 1, nargout_, &x);
    mxDestroyArray(a);
    mxDestroyArray(b);
    mxDestroyArray(beta);
    mxDestroyArray(eps1);
    mxDestroyArray(eps2);
    mxDestroyArray(i);
    mxDestroyArray(k);
    mxDestroyArray(n);
    mxDestroyArray(nargin_);
    mxDestroyArray(q);
    mxDestroyArray(s);
    mxDestroyArray(wu);
    mxDestroyArray(x0);
    mxDestroyArray(x1);
    mxDestroyArray(xmax);
    mxDestroyArray(xmin);
    mxDestroyArray(xu);
    mxDestroyArray(z);
    return x;
}

/*
 * The function "mlfSignal_private_tridieig" contains the normal interface for
 * the "signal/private/tridieig" M-function from file
 * "/u4/local/matlab/toolbox/signal/signal/private/tridieig.m" (lines 1-82).
 * This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
mxArray * mlfSignal_private_tridieig(mxArray * c,
                                     mxArray * b,
                                     mxArray * m1,
                                     mxArray * m2,
                                     mxArray * eps1) {
    int nargout = 1;
    mxArray * x = mclGetUninitializedArray();
    mlfEnterNewContext(0, 5, c, b, m1, m2, eps1);
    x = Msignal_private_tridieig(nargout, c, b, m1, m2, eps1);
    mlfRestorePreviousContext(0, 5, c, b, m1, m2, eps1);
    return mlfReturnValue(x);
}

/*
 * The function "mlxSignal_private_tridieig" contains the feval interface for
 * the "signal/private/tridieig" M-function from file
 * "/u4/local/matlab/toolbox/signal/signal/private/tridieig.m" (lines 1-82).
 * The feval function calls the implementation version of
 * signal/private/tridieig through this function. This function processes any
 * input arguments and passes them to the implementation version of the
 * function, appearing above.
 */
void mlxSignal_private_tridieig(int nlhs,
                                mxArray * plhs[],
                                int nrhs,
                                mxArray * prhs[]) {
    mxArray * mprhs[5];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: signal/private/tridieig Line: 1 Co"
            "lumn: 0 The function \"signal/private/tridieig\" was cal"
            "led with more than the declared number of outputs (1)"));
    }
    if (nrhs > 5) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: signal/private/tridieig Line: 1 Co"
            "lumn: 0 The function \"signal/private/tridieig\" was cal"
            "led with more than the declared number of inputs (5)"));
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
      = Msignal_private_tridieig(
          nlhs, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    mlfRestorePreviousContext(
      0, 5, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    plhs[0] = mplhs[0];
}
