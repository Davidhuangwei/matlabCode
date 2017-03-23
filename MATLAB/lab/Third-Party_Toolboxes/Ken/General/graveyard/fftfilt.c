/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:22 2000
 * Arguments: "-mw" "mtcsd" 
 */
#include "fftfilt.h"

static double __Array0_r[20]
  = { 18.0,
      59.0,
      138.0,
      303.0,
      660.0,
      1441.0,
      3150.0,
      6875.0,
      14952.0,
      32373.0,
      69762.0,
      149647.0,
      319644.0,
      680105.0,
      1441974.0,
      3047619.0,
      6422736.0,
      13500637.0,
      28311786.0,
      59244791.0 };

/*
 * The function "Mfftfilt" is the implementation version of the "fftfilt"
 * M-function from file "/u4/local/matlab/toolbox/signal/signal/fftfilt.m"
 * (lines 1-129). It contains the actual compiled code for that M-function. It
 * is a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function y = fftfilt(b,x,nfft)
 */
static mxArray * Mfftfilt(int nargout_,
                          mxArray * b,
                          mxArray * x,
                          mxArray * nfft) {
    mxArray * y = mclGetUninitializedArray();
    mxArray * B = mclGetUninitializedArray();
    mxArray * L = mclGetUninitializedArray();
    mxArray * X = mclGetUninitializedArray();
    mxArray * Y = mclGetUninitializedArray();
    mxArray * dum = mclGetUninitializedArray();
    mxArray * fftflops = mclGetUninitializedArray();
    mxArray * iend = mclGetUninitializedArray();
    mxArray * ind = mclGetUninitializedArray();
    mxArray * istart = mclGetUninitializedArray();
    mxArray * m = mclGetUninitializedArray();
    mxArray * n = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * nb = mclGetUninitializedArray();
    mxArray * nx = mclGetUninitializedArray();
    mxArray * validset = mclGetUninitializedArray();
    mxArray * yend = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, b, x, nfft, NULL));
    mclValidateInputs("fftfilt", 3, &b, &x, &nfft);
    mclCopyArray(&b);
    mclCopyArray(&x);
    mclCopyArray(&nfft);
    /*
     * %FFTFILT Overlap-add method of FIR filtering using FFT.
     * %   Y = FFTFILT(B,X) filters X with the FIR filter B using
     * %   the overlap/add method, using internal parameters (FFT
     * %   size and block length) which guarantee efficient execution.
     * %   
     * %   Y = FFTFILT(B,X,N) allows you to have some control over the
     * %   internal parameters, by using an FFT of at least N points.
     * %
     * %   If X is a matrix, FFTFILT filters its columns.  If B is a matrix,
     * %   FFTFILT applies the filter in each column of B to the signal vector X.
     * %   If B and X are both matrices with the same number of columns, then
     * %   the i-th column of B is used to filter the i-th column of X.
     * %
     * %   See also FILTER, FILTFILT.
     * %
     * %   --- Algorithmic details ---
     * %   The overlap/add algorithm convolves B with blocks of X, and adds
     * %   the overlapping output blocks.  It uses the FFT to compute the
     * %   convolution.
     * %
     * %   Particularly for short filters and long signals, this algorithm is 
     * %   MUCH faster than the equivalent numeric function FILTER(B,1,X).
     * %
     * %   Y = FFTFILT(B,X) -- If you leave N unspecified:   (RECOMMENDED)
     * %       Usually, length(X) > length(B).  Here, FFTFILT chooses an FFT 
     * %       length (N) and block length (L) which minimize the number of 
     * %       flops required for a length-N FFT times the number of blocks
     * %       ceil(length(X)/L).  
     * %       If length(X) <= length(B), FFTFILT uses a single FFT of length
     * %       nfft = 2^nextpow2(length(B)+length(X)-1), essentially computing 
     * %       ifft(fft(B,nfft).*fft(X,nfft)).
     * %
     * %   Y = FFTFILT(B,X,N) -- If you specify N:
     * %       In this case, N must be at least length(B); if it isn't, FFTFILT 
     * %       sets N to length(B).  Then, FFTFILT uses an FFT of length 
     * %       nfft = 2^nextpow2(N), and block length L = nfft - length(B) + 1. 
     * %       CAUTION: this can be VERY inefficient, if L ends up being small.
     * 
     * %   Author(s): L. Shure, 7-27-88
     * %              L. Shure, 4-25-90, revised
     * %              T. Krauss, 1-14-94, revised
     * %   Copyright (c) 1988-1999 The MathWorks, Inc. All Rights Reserved.
     * %   $Revision: 1.4 $  $Date: 1999/01/11 19:03:03 $
     * 
     * %   Reference:
     * %      A.V. Oppenheim and R.W. Schafer, Digital Signal 
     * %      Processing, Prentice-Hall, 1975.
     * 
     * disp(nargchk(2,3,nargin))
     */
    mlfDisp(mlfNargchk(mlfScalar(2.0), mlfScalar(3.0), nargin_));
    /*
     * 
     * [m,n] = size(x);
     */
    mlfSize(mlfVarargout(&m, &n, NULL), x, NULL);
    /*
     * if m == 1
     */
    if (mlfTobool(mlfEq(m, mlfScalar(1.0)))) {
        /*
         * x = x(:);    % turn row into a column
         */
        mlfAssign(&x, mlfIndexRef(x, "(?)", mlfCreateColonIndex()));
    /*
     * end
     */
    }
    /*
     * 
     * nx = size(x,1);
     */
    mlfAssign(&nx, mlfSize(mclValueVarargout(), x, mlfScalar(1.0)));
    /*
     * 
     * if min(size(b))>1
     */
    if (mlfTobool(
          mlfGt(
            mlfMin(NULL, mlfSize(mclValueVarargout(), b, NULL), NULL, NULL),
            mlfScalar(1.0)))) {
        /*
         * if (size(b,2)~=size(x,2))&(size(x,2)>1)
         */
        mxArray * a_ = mclInitialize(
                         mlfNe(
                           mlfSize(mclValueVarargout(), b, mlfScalar(2.0)),
                           mlfSize(mclValueVarargout(), x, mlfScalar(2.0))));
        if (mlfTobool(a_)
            && mlfTobool(
                 mlfAnd(
                   a_,
                   mlfGt(
                     mlfSize(mclValueVarargout(), x, mlfScalar(2.0)),
                     mlfScalar(1.0))))) {
            mxDestroyArray(a_);
            /*
             * error('Filter matrix B must have same number of columns as X.')
             */
            mlfError(
              mxCreateString(
                "Filter matrix B must have same number of columns as X."));
        } else {
            mxDestroyArray(a_);
        }
    /*
     * end
     * else
     */
    } else {
        /*
         * b = b(:);   % make input a column
         */
        mlfAssign(&b, mlfIndexRef(b, "(?)", mlfCreateColonIndex()));
    /*
     * end
     */
    }
    /*
     * nb = size(b,1);
     */
    mlfAssign(&nb, mlfSize(mclValueVarargout(), b, mlfScalar(1.0)));
    /*
     * 
     * if nargin < 3
     */
    if (mlfTobool(mlfLt(nargin_, mlfScalar(3.0)))) {
        /*
         * % figure out which nfft and L to use
         * if nb >= nx     % take a single FFT in this case
         */
        if (mlfTobool(mlfGe(nb, nx))) {
            /*
             * nfft = 2^nextpow2(nb+nx-1);
             */
            mlfAssign(
              &nfft,
              mlfMpower(
                mlfScalar(2.0),
                mlfNextpow2(mlfMinus(mlfPlus(nb, nx), mlfScalar(1.0)))));
            /*
             * L = nx;
             */
            mlfAssign(&L, nx);
        /*
         * else
         */
        } else {
            /*
             * fftflops = [ 18 59 138 303 660 1441 3150 6875 14952 32373 69762 ...
             */
            mlfAssign(&fftflops, mlfDoubleMatrix(1, 20, __Array0_r, NULL));
            /*
             * 149647 319644 680105 1441974 3047619 6422736 13500637 28311786 59244791];
             * n = 2.^(1:20); 
             */
            mlfAssign(
              &n,
              mlfPower(
                mlfScalar(2.0),
                mlfColon(mlfScalar(1.0), mlfScalar(20.0), NULL)));
            /*
             * validset = find(n>(nb-1));   % must have nfft > (nb-1)
             */
            mlfAssign(
              &validset,
              mlfFind(NULL, NULL, mlfGt(n, mlfMinus(nb, mlfScalar(1.0)))));
            /*
             * n = n(validset); 
             */
            mlfAssign(&n, mlfIndexRef(n, "(?)", validset));
            /*
             * fftflops = fftflops(validset);
             */
            mlfAssign(&fftflops, mlfIndexRef(fftflops, "(?)", validset));
            /*
             * % minimize (number of blocks) * (number of flops per fft)
             * L = n - (nb - 1);
             */
            mlfAssign(&L, mlfMinus(n, mlfMinus(nb, mlfScalar(1.0))));
            /*
             * [dum,ind] = min( ceil(nx./L) .* fftflops );
             */
            mlfAssign(
              &dum,
              mlfMin(
                &ind,
                mlfTimes(mlfCeil(mlfRdivide(nx, L)), fftflops),
                NULL,
                NULL));
            /*
             * nfft = n(ind);
             */
            mlfAssign(&nfft, mlfIndexRef(n, "(?)", ind));
            /*
             * L = L(ind);
             */
            mlfAssign(&L, mlfIndexRef(L, "(?)", ind));
        /*
         * end
         */
        }
    /*
     * 
     * else  % nfft is given
     */
    } else {
        /*
         * if nfft < nb
         */
        if (mlfTobool(mlfLt(nfft, nb))) {
            /*
             * nfft = nb;
             */
            mlfAssign(&nfft, nb);
        /*
         * end
         */
        }
        /*
         * nfft = 2.^(ceil(log(nfft)/log(2))); % force this to a power of 2 for speed
         */
        mlfAssign(
          &nfft,
          mlfPower(
            mlfScalar(2.0),
            mlfCeil(mlfMrdivide(mlfLog(nfft), mlfLog(mlfScalar(2.0))))));
        /*
         * L = nfft - nb + 1;
         */
        mlfAssign(&L, mlfPlus(mlfMinus(nfft, nb), mlfScalar(1.0)));
    /*
     * end
     */
    }
    /*
     * 
     * B = fft(b,nfft);
     */
    mlfAssign(&B, mlfFft(b, nfft, NULL));
    /*
     * if length(b)==1,
     */
    if (mlfTobool(mlfEq(mlfLength(b), mlfScalar(1.0)))) {
        /*
         * B = B(:);  % make sure fft of B is a column (might be a row if b is scalar)
         */
        mlfAssign(&B, mlfIndexRef(B, "(?)", mlfCreateColonIndex()));
    /*
     * end
     */
    }
    /*
     * if size(b,2)==1
     */
    if (mlfTobool(
          mlfEq(
            mlfSize(mclValueVarargout(), b, mlfScalar(2.0)), mlfScalar(1.0)))) {
        /*
         * B = B(:,ones(1,size(x,2)));  % replicate the column B 
         */
        mlfAssign(
          &B,
          mlfIndexRef(
            B,
            "(?,?)",
            mlfCreateColonIndex(),
            mlfOnes(
              mlfScalar(1.0),
              mlfSize(mclValueVarargout(), x, mlfScalar(2.0)),
              NULL)));
    /*
     * end
     */
    }
    /*
     * if size(x,2)==1
     */
    if (mlfTobool(
          mlfEq(
            mlfSize(mclValueVarargout(), x, mlfScalar(2.0)), mlfScalar(1.0)))) {
        /*
         * x = x(:,ones(1,size(b,2)));  % replicate the column x 
         */
        mlfAssign(
          &x,
          mlfIndexRef(
            x,
            "(?,?)",
            mlfCreateColonIndex(),
            mlfOnes(
              mlfScalar(1.0),
              mlfSize(mclValueVarargout(), b, mlfScalar(2.0)),
              NULL)));
    /*
     * end
     */
    }
    /*
     * y = zeros(size(x));
     */
    mlfAssign(&y, mlfZeros(mlfSize(mclValueVarargout(), x, NULL), NULL));
    /*
     * 
     * istart = 1;
     */
    mlfAssign(&istart, mlfScalar(1.0));
    /*
     * while istart <= nx
     */
    while (mlfTobool(mlfLe(istart, nx))) {
        /*
         * iend = min(istart+L-1,nx);
         */
        mlfAssign(
          &iend,
          mlfMin(NULL, mlfMinus(mlfPlus(istart, L), mlfScalar(1.0)), nx, NULL));
        /*
         * if (iend - istart) == 0
         */
        if (mlfTobool(mlfEq(mlfMinus(iend, istart), mlfScalar(0.0)))) {
            /*
             * X = x(istart(ones(nfft,1)),:);  % need to fft a scalar
             */
            mlfAssign(
              &X,
              mlfIndexRef(
                x,
                "(?,?)",
                mlfIndexRef(istart, "(?)", mlfOnes(nfft, mlfScalar(1.0), NULL)),
                mlfCreateColonIndex()));
        /*
         * else
         */
        } else {
            /*
             * X = fft(x(istart:iend,:),nfft);
             */
            mlfAssign(
              &X,
              mlfFft(
                mlfIndexRef(
                  x,
                  "(?,?)",
                  mlfColon(istart, iend, NULL),
                  mlfCreateColonIndex()),
                nfft,
                NULL));
        /*
         * end
         */
        }
        /*
         * Y = ifft(X.*B);
         */
        mlfAssign(&Y, mlfIfft(mlfTimes(X, B), NULL, NULL));
        /*
         * yend = min(nx,istart+nfft-1);
         */
        mlfAssign(
          &yend,
          mlfMin(
            NULL, nx, mlfMinus(mlfPlus(istart, nfft), mlfScalar(1.0)), NULL));
        /*
         * y(istart:yend,:) = y(istart:yend,:) + Y(1:(yend-istart+1),:);
         */
        mlfIndexAssign(
          &y,
          "(?,?)",
          mlfColon(istart, yend, NULL),
          mlfCreateColonIndex(),
          mlfPlus(
            mlfIndexRef(
              y, "(?,?)", mlfColon(istart, yend, NULL), mlfCreateColonIndex()),
            mlfIndexRef(
              Y,
              "(?,?)",
              mlfColon(
                mlfScalar(1.0),
                mlfPlus(mlfMinus(yend, istart), mlfScalar(1.0)),
                NULL),
              mlfCreateColonIndex())));
        /*
         * istart = istart + L;
         */
        mlfAssign(&istart, mlfPlus(istart, L));
    /*
     * end
     */
    }
    /*
     * 
     * if ~any(imag(b)) & ~any(imag(x))
     */
    {
        mxArray * a_ = mclInitialize(mlfNot(mlfAny(mlfImag(b), NULL)));
        if (mlfTobool(a_)
            && mlfTobool(mlfAnd(a_, mlfNot(mlfAny(mlfImag(x), NULL))))) {
            mxDestroyArray(a_);
            /*
             * y = real(y);
             */
            mlfAssign(&y, mlfReal(y));
        } else {
            mxDestroyArray(a_);
        }
    /*
     * end
     */
    }
    /*
     * 
     * if (m == 1)&(size(y,2) == 1)
     */
    {
        mxArray * a_ = mclInitialize(mlfEq(m, mlfScalar(1.0)));
        if (mlfTobool(a_)
            && mlfTobool(
                 mlfAnd(
                   a_,
                   mlfEq(
                     mlfSize(mclValueVarargout(), y, mlfScalar(2.0)),
                     mlfScalar(1.0))))) {
            mxDestroyArray(a_);
            /*
             * y = y(:).';    % turn column back into a row
             */
            mlfAssign(
              &y, mlfTranspose(mlfIndexRef(y, "(?)", mlfCreateColonIndex())));
        } else {
            mxDestroyArray(a_);
        }
    /*
     * end
     */
    }
    mclValidateOutputs("fftfilt", 1, nargout_, &y);
    mxDestroyArray(B);
    mxDestroyArray(L);
    mxDestroyArray(X);
    mxDestroyArray(Y);
    mxDestroyArray(b);
    mxDestroyArray(dum);
    mxDestroyArray(fftflops);
    mxDestroyArray(iend);
    mxDestroyArray(ind);
    mxDestroyArray(istart);
    mxDestroyArray(m);
    mxDestroyArray(n);
    mxDestroyArray(nargin_);
    mxDestroyArray(nb);
    mxDestroyArray(nfft);
    mxDestroyArray(nx);
    mxDestroyArray(validset);
    mxDestroyArray(x);
    mxDestroyArray(yend);
    /*
     * 
     */
    return y;
}

/*
 * The function "mlfFftfilt" contains the normal interface for the "fftfilt"
 * M-function from file "/u4/local/matlab/toolbox/signal/signal/fftfilt.m"
 * (lines 1-129). This function processes any input arguments and passes them
 * to the implementation version of the function, appearing above.
 */
mxArray * mlfFftfilt(mxArray * b, mxArray * x, mxArray * nfft) {
    int nargout = 1;
    mxArray * y = mclGetUninitializedArray();
    mlfEnterNewContext(0, 3, b, x, nfft);
    y = Mfftfilt(nargout, b, x, nfft);
    mlfRestorePreviousContext(0, 3, b, x, nfft);
    return mlfReturnValue(y);
}

/*
 * The function "mlxFftfilt" contains the feval interface for the "fftfilt"
 * M-function from file "/u4/local/matlab/toolbox/signal/signal/fftfilt.m"
 * (lines 1-129). The feval function calls the implementation version of
 * fftfilt through this function. This function processes any input arguments
 * and passes them to the implementation version of the function, appearing
 * above.
 */
void mlxFftfilt(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: fftfilt Line: 1 Column: "
            "0 The function \"fftfilt\" was called with mor"
            "e than the declared number of outputs (1)"));
    }
    if (nrhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: fftfilt Line: 1 Column:"
            " 0 The function \"fftfilt\" was called with m"
            "ore than the declared number of inputs (3)"));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 3 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 3; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    mplhs[0] = Mfftfilt(nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
}
