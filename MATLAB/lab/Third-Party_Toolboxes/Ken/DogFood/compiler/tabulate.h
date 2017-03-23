/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Jan 28 12:40:52 2000
 * Arguments: "-xwv" "KlustaKleen" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __tabulate_h
#define __tabulate_h 1

#include "matlab.h"

extern mxArray * mlfNTabulate(int nargout, mxArray * x);
extern mxArray * mlfTabulate(mxArray * x);
extern void mlfVTabulate(mxArray * x);
extern void mlxTabulate(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
