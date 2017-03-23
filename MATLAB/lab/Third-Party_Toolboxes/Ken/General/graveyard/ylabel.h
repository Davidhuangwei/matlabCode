/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:22 2000
 * Arguments: "-mw" "mtcsd" 
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
