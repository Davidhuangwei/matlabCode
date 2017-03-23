/*
 * MATLAB Compiler: 2.0
 * Date: Tue Jul 20 15:43:34 1999
 * Arguments: "-v" "-x" "PointCorrel.m" "hist.m" 
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
