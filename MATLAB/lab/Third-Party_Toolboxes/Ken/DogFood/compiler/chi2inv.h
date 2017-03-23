/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Jan 28 12:40:52 2000
 * Arguments: "-xwv" "KlustaKleen" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __chi2inv_h
#define __chi2inv_h 1

#include "matlab.h"

extern mxArray * mlfChi2inv(mxArray * p, mxArray * v);
extern void mlxChi2inv(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
