/*
 * MATLAB Compiler: 2.0
 * Date: Sun Dec 17 13:07:34 2000
 * Arguments: "-x" "dar.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __gauss_h
#define __gauss_h 1

#include "matlab.h"

extern mxArray * mlfGauss(mxArray * mu, mxArray * covar, mxArray * x);
extern void mlxGauss(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
