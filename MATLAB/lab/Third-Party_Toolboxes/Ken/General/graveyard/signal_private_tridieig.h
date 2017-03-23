/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:22 2000
 * Arguments: "-mw" "mtcsd" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __signal_private_tridieig_h
#define __signal_private_tridieig_h 1

#include "matlab.h"

extern mxArray * mlfSignal_private_tridieig(mxArray * c,
                                            mxArray * b,
                                            mxArray * m1,
                                            mxArray * m2,
                                            mxArray * eps1);
extern void mlxSignal_private_tridieig(int nlhs,
                                       mxArray * plhs[],
                                       int nrhs,
                                       mxArray * prhs[]);

#endif
