/*
 * MATLAB Compiler: 2.0
 * Date: Tue Jul 20 15:43:34 1999
 * Arguments: "-v" "-x" "PointCorrel.m" "hist.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __PointCorrel_h
#define __PointCorrel_h 1

#include "matlab.h"

extern mxArray * mlfPointCorrel(mxArray * T1,
                                mxArray * T2,
                                mxArray * BinSize,
                                mxArray * HalfBins,
                                mxArray * isauto,
                                mxArray * SampleRate);
extern void mlxPointCorrel(int nlhs,
                           mxArray * plhs[],
                           int nrhs,
                           mxArray * prhs[]);

#endif
