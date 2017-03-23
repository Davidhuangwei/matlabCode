/*
 * MATLAB Compiler: 2.0.1
 * Date: Tue Feb  1 12:56:03 2000
 * Arguments: "-xw" "TriggeredAv" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __TriggeredAv_h
#define __TriggeredAv_h 1

#include "matlab.h"

extern mxArray * mlfTriggeredAv(mxArray * Trace,
                                mxArray * nBefore,
                                mxArray * nAfter,
                                mxArray * T,
                                mxArray * G);
extern void mlxTriggeredAv(int nlhs,
                           mxArray * plhs[],
                           int nrhs,
                           mxArray * prhs[]);

#endif
