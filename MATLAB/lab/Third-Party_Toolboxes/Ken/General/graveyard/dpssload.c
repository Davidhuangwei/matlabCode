/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:22 2000
 * Arguments: "-mw" "mtcsd" 
 */
#include "dpssload.h"
#include "dpssdir.h"

/*
 * The function "Mdpssload" is the implementation version of the "dpssload"
 * M-function from file "/u4/local/matlab/toolbox/signal/signal/dpssload.m"
 * (lines 1-24). It contains the actual compiled code for that M-function. It
 * is a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function [E,V] = dpssload(N,NW)
 */
static mxArray * Mdpssload(mxArray * * V,
                           int nargout_,
                           mxArray * N,
                           mxArray * NW) {
    mxArray * E = mclGetUninitializedArray();
    mxArray * index = mclGetUninitializedArray();
    mxArray * key = mclGetUninitializedArray();
    mxArray * str = mclGetUninitializedArray();
    mclValidateInputs("dpssload", 2, &N, &NW);
    /*
     * %DPSSLOAD  Load discrete prolate spheroidal sequences from database.
     * %   [E,V] = DPSSLOAD(N,NW) are the  DPSSs E and their concentrations V, with 
     * %   length N and time-halfbandwidth product NW, as stored in the DPSS MAT-file 
     * %   database, 'dpss.mat'.  
     * %
     * %   See also DPSS, DPSSSAVE, DPSSDIR, DPSSCLEAR.
     * 
     * %   Author: T. Krauss
     * %   Copyright (c) 1988-1999 The MathWorks, Inc. All Rights Reserved.
     * %       $Revision: 1.3 $
     * 
     * index = dpssdir(N,NW);
     */
    mlfAssign(&index, mlfNDpssdir(1, N, NW));
    /*
     * if isempty(index)
     */
    if (mlfTobool(mlfIsempty(index))) {
        /*
         * error('DPSSs of given length N and parameter NW are not in database.')
         */
        mlfError(
          mxCreateString(
            "DPSSs of given length N and parameter NW are not in database."));
    /*
     * else
     */
    } else {
        /*
         * key = index.wlist.key;
         */
        mlfAssign(&key, mlfIndexRef(index, ".wlist.key"));
        /*
         * str = sprintf('load dpss E%g V%g', key, key);
         */
        mlfAssign(
          &str,
          mlfSprintf(
            NULL, mxCreateString("load dpss E%g V%g"), key, key, NULL));
        /*
         * eval(str)
         */
        mlfError(
          mxCreateString(
            "Run-time Error: File: dpssload Line: 19 Column: 4 The"
            " Compiler does not support EVAL or INPUT functions"));
        /*
         * str = sprintf('E = E%g; V =  V%g;', key, key);
         */
        mlfAssign(
          &str,
          mlfSprintf(
            NULL, mxCreateString("E = E%g; V =  V%g;"), key, key, NULL));
        /*
         * eval(str)
         */
        mlfError(
          mxCreateString(
            "Run-time Error: File: dpssload Line: 21 Column: 4 The"
            " Compiler does not support EVAL or INPUT functions"));
    /*
     * end
     */
    }
    mclValidateOutputs("dpssload", 2, nargout_, &E, V);
    mxDestroyArray(index);
    mxDestroyArray(key);
    mxDestroyArray(str);
    /*
     * 
     */
    return E;
}

/*
 * The function "mlfDpssload" contains the normal interface for the "dpssload"
 * M-function from file "/u4/local/matlab/toolbox/signal/signal/dpssload.m"
 * (lines 1-24). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
mxArray * mlfDpssload(mxArray * * V, mxArray * N, mxArray * NW) {
    int nargout = 1;
    mxArray * E = mclGetUninitializedArray();
    mxArray * V__ = mclGetUninitializedArray();
    mlfEnterNewContext(1, 2, V, N, NW);
    if (V != NULL) {
        ++nargout;
    }
    E = Mdpssload(&V__, nargout, N, NW);
    mlfRestorePreviousContext(1, 2, V, N, NW);
    if (V != NULL) {
        mclCopyOutputArg(V, V__);
    } else {
        mxDestroyArray(V__);
    }
    return mlfReturnValue(E);
}

/*
 * The function "mlxDpssload" contains the feval interface for the "dpssload"
 * M-function from file "/u4/local/matlab/toolbox/signal/signal/dpssload.m"
 * (lines 1-24). The feval function calls the implementation version of
 * dpssload through this function. This function processes any input arguments
 * and passes them to the implementation version of the function, appearing
 * above.
 */
void mlxDpssload(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[2];
    int i;
    if (nlhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: dpssload Line: 1 Column:"
            " 0 The function \"dpssload\" was called with m"
            "ore than the declared number of outputs (2)"));
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: dpssload Line: 1 Column:"
            " 0 The function \"dpssload\" was called with m"
            "ore than the declared number of inputs (2)"));
    }
    for (i = 0; i < 2; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 2 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 2; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 2, mprhs[0], mprhs[1]);
    mplhs[0] = Mdpssload(&mplhs[1], nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 2 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 2; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}
