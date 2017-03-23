/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:21 2000
 * Arguments: "-mw" "mtcsd" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __subplot_h
#define __subplot_h 1

#include "matlab.h"

extern mxArray * mlfNSubplot(int nargout,
                             mxArray * nrows,
                             mxArray * ncols,
                             mxArray * thisPlot);
extern mxArray * mlfSubplot(mxArray * nrows,
                            mxArray * ncols,
                            mxArray * thisPlot);
extern void mlfVSubplot(mxArray * nrows, mxArray * ncols, mxArray * thisPlot);
extern void mlxSubplot(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
