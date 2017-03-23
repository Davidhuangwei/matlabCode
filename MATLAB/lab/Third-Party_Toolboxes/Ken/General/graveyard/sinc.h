/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:22 2000
 * Arguments: "-mw" "mtcsd" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __sinc_h
#define __sinc_h 1

#include "matlab.h"

extern mxArray * mlfSinc(mxArray * x);
extern void mlxSinc(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
