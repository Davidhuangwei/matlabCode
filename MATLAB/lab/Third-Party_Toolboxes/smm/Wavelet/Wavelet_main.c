/*
 * MATLAB Compiler: 2.2
 * Date: Wed Jun  9 16:06:04 2004
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-m" "-W" "main" "-L"
 * "C" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "Wavelet" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#include "libmatlb.h"
#include "Wavelet.h"
#include "DefaultArgs.h"
#include "FreeMemory.h"
#include "WaveletSampling.h"
#include "WaveletTimeSplit.h"
#include "wave_bases.h"
#include "DirectProd.h"
#include "libmmfile.h"

mxArray * memcont = NULL;

static mexGlobalTableEntry global_table[1] = { { "memcont", &memcont } };

static mexFunctionTableEntry function_table[7]
  = { { "Wavelet", mlxWavelet, -2, 5, &_local_function_table_Wavelet },
      { "DefaultArgs", mlxDefaultArgs, 2, -1,
        &_local_function_table_DefaultArgs },
      { "FreeMemory", mlxFreeMemory, 0, 1, &_local_function_table_FreeMemory },
      { "WaveletSampling", mlxWaveletSampling, -1, 3,
        &_local_function_table_WaveletSampling },
      { "WaveletTimeSplit", mlxWaveletTimeSplit, -2, 2,
        &_local_function_table_WaveletTimeSplit },
      { "wave_bases", mlxWave_bases, 4, 4, &_local_function_table_wave_bases },
      { "DirectProd", mlxDirectProd, 2, 1,
        &_local_function_table_DirectProd } };

static _mexInitTermTableEntry init_term_table[8]
  = { { libmmfileInitialize, libmmfileTerminate },
      { InitializeModule_Wavelet, TerminateModule_Wavelet },
      { InitializeModule_DefaultArgs, TerminateModule_DefaultArgs },
      { InitializeModule_FreeMemory, TerminateModule_FreeMemory },
      { InitializeModule_WaveletSampling, TerminateModule_WaveletSampling },
      { InitializeModule_WaveletTimeSplit, TerminateModule_WaveletTimeSplit },
      { InitializeModule_wave_bases, TerminateModule_wave_bases },
      { InitializeModule_DirectProd, TerminateModule_DirectProd } };

static _mex_information _main_info
  = { 1, 7, function_table, 1, global_table, 0, NULL, 8, init_term_table };

/*
 * The function "main" is a Compiler-generated main wrapper, suitable for
 * building a stand-alone application.  It calls a library function to perform
 * initialization, call the main function, and perform library termination.
 */
int main(int argc, const char * * argv) {
    return mclMain(argc, argv, mlxWavelet, 1, &_main_info);
}
