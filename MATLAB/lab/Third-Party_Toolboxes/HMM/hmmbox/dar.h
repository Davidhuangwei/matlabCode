/*
 * MATLAB Compiler: 2.0
 * Date: Sun Dec 17 13:07:34 2000
 * Arguments: "-x" "dar.m" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __dar_h
#define __dar_h 1

#include "matlab.h"

extern mxArray * mlfDar(mxArray * * ev,
                        mxArray * * error,
                        mxArray * * gain,
                        mxArray * * sigma_obs,
                        mxArray * * sigma_wu,
                        mxArray * * pvol,
                        mxArray * * state_noise,
                        mxArray * * sigma_wu_q0,
                        mxArray * Z,
                        mxArray * p,
                        mxArray * V,
                        mxArray * ALPHA);
extern void mlxDar(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
