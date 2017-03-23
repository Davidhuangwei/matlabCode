/*
 * MATLAB Compiler: 2.2
 * Date: Wed Dec 12 11:05:47 2001
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "-h" "-w" "CircAnova" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __circmean_h
#define __circmean_h 1

#ifdef __cplusplus
extern "C" {
#endif

#include "libmatlb.h"

extern void InitializeModule_circmean(void);
extern void TerminateModule_circmean(void);
extern _mexLocalFunctionTable _local_function_table_circmean;

extern mxArray * mlfCircmean(mxArray * * r, mxArray * data_rad);
extern void mlxCircmean(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#ifdef __cplusplus
}
#endif

#endif
