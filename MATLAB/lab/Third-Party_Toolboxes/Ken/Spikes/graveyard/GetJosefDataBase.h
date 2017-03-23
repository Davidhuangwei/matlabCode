/*
 * MATLAB Compiler: 2.0.1
 * Date: Thu Mar 30 15:24:23 2000
 * Arguments: "-xw" "GetJosefDataBase" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __GetJosefDataBase_h
#define __GetJosefDataBase_h 1

#include "matlab.h"

extern mxArray * mlfGetJosefDataBase(void);
extern void mlxGetJosefDataBase(int nlhs,
                                mxArray * plhs[],
                                int nrhs,
                                mxArray * prhs[]);

#endif
