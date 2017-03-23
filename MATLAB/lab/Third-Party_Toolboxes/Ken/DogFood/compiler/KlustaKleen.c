/*
 * MATLAB Compiler: 2.0.1
 * Date: Fri Jan 28 12:40:52 2000
 * Arguments: "-xwv" "KlustaKleen" 
 */
#include "KlustaKleen.h"
#include "LoadClu.h"
#include "LoadFet.h"
#include "SaveClu.h"
#include "chi2inv.h"
#include "tabulate.h"

static mxArray * MKlustaKleen_CutClu(int nargout_,
                                     mxArray * FetRaw,
                                     mxArray * Clu,
                                     mxArray * Bursters);
static mxArray * mlfKlustaKleen_CutClu(mxArray * FetRaw,
                                       mxArray * Clu,
                                       mxArray * Bursters);
static void mlxKlustaKleen_CutClu(int nlhs,
                                  mxArray * plhs[],
                                  int nrhs,
                                  mxArray * prhs[]);
static mxArray * MKlustaKleen_AddMissing(int nargout_,
                                         mxArray * FetRaw,
                                         mxArray * Clu,
                                         mxArray * Bursters);
static mxArray * mlfKlustaKleen_AddMissing(mxArray * FetRaw,
                                           mxArray * Clu,
                                           mxArray * Bursters);
static void mlxKlustaKleen_AddMissing(int nlhs,
                                      mxArray * plhs[],
                                      int nrhs,
                                      mxArray * prhs[]);
static mxArray * MKlustaKleen_CalcStats(mxArray * * CovMatMH,
                                        int nargout_,
                                        mxArray * Fet,
                                        mxArray * Clu,
                                        mxArray * Bursters);
static mxArray * mlfKlustaKleen_CalcStats(mxArray * * CovMatMH,
                                          mxArray * Fet,
                                          mxArray * Clu,
                                          mxArray * Bursters);
static void mlxKlustaKleen_CalcStats(int nlhs,
                                     mxArray * plhs[],
                                     int nrhs,
                                     mxArray * prhs[]);
static mxArray * MKlustaKleen_GetUserInputs(mxArray * * Clu2Clean,
                                            mxArray * * CutDist,
                                            mxArray * * Bursters,
                                            int nargout_,
                                            mxArray * nDimsAll,
                                            mxArray * nClusters);
static mxArray * mlfKlustaKleen_GetUserInputs(mxArray * * Clu2Clean,
                                              mxArray * * CutDist,
                                              mxArray * * Bursters,
                                              mxArray * nDimsAll,
                                              mxArray * nClusters);
static void mlxKlustaKleen_GetUserInputs(int nlhs,
                                         mxArray * plhs[],
                                         int nrhs,
                                         mxArray * prhs[]);

/*
 * The function "MKlustaKleen" is the implementation version of the
 * "KlustaKleen" M-function from file
 * "/u5/b/ken/matlab/DogFood/compiler/KlustaKleen.m" (lines 1-59). It contains
 * the actual compiled code for that M-function. It is a static function and
 * must only be called from one of the interface functions, appearing below.
 */
/*
 * % Interactive Cluster cleaner.
 * % KlustaKleen(FileBase, ElecNo)
 * %
 * 
 * function KlustaKleen(FileBase, ElecNo)
 */
static void MKlustaKleen(mxArray * FileBase, mxArray * ElecNo) {
    mxArray * Action = mclGetUninitializedArray();
    mxArray * Clu = mclGetUninitializedArray();
    mxArray * CluFileName = mclGetUninitializedArray();
    mxArray * FetFileName = mclGetUninitializedArray();
    mxArray * FetRaw = mclGetUninitializedArray();
    mxArray * NewClu = mclGetUninitializedArray();
    mxArray * OldClu = mclUnassigned();
    mxArray * ans = mclInitializeAns();
    mclValidateInputs("KlustaKleen", 2, &FileBase, &ElecNo);
    /*
     * %function iClusterClean(FetRaw,Clu);
     * 
     * % load files
     * CluFileName = [FileBase, '.clu.', ElecNo];
     */
    mlfAssign(
      &CluFileName,
      mlfHorzcat(FileBase, mxCreateString(".clu."), ElecNo, NULL));
    /*
     * Clu = LoadClu(CluFileName);
     */
    mlfAssign(&Clu, mlfLoadClu(CluFileName));
    /*
     * FetFileName = [FileBase, '.fet.', ElecNo];
     */
    mlfAssign(
      &FetFileName,
      mlfHorzcat(FileBase, mxCreateString(".fet."), ElecNo, NULL));
    /*
     * FetRaw = LoadFet(FetFileName);
     */
    mlfAssign(&FetRaw, mlfLoadFet(FetFileName));
    /*
     * 
     * %CluFileName = '564004SP.clu.1'
     * 
     * % main LOOP
     * while (1)
     */
    while (mlfTobool(mlfScalar(1.0))) {
        /*
         * 
         * % get array dimensions
         * fprintf('Make-up of cluster file:\n');
         */
        mclAssignAns(
          &ans,
          mlfFprintf(mxCreateString("Make-up of cluster file:\\n"), NULL));
        /*
         * tabulate(Clu);
         */
        mclAssignAns(&ans, mlfNTabulate(0, Clu));
        /*
         * 
         * fprintf('What do you want to do?\n');
         */
        mclAssignAns(
          &ans, mlfFprintf(mxCreateString("What do you want to do?\\n"), NULL));
        /*
         * fprintf('d: Delete Outliers\n');
         */
        mclAssignAns(
          &ans, mlfFprintf(mxCreateString("d: Delete Outliers\\n"), NULL));
        /*
         * fprintf('r: Re-allocate cluster 1\n');
         */
        mclAssignAns(
          &ans,
          mlfFprintf(mxCreateString("r: Re-allocate cluster 1\\n"), NULL));
        /*
         * fprintf('l: Load cluster file\n');
         */
        mclAssignAns(
          &ans, mlfFprintf(mxCreateString("l: Load cluster file\\n"), NULL));
        /*
         * fprintf('u: Undo last operation\n');
         */
        mclAssignAns(
          &ans, mlfFprintf(mxCreateString("u: Undo last operation\\n"), NULL));
        /*
         * fprintf('q: Quit\n');
         */
        mclAssignAns(&ans, mlfFprintf(mxCreateString("q: Quit\\n"), NULL));
        /*
         * Action = input('', 's');
         */
        mlfAssign(
          &Action,
          (mlfError(
             mxCreateString(
               "Run-time Error: File: KlustaKleen Line: 29 Column: 10 T"
               "he Compiler does not support EVAL or INPUT functions")),
           mclCastToMxarray(NULL)));
        /*
         * 
         * switch Action
         * case 'd'
         */
        if (mclSwitchCompare(Action, mxCreateString("d"))) {
            /*
             * NewClu = CutClu(FetRaw,Clu);
             */
            mlfAssign(&NewClu, mlfKlustaKleen_CutClu(FetRaw, Clu, NULL));
        /*
         * case 'r'
         */
        } else if (mclSwitchCompare(Action, mxCreateString("r"))) {
            /*
             * NewClu = AddMissing(FetRaw,Clu);
             */
            mlfAssign(&NewClu, mlfKlustaKleen_AddMissing(FetRaw, Clu, NULL));
        /*
         * case 'l'
         */
        } else if (mclSwitchCompare(Action, mxCreateString("l"))) {
            /*
             * Clu = LoadClu(CluFileName);
             */
            mlfAssign(&Clu, mlfLoadClu(CluFileName));
        /*
         * case 'u'
         */
        } else if (mclSwitchCompare(Action, mxCreateString("u"))) {
            /*
             * NewClu = OldClu;
             */
            mlfAssign(&NewClu, OldClu);
        /*
         * case 'q'
         */
        } else if (mclSwitchCompare(Action, mxCreateString("q"))) {
            /*
             * break;
             */
            break;
        /*
         * end
         */
        }
        /*
         * 
         * if (Action == 'd' | Action == 'r' | Action == 'u')
         */
        {
            mxArray * a_ = mclInitialize(mlfEq(Action, mxCreateString("d")));
            if (mlfTobool(a_)) {
                mlfAssign(&a_, mlfScalar(1));
            } else {
                mlfAssign(&a_, mlfOr(a_, mlfEq(Action, mxCreateString("r"))));
            }
            if (mlfTobool(a_)
                || mlfTobool(mlfOr(a_, mlfEq(Action, mxCreateString("u"))))) {
                mxDestroyArray(a_);
                /*
                 * % save changes
                 * eval(sprintf('!mv %s %s.bak', CluFileName, CluFileName));
                 */
                mlfError(
                  mxCreateString(
                    "Run-time Error: File: KlustaKleen Line: 46 Column: 2 Th"
                    "e Compiler does not support EVAL or INPUT functions"));
                /*
                 * SaveClu(CluFileName, NewClu);
                 */
                mlfSaveClu(CluFileName, NewClu);
                /*
                 * fprintf('Saving Cluster File. \n');
                 */
                mclAssignAns(
                  &ans,
                  mlfFprintf(mxCreateString("Saving Cluster File. \\n"), NULL));
                /*
                 * OldClu = Clu;
                 */
                mlfAssign(&OldClu, Clu);
                /*
                 * Clu = NewClu;
                 */
                mlfAssign(&Clu, NewClu);
            } else {
                mxDestroyArray(a_);
            }
        /*
         * end
         */
        }
    /*
     * 
     * %scatter(Fet(:,1), Fet(:,2), 5, Clu);
     * 
     * end
     */
    }
    mxDestroyArray(Action);
    mxDestroyArray(Clu);
    mxDestroyArray(CluFileName);
    mxDestroyArray(FetFileName);
    mxDestroyArray(FetRaw);
    mxDestroyArray(NewClu);
    mxDestroyArray(OldClu);
    mxDestroyArray(ans);
/*
 * 
 * return
 * 
 */
}

/*
 * The function "mlfKlustaKleen" contains the normal interface for the
 * "KlustaKleen" M-function from file
 * "/u5/b/ken/matlab/DogFood/compiler/KlustaKleen.m" (lines 1-59). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
void mlfKlustaKleen(mxArray * FileBase, mxArray * ElecNo) {
    mlfEnterNewContext(0, 2, FileBase, ElecNo);
    MKlustaKleen(FileBase, ElecNo);
    mlfRestorePreviousContext(0, 2, FileBase, ElecNo);
}

/*
 * The function "mlxKlustaKleen" contains the feval interface for the
 * "KlustaKleen" M-function from file
 * "/u5/b/ken/matlab/DogFood/compiler/KlustaKleen.m" (lines 1-59). The feval
 * function calls the implementation version of KlustaKleen through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxKlustaKleen(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[2];
    int i;
    if (nlhs > 0) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: KlustaKleen Line: 5 Column"
            ": 0 The function \"KlustaKleen\" was called with"
            " more than the declared number of outputs (0)"));
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: KlustaKleen Line: 5 Column"
            ": 0 The function \"KlustaKleen\" was called with"
            " more than the declared number of inputs (2)"));
    }
    for (i = 0; i < 2 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 2; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 2, mprhs[0], mprhs[1]);
    MKlustaKleen(mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
}

/*
 * The function "MKlustaKleen_CutClu" is the implementation version of the
 * "KlustaKleen/CutClu" M-function from file
 * "/u5/b/ken/matlab/DogFood/compiler/KlustaKleen.m" (lines 59-84). It contains
 * the actual compiled code for that M-function. It is a static function and
 * must only be called from one of the interface functions, appearing below.
 */
/*
 * function NewClu = CutClu(FetRaw,Clu,Bursters)
 */
static mxArray * MKlustaKleen_CutClu(int nargout_,
                                     mxArray * FetRaw,
                                     mxArray * Clu,
                                     mxArray * Bursters) {
    mxArray * NewClu = mclGetUninitializedArray();
    mxArray * Clu2Clean = mclGetUninitializedArray();
    mxArray * CovMatMH = mclGetUninitializedArray();
    mxArray * CutDist = mclGetUninitializedArray();
    mxArray * Fet = mclGetUninitializedArray();
    mxArray * Mahals = mclGetUninitializedArray();
    mxArray * Means = mclGetUninitializedArray();
    mxArray * MySpikes = mclGetUninitializedArray();
    mxArray * NormVex = mclGetUninitializedArray();
    mxArray * Outliers = mclGetUninitializedArray();
    mxArray * WhichFets = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * c = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mxArray * nClusters = mclGetUninitializedArray();
    mxArray * nDims = mclGetUninitializedArray();
    mxArray * nDimsAll = mclGetUninitializedArray();
    mxArray * nMySpikes = mclGetUninitializedArray();
    mxArray * nSpikes = mclGetUninitializedArray();
    mclValidateInputs("KlustaKleen/CutClu", 3, &FetRaw, &Clu, &Bursters);
    mclCopyArray(&Bursters);
    /*
     * 
     * % initialize
     * nClusters = max(Clu);
     */
    mlfAssign(&nClusters, mlfMax(NULL, Clu, NULL, NULL));
    /*
     * nDimsAll = size(FetRaw,2);
     */
    mlfAssign(&nDimsAll, mlfSize(mclValueVarargout(), FetRaw, mlfScalar(2.0)));
    /*
     * NewClu = Clu;
     */
    mlfAssign(&NewClu, Clu);
    /*
     * [WhichFets, Clu2Clean, CutDist, Bursters] = GetUserInputs(nDimsAll, nClusters);
     */
    mlfAssign(
      &WhichFets,
      mlfKlustaKleen_GetUserInputs(
        &Clu2Clean, &CutDist, &Bursters, nDimsAll, nClusters));
    /*
     * Fet = FetRaw(:,WhichFets);
     */
    mlfAssign(
      &Fet, mlfIndexRef(FetRaw, "(?,?)", mlfCreateColonIndex(), WhichFets));
    /*
     * [nSpikes nDims] = size(Fet);
     */
    mlfSize(mlfVarargout(&nSpikes, &nDims, NULL), Fet, NULL);
    /*
     * 
     * [Means, CovMatMH] = CalcStats(Fet,Clu,Bursters);
     */
    mlfAssign(&Means, mlfKlustaKleen_CalcStats(&CovMatMH, Fet, Clu, Bursters));
    /*
     * 
     * % calculate mahalanobis distances
     * 
     * for c=Clu2Clean
     */
    for (mclForStart(&iterator_0, Clu2Clean, NULL, NULL);
         mclForNext(&iterator_0, &c);
         ) {
        /*
         * MySpikes = find(Clu==c);
         */
        mlfAssign(&MySpikes, mlfFind(NULL, NULL, mlfEq(Clu, c)));
        /*
         * nMySpikes = length(MySpikes);
         */
        mlfAssign(&nMySpikes, mlfLength(MySpikes));
        /*
         * NormVex = (Fet(MySpikes,:) - repmat(Means(c,:),nMySpikes,1)) * CovMatMH(:,:,c);
         */
        mlfAssign(
          &NormVex,
          mlfMtimes(
            mlfMinus(
              mlfIndexRef(Fet, "(?,?)", MySpikes, mlfCreateColonIndex()),
              mlfRepmat(
                mlfIndexRef(Means, "(?,?)", c, mlfCreateColonIndex()),
                nMySpikes,
                mlfScalar(1.0))),
            mlfIndexRef(
              CovMatMH,
              "(?,?,?)",
              mlfCreateColonIndex(),
              mlfCreateColonIndex(),
              c)));
        /*
         * Mahals = sum(NormVex.*NormVex,2);
         */
        mlfAssign(&Mahals, mlfSum(mlfTimes(NormVex, NormVex), mlfScalar(2.0)));
        /*
         * Outliers = find(Mahals>CutDist);
         */
        mlfAssign(&Outliers, mlfFind(NULL, NULL, mlfGt(Mahals, CutDist)));
        /*
         * fprintf('Cluster %d -> deleting %d outliers out of %d\n', c, length(Outliers), nMySpikes);
         */
        mclAssignAns(
          &ans,
          mlfFprintf(
            mxCreateString("Cluster %d -> deleting %d outliers out of %d\\n"),
            c, mlfLength(Outliers), nMySpikes, NULL));
        /*
         * NewClu(MySpikes(Outliers)) = 1;
         */
        mlfIndexAssign(
          &NewClu,
          "(?)",
          mlfIndexRef(MySpikes, "(?)", Outliers),
          mlfScalar(1.0));
    /*
     * end;
     */
    }
    mclValidateOutputs("KlustaKleen/CutClu", 1, nargout_, &NewClu);
    mxDestroyArray(Bursters);
    mxDestroyArray(Clu2Clean);
    mxDestroyArray(CovMatMH);
    mxDestroyArray(CutDist);
    mxDestroyArray(Fet);
    mxDestroyArray(Mahals);
    mxDestroyArray(Means);
    mxDestroyArray(MySpikes);
    mxDestroyArray(NormVex);
    mxDestroyArray(Outliers);
    mxDestroyArray(WhichFets);
    mxDestroyArray(ans);
    mxDestroyArray(c);
    mxDestroyArray(nClusters);
    mxDestroyArray(nDims);
    mxDestroyArray(nDimsAll);
    mxDestroyArray(nMySpikes);
    mxDestroyArray(nSpikes);
    /*
     * return
     * 
     */
    return NewClu;
}

/*
 * The function "mlfKlustaKleen_CutClu" contains the normal interface for the
 * "KlustaKleen/CutClu" M-function from file
 * "/u5/b/ken/matlab/DogFood/compiler/KlustaKleen.m" (lines 59-84). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
static mxArray * mlfKlustaKleen_CutClu(mxArray * FetRaw,
                                       mxArray * Clu,
                                       mxArray * Bursters) {
    int nargout = 1;
    mxArray * NewClu = mclGetUninitializedArray();
    mlfEnterNewContext(0, 3, FetRaw, Clu, Bursters);
    NewClu = MKlustaKleen_CutClu(nargout, FetRaw, Clu, Bursters);
    mlfRestorePreviousContext(0, 3, FetRaw, Clu, Bursters);
    return mlfReturnValue(NewClu);
}

/*
 * The function "mlxKlustaKleen_CutClu" contains the feval interface for the
 * "KlustaKleen/CutClu" M-function from file
 * "/u5/b/ken/matlab/DogFood/compiler/KlustaKleen.m" (lines 59-84). The feval
 * function calls the implementation version of KlustaKleen/CutClu through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
static void mlxKlustaKleen_CutClu(int nlhs,
                                  mxArray * plhs[],
                                  int nrhs,
                                  mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: KlustaKleen/CutClu Line: 59 Col"
            "umn: 0 The function \"KlustaKleen/CutClu\" was called"
            " with more than the declared number of outputs (1)"));
    }
    if (nrhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: KlustaKleen/CutClu Line: 59 Col"
            "umn: 0 The function \"KlustaKleen/CutClu\" was called"
            " with more than the declared number of inputs (3)"));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 3 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 3; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    mplhs[0] = MKlustaKleen_CutClu(nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
}

/*
 * The function "MKlustaKleen_AddMissing" is the implementation version of the
 * "KlustaKleen/AddMissing" M-function from file
 * "/u5/b/ken/matlab/DogFood/compiler/KlustaKleen.m" (lines 84-125). It
 * contains the actual compiled code for that M-function. It is a static
 * function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function NewClu = AddMissing(FetRaw,Clu,Bursters)
 */
static mxArray * MKlustaKleen_AddMissing(int nargout_,
                                         mxArray * FetRaw,
                                         mxArray * Clu,
                                         mxArray * Bursters) {
    mxArray * NewClu = mclGetUninitializedArray();
    mxArray * Clu1 = mclGetUninitializedArray();
    mxArray * Clu2Clean = mclGetUninitializedArray();
    mxArray * CovMatMH = mclGetUninitializedArray();
    mxArray * CutDist = mclGetUninitializedArray();
    mxArray * Exceptions = mclGetUninitializedArray();
    mxArray * Fet = mclGetUninitializedArray();
    mxArray * Mahals = mclGetUninitializedArray();
    mxArray * Means = mclGetUninitializedArray();
    mxArray * MyGuys = mclGetUninitializedArray();
    mxArray * NormVex = mclGetUninitializedArray();
    mxArray * OtherClusters = mclGetUninitializedArray();
    mxArray * WhichFets = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * c = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mxArray * nClu1 = mclGetUninitializedArray();
    mxArray * nClu2Clean = mclGetUninitializedArray();
    mxArray * nClusters = mclGetUninitializedArray();
    mxArray * nDims = mclGetUninitializedArray();
    mxArray * nDimsAll = mclGetUninitializedArray();
    mxArray * nSpikes = mclGetUninitializedArray();
    mclValidateInputs("KlustaKleen/AddMissing", 3, &FetRaw, &Clu, &Bursters);
    mclCopyArray(&Bursters);
    /*
     * 
     * % initialize
     * nClusters = max(Clu);
     */
    mlfAssign(&nClusters, mlfMax(NULL, Clu, NULL, NULL));
    /*
     * nDimsAll = size(FetRaw,2);
     */
    mlfAssign(&nDimsAll, mlfSize(mclValueVarargout(), FetRaw, mlfScalar(2.0)));
    /*
     * NewClu = Clu;
     */
    mlfAssign(&NewClu, Clu);
    /*
     * [WhichFets, Clu2Clean, CutDist, Bursters] = GetUserInputs(nDimsAll, nClusters);
     */
    mlfAssign(
      &WhichFets,
      mlfKlustaKleen_GetUserInputs(
        &Clu2Clean, &CutDist, &Bursters, nDimsAll, nClusters));
    /*
     * Fet = FetRaw(:,WhichFets);
     */
    mlfAssign(
      &Fet, mlfIndexRef(FetRaw, "(?,?)", mlfCreateColonIndex(), WhichFets));
    /*
     * [nSpikes nDims] = size(Fet);
     */
    mlfSize(mlfVarargout(&nSpikes, &nDims, NULL), Fet, NULL);
    /*
     * nClu2Clean = length(Clu2Clean);
     */
    mlfAssign(&nClu2Clean, mlfLength(Clu2Clean));
    /*
     * 
     * [Means, CovMatMH] = CalcStats(Fet,Clu,Bursters);
     */
    mlfAssign(&Means, mlfKlustaKleen_CalcStats(&CovMatMH, Fet, Clu, Bursters));
    /*
     * 
     * Clu1 = find(Clu==1);
     */
    mlfAssign(&Clu1, mlfFind(NULL, NULL, mlfEq(Clu, mlfScalar(1.0))));
    /*
     * nClu1 = length(Clu1);
     */
    mlfAssign(&nClu1, mlfLength(Clu1));
    /*
     * 
     * Mahals = zeros(nClu1, nClusters);
     */
    mlfAssign(&Mahals, mlfZeros(nClu1, nClusters, NULL));
    /*
     * % caclulate mahalanobis distances
     * for c=1:nClusters
     */
    for (mclForStart(&iterator_0, mlfScalar(1.0), nClusters, NULL);
         mclForNext(&iterator_0, &c);
         ) {
        /*
         * NormVex = (Fet(Clu1,:) - repmat(Means(c,:),nClu1,1)) * CovMatMH(:,:,c);
         */
        mlfAssign(
          &NormVex,
          mlfMtimes(
            mlfMinus(
              mlfIndexRef(Fet, "(?,?)", Clu1, mlfCreateColonIndex()),
              mlfRepmat(
                mlfIndexRef(Means, "(?,?)", c, mlfCreateColonIndex()),
                nClu1,
                mlfScalar(1.0))),
            mlfIndexRef(
              CovMatMH,
              "(?,?,?)",
              mlfCreateColonIndex(),
              mlfCreateColonIndex(),
              c)));
        /*
         * Mahals(:,c) = sum(NormVex.*NormVex,2);
         */
        mlfIndexAssign(
          &Mahals,
          "(?,?)",
          mlfCreateColonIndex(),
          c,
          mlfSum(mlfTimes(NormVex, NormVex), mlfScalar(2.0)));
    /*
     * end
     */
    }
    /*
     * 
     * for c=Clu2Clean
     */
    for (mclForStart(&iterator_0, Clu2Clean, NULL, NULL);
         mclForNext(&iterator_0, &c);
         ) {
        /*
         * % find those within the cut-off distance of cluster c
         * MyGuys = find(Mahals(:,c) < CutDist);
         */
        mlfAssign(
          &MyGuys,
          mlfFind(
            NULL,
            NULL,
            mlfLt(
              mlfIndexRef(Mahals, "(?,?)", mlfCreateColonIndex(), c),
              CutDist)));
        /*
         * 
         * % of these, find any that could also belong to another cluster
         * OtherClusters = setdiff(2:nClusters, c);
         */
        mlfAssign(
          &OtherClusters,
          mlfSetdiff(NULL, mlfColon(mlfScalar(2.0), nClusters, NULL), c, NULL));
        /*
         * Exceptions = find(any(Mahals(MyGuys,OtherClusters)<CutDist, 2));
         */
        mlfAssign(
          &Exceptions,
          mlfFind(
            NULL,
            NULL,
            mlfAny(
              mlfLt(
                mlfIndexRef(Mahals, "(?,?)", MyGuys, OtherClusters), CutDist),
              mlfScalar(2.0))));
        /*
         * MyGuys(Exceptions) = [];
         */
        mlfIndexDelete(&MyGuys, "(?)", Exceptions);
        /*
         * 
         * fprintf('Cluster %d -> Allocating %d spikes.  %d not allocated because they could also go to another cluster\n',...
         */
        mclAssignAns(
          &ans,
          mlfFprintf(
            mxCreateString(
              "Cluster %d -> Allocating %d spikes.  %d not allocate"
              "d because they could also go to another cluster\\n"),
            c, mlfLength(MyGuys), mlfLength(Exceptions), NULL));
        /*
         * c, length(MyGuys), length(Exceptions));
         * 
         * % now reallocate them
         * NewClu(Clu1(MyGuys)) = c;
         */
        mlfIndexAssign(&NewClu, "(?)", mlfIndexRef(Clu1, "(?)", MyGuys), c);
    /*
     * end
     */
    }
    mclValidateOutputs("KlustaKleen/AddMissing", 1, nargout_, &NewClu);
    mxDestroyArray(Bursters);
    mxDestroyArray(Clu1);
    mxDestroyArray(Clu2Clean);
    mxDestroyArray(CovMatMH);
    mxDestroyArray(CutDist);
    mxDestroyArray(Exceptions);
    mxDestroyArray(Fet);
    mxDestroyArray(Mahals);
    mxDestroyArray(Means);
    mxDestroyArray(MyGuys);
    mxDestroyArray(NormVex);
    mxDestroyArray(OtherClusters);
    mxDestroyArray(WhichFets);
    mxDestroyArray(ans);
    mxDestroyArray(c);
    mxDestroyArray(nClu1);
    mxDestroyArray(nClu2Clean);
    mxDestroyArray(nClusters);
    mxDestroyArray(nDims);
    mxDestroyArray(nDimsAll);
    mxDestroyArray(nSpikes);
    /*
     * 
     * return
     * 
     */
    return NewClu;
}

/*
 * The function "mlfKlustaKleen_AddMissing" contains the normal interface for
 * the "KlustaKleen/AddMissing" M-function from file
 * "/u5/b/ken/matlab/DogFood/compiler/KlustaKleen.m" (lines 84-125). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
static mxArray * mlfKlustaKleen_AddMissing(mxArray * FetRaw,
                                           mxArray * Clu,
                                           mxArray * Bursters) {
    int nargout = 1;
    mxArray * NewClu = mclGetUninitializedArray();
    mlfEnterNewContext(0, 3, FetRaw, Clu, Bursters);
    NewClu = MKlustaKleen_AddMissing(nargout, FetRaw, Clu, Bursters);
    mlfRestorePreviousContext(0, 3, FetRaw, Clu, Bursters);
    return mlfReturnValue(NewClu);
}

/*
 * The function "mlxKlustaKleen_AddMissing" contains the feval interface for
 * the "KlustaKleen/AddMissing" M-function from file
 * "/u5/b/ken/matlab/DogFood/compiler/KlustaKleen.m" (lines 84-125). The feval
 * function calls the implementation version of KlustaKleen/AddMissing through
 * this function. This function processes any input arguments and passes them
 * to the implementation version of the function, appearing above.
 */
static void mlxKlustaKleen_AddMissing(int nlhs,
                                      mxArray * plhs[],
                                      int nrhs,
                                      mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: KlustaKleen/AddMissing Line: 84 Co"
            "lumn: 0 The function \"KlustaKleen/AddMissing\" was call"
            "ed with more than the declared number of outputs (1)"));
    }
    if (nrhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: KlustaKleen/AddMissing Line: 84 Co"
            "lumn: 0 The function \"KlustaKleen/AddMissing\" was call"
            "ed with more than the declared number of inputs (3)"));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 3 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 3; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    mplhs[0] = MKlustaKleen_AddMissing(nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
}

/*
 * The function "MKlustaKleen_CalcStats" is the implementation version of the
 * "KlustaKleen/CalcStats" M-function from file
 * "/u5/b/ken/matlab/DogFood/compiler/KlustaKleen.m" (lines 125-156). It
 * contains the actual compiled code for that M-function. It is a static
 * function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function [Means, CovMatMH] = CalcStats(Fet,Clu,Bursters)
 */
static mxArray * MKlustaKleen_CalcStats(mxArray * * CovMatMH,
                                        int nargout_,
                                        mxArray * Fet,
                                        mxArray * Clu,
                                        mxArray * Bursters) {
    mxArray * Means = mclGetUninitializedArray();
    mxArray * CommonCovMat = mclGetUninitializedArray();
    mxArray * CommonCovMatMH = mclGetUninitializedArray();
    mxArray * CommonSpikes = mclGetUninitializedArray();
    mxArray * CovMat = mclGetUninitializedArray();
    mxArray * c = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mxArray * nClusters = mclGetUninitializedArray();
    mxArray * nDims = mclGetUninitializedArray();
    mclValidateInputs("KlustaKleen/CalcStats", 3, &Fet, &Clu, &Bursters);
    /*
     * % Calculate means
     * nClusters = max(Clu);
     */
    mlfAssign(&nClusters, mlfMax(NULL, Clu, NULL, NULL));
    /*
     * nDims = size(Fet,2);
     */
    mlfAssign(&nDims, mlfSize(mclValueVarargout(), Fet, mlfScalar(2.0)));
    /*
     * 
     * Means = zeros(nClusters, nDims);
     */
    mlfAssign(&Means, mlfZeros(nClusters, nDims, NULL));
    /*
     * for c=2:nClusters
     */
    for (mclForStart(&iterator_0, mlfScalar(2.0), nClusters, NULL);
         mclForNext(&iterator_0, &c);
         ) {
        /*
         * Means(c,:) = mean(Fet(find(Clu==c),:));
         */
        mlfIndexAssign(
          &Means,
          "(?,?)",
          c,
          mlfCreateColonIndex(),
          mlfMean(
            mlfIndexRef(
              Fet,
              "(?,?)",
              mlfFind(NULL, NULL, mlfEq(Clu, c)),
              mlfCreateColonIndex()),
            NULL));
    /*
     * end
     */
    }
    /*
     * 
     * % Calculate common covariance matrix and -.5 power
     * if (length(Bursters) < nClusters-1) % only do it if you need to
     */
    if (mlfTobool(
          mlfLt(mlfLength(Bursters), mlfMinus(nClusters, mlfScalar(1.0))))) {
        /*
         * CommonSpikes = find(~ismember(Clu,union(1,Bursters)));
         */
        mlfAssign(
          &CommonSpikes,
          mlfFind(
            NULL,
            NULL,
            mlfNot(
              mlfIsmember(
                Clu,
                mlfNUnion(1, NULL, NULL, mlfScalar(1.0), Bursters, NULL),
                NULL))));
        /*
         * CommonCovMat = cov(Fet(CommonSpikes,:) - Means(Clu(CommonSpikes),:));
         */
        mlfAssign(
          &CommonCovMat,
          mlfCov(
            mlfMinus(
              mlfIndexRef(Fet, "(?,?)", CommonSpikes, mlfCreateColonIndex()),
              mlfIndexRef(
                Means,
                "(?,?)",
                mlfIndexRef(Clu, "(?)", CommonSpikes),
                mlfCreateColonIndex())),
            NULL));
        /*
         * CommonCovMatMH = CommonCovMat^-0.5;
         */
        mlfAssign(&CommonCovMatMH, mlfMpower(CommonCovMat, mlfScalar(-0.5)));
    /*
     * end
     */
    }
    /*
     * 
     * % Calculate all others
     * for c=2:nClusters
     */
    for (mclForStart(&iterator_0, mlfScalar(2.0), nClusters, NULL);
         mclForNext(&iterator_0, &c);
         ) {
        /*
         * if (ismember(c,Bursters))
         */
        if (mlfTobool(mlfIsmember(c, Bursters, NULL))) {
            /*
             * % for bursting cells calculate the covariance matrix individually
             * CovMat = cov(Fet(find(Clu==c),:));
             */
            mlfAssign(
              &CovMat,
              mlfCov(
                mlfIndexRef(
                  Fet,
                  "(?,?)",
                  mlfFind(NULL, NULL, mlfEq(Clu, c)),
                  mlfCreateColonIndex()),
                NULL));
            /*
             * CovMatMH(:,:,c) = CovMat^-0.5;
             */
            mlfIndexAssign(
              CovMatMH,
              "(?,?,?)",
              mlfCreateColonIndex(),
              mlfCreateColonIndex(),
              c,
              mlfMpower(CovMat, mlfScalar(-0.5)));
        /*
         * else
         */
        } else {
            /*
             * % for all others use the common covariance matrix
             * CovMatMH(:,:,c) = CommonCovMatMH;
             */
            mlfIndexAssign(
              CovMatMH,
              "(?,?,?)",
              mlfCreateColonIndex(),
              mlfCreateColonIndex(),
              c,
              CommonCovMatMH);
        /*
         * end
         */
        }
    /*
     * end
     */
    }
    mclValidateOutputs("KlustaKleen/CalcStats", 2, nargout_, &Means, CovMatMH);
    mxDestroyArray(CommonCovMat);
    mxDestroyArray(CommonCovMatMH);
    mxDestroyArray(CommonSpikes);
    mxDestroyArray(CovMat);
    mxDestroyArray(c);
    mxDestroyArray(nClusters);
    mxDestroyArray(nDims);
    /*
     * return
     * 
     * % this function gets certain stuff from the user at the start of each operation
     * function [WhichFets, Clu2Clean, CutDist, Bursters] = GetUserInputs(nDimsAll, nClusters)
     * 
     * fprintf('Which features to use (all)? Use MATLAB format, eg 1:12, [1 4 7 10].\n');
     * WhichFets  = input('');
     * if (isempty(WhichFets)) 
     * WhichFets = 1:nDimsAll;
     * end
     * 
     * Clu2Clean = input('Which clusters do you want to clean (all)?\n');
     * if (isempty(Clu2Clean))
     * Clu2Clean = 2:nClusters;
     * end
     * 
     * Bursters = input('Enter any clusters that you want to have their own covariance matrices (i.e. bursting cells)\n');
     * 
     * pVal = input('Enter cut-off p-value (default 0.99)\n');
     * if (isempty(pVal)) 
     * pVal = 0.99; 
     * end
     * CutDist = chi2inv(pVal, length(WhichFets));
     * return;
     */
    return Means;
}

/*
 * The function "mlfKlustaKleen_CalcStats" contains the normal interface for
 * the "KlustaKleen/CalcStats" M-function from file
 * "/u5/b/ken/matlab/DogFood/compiler/KlustaKleen.m" (lines 125-156). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
static mxArray * mlfKlustaKleen_CalcStats(mxArray * * CovMatMH,
                                          mxArray * Fet,
                                          mxArray * Clu,
                                          mxArray * Bursters) {
    int nargout = 1;
    mxArray * Means = mclGetUninitializedArray();
    mxArray * CovMatMH__ = mclGetUninitializedArray();
    mlfEnterNewContext(1, 3, CovMatMH, Fet, Clu, Bursters);
    if (CovMatMH != NULL) {
        ++nargout;
    }
    Means = MKlustaKleen_CalcStats(&CovMatMH__, nargout, Fet, Clu, Bursters);
    mlfRestorePreviousContext(1, 3, CovMatMH, Fet, Clu, Bursters);
    if (CovMatMH != NULL) {
        mclCopyOutputArg(CovMatMH, CovMatMH__);
    } else {
        mxDestroyArray(CovMatMH__);
    }
    return mlfReturnValue(Means);
}

/*
 * The function "mlxKlustaKleen_CalcStats" contains the feval interface for the
 * "KlustaKleen/CalcStats" M-function from file
 * "/u5/b/ken/matlab/DogFood/compiler/KlustaKleen.m" (lines 125-156). The feval
 * function calls the implementation version of KlustaKleen/CalcStats through
 * this function. This function processes any input arguments and passes them
 * to the implementation version of the function, appearing above.
 */
static void mlxKlustaKleen_CalcStats(int nlhs,
                                     mxArray * plhs[],
                                     int nrhs,
                                     mxArray * prhs[]) {
    mxArray * mprhs[3];
    mxArray * mplhs[2];
    int i;
    if (nlhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: KlustaKleen/CalcStats Line: 125 Co"
            "lumn: 0 The function \"KlustaKleen/CalcStats\" was calle"
            "d with more than the declared number of outputs (2)"));
    }
    if (nrhs > 3) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: KlustaKleen/CalcStats Line: 125 C"
            "olumn: 0 The function \"KlustaKleen/CalcStats\" was cal"
            "led with more than the declared number of inputs (3)"));
    }
    for (i = 0; i < 2; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 3 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 3; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    mplhs[0]
      = MKlustaKleen_CalcStats(&mplhs[1], nlhs, mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 2 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 2; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}

/*
 * The function "MKlustaKleen_GetUserInputs" is the implementation version of
 * the "KlustaKleen/GetUserInputs" M-function from file
 * "/u5/b/ken/matlab/DogFood/compiler/KlustaKleen.m" (lines 156-177). It
 * contains the actual compiled code for that M-function. It is a static
 * function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * function [WhichFets, Clu2Clean, CutDist, Bursters] = GetUserInputs(nDimsAll, nClusters)
 */
static mxArray * MKlustaKleen_GetUserInputs(mxArray * * Clu2Clean,
                                            mxArray * * CutDist,
                                            mxArray * * Bursters,
                                            int nargout_,
                                            mxArray * nDimsAll,
                                            mxArray * nClusters) {
    mxArray * WhichFets = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mxArray * pVal = mclGetUninitializedArray();
    mclValidateInputs("KlustaKleen/GetUserInputs", 2, &nDimsAll, &nClusters);
    /*
     * 
     * fprintf('Which features to use (all)? Use MATLAB format, eg 1:12, [1 4 7 10].\n');
     */
    mclAssignAns(
      &ans,
      mlfFprintf(
        mxCreateString(
          "Which features to use (all)? Use MATL"
          "AB format, eg 1:12, [1 4 7 10].\\n"),
        NULL));
    /*
     * WhichFets  = input('');
     */
    mlfAssign(
      &WhichFets,
      (mlfError(
         mxCreateString(
           "Run-time Error: File: KlustaKleen Line: 159 Column: 14 T"
           "he Compiler does not support EVAL or INPUT functions")),
       mclCastToMxarray(NULL)));
    /*
     * if (isempty(WhichFets)) 
     */
    if (mlfTobool(mlfIsempty(WhichFets))) {
        /*
         * WhichFets = 1:nDimsAll;
         */
        mlfAssign(&WhichFets, mlfColon(mlfScalar(1.0), nDimsAll, NULL));
    /*
     * end
     */
    }
    /*
     * 
     * Clu2Clean = input('Which clusters do you want to clean (all)?\n');
     */
    mlfAssign(
      Clu2Clean,
      (mlfError(
         mxCreateString(
           "Run-time Error: File: KlustaKleen Line: 164 Column: 13 T"
           "he Compiler does not support EVAL or INPUT functions")),
       mclCastToMxarray(NULL)));
    /*
     * if (isempty(Clu2Clean))
     */
    if (mlfTobool(mlfIsempty(*Clu2Clean))) {
        /*
         * Clu2Clean = 2:nClusters;
         */
        mlfAssign(Clu2Clean, mlfColon(mlfScalar(2.0), nClusters, NULL));
    /*
     * end
     */
    }
    /*
     * 
     * Bursters = input('Enter any clusters that you want to have their own covariance matrices (i.e. bursting cells)\n');
     */
    mlfAssign(
      Bursters,
      (mlfError(
         mxCreateString(
           "Run-time Error: File: KlustaKleen Line: 169 Column: 12 T"
           "he Compiler does not support EVAL or INPUT functions")),
       mclCastToMxarray(NULL)));
    /*
     * 
     * pVal = input('Enter cut-off p-value (default 0.99)\n');
     */
    mlfAssign(
      &pVal,
      (mlfError(
         mxCreateString(
           "Run-time Error: File: KlustaKleen Line: 171 Column: 8 T"
           "he Compiler does not support EVAL or INPUT functions")),
       mclCastToMxarray(NULL)));
    /*
     * if (isempty(pVal)) 
     */
    if (mlfTobool(mlfIsempty(pVal))) {
        /*
         * pVal = 0.99; 
         */
        mlfAssign(&pVal, mlfScalar(0.99));
    /*
     * end
     */
    }
    /*
     * CutDist = chi2inv(pVal, length(WhichFets));
     */
    mlfAssign(CutDist, mlfChi2inv(pVal, mlfLength(WhichFets)));
    mclValidateOutputs(
      "KlustaKleen/GetUserInputs",
      4,
      nargout_,
      &WhichFets,
      Clu2Clean,
      CutDist,
      Bursters);
    mxDestroyArray(ans);
    mxDestroyArray(pVal);
    /*
     * return;
     */
    return WhichFets;
}

/*
 * The function "mlfKlustaKleen_GetUserInputs" contains the normal interface
 * for the "KlustaKleen/GetUserInputs" M-function from file
 * "/u5/b/ken/matlab/DogFood/compiler/KlustaKleen.m" (lines 156-177). This
 * function processes any input arguments and passes them to the implementation
 * version of the function, appearing above.
 */
static mxArray * mlfKlustaKleen_GetUserInputs(mxArray * * Clu2Clean,
                                              mxArray * * CutDist,
                                              mxArray * * Bursters,
                                              mxArray * nDimsAll,
                                              mxArray * nClusters) {
    int nargout = 1;
    mxArray * WhichFets = mclGetUninitializedArray();
    mxArray * Clu2Clean__ = mclGetUninitializedArray();
    mxArray * CutDist__ = mclGetUninitializedArray();
    mxArray * Bursters__ = mclGetUninitializedArray();
    mlfEnterNewContext(3, 2, Clu2Clean, CutDist, Bursters, nDimsAll, nClusters);
    if (Clu2Clean != NULL) {
        ++nargout;
    }
    if (CutDist != NULL) {
        ++nargout;
    }
    if (Bursters != NULL) {
        ++nargout;
    }
    WhichFets
      = MKlustaKleen_GetUserInputs(
          &Clu2Clean__, &CutDist__, &Bursters__, nargout, nDimsAll, nClusters);
    mlfRestorePreviousContext(
      3, 2, Clu2Clean, CutDist, Bursters, nDimsAll, nClusters);
    if (Clu2Clean != NULL) {
        mclCopyOutputArg(Clu2Clean, Clu2Clean__);
    } else {
        mxDestroyArray(Clu2Clean__);
    }
    if (CutDist != NULL) {
        mclCopyOutputArg(CutDist, CutDist__);
    } else {
        mxDestroyArray(CutDist__);
    }
    if (Bursters != NULL) {
        mclCopyOutputArg(Bursters, Bursters__);
    } else {
        mxDestroyArray(Bursters__);
    }
    return mlfReturnValue(WhichFets);
}

/*
 * The function "mlxKlustaKleen_GetUserInputs" contains the feval interface for
 * the "KlustaKleen/GetUserInputs" M-function from file
 * "/u5/b/ken/matlab/DogFood/compiler/KlustaKleen.m" (lines 156-177). The feval
 * function calls the implementation version of KlustaKleen/GetUserInputs
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
static void mlxKlustaKleen_GetUserInputs(int nlhs,
                                         mxArray * plhs[],
                                         int nrhs,
                                         mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[4];
    int i;
    if (nlhs > 4) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: KlustaKleen/GetUserInputs Line: 156 "
            "Column: 0 The function \"KlustaKleen/GetUserInputs\" was c"
            "alled with more than the declared number of outputs (4)"));
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: KlustaKleen/GetUserInputs Line: 156 "
            "Column: 0 The function \"KlustaKleen/GetUserInputs\" was c"
            "alled with more than the declared number of inputs (2)"));
    }
    for (i = 0; i < 4; ++i) {
        mplhs[i] = NULL;
    }
    for (i = 0; i < 2 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 2; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 2, mprhs[0], mprhs[1]);
    mplhs[0]
      = MKlustaKleen_GetUserInputs(
          &mplhs[1], &mplhs[2], &mplhs[3], nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
    plhs[0] = mplhs[0];
    for (i = 1; i < 4 && i < nlhs; ++i) {
        plhs[i] = mplhs[i];
    }
    for (; i < 4; ++i) {
        mxDestroyArray(mplhs[i]);
    }
}
