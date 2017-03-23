/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:22 2000
 * Arguments: "-mw" "mtcsd" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __dpssdir_h
#define __dpssdir_h 1

#include "matlab.h"

extern mxArray * mlfNDpssdir(int nargout, mxArray * N, mxArray * NW);
extern mxArray * mlfDpssdir(mxArray * N, mxArray * NW);
extern void mlfVDpssdir(mxArray * N, mxArray * NW);
extern void mlxDpssdir(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
