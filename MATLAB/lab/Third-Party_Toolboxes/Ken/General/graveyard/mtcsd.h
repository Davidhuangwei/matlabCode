/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:20 2000
 * Arguments: "-mw" "mtcsd" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __mtcsd_h
#define __mtcsd_h 1

#include "matlab.h"

extern mxArray * mlfNMtcsd(int nargout, mxArray * * fo, ...);
extern mxArray * mlfMtcsd(mxArray * * fo, ...);
extern void mlfVMtcsd(mxArray * synthetic_varargin_argument, ...);
extern void mlxMtcsd(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
