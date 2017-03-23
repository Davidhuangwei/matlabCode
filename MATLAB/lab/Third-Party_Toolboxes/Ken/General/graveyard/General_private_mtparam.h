/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:21 2000
 * Arguments: "-mw" "mtcsd" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __General_private_mtparam_h
#define __General_private_mtparam_h 1

#include "matlab.h"

extern mxArray * mlfGeneral_private_mtparam(mxArray * * nFFT,
                                            mxArray * * Fs,
                                            mxArray * * WinLength,
                                            mxArray * * nOverlap,
                                            mxArray * * NW,
                                            mxArray * * Detrend,
                                            mxArray * * nTapers,
                                            mxArray * * nChannels,
                                            mxArray * * nSamples,
                                            mxArray * * nFFTChunks,
                                            mxArray * * winstep,
                                            mxArray * * select,
                                            mxArray * * nFreqBins,
                                            mxArray * * f,
                                            mxArray * * t,
                                            mxArray * P);
extern void mlxGeneral_private_mtparam(int nlhs,
                                       mxArray * plhs[],
                                       int nrhs,
                                       mxArray * prhs[]);

#endif
