/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:22 2000
 * Arguments: "-mw" "mtcsd" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __dpssload_h
#define __dpssload_h 1

#include "matlab.h"

extern mxArray * mlfDpssload(mxArray * * V, mxArray * N, mxArray * NW);
extern void mlxDpssload(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
