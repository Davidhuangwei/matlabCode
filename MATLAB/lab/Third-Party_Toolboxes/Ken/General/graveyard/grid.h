/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:21 2000
 * Arguments: "-mw" "mtcsd" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __grid_h
#define __grid_h 1

#include "matlab.h"

extern void mlfGrid(mxArray * opt_grid);
extern void mlxGrid(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
