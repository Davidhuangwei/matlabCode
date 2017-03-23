/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:22 2000
 * Arguments: "-mw" "mtcsd" 
 */

#ifndef MLF_V2
#define MLF_V2 1
#endif

#include "matlab.h"
#include "signal_private_tridieig.h"
#include "sinc.h"
#include "fftfilt.h"
#include "dpssload.h"
#include "dpssdir.h"
#include "ylabel.h"
#include "xlabel.h"
#include "subplot.h"
#include "squeeze.h"
#include "General_private_mtparam.h"
#include "grid.h"
#include "dpss.h"
#include "detrend.h"
#include "complex.h"
#include "mtcsd.h"

static mlfFunctionTableEntry function_table[15]
  = { { "signal/private/tridieig", mlxSignal_private_tridieig, 5, 1 },
      { "sinc", mlxSinc, 1, 1 },
      { "fftfilt", mlxFftfilt, 3, 1 },
      { "dpssload", mlxDpssload, 2, 2 },
      { "dpssdir", mlxDpssdir, 2, 1 },
      { "ylabel", mlxYlabel, -2, 1 },
      { "xlabel", mlxXlabel, -2, 1 },
      { "subplot", mlxSubplot, 3, 1 },
      { "squeeze", mlxSqueeze, 1, 1 },
      { "General/private/mtparam", mlxGeneral_private_mtparam, 1, 16 },
      { "grid", mlxGrid, 1, 0 },
      { "dpss", mlxDpss, -3, 2 },
      { "detrend", mlxDetrend, 3, 1 },
      { "complex", mlxComplex, 2, 1 },
      { "mtcsd", mlxMtcsd, -1, 2 } };

/*
 * The function "main" is a Compiler-generated main wrapper, suitable for
 * building a stand-alone application. It initializes a function table for use
 * by the feval function, and then calls the function "mlxMtcsd". Finally, it
 * clears the feval table and exits.
 */
int main(int argc, const char * * argv) {
    int status = 0;
    mxArray * varargin = mclInitialize(NULL);
    mxArray * result = mclInitialize(NULL);
    mlfEnterNewContext(0, 0);
    mlfFunctionTableSetup(15, function_table);
    mlfAssign(&varargin, mclCreateCellFromStrings(argc - 1, argv + 1));
    mlfAssign(
      &result,
      mlfNMtcsd(
        1, NULL, mlfIndexRef(varargin, "{?}", mlfCreateColonIndex()), NULL));
    mxDestroyArray(varargin);
    if (mclIsInitialized(result) && ! mxIsEmpty(result)) {
        status = mclArrayToInt(result);
    }
    mxDestroyArray(result);
    mlfFunctionTableTakedown(15, function_table);
    mlfRestorePreviousContext(0, 0);
    return status;
}
