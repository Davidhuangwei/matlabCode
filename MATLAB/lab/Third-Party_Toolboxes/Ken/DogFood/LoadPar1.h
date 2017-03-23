/*
 * MATLAB Compiler: 2.1
 * Date: Mon May  7 15:50:01 2001
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "-w" "ResSubset" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __LoadPar1_h
#define __LoadPar1_h 1

#ifdef __cplusplus
extern "C" {
#endif

#include "libmatlb.h"

extern void InitializeModule_LoadPar1(void);
extern void TerminateModule_LoadPar1(void);
extern _mexLocalFunctionTable _local_function_table_LoadPar1;

extern mxArray * mlfLoadPar1(mxArray * FileName);
extern void mlxLoadPar1(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#ifdef __cplusplus
}
#endif

#endif
