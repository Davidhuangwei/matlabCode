/*
 * MATLAB Compiler: 2.0
 * Date: Tue Jul 20 15:43:34 1999
 * Arguments: "-v" "-x" "PointCorrel.m" "hist.m" 
 */
#include "hist.h"
#include "bar.h"
#include "histc.h"

/*
 * The function "Mhist" is the implementation version of the "hist" M-function
 * from file "/u5/b/ken/matlab/Spikes/hist.m" (lines 1-87). It contains the
 * actual compiled code for that M-function. It is a static function and must
 * only be called from one of the interface functions, appearing below.
 */
/*
 * function [no,xo] = hist(y,x)
 */
static mxArray * Mhist(mxArray * * xo, int nargout_, mxArray * y, mxArray * x) {
    mxArray * no = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * bins = mclGetUninitializedArray();
    mxArray * binwidth = mclGetUninitializedArray();
    mxArray * m = mclGetUninitializedArray();
    mxArray * maxy = mclGetUninitializedArray();
    mxArray * miny = mclGetUninitializedArray();
    mxArray * n = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * nargout = mclInitialize(mlfScalar(nargout_));
    mxArray * nbin = mclGetUninitializedArray();
    mxArray * nn = mclGetUninitializedArray();
    mxArray * xx = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, y, x, NULL));
    mclValidateInputs("hist", 2, &y, &x);
    mclCopyArray(&y);
    mclCopyArray(&x);
    /*
     * %HIST  Histogram.
     * %   N = HIST(Y) bins the elements of Y into 10 equally spaced containers
     * %   and returns the number of elements in each container.  If Y is a
     * %   matrix, HIST works down the columns.
     * %
     * %   N = HIST(Y,M), where M is a scalar, uses M bins.
     * %
     * %   N = HIST(Y,X), where X is a vector, returns the distribution of Y
     * %   among bins with centers specified by X.  Note: Use HISTC if it is
     * %   more natural to specify bin edges instead.
     * %
     * %   [N,X] = HIST(...) also returns the position of the bin centers in X.
     * %
     * %   HIST(...) without output arguments produces a histogram bar plot of
     * %   the results.
     * %
     * %   See also HISTC.
     * 
     * %   J.N. Little 2-06-86
     * %   Revised 10-29-87, 12-29-88 LS
     * %   Revised 8-13-91 by cmt, 2-3-92 by ls.
     * %   Copyright (c) 1984-98 by The MathWorks, Inc.
     * %   $Revision: 5.16 $  $Date: 1998/05/22 15:51:00 $
     * 
     * if nargin == 0
     */
    if (mlfTobool(mlfEq(nargin_, mlfScalar(0.0)))) {
        /*
         * error('Requires one or two input arguments.')
         */
        mlfError(mxCreateString("Requires one or two input arguments."));
    /*
     * end
     */
    }
    /*
     * if nargin == 1
     */
    if (mlfTobool(mlfEq(nargin_, mlfScalar(1.0)))) {
        /*
         * x = 10;
         */
        mlfAssign(&x, mlfScalar(10.0));
    /*
     * end
     */
    }
    /*
     * if min(size(y))==1, y = y(:); end
     */
    if (mlfTobool(
          mlfEq(
            mlfMin(NULL, mlfSize(mclValueVarargout(), y, NULL), NULL, NULL),
            mlfScalar(1.0)))) {
        mlfAssign(&y, mlfIndexRef(y, "(?)", mlfCreateColonIndex()));
    }
    /*
     * if isstr(x) | isstr(y)
     */
    {
        mxArray * a_ = mclInitialize(mlfIsstr(x));
        if (mlfTobool(a_) || mlfTobool(mlfOr(a_, mlfIsstr(y)))) {
            mxDestroyArray(a_);
            /*
             * error('Input arguments must be numeric.')
             */
            mlfError(mxCreateString("Input arguments must be numeric."));
        } else {
            mxDestroyArray(a_);
        }
    /*
     * end
     */
    }
    /*
     * 
     * [m,n] = size(y);
     */
    mlfSize(mlfVarargout(&m, &n, NULL), y, NULL);
    /*
     * if isempty(y),
     */
    if (mlfTobool(mlfIsempty(y))) {
        /*
         * if length(x) == 1,
         */
        if (mlfTobool(mlfEq(mlfLength(x), mlfScalar(1.0)))) {
            /*
             * x = 1:x;
             */
            mlfAssign(&x, mlfColon(mlfScalar(1.0), x, NULL));
        /*
         * end
         */
        }
        /*
         * nn = zeros(size(x)); % No elements to count
         */
        mlfAssign(&nn, mlfZeros(mlfSize(mclValueVarargout(), x, NULL), NULL));
    /*
     * else
     */
    } else {
        /*
         * if length(x) == 1
         */
        if (mlfTobool(mlfEq(mlfLength(x), mlfScalar(1.0)))) {
            /*
             * miny = min(min(y));
             */
            mlfAssign(
              &miny, mlfMin(NULL, mlfMin(NULL, y, NULL, NULL), NULL, NULL));
            /*
             * maxy = max(max(y));
             */
            mlfAssign(
              &maxy, mlfMax(NULL, mlfMax(NULL, y, NULL, NULL), NULL, NULL));
            /*
             * if miny == maxy,
             */
            if (mlfTobool(mlfEq(miny, maxy))) {
                /*
                 * miny = miny - floor(x/2) - 0.5; 
                 */
                mlfAssign(
                  &miny,
                  mlfMinus(
                    mlfMinus(miny, mlfFloor(mlfMrdivide(x, mlfScalar(2.0)))),
                    mlfScalar(0.5)));
                /*
                 * maxy = maxy + ceil(x/2) - 0.5;
                 */
                mlfAssign(
                  &maxy,
                  mlfMinus(
                    mlfPlus(maxy, mlfCeil(mlfMrdivide(x, mlfScalar(2.0)))),
                    mlfScalar(0.5)));
            /*
             * end
             */
            }
            /*
             * binwidth = (maxy - miny) ./ x;
             */
            mlfAssign(&binwidth, mlfRdivide(mlfMinus(maxy, miny), x));
            /*
             * xx = miny + binwidth*(0:x);
             */
            mlfAssign(
              &xx,
              mlfPlus(
                miny, mlfMtimes(binwidth, mlfColon(mlfScalar(0.0), x, NULL))));
            /*
             * xx(length(xx)) = maxy;
             */
            mlfIndexAssign(&xx, "(?)", mlfLength(xx), maxy);
            /*
             * x = xx(1:length(xx)-1) + binwidth/2;
             */
            mlfAssign(
              &x,
              mlfPlus(
                mlfIndexRef(
                  xx,
                  "(?)",
                  mlfColon(
                    mlfScalar(1.0),
                    mlfMinus(mlfLength(xx), mlfScalar(1.0)),
                    NULL)),
                mlfMrdivide(binwidth, mlfScalar(2.0))));
        /*
         * else
         */
        } else {
            /*
             * xx = x(:)';
             */
            mlfAssign(
              &xx, mlfCtranspose(mlfIndexRef(x, "(?)", mlfCreateColonIndex())));
            /*
             * miny = min(min(y));
             */
            mlfAssign(
              &miny, mlfMin(NULL, mlfMin(NULL, y, NULL, NULL), NULL, NULL));
            /*
             * maxy = max(max(y));
             */
            mlfAssign(
              &maxy, mlfMax(NULL, mlfMax(NULL, y, NULL, NULL), NULL, NULL));
            /*
             * binwidth = [diff(xx) 0];
             */
            mlfAssign(
              &binwidth,
              mlfHorzcat(mlfDiff(xx, NULL, NULL), mlfScalar(0.0), NULL));
            /*
             * xx = [xx(1)-binwidth(1)/2 xx+binwidth/2];
             */
            mlfAssign(
              &xx,
              mlfHorzcat(
                mlfMinus(
                  mlfIndexRef(xx, "(?)", mlfScalar(1.0)),
                  mlfMrdivide(
                    mlfIndexRef(binwidth, "(?)", mlfScalar(1.0)),
                    mlfScalar(2.0))),
                mlfPlus(xx, mlfMrdivide(binwidth, mlfScalar(2.0))),
                NULL));
            /*
             * xx(1) = min(xx(1),miny);
             */
            mlfIndexAssign(
              &xx,
              "(?)",
              mlfScalar(1.0),
              mlfMin(NULL, mlfIndexRef(xx, "(?)", mlfScalar(1.0)), miny, NULL));
            /*
             * xx(end) = max(xx(end),maxy);
             */
            mlfIndexAssign(
              &xx,
              "(?)",
              mlfEnd(xx, mlfScalar(1), mlfScalar(1)),
              mlfMax(
                NULL,
                mlfIndexRef(xx, "(?)", mlfEnd(xx, mlfScalar(1), mlfScalar(1))),
                maxy,
                NULL));
        /*
         * end
         */
        }
        /*
         * nbin = length(xx);
         */
        mlfAssign(&nbin, mlfLength(xx));
        /*
         * % Shift bins so the internal is ( ] instead of [ ).
         * xx = full(real(xx)); y = full(real(y)); % For compatibility
         */
        mlfAssign(&xx, mlfFull(mlfReal(xx)));
        mlfAssign(&y, mlfFull(mlfReal(y)));
        /*
         * bins = xx + max(eps,eps*abs(xx));
         */
        mlfAssign(
          &bins,
          mlfPlus(
            xx, mlfMax(NULL, mlfEps(), mlfMtimes(mlfEps(), mlfAbs(xx)), NULL)));
        /*
         * nn = histc(y,[-inf bins],1);
         */
        mlfAssign(
          &nn,
          mlfNHistc(
            0,
            mclValueVarargout(),
            y,
            mlfHorzcat(mlfUminus(mlfInf()), bins, NULL),
            mlfScalar(1.0),
            NULL));
        /*
         * 
         * % Combine first bin with 2nd bin and last bin with next to last bin
         * nn(2,:) = nn(2,:)+nn(1,:);
         */
        mlfIndexAssign(
          &nn,
          "(?,?)",
          mlfScalar(2.0),
          mlfCreateColonIndex(),
          mlfPlus(
            mlfIndexRef(nn, "(?,?)", mlfScalar(2.0), mlfCreateColonIndex()),
            mlfIndexRef(nn, "(?,?)", mlfScalar(1.0), mlfCreateColonIndex())));
        /*
         * nn(end-1,:) = nn(end-1,:)+nn(end,:);
         */
        mlfIndexAssign(
          &nn,
          "(?,?)",
          mlfMinus(mlfEnd(nn, mlfScalar(1), mlfScalar(2)), mlfScalar(1.0)),
          mlfCreateColonIndex(),
          mlfPlus(
            mlfIndexRef(
              nn,
              "(?,?)",
              mlfMinus(mlfEnd(nn, mlfScalar(1), mlfScalar(2)), mlfScalar(1.0)),
              mlfCreateColonIndex()),
            mlfIndexRef(
              nn,
              "(?,?)",
              mlfEnd(nn, mlfScalar(1), mlfScalar(2)),
              mlfCreateColonIndex())));
        /*
         * nn = nn(2:end-1,:);
         */
        mlfAssign(
          &nn,
          mlfIndexRef(
            nn,
            "(?,?)",
            mlfColon(
              mlfScalar(2.0),
              mlfMinus(mlfEnd(nn, mlfScalar(1), mlfScalar(2)), mlfScalar(1.0)),
              NULL),
            mlfCreateColonIndex()));
    /*
     * end
     */
    }
    /*
     * 
     * if nargout == 0
     */
    if (mlfTobool(mlfEq(nargout, mlfScalar(0.0)))) {
        /*
         * bar(x,nn,'hist');
         */
        mclAssignAns(
          &ans, mlfNBar(0, NULL, x, nn, mxCreateString("hist"), NULL));
    /*
     * else
     */
    } else {
        /*
         * if min(size(y))==1, % Return row vectors if possible.
         */
        if (mlfTobool(
              mlfEq(
                mlfMin(NULL, mlfSize(mclValueVarargout(), y, NULL), NULL, NULL),
                mlfScalar(1.0)))) {
            /*
             * no = nn';
             */
            mlfAssign(&no, mlfCtranspose(nn));
            /*
             * xo = x;
             */
            mlfAssign(xo, x);
        /*
         * else
         */
        } else {
            /*
             * no = nn;
             */
            mlfAssign(&no, nn);
            /*
             * xo = x';
             */
            mlfAssign(xo, mlfCtranspose(x));
        /*
         * end
         */
        }
    /*
     * end
     */
    }
    mclValidateOutputs("hist", 2, nargout_, &no, xo);
    mxDestroyArray(ans);
    mxDestroyArray(bins);
    mxDestroyArray(binwidth);
    mxDestroyArray(m);
    mxDestroyArray(maxy);
    mxDestroyArray(miny);
    mxDestroyArray(n);
    mxDestroyArray(nargin_);
    mxDestroyArray(nargout);
    mxDestroyArray(nbin);
    mxDestroyArray(nn);
    mxDestroyArray(x);
    mxDestroyArray(xx);
    mxDestroyArray(y);
    return no;
}

/*
 * The function "mlfNHist" contains the nargout interface for the "hist"
 * M-function from file "/u5/b/ken/matlab/Spikes/hist.m" (lines 1-87). This
 * interface is only produced if the M-function uses the special variable
 * "nargout". The nargout interface allows the number of requested outputs to
 * be specified via the nargout argument, as opposed to the normal interface
 * which dynamically calculates the number of outputs based on the number of
 * non-NULL inputs it receives. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
mxArray * mlfNHist(int nargout, mxArray * * xo, mxArray * y, mxArray * x) {
    mxArray * no = mclGetUninitializedArray();
    mxArray * xo__ = mclGetUninitializedArray();
    mlfEnterNewContext(1, 2, xo, y, x);
    no = Mhist(&xo__, nargout, y, x);
    mlfRestorePreviousContext(1, 2, xo, y, x);
    if (xo != NULL) {
        mclCopyOutputArg(xo, xo__);
    } else {
        mxDestroyArray(xo__);
    }
    return mlfReturnValue(no);
}

/*
 * The function "mlfHist" contains the normal interface for the "hist"
 * M-function from file "/u5/b/ken/matlab/Spikes/hist.m" (lines 1-87). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
mxArray * mlfHist(mxArray * * xo, mxArray * y, mxArray * x) {
    int nargout = 1;
    mxArray * no = mclGetUninitializedArray();
    mxArray * xo__ = mclGetUninitializedArray();
    mlfEnterNewContext(1, 2, xo, y, x);
    if (xo != NULL) {
        ++nargout;
    }
    no = Mhist(&xo__, nargout, y, x);
    mlfRestorePreviousContext(1, 2, xo, y, x);
    if (xo != NULL) {
        mclCopyOutputArg(xo, xo__);
    } else {
        mxDestroyArray(xo__);
    }
    return mlfReturnValue(no);
}

/*
 * The function "mlfVHist" contains the void interface for the "hist"
 * M-function from file "/u5/b/ken/matlab/Spikes/hist.m" (lines 1-87). The void
 * interface is only produced if the M-function uses the special variable
 * "nargout", and has at least one output. The void interface function
 * specifies zero output arguments to the implementation version of the
 * function, and in the event that the implementation version still returns an
 * output (which, in MATLAB, would be assigned to the "ans" variable), it
 * deallocates the output. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlfVHist(mxArray * y, mxArray * x) {
    mxArray * no = mclUnassigned();
    mxArray * xo = mclUnassigned();
    mlfEnterNewContext(0, 2, y, x);
    no = Mhist(&xo, 0, y, x);
    mlfRestorePreviousContext(0, 2, y, x);
    mxDestroyArray(no);
    mxDestroyArray(xo);
}

/*
 * The function "mlxHist" contains the feval interface for the "hist"
 * M-function from file "/u5/b/ken/matlab/Spikes/hist.m" (lines 1-87). The
 * feval function calls the implementation version of hist through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxHist(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[2];
    int i;
    if (nlhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hist Line: 1 Column: 0 The function \"hist\""
            " was called with more than the declared number of outputs (2)"));
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: hist Line: 1 Column: 0 The function \"hist"
            "\" was called with more than the declared number of inputs (2)"));
    }
    for (i = 0; i < 2; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 2 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 2; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 2, mprhs[0], mprhs[1]);
    mplhs[0] = Mhist(&mplhs[1], nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 2 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 2; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}
