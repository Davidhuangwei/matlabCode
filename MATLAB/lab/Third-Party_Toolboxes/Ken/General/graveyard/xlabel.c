/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:22 2000
 * Arguments: "-mw" "mtcsd" 
 */
#include "xlabel.h"

/*
 * The function "Mxlabel" is the implementation version of the "xlabel"
 * M-function from file "/u4/local/matlab/toolbox/matlab/graph2d/xlabel.m"
 * (lines 1-33). It contains the actual compiled code for that M-function. It
 * is a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function hh = xlabel(string,varargin)
 */
static mxArray * Mxlabel(int nargout_, mxArray * string, mxArray * varargin) {
    mxArray * hh = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * ax = mclGetUninitializedArray();
    mxArray * h = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * nargout = mclInitialize(mlfScalar(nargout_));
    mlfAssign(&nargin_, mlfNargin(1, string, varargin, NULL));
    mclValidateInputs("xlabel", 1, &string);
    /*
     * %XLABEL X-axis label.
     * %   XLABEL('text') adds text beside the X-axis on the current axis.
     * %
     * %   XLABEL('text','Property1',PropertyValue1,'Property2',PropertyValue2,...)
     * %   sets the values of the specified properties of the xlabel.
     * %
     * %   H = XLABEL(...) returns the handle to the text object used as the label.
     * %
     * %   See also YLABEL, ZLABEL, TITLE, TEXT.
     * 
     * %   Copyright (c) 1984-98 by The MathWorks, Inc.
     * %   $Revision: 5.7 $  $Date: 1997/11/21 23:33:16 $
     * 
     * ax = gca;
     */
    mlfAssign(&ax, mlfGca(NULL));
    /*
     * h = get(ax,'xlabel');
     */
    mlfAssign(&h, mlfGet(ax, mxCreateString("xlabel"), NULL));
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
     * 'string',     string,varargin{:});
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
    mclValidateOutputs("xlabel", 1, nargout_, &hh);
    mxDestroyArray(ans);
    mxDestroyArray(ax);
    mxDestroyArray(h);
    mxDestroyArray(nargin_);
    mxDestroyArray(nargout);
    return hh;
}

/*
 * The function "mlfNXlabel" contains the nargout interface for the "xlabel"
 * M-function from file "/u4/local/matlab/toolbox/matlab/graph2d/xlabel.m"
 * (lines 1-33). This interface is only produced if the M-function uses the
 * special variable "nargout". The nargout interface allows the number of
 * requested outputs to be specified via the nargout argument, as opposed to
 * the normal interface which dynamically calculates the number of outputs
 * based on the number of non-NULL inputs it receives. This function processes
 * any input arguments and passes them to the implementation version of the
 * function, appearing above.
 */
mxArray * mlfNXlabel(int nargout, mxArray * string, ...) {
    mxArray * varargin = mclUnassigned();
    mxArray * hh = mclGetUninitializedArray();
    mlfVarargin(&varargin, string, 0);
    mlfEnterNewContext(0, -2, string, varargin);
    hh = Mxlabel(nargout, string, varargin);
    mlfRestorePreviousContext(0, 1, string);
    mxDestroyArray(varargin);
    return mlfReturnValue(hh);
}

/*
 * The function "mlfXlabel" contains the normal interface for the "xlabel"
 * M-function from file "/u4/local/matlab/toolbox/matlab/graph2d/xlabel.m"
 * (lines 1-33). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
mxArray * mlfXlabel(mxArray * string, ...) {
    mxArray * varargin = mclUnassigned();
    int nargout = 1;
    mxArray * hh = mclGetUninitializedArray();
    mlfVarargin(&varargin, string, 0);
    mlfEnterNewContext(0, -2, string, varargin);
    hh = Mxlabel(nargout, string, varargin);
    mlfRestorePreviousContext(0, 1, string);
    mxDestroyArray(varargin);
    return mlfReturnValue(hh);
}

/*
 * The function "mlfVXlabel" contains the void interface for the "xlabel"
 * M-function from file "/u4/local/matlab/toolbox/matlab/graph2d/xlabel.m"
 * (lines 1-33). The void interface is only produced if the M-function uses the
 * special variable "nargout", and has at least one output. The void interface
 * function specifies zero output arguments to the implementation version of
 * the function, and in the event that the implementation version still returns
 * an output (which, in MATLAB, would be assigned to the "ans" variable), it
 * deallocates the output. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlfVXlabel(mxArray * string, ...) {
    mxArray * varargin = mclUnassigned();
    mxArray * hh = mclUnassigned();
    mlfVarargin(&varargin, string, 0);
    mlfEnterNewContext(0, -2, string, varargin);
    hh = Mxlabel(0, string, varargin);
    mlfRestorePreviousContext(0, 1, string);
    mxDestroyArray(varargin);
}

/*
 * The function "mlxXlabel" contains the feval interface for the "xlabel"
 * M-function from file "/u4/local/matlab/toolbox/matlab/graph2d/xlabel.m"
 * (lines 1-33). The feval function calls the implementation version of xlabel
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
void mlxXlabel(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: xlabel Line: 1 Column: "
            "0 The function \"xlabel\" was called with mor"
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
    mplhs[0] = Mxlabel(nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
    plhs[0] = mplhs[0];
    mxDestroyArray(mprhs[1]);
}
