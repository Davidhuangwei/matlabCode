/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:21 2000
 * Arguments: "-mw" "mtcsd" 
 */
#include "grid.h"

/*
 * The function "Mgrid" is the implementation version of the "grid" M-function
 * from file "/u4/local/matlab/toolbox/matlab/graph2d/grid.m" (lines 1-44). It
 * contains the actual compiled code for that M-function. It is a static
 * function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function grid(opt_grid);
 */
static void Mgrid(mxArray * opt_grid) {
    mxArray * ans = mclInitializeAns();
    mxArray * ax = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, opt_grid, NULL));
    mclValidateInputs("grid", 1, &opt_grid);
    /*
     * %GRID   Grid lines.
     * %   GRID ON adds grid lines to the current axes.
     * %   GRID OFF takes them off.
     * %   GRID, by itself, toggles the grid state.
     * %
     * %   GRID sets the XGrid, YGrid, and ZGrid properties of
     * %   the current axes.
     * %
     * %   See also TITLE, XLABEL, YLABEL, ZLABEL, AXES, PLOT.
     * 
     * %   Copyright (c) 1984-98 by The MathWorks, Inc.
     * %   $Revision: 5.4 $  $Date: 1997/11/21 23:33:00 $
     * 
     * ax = gca;
     */
    mlfAssign(&ax, mlfGca(NULL));
    /*
     * 
     * if (nargin == 0)
     */
    if (mlfTobool(mlfEq(nargin_, mlfScalar(0.0)))) {
        /*
         * if (strcmp(get(ax,'XGrid'),'off'))
         */
        if (mlfTobool(
              mlfStrcmp(
                mlfGet(ax, mxCreateString("XGrid"), NULL),
                mxCreateString("off")))) {
            /*
             * set(ax,'XGrid','on');
             */
            mclAssignAns(
              &ans,
              mlfNSet(
                0, ax, mxCreateString("XGrid"), mxCreateString("on"), NULL));
        /*
         * else
         */
        } else {
            /*
             * set(ax,'XGrid','off');
             */
            mclAssignAns(
              &ans,
              mlfNSet(
                0, ax, mxCreateString("XGrid"), mxCreateString("off"), NULL));
        /*
         * end
         */
        }
        /*
         * if (strcmp(get(ax,'YGrid'),'off'))
         */
        if (mlfTobool(
              mlfStrcmp(
                mlfGet(ax, mxCreateString("YGrid"), NULL),
                mxCreateString("off")))) {
            /*
             * set(ax,'YGrid','on');
             */
            mclAssignAns(
              &ans,
              mlfNSet(
                0, ax, mxCreateString("YGrid"), mxCreateString("on"), NULL));
        /*
         * else
         */
        } else {
            /*
             * set(ax,'YGrid','off');
             */
            mclAssignAns(
              &ans,
              mlfNSet(
                0, ax, mxCreateString("YGrid"), mxCreateString("off"), NULL));
        /*
         * end
         */
        }
        /*
         * if (strcmp(get(ax,'ZGrid'),'off'))
         */
        if (mlfTobool(
              mlfStrcmp(
                mlfGet(ax, mxCreateString("ZGrid"), NULL),
                mxCreateString("off")))) {
            /*
             * set(ax,'ZGrid','on');
             */
            mclAssignAns(
              &ans,
              mlfNSet(
                0, ax, mxCreateString("ZGrid"), mxCreateString("on"), NULL));
        /*
         * else
         */
        } else {
            /*
             * set(ax,'ZGrid','off');
             */
            mclAssignAns(
              &ans,
              mlfNSet(
                0, ax, mxCreateString("ZGrid"), mxCreateString("off"), NULL));
        /*
         * end
         */
        }
    /*
     * elseif (strcmp(opt_grid, 'on'))
     */
    } else if (mlfTobool(mlfStrcmp(opt_grid, mxCreateString("on")))) {
        /*
         * set(ax,'XGrid', 'on');
         */
        mclAssignAns(
          &ans,
          mlfNSet(0, ax, mxCreateString("XGrid"), mxCreateString("on"), NULL));
        /*
         * set(ax,'YGrid', 'on');
         */
        mclAssignAns(
          &ans,
          mlfNSet(0, ax, mxCreateString("YGrid"), mxCreateString("on"), NULL));
        /*
         * set(ax,'ZGrid', 'on');
         */
        mclAssignAns(
          &ans,
          mlfNSet(0, ax, mxCreateString("ZGrid"), mxCreateString("on"), NULL));
    /*
     * elseif (strcmp(opt_grid, 'off'))
     */
    } else if (mlfTobool(mlfStrcmp(opt_grid, mxCreateString("off")))) {
        /*
         * set(ax,'XGrid', 'off');
         */
        mclAssignAns(
          &ans,
          mlfNSet(0, ax, mxCreateString("XGrid"), mxCreateString("off"), NULL));
        /*
         * set(ax,'YGrid', 'off');
         */
        mclAssignAns(
          &ans,
          mlfNSet(0, ax, mxCreateString("YGrid"), mxCreateString("off"), NULL));
        /*
         * set(ax,'ZGrid', 'off');
         */
        mclAssignAns(
          &ans,
          mlfNSet(0, ax, mxCreateString("ZGrid"), mxCreateString("off"), NULL));
    /*
     * else
     */
    } else {
        /*
         * error('Unknown command option.');
         */
        mlfError(mxCreateString("Unknown command option."));
    /*
     * end
     */
    }
    mxDestroyArray(ans);
    mxDestroyArray(ax);
    mxDestroyArray(nargin_);
}

/*
 * The function "mlfGrid" contains the normal interface for the "grid"
 * M-function from file "/u4/local/matlab/toolbox/matlab/graph2d/grid.m" (lines
 * 1-44). This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlfGrid(mxArray * opt_grid) {
    mlfEnterNewContext(0, 1, opt_grid);
    Mgrid(opt_grid);
    mlfRestorePreviousContext(0, 1, opt_grid);
}

/*
 * The function "mlxGrid" contains the feval interface for the "grid"
 * M-function from file "/u4/local/matlab/toolbox/matlab/graph2d/grid.m" (lines
 * 1-44). The feval function calls the implementation version of grid through
 * this function. This function processes any input arguments and passes them
 * to the implementation version of the function, appearing above.
 */
void mlxGrid(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[1];
    int i;
    if (nlhs > 0) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: grid Line: 1 Column: 0 The function \"grid\""
            " was called with more than the declared number of outputs (0)"));
    }
    if (nrhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: grid Line: 1 Column: 0 The function \"grid"
            "\" was called with more than the declared number of inputs (1)"));
    }
    for (i = 0; i < 1 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 1; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 1, mprhs[0]);
    Mgrid(mprhs[0]);
    mlfRestorePreviousContext(0, 1, mprhs[0]);
}
