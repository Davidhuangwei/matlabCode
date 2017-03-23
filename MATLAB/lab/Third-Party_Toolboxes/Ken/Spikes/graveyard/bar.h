/*
 * MATLAB Compiler: 2.0.1
 * Date: Wed Jan 26 11:51:55 2000
 * Arguments: "-xw" "PointCorrel" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __bar_h
#define __bar_h 1

#include "matlab.h"

extern mxArray * mlfNBar(int nargout, mxArray * * yo, ...);
extern mxArray * mlfBar(mxArray * * yo, ...);
extern void mlfVBar(mxArray * synthetic_varargin_argument, ...);
extern void mlxBar(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
