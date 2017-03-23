/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Jan 28 12:40:52 2000
 * Arguments: "-xwv" "KlustaKleen" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __LoadFet_h
#define __LoadFet_h 1

#include "matlab.h"

extern mxArray * mlfLoadFet(mxArray * FileName);
extern void mlxLoadFet(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
