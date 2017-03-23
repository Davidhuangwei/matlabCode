/*
 * MATLAB Compiler: 2.0
 * Date: Tue Jul 20 15:43:34 1999
 * Arguments: "-v" "-x" "PointCorrel.m" "hist.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __ylabel_h
#define __ylabel_h 1

#include "matlab.h"

extern mxArray * mlfNYlabel(int nargout, mxArray * string, ...);
extern mxArray * mlfYlabel(mxArray * string, ...);
extern void mlfVYlabel(mxArray * string, ...);
extern void mlxYlabel(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
