/*
 * MATLAB Compiler: 2.0.1
 * Date: Thu Mar 30 15:24:24 2000
 * Arguments: "-xw" "GetJosefDataBase" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __textread_h
#define __textread_h 1

#include "matlab.h"

extern mxArray * mlfNTextread(int nargout, mlfVarargoutList * varargout, ...);
extern mxArray * mlfTextread(mlfVarargoutList * varargout, ...);
extern void mlfVTextread(mxArray * synthetic_varargin_argument, ...);
extern void mlxTextread(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
