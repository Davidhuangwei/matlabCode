/*
 * MATLAB Compiler: 2.0
 * Date: Sun Dec 17 13:07:34 2000
 * Arguments: "-x" "dar.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __waitbar_h
#define __waitbar_h 1

#include "matlab.h"

extern mxArray * mlfNWaitbar(int nargout, mxArray * x, mxArray * whichbar);
extern mxArray * mlfWaitbar(mxArray * x, mxArray * whichbar);
extern void mlfVWaitbar(mxArray * x, mxArray * whichbar);
extern void mlxWaitbar(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
