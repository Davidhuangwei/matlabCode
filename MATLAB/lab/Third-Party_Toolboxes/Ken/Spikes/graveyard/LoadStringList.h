/*
 * MATLAB Compiler: 2.0.1
 * Date: Thu Mar 30 15:24:24 2000
 * Arguments: "-xw" "GetJosefDataBase" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __LoadStringList_h
#define __LoadStringList_h 1

#include "matlab.h"

extern mxArray * mlfLoadStringList(mxArray * FileName);
extern void mlxLoadStringList(int nlhs,
                              mxArray * plhs[],
                              int nrhs,
                              mxArray * prhs[]);

#endif
