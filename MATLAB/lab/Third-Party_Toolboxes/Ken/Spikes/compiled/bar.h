/*
 * MATLAB Compiler: 2.0
 * Date: Tue Jul 20 15:43:34 1999
 * Arguments: "-v" "-x" "PointCorrel.m" "hist.m" 
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
