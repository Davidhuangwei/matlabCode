//
// MATLAB Compiler: 2.2
// Date: Mon Jul 12 19:42:22 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-p" "-W" "main" "-L"
// "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "ResampleFile.m" 
//
#include "libmatlb.hpp"
#include "ResampleFile.hpp"
#include "Sresample.hpp"
#include "Sfirls.hpp"
#include "Skaiser.hpp"
#include "Supfirdn_mex_interface.hpp"
#include "signal_private_Sfirchk.hpp"
#include "Ssinc.hpp"
#include "signal_private_Scheck_order.hpp"
#include "libmmfile.hpp"

static mexFunctionTableEntry function_table[8]
  = { { "ResampleFile", mlxResampleFile, 5, 0,
        &_local_function_table_ResampleFile },
      { "Sresample", mlxSresample, 5, 2, &_local_function_table_Sresample },
      { "Sfirls", mlxSfirls, 5, 2, &_local_function_table_Sfirls },
      { "Skaiser", mlxSkaiser, 2, 1, &_local_function_table_Skaiser },
      { "Supfirdn", mlxSupfirdn, -1, -1, &_local_function_table_Supfirdn },
      { "signal/private/Sfirchk", mlxSignal_private_Sfirchk,
        3, 3, &_local_function_table_signal_private_Sfirchk },
      { "Ssinc", mlxSsinc, 1, 1, &_local_function_table_Ssinc },
      { "signal/private/Scheck_order", mlxSignal_private_Scheck_order,
        1, 3, &_local_function_table_signal_private_Scheck_order } };

static const char * path_list_[1]
  = { "/u16/tmp_matlab/Smatlab6/SIGNAL/signal" };

static _mexcppInitTermTableEntry init_term_table[9]
  = { { libmmfileInitialize, libmmfileTerminate },
      { InitializeModule_ResampleFile, TerminateModule_ResampleFile },
      { InitializeModule_Sresample, TerminateModule_Sresample },
      { InitializeModule_Sfirls, TerminateModule_Sfirls },
      { InitializeModule_Skaiser, TerminateModule_Skaiser },
      { InitializeModule_Supfirdn_mex_interface,
        TerminateModule_Supfirdn_mex_interface },
      { InitializeModule_signal_private_Sfirchk,
        TerminateModule_signal_private_Sfirchk },
      { InitializeModule_Ssinc, TerminateModule_Ssinc },
      { InitializeModule_signal_private_Scheck_order,
        TerminateModule_signal_private_Scheck_order } };

static _mexcpp_information _main_info
  = { 1, 8, function_table, 0, NULL, 1, path_list_, 9, init_term_table };

//
// The function "main" is a Compiler-generated main wrapper, suitable for
// building a stand-alone application.  It calls a library function to perform
// initialization, call the main function, and perform library termination.
//
int main(int argc, const char * * argv) {
    return mwMain(argc, argv, mlxResampleFile, 0, &_main_info);
}
