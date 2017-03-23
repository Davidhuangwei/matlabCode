/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:20 2000
 * Arguments: "-mw" "mtcsd" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __detrend_h
#define __detrend_h 1

#include "matlab.h"

extern mxArray * mlfDetrend(mxArray * x, mxArray * o, mxArray * bp);
extern void mlxDetrend(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
