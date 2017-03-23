/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:22 2000
 * Arguments: "-mw" "mtcsd" 
 */
#include "ylabel.h"

/*
 * The function "Mylabel" is the implementation version of the "ylabel"
 * M-function from file "/u4/local/matlab/toolbox/matlab/graph2d/ylabel.m"
 * (lines 1-33). It contains the actual compiled code for that M-function. It
 * is a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function hh = ylabel(string,varargin)
 */
static mxArray * Mylabel(int nargout_, mxArray * string, mxArray * varargin) {
    mxArray * hh = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * ax = mclGetUninitializedArray();
    mxArray * h = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * nargout = mclInitialize(mlfScalar(nargout_));
    mlfAssign(&nargin_, mlfNargin(1, string, varargin, NULL));
    mclValidateInputs("ylabel", 1, &string);
    /*
     * %YLABEL Y-axis label.
     * %   YLABEL('text') adds text beside the Y-axis on the current axis.
     * %
     * %   YLABEL('text','Property1',PropertyValue1,'Property2',PropertyValue2,...)
     * %   sets the values of the specified properties of the ylabel.
     * %
     * %   H = YLABEL(...) returns the handle to the text object used as the label.
     * %
     * %   See also XLABEL, ZLABEL, TITLE, TEXT.
     * 
     * %   Copyright (c) 1984-98 by The MathWorks, Inc.
     * %   $Revision: 5.7 $  $Date: 1997/11/21 23:33:17 $
     * 
     * ax = gca;
     */
    mlfAssign(&ax, mlfGca(NULL));
    /*
     * h = get(ax,'ylabel');
     */
    mlfAssign(&h, mlfGet(ax, mxCreateString("ylabel"), NULL));
    /*
     * 
     * if nargin > 1 & (nargin-1)/2-fix((nargin-1)/2),
     */
    {
        mxArray * a_ = mclInitialize(mlfGt(nargin_, mlfScalar(1.0)));
        if (mlfTobool(a_)
            && mlfTobool(
                 mlfAnd(
                   a_,
                   mlfMinus(
                     mlfMrdivide(
                       mlfMinus(nargin_, mlfScalar(1.0)), mlfScalar(2.0)),
                     mlfFix(
                       mlfMrdivide(
                         mlfMinus(nargin_, mlfScalar(1.0)),
                         mlfScalar(2.0))))))) {
            mxDestroyArray(a_);
            /*
             * error('Incorrect number of input arguments')
             */
            mlfError(mxCreateString("Incorrect number of input arguments"));
        } else {
            mxDestroyArray(a_);
        }
    /*
     * end
     */
    }
    /*
     * 
     * %Over-ride text objects default font attributes with
     * %the Axes' default font attributes.
     * set(h, 'FontAngle',  get(ax, 'FontAngle'), ...
     */
    mclAssignAns(
      &ans,
      mlfNSet(
        0,
        h,
        mxCreateString("FontAngle"),
        mlfGet(ax, mxCreateString("FontAngle"), NULL),
        mxCreateString("FontName"),
        mlfGet(ax, mxCreateString("FontName"), NULL),
        mxCreateString("FontSize"),
        mlfGet(ax, mxCreateString("FontSize"), NULL),
        mxCreateString("FontWeight"),
        mlfGet(ax, mxCreateString("FontWeight"), NULL),
        mxCreateString("string"),
        string,
        mlfIndexRef(varargin, "{?}", mlfCreateColonIndex()),
        NULL));
    /*
     * 'FontName',   get(ax, 'FontName'), ...
     * 'FontSize',   get(ax, 'FontSize'), ...
     * 'FontWeight', get(ax, 'FontWeight'), ...
     * 'string',     string, varargin{:});
     * 
     * if nargout > 0
     */
    if (mlfTobool(mlfGt(nargout, mlfScalar(0.0)))) {
        /*
         * hh = h;
         */
        mlfAssign(&hh, h);
    /*
     * end
     */
    }
    mclValidateOutputs("ylabel", 1, nargout_, &hh);
    mxDestroyArray(ans);
    mxDestroyArray(ax);
    mxDestroyArray(h);
    mxDestroyArray(nargin_);
    mxDestroyArray(nargout);
    return hh;
}

/*
 * The function "mlfNYlabel" contains the nargout interface for the "ylabel"
 * M-function from file "/u4/local/matlab/toolbox/matlab/graph2d/ylabel.m"
 * (lines 1-33). This interface is only produced if the M-function uses the
 * special variable "nargout". The nargout interface allows the number of
 * requested outputs to be specified via the nargout argument, as opposed to
 * the normal interface which dynamically calculates the number of outputs
 * based on the number of non-NULL inputs it receives. This function processes
 * any input arguments and passes them to the implementation version of the
 * function, appearing above.
 */
mxArray * mlfNYlabel(int nargout, mxArray * string, ...) {
    mxArray * varargin = mclUnassigned();
    mxArray * hh = mclGetUninitializedArray();
    mlfVarargin(&varargin, string, 0);
    mlfEnterNewContext(0, -2, string, varargin);
    hh = Mylabel(nargout, string, varargin);
    mlfRestorePreviousContext(0, 1, string);
    mxDestroyArray(varargin);
    return mlfReturnValue(hh);
}

/*
 * The function "mlfYlabel" contains the normal interface for the "ylabel"
 * M-function from file "/u4/local/matlab/toolbox/matlab/graph2d/ylabel.m"
 * (lines 1-33). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
mxArray * mlfYlabel(mxArray * string, ...) {
    mxArray * varargin = mclUnassigned();
    int nargout = 1;
    mxArray * hh = mclGetUninitializedArray();
    mlfVarargin(&varargin, string, 0);
    mlfEnterNewContext(0, -2, string, varargin);
    hh = Mylabel(nargout, string, varargin);
    mlfRestorePreviousContext(0, 1, string);
    mxDestroyArray(varargin);
    return mlfReturnValue(hh);
}

/*
 * The function "mlfVYlabel" contains the void interface for the "ylabel"
 * M-function from file "/u4/local/matlab/toolbox/matlab/graph2d/ylabel.m"
 * (lines 1-33). The void interface is only produced if the M-function uses the
 * special variable "nargout", and has at least one output. The void interface
 * function specifies zero output arguments to the implementation version of
 * the function, and in the event that the implementation version still returns
 * an output (which, in MATLAB, would be assigned to the "ans" variable), it
 * deallocates the output. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlfVYlabel(mxArray * string, ...) {
    mxArray * varargin = mclUnassigned();
    mxArray * hh = mclUnassigned();
    mlfVarargin(&varargin, string, 0);
    mlfEnterNewContext(0, -2, string, varargin);
    hh = Mylabel(0, string, varargin);
    mlfRestorePreviousContext(0, 1, string);
    mxDestroyArray(varargin);
}

/*
 * The function "mlxYlabel" contains the feval interface for the "ylabel"
 * M-function from file "/u4/local/matlab/toolbox/matlab/graph2d/ylabel.m"
 * (lines 1-33). The feval function calls the implementation version of ylabel
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxYlabel(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: ylabel Line: 1 Column: "
            "0 The function \"ylabel\" was called with mor"
            "e than the declared number of outputs (1)"));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 1 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 1; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 1, mprhs[0]);
    mprhs[1] = NULL;
    mlfAssign(&mprhs[1], mclCreateVararginCell(nrhs - 1, prhs + 1));
    mplhs[0] = Mylabel(nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
    mxDestroyArray(mprhs[1]);
}
