/*
 * MATLAB Compiler: 2.1
 * Date: Mon May  7 15:50:01 2001
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-x" "-W" "mex" "-L" "C"
 * "-t" "-T" "link:mexlibrary" "libmatlbmx.mlib" "-w" "ResSubset" 
 */
#include "ResSubset.h"
#include "LoadClu.h"
#include "LoadFet.h"
#include "LoadPar.h"
#include "LoadPar1.h"
#include "SaveClu.h"
#include "SaveFet.h"
#include "SaveSpk.h"
#include "WithinRanges.h"
#include "bload.h"
#include "libmatlbm.h"
#include "msave.h"
#include "num2str.h"

static mxChar _array1_[136] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'R', 'e', 's', 'S', 'u',
                                'b', 's', 'e', 't', ' ', 'L', 'i', 'n', 'e',
                                ':', ' ', '9', ' ', 'C', 'o', 'l', 'u', 'm',
                                'n', ':', ' ', '1', ' ', 'T', 'h', 'e', ' ',
                                'f', 'u', 'n', 'c', 't', 'i', 'o', 'n', ' ',
                                '"', 'R', 'e', 's', 'S', 'u', 'b', 's', 'e',
                                't', '"', ' ', 'w', 'a', 's', ' ', 'c', 'a',
                                'l', 'l', 'e', 'd', ' ', 'w', 'i', 't', 'h',
                                ' ', 'm', 'o', 'r', 'e', ' ', 't', 'h', 'a',
                                'n', ' ', 't', 'h', 'e', ' ', 'd', 'e', 'c',
                                'l', 'a', 'r', 'e', 'd', ' ', 'n', 'u', 'm',
                                'b', 'e', 'r', ' ', 'o', 'f', ' ', 'o', 'u',
                                't', 'p', 'u', 't', 's', ' ', '(', '0', ')',
                                '.' };
static mxArray * _mxarray0_;

static mxChar _array3_[135] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'R', 'e', 's', 'S', 'u',
                                'b', 's', 'e', 't', ' ', 'L', 'i', 'n', 'e',
                                ':', ' ', '9', ' ', 'C', 'o', 'l', 'u', 'm',
                                'n', ':', ' ', '1', ' ', 'T', 'h', 'e', ' ',
                                'f', 'u', 'n', 'c', 't', 'i', 'o', 'n', ' ',
                                '"', 'R', 'e', 's', 'S', 'u', 'b', 's', 'e',
                                't', '"', ' ', 'w', 'a', 's', ' ', 'c', 'a',
                                'l', 'l', 'e', 'd', ' ', 'w', 'i', 't', 'h',
                                ' ', 'm', 'o', 'r', 'e', ' ', 't', 'h', 'a',
                                'n', ' ', 't', 'h', 'e', ' ', 'd', 'e', 'c',
                                'l', 'a', 'r', 'e', 'd', ' ', 'n', 'u', 'm',
                                'b', 'e', 'r', ' ', 'o', 'f', ' ', 'i', 'n',
                                'p', 'u', 't', 's', ' ', '(', '3', ')', '.' };
static mxArray * _mxarray2_;

static mxChar _array5_[4] = { '.', 'p', 'a', 'r' };
static mxArray * _mxarray4_;
static mxArray * _mxarray6_;

static mxChar _array8_[4] = { '.', 'r', 'e', 's' };
static mxArray * _mxarray7_;

static mxChar _array10_[4] = { '.', 'c', 'l', 'u' };
static mxArray * _mxarray9_;

static mxChar _array12_[4] = { '!', 'c', 'p', ' ' };
static mxArray * _mxarray11_;

static mxChar _array14_[5] = { '.', 'p', 'a', 'r', ' ' };
static mxArray * _mxarray13_;

static mxChar _array16_[5] = { '.', 'p', 'a', 'r', '.' };
static mxArray * _mxarray15_;

static mxChar _array18_[5] = { '.', 'r', 'e', 's', '.' };
static mxArray * _mxarray17_;

static mxChar _array20_[5] = { '.', 'c', 'l', 'u', '.' };
static mxArray * _mxarray19_;

static mxChar _array22_[5] = { '.', 'f', 'e', 't', '.' };
static mxArray * _mxarray21_;

static mxChar _array24_[5] = { '.', 's', 'p', 'k', '.' };
static mxArray * _mxarray23_;
static mxArray * _mxarray25_;

static mxChar _array27_[6] = { '*', 'i', 'n', 't', '1', '6' };
static mxArray * _mxarray26_;

static mxChar _array29_[1] = { ' ' };
static mxArray * _mxarray28_;

static mxChar _array31_[4] = { '.', 'm', 'm', '.' };
static mxArray * _mxarray30_;

void InitializeModule_ResSubset(void) {
    _mxarray0_ = mclInitializeString(136, _array1_);
    _mxarray2_ = mclInitializeString(135, _array3_);
    _mxarray4_ = mclInitializeString(4, _array5_);
    _mxarray6_ = mclInitializeDouble(1.0);
    _mxarray7_ = mclInitializeString(4, _array8_);
    _mxarray9_ = mclInitializeString(4, _array10_);
    _mxarray11_ = mclInitializeString(4, _array12_);
    _mxarray13_ = mclInitializeString(5, _array14_);
    _mxarray15_ = mclInitializeString(5, _array16_);
    _mxarray17_ = mclInitializeString(5, _array18_);
    _mxarray19_ = mclInitializeString(5, _array20_);
    _mxarray21_ = mclInitializeString(5, _array22_);
    _mxarray23_ = mclInitializeString(5, _array24_);
    _mxarray25_ = mclInitializeDouble(2.0);
    _mxarray26_ = mclInitializeString(6, _array27_);
    _mxarray28_ = mclInitializeString(1, _array29_);
    _mxarray30_ = mclInitializeString(4, _array31_);
}

void TerminateModule_ResSubset(void) {
    mxDestroyArray(_mxarray30_);
    mxDestroyArray(_mxarray28_);
    mxDestroyArray(_mxarray26_);
    mxDestroyArray(_mxarray25_);
    mxDestroyArray(_mxarray23_);
    mxDestroyArray(_mxarray21_);
    mxDestroyArray(_mxarray19_);
    mxDestroyArray(_mxarray17_);
    mxDestroyArray(_mxarray15_);
    mxDestroyArray(_mxarray13_);
    mxDestroyArray(_mxarray11_);
    mxDestroyArray(_mxarray9_);
    mxDestroyArray(_mxarray7_);
    mxDestroyArray(_mxarray6_);
    mxDestroyArray(_mxarray4_);
    mxDestroyArray(_mxarray2_);
    mxDestroyArray(_mxarray0_);
}

static void MResSubset(mxArray * From, mxArray * To, mxArray * Ranges);

_mexLocalFunctionTable _local_function_table_ResSubset
  = { 0, (mexFunctionTableEntry *)NULL };

/*
 * The function "mlfResSubset" contains the normal interface for the
 * "ResSubset" M-function from file "/u5/b/ken/matlab/DogFood/ResSubset.m"
 * (lines 1-53). This function processes any input arguments and passes them to
 * the implementation version of the function, appearing above.
 */
void mlfResSubset(mxArray * From, mxArray * To, mxArray * Ranges) {
    mlfEnterNewContext(0, 3, From, To, Ranges);
    MResSubset(From, To, Ranges);
    mlfRestorePreviousContext(0, 3, From, To, Ranges);
}

/*
 * The function "mlxResSubset" contains the feval interface for the "ResSubset"
 * M-function from file "/u5/b/ken/matlab/DogFood/ResSubset.m" (lines 1-53).
 * The feval function calls the implementation version of ResSubset through
 * this function. This function processes any input arguments and passes them
 * to the implementation version of the function, appearing above.
 */
void mlxResSubset(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[3];
    int i;
    if (nlhs > 0) {
        mlfError(_mxarray0_);
    }
    if (nrhs > 3) {
        mlfError(_mxarray2_);
    }
    for (i = 0; i < 3 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 3; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
    MResSubset(mprhs[0], mprhs[1], mprhs[2]);
    mlfRestorePreviousContext(0, 3, mprhs[0], mprhs[1], mprhs[2]);
}

/*
 * The function "MResSubset" is the implementation version of the "ResSubset"
 * M-function from file "/u5/b/ken/matlab/DogFood/ResSubset.m" (lines 1-53). It
 * contains the actual compiled code for that M-function. It is a static
 * function and must only be called from one of the interface functions,
 * appearing below.
 */
/*
 * % ResSubSet(From, To, Ranges)
 * %
 * % loads From.res, From.clu, and all From.fet.n, From.spk.m, etc
 * % finds those spikes from which the res values are within Ranges,
 * % and writes To.res, etc.
 * %
 * % also copies .par and .par.n files, and .mm files
 * 
 * function ResSubSet(From, To, Ranges)
 */
static void MResSubset(mxArray * From, mxArray * To, mxArray * Ranges) {
    mexLocalFunctionTable save_local_function_table_ = mclSetCurrentLocalFunctionTable(
                                                         &_local_function_table_ResSubset);
    mxArray * nSpikes = mclGetUninitializedArray();
    mxArray * Spk = mclGetUninitializedArray();
    mxArray * LoadFrom = mclGetUninitializedArray();
    mxArray * n2Load = mclGetUninitializedArray();
    mxArray * Fet = mclGetUninitializedArray();
    mxArray * Par1 = mclGetUninitializedArray();
    mxArray * stri = mclGetUninitializedArray();
    mxArray * i = mclGetUninitializedArray();
    mxArray * Clu = mclGetUninitializedArray();
    mxArray * ans = mclGetUninitializedArray();
    mxArray * good = mclGetUninitializedArray();
    mxArray * Res = mclGetUninitializedArray();
    mxArray * Par = mclGetUninitializedArray();
    mclCopyArray(&From);
    mclCopyArray(&To);
    mclCopyArray(&Ranges);
    /*
     * 
     * Par = LoadPar([From '.par']);
     */
    mlfAssign(
      &Par, mlfLoadPar(mlfHorzcat(mclVa(From, "From"), _mxarray4_, NULL)));
    /*
     * if 1
     */
    if (mlfTobool(_mxarray6_)) {
        /*
         * Res = load([From '.res']);
         */
        mlfAssign(
          &Res,
          mlfLoadStruct(
            mlfHorzcat(mclVa(From, "From"), _mxarray7_, NULL), NULL));
        /*
         * good = find(WithinRanges(Res, Ranges));
         */
        mlfAssign(
          &good,
          mlfFind(
            NULL,
            NULL,
            mclVe(
              mlfWithinRanges(
                mclVv(Res, "Res"), mclVa(Ranges, "Ranges"), NULL))));
        /*
         * msave([To '.res'], Res(good));
         */
        mlfMsave(
          mlfHorzcat(mclVa(To, "To"), _mxarray7_, NULL),
          mclVe(mclArrayRef1(mclVsv(Res, "Res"), mclVsv(good, "good"))));
        /*
         * clear Res;
         */
        mlfClear(&Res, NULL);
        /*
         * 
         * Clu = LoadClu([From '.clu']);
         */
        mlfAssign(
          &Clu, mlfLoadClu(mlfHorzcat(mclVa(From, "From"), _mxarray9_, NULL)));
        /*
         * SaveClu([To '.clu'], Clu(good));
         */
        mlfSaveClu(
          mlfHorzcat(mclVa(To, "To"), _mxarray9_, NULL),
          mclVe(mclArrayRef1(mclVsv(Clu, "Clu"), mclVsv(good, "good"))));
        /*
         * 
         * eval(['!cp ' From '.par ' To '.par']);
         */
        mclAssignAns(
          &ans,
          mlfEval(
            mclAnsVarargout(),
            mlfHorzcat(
              _mxarray11_,
              mclVa(From, "From"),
              _mxarray13_,
              mclVa(To, "To"),
              _mxarray4_,
              NULL),
            NULL));
    /*
     * end
     */
    }
    /*
     * for i=1:Par.nElecGps
     */
    {
        mclForLoopIterator viter__;
        for (mclForStart(
               &viter__,
               mclFeval(
                 mclValueVarargout(),
                 mlxColon,
                 _mxarray6_,
                 mclVe(mlfIndexRef(mclVsv(Par, "Par"), ".nElecGps")),
                 NULL),
               NULL,
               NULL);
             mclForNext(&viter__, &i);
             ) {
            /*
             * stri = num2str(i);
             */
            mlfAssign(&stri, mlfNum2str(mclVv(i, "i"), NULL));
            /*
             * Par1 = LoadPar1([From '.par.' num2str(i)]);
             */
            mlfAssign(
              &Par1,
              mlfLoadPar1(
                mlfHorzcat(
                  mclVa(From, "From"),
                  _mxarray15_,
                  mclVe(mlfNum2str(mclVv(i, "i"), NULL)),
                  NULL)));
            /*
             * Res = load([From '.res.' stri]);
             */
            mlfAssign(
              &Res,
              mlfLoadStruct(
                mlfHorzcat(
                  mclVa(From, "From"), _mxarray17_, mclVv(stri, "stri"), NULL),
                NULL));
            /*
             * good = find(WithinRanges(Res, Ranges));
             */
            mlfAssign(
              &good,
              mlfFind(
                NULL,
                NULL,
                mclVe(
                  mlfWithinRanges(
                    mclVv(Res, "Res"), mclVa(Ranges, "Ranges"), NULL))));
            /*
             * 
             * msave([To '.res.' stri], Res(good));
             */
            mlfMsave(
              mlfHorzcat(
                mclVa(To, "To"), _mxarray17_, mclVv(stri, "stri"), NULL),
              mclVe(mclArrayRef1(mclVsv(Res, "Res"), mclVsv(good, "good"))));
            /*
             * clear Res;
             */
            mlfClear(&Res, NULL);
            /*
             * 
             * Clu = LoadClu([From '.clu.' stri]);
             */
            mlfAssign(
              &Clu,
              mlfLoadClu(
                mlfHorzcat(
                  mclVa(From, "From"),
                  _mxarray19_,
                  mclVv(stri, "stri"),
                  NULL)));
            /*
             * SaveClu([To '.clu.' stri], Clu(good));
             */
            mlfSaveClu(
              mlfHorzcat(
                mclVa(To, "To"), _mxarray19_, mclVv(stri, "stri"), NULL),
              mclVe(mclArrayRef1(mclVsv(Clu, "Clu"), mclVsv(good, "good"))));
            /*
             * clear Clu;
             */
            mlfClear(&Clu, NULL);
            /*
             * 
             * Fet = LoadFet([From '.fet.' stri]);
             */
            mlfAssign(
              &Fet,
              mlfLoadFet(
                mlfHorzcat(
                  mclVa(From, "From"),
                  _mxarray21_,
                  mclVv(stri, "stri"),
                  NULL)));
            /*
             * SaveFet([To '.fet.' stri], Fet(good,:));
             */
            mlfSaveFet(
              mlfHorzcat(
                mclVa(To, "To"), _mxarray21_, mclVv(stri, "stri"), NULL),
              mclVe(
                mclArrayRef2(
                  mclVsv(Fet, "Fet"),
                  mclVsv(good, "good"),
                  mlfCreateColonIndex())));
            /*
             * 
             * %	Spk = LoadSpk([From '.spk.' stri], Par1.nChannels, Par1.WaveSamples, max(good));
             * % load spike manually to deal with huge files ...
             * n2Load = 1+max(good)-min(good);
             */
            mlfAssign(
              &n2Load,
              mclMinus(
                mclPlus(
                  _mxarray6_,
                  mclVe(mlfMax(NULL, mclVv(good, "good"), NULL, NULL))),
                mclVe(mlfMin(NULL, mclVv(good, "good"), NULL, NULL))));
            /*
             * LoadFrom = min(good)-1;
             */
            mlfAssign(
              &LoadFrom,
              mclMinus(
                mclVe(mlfMin(NULL, mclVv(good, "good"), NULL, NULL)),
                _mxarray6_));
            /*
             * Spk = bload([From '.spk.' stri], [Par1.nChannels, Par1.WaveSamples*n2Load], ...
             */
            mlfAssign(
              &Spk,
              mlfBload(
                mlfHorzcat(
                  mclVa(From, "From"), _mxarray23_, mclVv(stri, "stri"), NULL),
                mlfHorzcat(
                  mclVe(mlfIndexRef(mclVsv(Par1, "Par1"), ".nChannels")),
                  mclFeval(
                    mclValueVarargout(),
                    mlxMtimes,
                    mclVe(mlfIndexRef(mclVsv(Par1, "Par1"), ".WaveSamples")),
                    mclVv(n2Load, "n2Load"),
                    NULL),
                  NULL),
                mclFeval(
                  mclValueVarargout(),
                  mlxMtimes,
                  mclFeval(
                    mclValueVarargout(),
                    mlxMtimes,
                    mclMtimes(mclVv(LoadFrom, "LoadFrom"), _mxarray25_),
                    mclVe(mlfIndexRef(mclVsv(Par1, "Par1"), ".nChannels")),
                    NULL),
                  mclVe(mlfIndexRef(mclVsv(Par1, "Par1"), ".WaveSamples")),
                  NULL),
                _mxarray26_,
                NULL));
            /*
             * LoadFrom*2*Par1.nChannels*Par1.WaveSamples, '*int16');
             * nSpikes = size(Spk,2)/Par1.WaveSamples;
             */
            mlfAssign(
              &nSpikes,
              mclFeval(
                mclValueVarargout(),
                mlxMrdivide,
                mclVe(
                  mlfSize(mclValueVarargout(), mclVv(Spk, "Spk"), _mxarray25_)),
                mclVe(mlfIndexRef(mclVsv(Par1, "Par1"), ".WaveSamples")),
                NULL));
            /*
             * Spk = reshape(Spk, [Par1.nChannels, Par1.WaveSamples, nSpikes]);
             */
            mlfAssign(
              &Spk,
              mlfReshape(
                mclVv(Spk, "Spk"),
                mlfHorzcat(
                  mclVe(mlfIndexRef(mclVsv(Par1, "Par1"), ".nChannels")),
                  mclVe(mlfIndexRef(mclVsv(Par1, "Par1"), ".WaveSamples")),
                  mclVv(nSpikes, "nSpikes"),
                  NULL),
                NULL));
            /*
             * SaveSpk([To '.spk.' stri], Spk(:,:,good-LoadFrom));
             */
            mlfSaveSpk(
              mlfHorzcat(
                mclVa(To, "To"), _mxarray23_, mclVv(stri, "stri"), NULL),
              mclVe(
                mlfIndexRef(
                  mclVsv(Spk, "Spk"),
                  "(?,?,?)",
                  mlfCreateColonIndex(),
                  mlfCreateColonIndex(),
                  mclMinus(mclVv(good, "good"), mclVv(LoadFrom, "LoadFrom")))));
            /*
             * clear Spk
             */
            mlfClear(&Spk, NULL);
            /*
             * 
             * % now copy .par.n and .mm.n    
             * eval(['!cp ' From '.par.' stri ' ' To '.par.' stri]);
             */
            mclAssignAns(
              &ans,
              mlfEval(
                mclAnsVarargout(),
                mlfHorzcat(
                  _mxarray11_,
                  mclVa(From, "From"),
                  _mxarray15_,
                  mclVv(stri, "stri"),
                  _mxarray28_,
                  mclVa(To, "To"),
                  _mxarray15_,
                  mclVv(stri, "stri"),
                  NULL),
                NULL));
            /*
             * eval(['!cp ' From '.mm.' stri ' ' To '.mm.' stri]);   
             */
            mclAssignAns(
              &ans,
              mlfEval(
                mclAnsVarargout(),
                mlfHorzcat(
                  _mxarray11_,
                  mclVa(From, "From"),
                  _mxarray30_,
                  mclVv(stri, "stri"),
                  _mxarray28_,
                  mclVa(To, "To"),
                  _mxarray30_,
                  mclVv(stri, "stri"),
                  NULL),
                NULL));
        /*
         * end
         */
        }
        mclDestroyForLoopIterator(viter__);
    }
    mxDestroyArray(Par);
    mxDestroyArray(Res);
    mxDestroyArray(good);
    mxDestroyArray(ans);
    mxDestroyArray(Clu);
    mxDestroyArray(i);
    mxDestroyArray(stri);
    mxDestroyArray(Par1);
    mxDestroyArray(Fet);
    mxDestroyArray(n2Load);
    mxDestroyArray(LoadFrom);
    mxDestroyArray(Spk);
    mxDestroyArray(nSpikes);
    mxDestroyArray(Ranges);
    mxDestroyArray(To);
    mxDestroyArray(From);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
}
