/*
 * MATLAB Compiler: 3.0
 * Date: Mon Jul 12 20:54:12 2004
 * Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
 * "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
 * "array_indexing:on" "-O" "optimize_conditionals:on" "-m" "-W" "main" "-L"
 * "C" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "-v" "ResampleFile" 
 */
#include "ResampleFile.h"
#include "Sresample.h"
#include "libmatlbm.h"
#include "libmmfile.h"

static mxChar _array1_[71] = { 'f', 'u', 'n', 'c', 't', 'i', 'o', 'n', ' ',
                               'R', 'e', 's', 'a', 'm', 'p', 'l', 'e', 'F',
                               'i', 'l', 'e', '(', 'i', 'n', 'n', 'a', 'm',
                               'e', ',', 'o', 'u', 't', 'n', 'a', 'm', 'e',
                               ',', 'n', 'u', 'm', 'c', 'h', 'a', 'n', 'n',
                               'e', 'l', ',', 'r', 'e', 's', 'a', 'm', 'p',
                               'l', 'd', 'o', 'w', 'n', ',', ' ', 'r', 'e',
                               's', 'a', 'm', 'p', 'l', 'u', 'p', ')' };
static mxArray * _mxarray0_;
static mxArray * _mxarray2_;

static mxChar _array4_[1] = { 'r' };
static mxArray * _mxarray3_;

static mxChar _array6_[1] = { 'w' };
static mxArray * _mxarray5_;
static mxArray * _mxarray7_;
static mxArray * _mxarray8_;
static mxArray * _mxarray9_;

static mxChar _array11_[5] = { 'i', 'n', 't', '1', '6' };
static mxArray * _mxarray10_;

void InitializeModule_ResampleFile(void) {
    _mxarray0_ = mclInitializeString(71, _array1_);
    _mxarray2_ = mclInitializeDouble(1.0);
    _mxarray3_ = mclInitializeString(1, _array4_);
    _mxarray5_ = mclInitializeString(1, _array6_);
    _mxarray7_ = mclInitializeDouble(4096.0);
    _mxarray8_ = mclInitializeDouble(8.0);
    _mxarray9_ = mclInitializeDouble(2.0);
    _mxarray10_ = mclInitializeString(5, _array11_);
}

void TerminateModule_ResampleFile(void) {
    mxDestroyArray(_mxarray10_);
    mxDestroyArray(_mxarray9_);
    mxDestroyArray(_mxarray8_);
    mxDestroyArray(_mxarray7_);
    mxDestroyArray(_mxarray5_);
    mxDestroyArray(_mxarray3_);
    mxDestroyArray(_mxarray2_);
    mxDestroyArray(_mxarray0_);
}

static void MResampleFile(mxArray * inname,
                          mxArray * outname,
                          mxArray * numchannel,
                          mxArray * resampldown,
                          mxArray * resamplup);

_mexLocalFunctionTable _local_function_table_ResampleFile
  = { 0, (mexFunctionTableEntry *)NULL };

/*
 * The function "mlfResampleFile" contains the normal interface for the
 * "ResampleFile" M-function from file
 * "/u12/antsiro/matlab/General/ResampleFile.m" (lines 1-60). This function
 * processes any input arguments and passes them to the implementation version
 * of the function, appearing above.
 */
void mlfResampleFile(mxArray * inname,
                     mxArray * outname,
                     mxArray * numchannel,
                     mxArray * resampldown,
                     mxArray * resamplup) {
    mlfEnterNewContext(
      0, 5, inname, outname, numchannel, resampldown, resamplup);
    MResampleFile(inname, outname, numchannel, resampldown, resamplup);
    mlfRestorePreviousContext(
      0, 5, inname, outname, numchannel, resampldown, resamplup);
}

/*
 * The function "mlxResampleFile" contains the feval interface for the
 * "ResampleFile" M-function from file
 * "/u12/antsiro/matlab/General/ResampleFile.m" (lines 1-60). The feval
 * function calls the implementation version of ResampleFile through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxResampleFile(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    mxArray * mprhs[5];
    int i;
    if (nlhs > 0) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: ResampleFile Line: 8 Column"
            ": 1 The function \"ResampleFile\" was called with"
            " more than the declared number of outputs (0)."),
          NULL);
    }
    if (nrhs > 5) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: ResampleFile Line: 8 Column"
            ": 1 The function \"ResampleFile\" was called with"
            " more than the declared number of inputs (5)."),
          NULL);
    }
    for (i = 0; i < 5 && i < nrhs; ++i) {
        mprhs[i] = prhs[i];
    }
    for (; i < 5; ++i) {
        mprhs[i] = NULL;
    }
    mlfEnterNewContext(0, 5, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    MResampleFile(mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    mlfRestorePreviousContext(
      0, 5, mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
}

/*
 * The function "MResampleFile" is the implementation version of the
 * "ResampleFile" M-function from file
 * "/u12/antsiro/matlab/General/ResampleFile.m" (lines 1-60). It contains the
 * actual compiled code for that M-function. It is a static function and must
 * only be called from one of the interface functions, appearing below.
 */
/*
 * %ResampleFile(inname,outname,numchannel,resampldown, resamplup)
 * % resampling program --- requires signal processing toolbox
 * % Hajime Hirase ... no warranty ..(sorry) (1999)
 * % function deciall(inname,outname,numchannel,resampl)
 * % this function passes anti aliasing low pass filter first
 * % to the data and then resamples with 1/resampl sampling rate)
 * 
 * function ResampleFile(inname,outname,numchannel,resampldown, resamplup)
 */
static void MResampleFile(mxArray * inname,
                          mxArray * outname,
                          mxArray * numchannel,
                          mxArray * resampldown,
                          mxArray * resamplup) {
    mexLocalFunctionTable save_local_function_table_
      = mclSetCurrentLocalFunctionTable(&_local_function_table_ResampleFile);
    int nargin_
      = mclNargin(
          5, inname, outname, numchannel, resampldown, resamplup, NULL);
    mxArray * count2 = NULL;
    mxArray * resampled = NULL;
    mxArray * datasegment2 = NULL;
    mxArray * datasegment = NULL;
    mxArray * count = NULL;
    mxArray * obuf = NULL;
    mxArray * obufsize11 = NULL;
    mxArray * obufsize = NULL;
    mxArray * overlaporder21 = NULL;
    mxArray * overlaporder2 = NULL;
    mxArray * overlaporder = NULL;
    mxArray * buffersize = NULL;
    mxArray * outfile = NULL;
    mxArray * datafile = NULL;
    mxArray * ans = NULL;
    mclCopyArray(&inname);
    mclCopyArray(&outname);
    mclCopyArray(&numchannel);
    mclCopyArray(&resampldown);
    mclCopyArray(&resamplup);
    /*
     * 
     * if nargin <4,
     */
    if (nargin_ < 4) {
        /*
         * error('function ResampleFile(inname,outname,numchannel,resampldown, resamplup)');
         */
        mlfError(_mxarray0_, NULL);
        /*
         * return
         */
        goto return_;
    /*
     * end
     */
    }
    /*
     * if nargin<5 | isempty(resamplup) %length(resampl)==1
     */
    {
        mxArray * a_ = mclInitialize(mclBoolToArray(nargin_ < 5));
        if (mlfTobool(a_)
            || mlfTobool(
                 mclOr(a_, mlfIsempty(mclVa(resamplup, "resamplup"))))) {
            mxDestroyArray(a_);
            /*
             * resamplup = 1;
             */
            mlfAssign(&resamplup, _mxarray2_);
        } else {
            mxDestroyArray(a_);
        }
    /*
     * end 
     */
    }
    /*
     * 
     * 
     * %if FileLength(inname)<600000
     * %	mydat = bload(inname,[numchannel inf],0);
     * 
     * 
     * 
     * % open input file and output file
     * datafile = fopen(inname,'r');
     */
    mlfAssign(
      &datafile,
      mlfFopen(NULL, NULL, mclVa(inname, "inname"), _mxarray3_, NULL));
    /*
     * outfile = fopen(outname,'w');
     */
    mlfAssign(
      &outfile,
      mlfFopen(NULL, NULL, mclVa(outname, "outname"), _mxarray5_, NULL));
    /*
     * %
     * buffersize = 2^12;
     */
    mlfAssign(&buffersize, _mxarray7_);
    /*
     * overlaporder   = lcm(8,resamplup);
     */
    mlfAssign(&overlaporder, mlfLcm(_mxarray8_, mclVa(resamplup, "resamplup")));
    /*
     * overlaporder2  = overlaporder/2;
     */
    mlfAssign(
      &overlaporder2,
      mclMrdivide(mclVv(overlaporder, "overlaporder"), _mxarray9_));
    /*
     * overlaporder21 = overlaporder2+1;
     */
    mlfAssign(
      &overlaporder21,
      mclPlus(mclVv(overlaporder2, "overlaporder2"), _mxarray2_));
    /*
     * obufsize = overlaporder * resampldown/resamplup ;
     */
    mlfAssign(
      &obufsize,
      mclMrdivide(
        mclMtimes(
          mclVv(overlaporder, "overlaporder"),
          mclVa(resampldown, "resampldown")),
        mclVa(resamplup, "resamplup")));
    /*
     * obufsize11 = obufsize - 1;
     */
    mlfAssign(&obufsize11, mclMinus(mclVv(obufsize, "obufsize"), _mxarray2_));
    /*
     * 
     * % the first buffer
     * 
     * [obuf,count] = fread(datafile,[numchannel,obufsize],'int16');
     */
    mlfAssign(
      &obuf,
      mlfFread(
        &count,
        mclVv(datafile, "datafile"),
        mlfHorzcat(
          mclVa(numchannel, "numchannel"), mclVv(obufsize, "obufsize"), NULL),
        _mxarray10_,
        NULL));
    /*
     * obuf = fliplr(obuf);
     */
    mlfAssign(&obuf, mlfFliplr(mclVv(obuf, "obuf")));
    /*
     * frewind(datafile);
     */
    mlfFrewind(mclVv(datafile, "datafile"));
    /*
     * [datasegment,count] = fread(datafile,[numchannel,buffersize],'int16');  
     */
    mlfAssign(
      &datasegment,
      mlfFread(
        &count,
        mclVv(datafile, "datafile"),
        mlfHorzcat(
          mclVa(numchannel, "numchannel"),
          mclVv(buffersize, "buffersize"),
          NULL),
        _mxarray10_,
        NULL));
    /*
     * datasegment2 = [obuf,datasegment]';
     */
    mlfAssign(
      &datasegment2,
      mlfCtranspose(
        mlfHorzcat(
          mclVv(obuf, "obuf"), mclVv(datasegment, "datasegment"), NULL)));
    /*
     * resampled = Sresample(datasegment2,resamplup,resampldown);
     */
    mlfAssign(
      &resampled,
      mlfSresample(
        NULL,
        mclVv(datasegment2, "datasegment2"),
        mclVa(resamplup, "resamplup"),
        mclVa(resampldown, "resampldown"),
        NULL,
        NULL));
    /*
     * count2 = fwrite(outfile,resampled(overlaporder+1:size(resampled,1)-overlaporder2,:)','int16');
     */
    mlfAssign(
      &count2,
      mlfFwrite(
        mclVv(outfile, "outfile"),
        mlfCtranspose(
          mclArrayRef2(
            mclVv(resampled, "resampled"),
            mlfColon(
              mclPlus(mclVv(overlaporder, "overlaporder"), _mxarray2_),
              mclMinus(
                mlfSize(
                  mclValueVarargout(),
                  mclVv(resampled, "resampled"),
                  _mxarray2_),
                mclVv(overlaporder2, "overlaporder2")),
              NULL),
            mlfCreateColonIndex())),
        _mxarray10_,
        NULL));
    /*
     * obuf = datasegment2(size(datasegment2,1)-obufsize11:size(datasegment2,1),:);
     */
    mlfAssign(
      &obuf,
      mclArrayRef2(
        mclVv(datasegment2, "datasegment2"),
        mlfColon(
          mclMinus(
            mlfSize(
              mclValueVarargout(),
              mclVv(datasegment2, "datasegment2"),
              _mxarray2_),
            mclVv(obufsize11, "obufsize11")),
          mlfSize(
            mclValueVarargout(),
            mclVv(datasegment2, "datasegment2"),
            _mxarray2_),
          NULL),
        mlfCreateColonIndex()));
    /*
     * % do the rest
     * 
     * while ~feof(datafile),
     */
    while (mclNotBool(mlfFeof(mclVv(datafile, "datafile")))) {
        /*
         * [datasegment,count] = fread(datafile,[numchannel,buffersize],'int16');  
         */
        mlfAssign(
          &datasegment,
          mlfFread(
            &count,
            mclVv(datafile, "datafile"),
            mlfHorzcat(
              mclVa(numchannel, "numchannel"),
              mclVv(buffersize, "buffersize"),
              NULL),
            _mxarray10_,
            NULL));
        /*
         * datasegment2 = [obuf;datasegment'];
         */
        mlfAssign(
          &datasegment2,
          mlfVertcat(
            mclVv(obuf, "obuf"),
            mlfCtranspose(mclVv(datasegment, "datasegment")),
            NULL));
        /*
         * resampled = Sresample(datasegment2,resamplup,resampldown);
         */
        mlfAssign(
          &resampled,
          mlfSresample(
            NULL,
            mclVv(datasegment2, "datasegment2"),
            mclVa(resamplup, "resamplup"),
            mclVa(resampldown, "resampldown"),
            NULL,
            NULL));
        /*
         * count2 = fwrite(outfile,resampled(overlaporder21:size(resampled,1)-overlaporder2,:)','int16');
         */
        mlfAssign(
          &count2,
          mlfFwrite(
            mclVv(outfile, "outfile"),
            mlfCtranspose(
              mclArrayRef2(
                mclVv(resampled, "resampled"),
                mlfColon(
                  mclVv(overlaporder21, "overlaporder21"),
                  mclMinus(
                    mlfSize(
                      mclValueVarargout(),
                      mclVv(resampled, "resampled"),
                      _mxarray2_),
                    mclVv(overlaporder2, "overlaporder2")),
                  NULL),
                mlfCreateColonIndex())),
            _mxarray10_,
            NULL));
        /*
         * obuf = datasegment2(size(datasegment2,1)-obufsize11:size(datasegment2,1),:);
         */
        mlfAssign(
          &obuf,
          mclArrayRef2(
            mclVv(datasegment2, "datasegment2"),
            mlfColon(
              mclMinus(
                mlfSize(
                  mclValueVarargout(),
                  mclVv(datasegment2, "datasegment2"),
                  _mxarray2_),
                mclVv(obufsize11, "obufsize11")),
              mlfSize(
                mclValueVarargout(),
                mclVv(datasegment2, "datasegment2"),
                _mxarray2_),
              NULL),
            mlfCreateColonIndex()));
    /*
     * end  
     */
    }
    /*
     * 
     * % add the last unprocessed portion 
     * resampled = Sresample(obuf,resamplup,resampldown);
     */
    mlfAssign(
      &resampled,
      mlfSresample(
        NULL,
        mclVv(obuf, "obuf"),
        mclVa(resamplup, "resamplup"),
        mclVa(resampldown, "resampldown"),
        NULL,
        NULL));
    /*
     * count2 = fwrite(outfile,resampled(overlaporder21:end,:)','int16');
     */
    mlfAssign(
      &count2,
      mlfFwrite(
        mclVv(outfile, "outfile"),
        mlfCtranspose(
          mclArrayRef2(
            mclVv(resampled, "resampled"),
            mlfColon(
              mclVv(overlaporder21, "overlaporder21"),
              mlfEnd(mclVv(resampled, "resampled"), _mxarray2_, _mxarray9_),
              NULL),
            mlfCreateColonIndex())),
        _mxarray10_,
        NULL));
    /*
     * fclose(outfile);
     */
    mclAssignAns(&ans, mlfFclose(mclVv(outfile, "outfile")));
    /*
     * 
     */
    return_:
    mxDestroyArray(ans);
    mxDestroyArray(datafile);
    mxDestroyArray(outfile);
    mxDestroyArray(buffersize);
    mxDestroyArray(overlaporder);
    mxDestroyArray(overlaporder2);
    mxDestroyArray(overlaporder21);
    mxDestroyArray(obufsize);
    mxDestroyArray(obufsize11);
    mxDestroyArray(obuf);
    mxDestroyArray(count);
    mxDestroyArray(datasegment);
    mxDestroyArray(datasegment2);
    mxDestroyArray(resampled);
    mxDestroyArray(count2);
    mxDestroyArray(resamplup);
    mxDestroyArray(resampldown);
    mxDestroyArray(numchannel);
    mxDestroyArray(outname);
    mxDestroyArray(inname);
    mclSetCurrentLocalFunctionTable(save_local_function_table_);
}
