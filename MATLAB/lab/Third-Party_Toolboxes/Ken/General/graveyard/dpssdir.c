/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Feb  4 11:20:22 2000
 * Arguments: "-mw" "mtcsd" 
 */
#include "dpssdir.h"

/*
 * The function "Mdpssdir" is the implementation version of the "dpssdir"
 * M-function from file "/u4/local/matlab/toolbox/signal/signal/dpssdir.m"
 * (lines 1-112). It contains the actual compiled code for that M-function. It
 * is a static function and must only be called from one of the interface
 * functions, appearing below.
 */
/*
 * function d = dpssdir(N,NW)
 */
static mxArray * Mdpssdir(int nargout_, mxArray * N, mxArray * NW) {
    mxArray * d = mclGetUninitializedArray();
    mxArray * NW_FIXED = mclGetUninitializedArray();
    mxArray * N_FIXED = mclGetUninitializedArray();
    mxArray * Nsort = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * args = mclGetUninitializedArray();
    mxArray * doubled = mclGetUninitializedArray();
    mxArray * i = mclGetUninitializedArray();
    mxArray * ind = mclGetUninitializedArray();
    mxArray * index = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mclForLoopIterator iterator_1;
    mxArray * j = mclGetUninitializedArray();
    mxArray * key = mclGetUninitializedArray();
    mxArray * nargin_ = mclGetUninitializedArray();
    mxArray * nargout = mclInitialize(mlfScalar(nargout_));
    mxArray * str = mclGetUninitializedArray();
    mxArray * w = mclGetUninitializedArray();
    mxArray * wh = mclGetUninitializedArray();
    mxArray * wlist = mclGetUninitializedArray();
    mlfAssign(&nargin_, mlfNargin(0, N, NW, NULL));
    mclValidateInputs("dpssdir", 2, &N, &NW);
    mclCopyArray(&NW);
    /*
     * %DPSSDIR  Discrete prolate spheroidal sequence database directory.
     * %   DPSSDIR lists the directory of saved DPSSs in the file dpss.mat.
     * %   DPSSDIR(N) lists the DPSSs saved with length N.
     * %   DPSSDIR(NW,'NW') lists the DPSSs saved with time-halfbandwidth product NW.
     * %   DPSSDIR(N,NW) lists the DPSSs saved with length N and time-halfbandwidth 
     * %   product NW.
     * %
     * %   INDEX = DPSSDIR is a structure array describing the DPSS database.
     * %   Pass N and NW options as for the no output case to get a filtered INDEX.
     * %
     * %   See also DPSS, DPSSSAVE, DPSSLOAD, DPSSCLEAR.
     * 
     * %   Author: T. Krauss
     * %   Copyright (c) 1988-1999 The MathWorks, Inc. All Rights Reserved.
     * %       $Revision: 1.3 $
     * 
     * N_FIXED = 0;
     */
    mlfAssign(&N_FIXED, mlfScalar(0.0));
    /*
     * NW_FIXED = 0;
     */
    mlfAssign(&NW_FIXED, mlfScalar(0.0));
    /*
     * 
     * if nargin == 1
     */
    if (mlfTobool(mlfEq(nargin_, mlfScalar(1.0)))) {
        /*
         * N_FIXED = 1;
         */
        mlfAssign(&N_FIXED, mlfScalar(1.0));
    /*
     * end
     */
    }
    /*
     * if nargin == 2
     */
    if (mlfTobool(mlfEq(nargin_, mlfScalar(2.0)))) {
        /*
         * if isstr(NW)
         */
        if (mlfTobool(mlfIsstr(NW))) {
            /*
             * NW_FIXED = 1;
             */
            mlfAssign(&NW_FIXED, mlfScalar(1.0));
            /*
             * NW = N;
             */
            mlfAssign(&NW, N);
        /*
         * else
         */
        } else {
            /*
             * N_FIXED = 1;
             */
            mlfAssign(&N_FIXED, mlfScalar(1.0));
            /*
             * NW_FIXED = 1;
             */
            mlfAssign(&NW_FIXED, mlfScalar(1.0));
        /*
         * end
         */
        }
    /*
     * end
     */
    }
    /*
     * 
     * index = [];
     */
    mlfAssign(&index, mclCreateEmptyArray());
    /*
     * w = which('dpss.mat','-all');
     */
    mlfAssign(
      &w, mlfWhich(mxCreateString("dpss.mat"), mxCreateString("-all"), NULL));
    /*
     * 
     * doubled = 0;
     */
    mlfAssign(&doubled, mlfScalar(0.0));
    /*
     * if iscell(w)
     */
    if (mlfTobool(mlfIscell(w))) {
        /*
         * for i=2:length(w)
         */
        for (mclForStart(&iterator_0, mlfScalar(2.0), mlfLength(w), NULL);
             mclForNext(&iterator_0, &i);
             ) {
            /*
             * doubled = ~strcmp(w{1},w{i});
             */
            mlfAssign(
              &doubled,
              mlfNot(
                mlfFeval(
                  mclValueVarargout(),
                  mlxStrcmp,
                  mlfIndexRef(w, "{?}", mlfScalar(1.0)),
                  mlfIndexRef(w, "{?}", i),
                  NULL)));
            /*
             * if doubled, break, end
             */
            if (mlfTobool(doubled)) {
                mclDestroyForLoopIterator(&iterator_0);
                break;
            }
        /*
         * end
         */
        }
    /*
     * end
     */
    }
    /*
     * 
     * if doubled & length(w)>1
     */
    if (mlfTobool(doubled)
        && mlfTobool(mlfAnd(doubled, mlfGt(mlfLength(w), mlfScalar(1.0))))) {
        /*
         * warning(sprintf('Multiple dpss.mat files found on path, using %s.',w{1}))
         */
        mclPrintAns(
          &ans,
          mlfWarning(
            NULL,
            mlfSprintf(
              NULL,
              mxCreateString(
                "Multiple dpss.mat files found on path, using %s."),
              mlfIndexRef(w, "{?}", mlfScalar(1.0)),
              NULL)));
    /*
     * end
     */
    }
    /*
     * 
     * if length(w) == 0      % new dpss database
     */
    if (mlfTobool(mlfEq(mlfLength(w), mlfScalar(0.0)))) {
        /*
         * if nargout == 0
         */
        if (mlfTobool(mlfEq(nargout, mlfScalar(0.0)))) {
            /*
             * disp('   Could not find dpss.mat on path or in current directory.')
             */
            mlfDisp(
              mxCreateString(
                "   Could not find dpss.mat on path or in current directory."));
        /*
         * end
         */
        }
    /*
     * else     % add this to existing dpss
     */
    } else {
        /*
         * w = w{1};
         */
        mlfAssign(&w, mlfIndexRef(w, "{?}", mlfScalar(1.0)));
        /*
         * eval(['load(''' w ''', ''index'', ''next_key'')'])
         */
        mlfError(
          mxCreateString(
            "Run-time Error: File: dpssdir Line: 55 Column: 4 The "
            "Compiler does not support EVAL or INPUT functions"));
        /*
         * 
         * if nargout == 0
         */
        if (mlfTobool(mlfEq(nargout, mlfScalar(0.0)))) {
            /*
             * disp(sprintf('File: %s',w))
             */
            mlfDisp(mlfSprintf(NULL, mxCreateString("File: %s"), w, NULL));
            /*
             * disp('    N     NW    Variable names')
             */
            mlfDisp(mxCreateString("    N     NW    Variable names"));
            /*
             * disp('   ---   ----  ----------------')
             */
            mlfDisp(mxCreateString("   ---   ----  ----------------"));
        /*
         * end
         */
        }
        /*
         * wh = whos('-file',w);
         */
        mlfAssign(&wh, mlfWhos(mxCreateString("-file"), w, NULL));
        /*
         * 
         * [Nsort,ind] = sort([index.N]);
         */
        mlfAssign(
          &Nsort,
          mlfSort(&ind, mlfHorzcat(mlfIndexRef(index, ".N"), NULL), NULL));
        /*
         * index = index(ind);
         */
        mlfAssign(&index, mlfIndexRef(index, "(?)", ind));
        /*
         * 
         * if N_FIXED
         */
        if (mlfTobool(N_FIXED)) {
            /*
             * ind = find(Nsort==N);
             */
            mlfAssign(&ind, mlfFind(NULL, NULL, mlfEq(Nsort, N)));
            /*
             * index = index(ind);
             */
            mlfAssign(&index, mlfIndexRef(index, "(?)", ind));
        /*
         * end
         */
        }
        /*
         * 
         * for i = 1:length(index)
         */
        for (mclForStart(&iterator_0, mlfScalar(1.0), mlfLength(index), NULL);
             mclForNext(&iterator_0, &i);
             ) {
            /*
             * [wlist,ind] = sort([index(i).wlist.NW]);
             */
            mlfAssign(
              &wlist,
              mlfSort(
                &ind,
                mlfHorzcat(mlfIndexRef(index, "(?).wlist.NW", i), NULL),
                NULL));
            /*
             * index(i).wlist = index(i).wlist(ind);
             */
            mlfIndexAssign(
              &index,
              "(?).wlist",
              i,
              mlfIndexRef(index, "(?).wlist(?)", i, ind));
            /*
             * if NW_FIXED
             */
            if (mlfTobool(NW_FIXED)) {
                /*
                 * ind = find(wlist==NW);
                 */
                mlfAssign(&ind, mlfFind(NULL, NULL, mlfEq(wlist, NW)));
                /*
                 * index(i).wlist = index(i).wlist(ind);
                 */
                mlfIndexAssign(
                  &index,
                  "(?).wlist",
                  i,
                  mlfIndexRef(index, "(?).wlist(?)", i, ind));
            /*
             * end
             */
            }
            /*
             * 
             * if nargout == 0
             */
            if (mlfTobool(mlfEq(nargout, mlfScalar(0.0)))) {
                /*
                 * for j = 1:length(index(i).wlist)
                 */
                for (mclForStart(
                       &iterator_1,
                       mlfScalar(1.0),
                       mlfFeval(
                         mclValueVarargout(),
                         mlxLength,
                         mlfIndexRef(index, "(?).wlist", i),
                         NULL),
                       NULL);
                     mclForNext(&iterator_1, &j);
                     ) {
                    /*
                     * 
                     * key = index(i).wlist(j).key;
                     */
                    mlfAssign(
                      &key, mlfIndexRef(index, "(?).wlist(?).key", i, j));
                    /*
                     * 
                     * args = {index(i).wlist(j).NW, key, key};
                     */
                    mlfAssign(
                      &args,
                      mlfCellhcat(
                        mlfIndexRef(index, "(?).wlist(?).NW", i, j),
                        key,
                        key,
                        NULL));
                    /*
                     * if j == 1
                     */
                    if (mlfTobool(mlfEq(j, mlfScalar(1.0)))) {
                        /*
                         * args = {index(i).N, args{:}};
                         */
                        mlfAssign(
                          &args,
                          mlfCellhcat(
                            mlfIndexRef(index, "(?).N", i),
                            mlfIndexRef(args, "{?}", mlfCreateColonIndex()),
                            NULL));
                        /*
                         * str = sprintf('%7.0f %5.2f  E%g, V%g', args{:});
                         */
                        mlfAssign(
                          &str,
                          mlfSprintf(
                            NULL,
                            mxCreateString("%7.0f %5.2f  E%g, V%g"),
                            mlfIndexRef(args, "{?}", mlfCreateColonIndex()),
                            NULL));
                    /*
                     * else
                     */
                    } else {
                        /*
                         * str = sprintf('        %5.2f  E%g, V%g', args{:});
                         */
                        mlfAssign(
                          &str,
                          mlfSprintf(
                            NULL,
                            mxCreateString("        %5.2f  E%g, V%g"),
                            mlfIndexRef(args, "{?}", mlfCreateColonIndex()),
                            NULL));
                    /*
                     * end
                     */
                    }
                    /*
                     * disp(str)
                     */
                    mlfDisp(str);
                /*
                 * 
                 * end
                 */
                }
            /*
             * end
             */
            }
        /*
         * 
         * end
         */
        }
        /*
         * for i = length(index):-1:1
         */
        for (mclForStart(
               &iterator_0, mlfLength(index), mlfScalar(-1.0), mlfScalar(1.0));
             mclForNext(&iterator_0, &i);
             ) {
            /*
             * if length(index(i).wlist)==0
             */
            if (mlfTobool(
                  mlfEq(
                    mlfFeval(
                      mclValueVarargout(),
                      mlxLength,
                      mlfIndexRef(index, "(?).wlist", i),
                      NULL),
                    mlfScalar(0.0)))) {
                /*
                 * index(i) = [];
                 */
                mlfIndexDelete(&index, "(?)", i);
            /*
             * end
             */
            }
        /*
         * end
         */
        }
        /*
         * if length(index)==0 & nargout == 0
         */
        {
            mxArray * a_ = mclInitialize(
                             mlfEq(mlfLength(index), mlfScalar(0.0)));
            if (mlfTobool(a_)
                && mlfTobool(mlfAnd(a_, mlfEq(nargout, mlfScalar(0.0))))) {
                mxDestroyArray(a_);
                /*
                 * disp('    No DPSSs found.')
                 */
                mlfDisp(mxCreateString("    No DPSSs found."));
            } else {
                mxDestroyArray(a_);
            }
        /*
         * end
         */
        }
    /*
     * end
     */
    }
    /*
     * 
     * 
     * if nargout > 0
     */
    if (mlfTobool(mlfGt(nargout, mlfScalar(0.0)))) {
        /*
         * d = index;
         */
        mlfAssign(&d, index);
    /*
     * end
     */
    }
    mclValidateOutputs("dpssdir", 1, nargout_, &d);
    mxDestroyArray(NW);
    mxDestroyArray(NW_FIXED);
    mxDestroyArray(N_FIXED);
    mxDestroyArray(Nsort);
    mxDestroyArray(ans);
    mxDestroyArray(args);
    mxDestroyArray(doubled);
    mxDestroyArray(i);
    mxDestroyArray(ind);
    mxDestroyArray(index);
    mxDestroyArray(j);
    mxDestroyArray(key);
    mxDestroyArray(nargin_);
    mxDestroyArray(nargout);
    mxDestroyArray(str);
    mxDestroyArray(w);
    mxDestroyArray(wh);
    mxDestroyArray(wlist);
    return d;
}

/*
 * The function "mlfNDpssdir" contains the nargout interface for the "dpssdir"
 * M-function from file "/u4/local/matlab/toolbox/signal/signal/dpssdir.m"
 * (lines 1-112). This interface is only produced if the M-function uses the
 * special variable "nargout". The nargout interface allows the number of
 * requested outputs to be specified via the nargout argument, as opposed to
 * the normal interface which dynamically calculates the number of outputs
 * based on the number of non-NULL inputs it receives. This function processes
 * any input arguments and passes them to the implementation version of the
 * function, appearing above.
 */
mxArray * mlfNDpssdir(int nargout, mxArray * N, mxArray * NW) {
    mxArray * d = mclGetUninitializedArray();
    mlfEnterNewContext(0, 2, N, NW);
    d = Mdpssdir(nargout, N, NW);
    mlfRestorePreviousContext(0, 2, N, NW);
    return mlfReturnValue(d);
}

/*
 * The function "mlfDpssdir" contains the normal interface for the "dpssdir"
 * M-function from file "/u4/local/matlab/toolbox/signal/signal/dpssdir.m"
 * (lines 1-112). This function processes any input arguments and passes them
 * to the implementation version of the function, appearing above.
 */
mxArray * mlfDpssdir(mxArray * N, mxArray * NW) {
    int nargout = 1;
    mxArray * d = mclGetUninitializedArray();
    mlfEnterNewContext(0, 2, N, NW);
    d = Mdpssdir(nargout, N, NW);
    mlfRestorePreviousContext(0, 2, N, NW);
    return mlfReturnValue(d);
}

/*
 * The function "mlfVDpssdir" contains the void interface for the "dpssdir"
 * M-function from file "/u4/local/matlab/toolbox/signal/signal/dpssdir.m"
 * (lines 1-112). The void interface is only produced if the M-function uses
 * the special variable "nargout", and has at least one output. The void
 * interface function specifies zero output arguments to the implementation
 * version of the function, and in the event that the implementation version
 * still returns an output (which, in MATLAB, would be assigned to the "ans"
 * variable), it deallocates the output. This function processes any input
 * arguments and passes them to the implementation version of the function,
 * appearing above.
 */
void mlfVDpssdir(mxArray * N, mxArray * NW) {
    mxArray * d = mclUnassigned();
    mlfEnterNewContext(0, 2, N, NW);
    d = Mdpssdir(0, N, NW);
    mlfRestorePreviousContext(0, 2, N, NW);
    mxDestroyArray(d);
}

/*
 * The function "mlxDpssdir" contains the feval interface for the "dpssdir"
 * M-function from file "/u4/local/matlab/toolbox/signal/signal/dpssdir.m"
 * (lines 1-112). The feval function calls the implementation version of
 * dpssdir through this function. This function processes any input arguments
 * and passes them to the implementation version of the function, appearing
 * above.
 */
void mlxDpssdir(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: dpssdir Line: 1 Column: "
            "0 The function \"dpssdir\" was called with mor"
            "e than the declared number of outputs (1)"));
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: dpssdir Line: 1 Column:"
            " 0 The function \"dpssdir\" was called with m"
            "ore than the declared number of inputs (2)"));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 2 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 2; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 2, mprhs[0], mprhs[1]);
    mplhs[0] = Mdpssdir(nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
    plhs[0] = mplhs[0];
}
