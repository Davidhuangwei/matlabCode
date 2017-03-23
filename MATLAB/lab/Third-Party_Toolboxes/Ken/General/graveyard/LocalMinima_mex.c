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

#include "libmatlb.h"
#include "LocalMinima.h"
#include "libmatlbmx.h"

static mexFunctionTableEntry function_table[1]
  = { { "LocalMinima", mlxLocalMinima, 3, 1,
        &_local_function_table_LocalMinima } };

static _mexInitTermTableEntry init_term_table[2]
  = { { libmatlbmxInitialize, libmatlbmxTerminate },
      { InitializeModule_LocalMinima, TerminateModule_LocalMinima } };

static _mex_information _mex_info
  = { 1, 1, function_table, 0, NULL, 0, NULL, 2, init_term_table };

/*
 * The function "mexLibrary" is a Compiler-generated mex wrapper, suitable for
 * building a MEX-function. It initializes any persistent variables as well as
 * a function table for use by the feval function. It then calls the function
 * "mlxLocalMinima". Finally, it clears the feval table and exits.
 */
mex_information mexLibrary(void) {
    return &_mex_info;
}
