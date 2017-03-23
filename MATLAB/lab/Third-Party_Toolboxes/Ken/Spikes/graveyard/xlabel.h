/*
 * MATLAB Compiler: 2.0.1
 * Date: Wed Jan 26 11:51:55 2000
 * Arguments: "-xw" "PointCorrel" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __xlabel_h
#define __xlabel_h 1

#include "matlab.h"

extern mxArray * mlfNXlabel(int nargout, mxArray * string, ...);
extern mxArray * mlfXlabel(mxArray * string, ...);
extern void mlfVXlabel(mxArray * string, ...);
extern void mlxXlabel(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
