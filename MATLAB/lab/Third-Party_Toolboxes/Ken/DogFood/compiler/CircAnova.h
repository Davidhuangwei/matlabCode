/*
 * MATLAB Compiler: 2.2
 * Date: Wed Dec 12 11:34:20 2001
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "-h" "-w" "CircAnova" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __CircAnova_h
#define __CircAnova_h 1

#ifdef __cplusplus
extern "C" {
#endif

#include "libmatlb.h"

extern void InitializeModule_CircAnova(void);
extern void TerminateModule_CircAnova(void);
extern _mexLocalFunctionTable _local_function_table_CircAnova;

extern mxArray * mlfCircAnova(mxArray * Arg1, mxArray * Arg2, mxArray * Arg3);
extern void mlxCircAnova(int nlhs,
                         mxArray * plhs[],
                         int nrhs,
                         mxArray * prhs[]);

#ifdef __cplusplus
}
#endif

#endif
