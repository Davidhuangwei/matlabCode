/*
 * MATLAB Compiler: 2.2
 * Date: Wed Jun  9 16:08:34 2004
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "Wavelet" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#ifndef __WaveletTimeSplit_h
#define __WaveletTimeSplit_h 1

#ifdef __cplusplus
extern "C" {
#endif

#include "libmatlb.h"

extern void InitializeModule_WaveletTimeSplit(void);
extern void TerminateModule_WaveletTimeSplit(void);
extern _mexLocalFunctionTable _local_function_table_WaveletTimeSplit;

extern mxArray * mlfWaveletTimeSplit(mxArray * * BlockSize, mxArray * x, ...);
extern void mlxWaveletTimeSplit(int nlhs,
                                mxArray * plhs[],
                                int nrhs,
                                mxArray * prhs[]);

#ifdef __cplusplus
}
#endif

#endif
