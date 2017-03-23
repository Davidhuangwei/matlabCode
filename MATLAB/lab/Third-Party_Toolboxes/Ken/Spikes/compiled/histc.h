/*
 * MATLAB Compiler: 2.0
 * Date: Tue Jul 20 15:43:34 1999
 * Arguments: "-v" "-x" "PointCorrel.m" "hist.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __histc_h
#define __histc_h 1

#include "matlab.h"

extern mxArray * mlfNHistc(int nargout, mlfVarargoutList * varargout, ...);
extern mxArray * mlfHistc(mlfVarargoutList * varargout, ...);
extern void mlfVHistc(mxArray * synthetic_varargin_argument, ...);
extern void mlxHistc(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
