/*
 * MATLAB Compiler: 2.1
 * Date: Wed Apr 11 10:31:27 2001
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "-w" "LocalMinima" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __LocalMinima_h
#define __LocalMinima_h 1

#ifdef __cplusplus
extern "C" {
#endif

#include "libmatlb.h"

extern void InitializeModule_LocalMinima(void);
extern void TerminateModule_LocalMinima(void);
extern _mexLocalFunctionTable _local_function_table_LocalMinima;

extern mxArray * mlfLocalMinima(mxArray * x,
                                mxArray * NotCloserThan,
                                mxArray * LessThan);
extern void mlxLocalMinima(int nlhs,
                           mxArray * plhs[],
                           int nrhs,
                           mxArray * prhs[]);

#ifdef __cplusplus
}
#endif

#endif
