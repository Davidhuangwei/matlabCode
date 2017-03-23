/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:20 2000
 * Arguments: "-mw" "mtcsd" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __dpss_h
#define __dpss_h 1

#include "matlab.h"

extern mxArray * mlfDpss(mxArray * * V, mxArray * N, mxArray * NW, ...);
extern void mlxDpss(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
