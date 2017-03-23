/*
 * MATLAB Compiler: 2.0.1
 * Date: Wed Jan 26 11:51:55 2000
 * Arguments: "-xw" "PointCorrel" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __PointCorrel_h
#define __PointCorrel_h 1

#include "matlab.h"

extern mxArray * mlfNPointCorrel(int nargout,
                                 mxArray * * t,
                                 mxArray * T1,
                                 mxArray * T2,
                                 mxArray * BinSize,
                                 mxArray * HalfBins,
                                 mxArray * isauto,
                                 mxArray * SampleRate,
                                 mxArray * Normalization);
extern mxArray * mlfPointCorrel(mxArray * * t,
                                mxArray * T1,
                                mxArray * T2,
                                mxArray * BinSize,
                                mxArray * HalfBins,
                                mxArray * isauto,
                                mxArray * SampleRate,
                                mxArray * Normalization);
extern void mlfVPointCorrel(mxArray * T1,
                            mxArray * T2,
                            mxArray * BinSize,
                            mxArray * HalfBins,
                            mxArray * isauto,
                            mxArray * SampleRate,
                            mxArray * Normalization);
extern void mlxPointCorrel(int nlhs,
                           mxArray * plhs[],
                           int nrhs,
                           mxArray * prhs[]);

#endif
