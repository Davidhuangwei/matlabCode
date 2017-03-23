/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:22 2000
 * Arguments: "-mw" "mtcsd" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __signal_private_tridisolve_h
#define __signal_private_tridisolve_h 1

#include "matlab.h"

extern mxArray * mlfNSignal_private_tridisolve(int nargout,
                                               mlfVarargoutList * varargout,
                                               ...);
extern mxArray * mlfSignal_private_tridisolve(mlfVarargoutList * varargout,
                                              ...);
extern void mlfVSignal_private_tridisolve(mxArray * synthetic_varargin_argument,
                                          ...);
extern void mlxSignal_private_tridisolve(int nlhs,
                                         mxArray * plhs[],
                                         int nrhs,
                                         mxArray * prhs[]);

#endif
