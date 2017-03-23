/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:20 2000
 * Arguments: "-mw" "mtcsd" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __complex_h
#define __complex_h 1

#include "matlab.h"

extern mxArray * mlfComplex(mxArray * A, mxArray * B);
extern void mlxComplex(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
