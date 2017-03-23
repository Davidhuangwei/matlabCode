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

#ifndef __SaveFet_h
#define __SaveFet_h 1

#ifdef __cplusplus
extern "C" {
#endif

#include "libmatlb.h"

extern void InitializeModule_SaveFet(void);
extern void TerminateModule_SaveFet(void);
extern _mexLocalFunctionTable _local_function_table_SaveFet;

extern void mlfSaveFet(mxArray * FileName, mxArray * Fet);
extern void mlxSaveFet(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#ifdef __cplusplus
}
#endif

#endif
