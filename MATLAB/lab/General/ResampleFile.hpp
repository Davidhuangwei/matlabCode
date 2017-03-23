//
// MATLAB Compiler: 2.2
// Date: Mon Jul 12 19:42:22 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-p" "-W" "main" "-L"
// "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "ResampleFile.m" 
//
#ifndef __ResampleFile_hpp
#define __ResampleFile_hpp 1

#include "libmatlb.hpp"

extern void InitializeModule_ResampleFile();
extern void TerminateModule_ResampleFile();
extern _mexLocalFunctionTable _local_function_table_ResampleFile;

extern void ResampleFile(mwArray inname = mwArray::DIN,
                         mwArray outname = mwArray::DIN,
                         mwArray numchannel = mwArray::DIN,
                         mwArray resampldown = mwArray::DIN,
                         mwArray resamplup = mwArray::DIN);
#ifdef __cplusplus
extern "C"
#endif
void mlxResampleFile(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]);

#endif
