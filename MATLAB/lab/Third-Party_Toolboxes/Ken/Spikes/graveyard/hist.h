/*
 * MATLAB Compiler: 2.0.1
 * Date: Wed Jan 26 11:51:55 2000
 * Arguments: "-xw" "PointCorrel" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __hist_h
#define __hist_h 1

#include "matlab.h"

extern mxArray * mlfNHist(int nargout,
                          mxArray * * xo,
                          mxArray * y,
                          mxArray * x);
extern mxArray * mlfHist(mxArray * * xo, mxArray * y, mxArray * x);
extern void mlfVHist(mxArray * y, mxArray * x);
extern void mlxHist(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
