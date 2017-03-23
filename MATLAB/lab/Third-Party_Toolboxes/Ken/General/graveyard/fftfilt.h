/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:22 2000
 * Arguments: "-mw" "mtcsd" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __fftfilt_h
#define __fftfilt_h 1

#include "matlab.h"

extern mxArray * mlfFftfilt(mxArray * b, mxArray * x, mxArray * nfft);
extern void mlxFftfilt(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
