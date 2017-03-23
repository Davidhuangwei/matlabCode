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

#include "libmatlb.h"
#include "CircAnova.h"
#include "Quantile.h"
#include "iscell.h"
#include "mean.h"
#include "randperm.h"

static mexFunctionTableEntry function_table[5]
  = { { "CircAnova", mlxCircAnova, 3, 1, &_local_function_table_CircAnova },
      { "Quantile", mlxQuantile, 2, 1, &_local_function_table_Quantile },
      { "iscell", mlxIscell, 1, 1, &_local_function_table_iscell },
      { "mean", mlxMean, 2, 1, &_local_function_table_mean },
      { "randperm", mlxRandperm, 1, 1, &_local_function_table_randperm } };

static _mexInitTermTableEntry init_term_table[5]
  = { { InitializeModule_CircAnova, TerminateModule_CircAnova },
      { InitializeModule_Quantile, TerminateModule_Quantile },
      { InitializeModule_iscell, TerminateModule_iscell },
      { InitializeModule_mean, TerminateModule_mean },
      { InitializeModule_randperm, TerminateModule_randperm } };

static _mex_information _mex_info
  = { 1, 5, function_table, 0, NULL, 0, NULL, 5, init_term_table };

/*
 * The function "mexLibrary" is a Compiler-generated mex wrapper, suitable for
 * building a MEX-function. It initializes any persistent variables as well as
 * a function table for use by the feval function. It then calls the function
 * "mlxCircAnova". Finally, it clears the feval table and exits.
 */
mex_information mexLibrary(void) {
    mclMexLibraryInit();
    return &_mex_info;
}
