//
// MATLAB Compiler: 2.2
// Date: Mon Jul 12 19:42:22 2004
// Arguments: "-B" "macro_default" "-O" "all" "-O" "fold_scalar_mxarrays:on"
// "-O" "fold_non_scalar_mxarrays:on" "-O" "optimize_integer_for_loops:on" "-O"
// "array_indexing:on" "-O" "optimize_conditionals:on" "-p" "-W" "main" "-L"
// "Cpp" "-t" "-T" "link:exe" "-h" "libmmfile.mlib" "ResampleFile.m" 
//
#include "ResampleFile.hpp"
#include "Sresample.hpp"
#include "libmatlbm.hpp"
#include "libmmfile.hpp"

static mxChar _array1_[142] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'R', 'e', 's', 'a', 'm',
                                'p', 'l', 'e', 'F', 'i', 'l', 'e', ' ', 'L',
                                'i', 'n', 'e', ':', ' ', '8', ' ', 'C', 'o',
                                'l', 'u', 'm', 'n', ':', ' ', '1', ' ', 'T',
                                'h', 'e', ' ', 'f', 'u', 'n', 'c', 't', 'i',
                                'o', 'n', ' ', '"', 'R', 'e', 's', 'a', 'm',
                                'p', 'l', 'e', 'F', 'i', 'l', 'e', '"', ' ',
                                'w', 'a', 's', ' ', 'c', 'a', 'l', 'l', 'e',
                                'd', ' ', 'w', 'i', 't', 'h', ' ', 'm', 'o',
                                'r', 'e', ' ', 't', 'h', 'a', 'n', ' ', 't',
                                'h', 'e', ' ', 'd', 'e', 'c', 'l', 'a', 'r',
                                'e', 'd', ' ', 'n', 'u', 'm', 'b', 'e', 'r',
                                ' ', 'o', 'f', ' ', 'o', 'u', 't', 'p', 'u',
                                't', 's', ' ', '(', '0', ')', '.' };
static mwArray _mxarray0_ = mclInitializeString(142, _array1_);

static mxChar _array3_[141] = { 'R', 'u', 'n', '-', 't', 'i', 'm', 'e', ' ',
                                'E', 'r', 'r', 'o', 'r', ':', ' ', 'F', 'i',
                                'l', 'e', ':', ' ', 'R', 'e', 's', 'a', 'm',
                                'p', 'l', 'e', 'F', 'i', 'l', 'e', ' ', 'L',
                                'i', 'n', 'e', ':', ' ', '8', ' ', 'C', 'o',
                                'l', 'u', 'm', 'n', ':', ' ', '1', ' ', 'T',
                                'h', 'e', ' ', 'f', 'u', 'n', 'c', 't', 'i',
                                'o', 'n', ' ', '"', 'R', 'e', 's', 'a', 'm',
                                'p', 'l', 'e', 'F', 'i', 'l', 'e', '"', ' ',
                                'w', 'a', 's', ' ', 'c', 'a', 'l', 'l', 'e',
                                'd', ' ', 'w', 'i', 't', 'h', ' ', 'm', 'o',
                                'r', 'e', ' ', 't', 'h', 'a', 'n', ' ', 't',
                                'h', 'e', ' ', 'd', 'e', 'c', 'l', 'a', 'r',
                                'e', 'd', ' ', 'n', 'u', 'm', 'b', 'e', 'r',
                                ' ', 'o', 'f', ' ', 'i', 'n', 'p', 'u', 't',
                                's', ' ', '(', '5', ')', '.' };
static mwArray _mxarray2_ = mclInitializeString(141, _array3_);

static mxChar _array5_[71] = { 'f', 'u', 'n', 'c', 't', 'i', 'o', 'n', ' ',
                               'R', 'e', 's', 'a', 'm', 'p', 'l', 'e', 'F',
                               'i', 'l', 'e', '(', 'i', 'n', 'n', 'a', 'm',
                               'e', ',', 'o', 'u', 't', 'n', 'a', 'm', 'e',
                               ',', 'n', 'u', 'm', 'c', 'h', 'a', 'n', 'n',
                               'e', 'l', ',', 'r', 'e', 's', 'a', 'm', 'p',
                               'l', 'd', 'o', 'w', 'n', ',', ' ', 'r', 'e',
                               's', 'a', 'm', 'p', 'l', 'u', 'p', ')' };
static mwArray _mxarray4_ = mclInitializeString(71, _array5_);
static mwArray _mxarray6_ = mclInitializeDouble(1.0);

static mxChar _array8_[1] = { 'r' };
static mwArray _mxarray7_ = mclInitializeString(1, _array8_);

static mxChar _array10_[1] = { 'w' };
static mwArray _mxarray9_ = mclInitializeString(1, _array10_);
static mwArray _mxarray11_ = mclInitializeDouble(4096.0);
static mwArray _mxarray12_ = mclInitializeDouble(8.0);
static mwArray _mxarray13_ = mclInitializeDouble(2.0);

static mxChar _array15_[5] = { 'i', 'n', 't', '1', '6' };
static mwArray _mxarray14_ = mclInitializeString(5, _array15_);

void InitializeModule_ResampleFile() {
}

void TerminateModule_ResampleFile() {
}

static void MResampleFile(mwArray inname,
                          mwArray outname,
                          mwArray numchannel,
                          mwArray resampldown,
                          mwArray resamplup);

_mexLocalFunctionTable _local_function_table_ResampleFile
  = { 0, (mexFunctionTableEntry *)NULL };

//
// The function "ResampleFile" contains the normal interface for the
// "ResampleFile" M-function from file
// "/u12/antsiro/matlab/General/ResampleFile.m" (lines 1-60). This function
// processes any input arguments and passes them to the implementation version
// of the function, appearing above.
//
void ResampleFile(mwArray inname,
                  mwArray outname,
                  mwArray numchannel,
                  mwArray resampldown,
                  mwArray resamplup) {
    MResampleFile(inname, outname, numchannel, resampldown, resamplup);
}

//
// The function "mlxResampleFile" contains the feval interface for the
// "ResampleFile" M-function from file
// "/u12/antsiro/matlab/General/ResampleFile.m" (lines 1-60). The feval
// function calls the implementation version of ResampleFile through this
// function. This function processes any input arguments and passes them to the
// implementation version of the function, appearing above.
//
void mlxResampleFile(int nlhs, mxArray * plhs[], int nrhs, mxArray * prhs[]) {
    MW_BEGIN_MLX();
    {
        mwArray mprhs[5];
        int i;
        if (nlhs > 0) {
            error(_mxarray0_);
        }
        if (nrhs > 5) {
            error(_mxarray2_);
        }
        for (i = 0; i < 5 && i < nrhs; ++i) {
            mprhs[i] = mwArray(prhs[i], 0);
        }
        for (; i < 5; ++i) {
            mprhs[i].MakeDIN();
        }
        MResampleFile(mprhs[0], mprhs[1], mprhs[2], mprhs[3], mprhs[4]);
    }
    MW_END_MLX();
}

//
// The function "MResampleFile" is the implementation version of the
// "ResampleFile" M-function from file
// "/u12/antsiro/matlab/General/ResampleFile.m" (lines 1-60). It contains the
// actual compiled code for that M-function. It is a static function and must
// only be called from one of the interface functions, appearing below.
//
//
// %ResampleFile(inname,outname,numchannel,resampldown, resamplup)
// % resampling program --- requires signal processing toolbox
// % Hajime Hirase ... no warranty ..(sorry) (1999)
// % function deciall(inname,outname,numchannel,resampl)
// % this function passes anti aliasing low pass filter first
// % to the data and then resamples with 1/resampl sampling rate)
// 
// function ResampleFile(inname,outname,numchannel,resampldown, resamplup)
//
static void MResampleFile(mwArray inname,
                          mwArray outname,
                          mwArray numchannel,
                          mwArray resampldown,
                          mwArray resamplup) {
    mwLocalFunctionTable save_local_function_table_
      (&_local_function_table_ResampleFile);
    int nargin_
      (nargin(
         5, mwVarargin(inname, outname, numchannel, resampldown, resamplup)));
    mwArray count2(mclGetUninitializedArray());
    mwArray resampled(mclGetUninitializedArray());
    mwArray datasegment2(mclGetUninitializedArray());
    mwArray datasegment(mclGetUninitializedArray());
    mwArray count(mclGetUninitializedArray());
    mwArray obuf(mclGetUninitializedArray());
    mwArray obufsize11(mclGetUninitializedArray());
    mwArray obufsize(mclGetUninitializedArray());
    mwArray overlaporder21(mclGetUninitializedArray());
    mwArray overlaporder2(mclGetUninitializedArray());
    mwArray overlaporder(mclGetUninitializedArray());
    mwArray buffersize(mclGetUninitializedArray());
    mwArray outfile(mclGetUninitializedArray());
    mwArray datafile(mclGetUninitializedArray());
    mwArray ans(mclGetUninitializedArray());
    //
    // 
    // if nargin <4,
    //
    if (nargin_ < 4) {
        //
        // error('function ResampleFile(inname,outname,numchannel,resampldown, resamplup)');
        //
        error(_mxarray4_);
        //
        // return
        //
        goto return_;
    //
    // end
    //
    }
    //
    // if nargin<5 | isempty(resamplup) %length(resampl)==1
    //
    {
        mwArray a_(nargin_ < 5);
        if (tobool(a_)
            || tobool(a_ | mwVe(isempty(mwVa(resamplup, "resamplup"))))) {
            //
            // resamplup = 1;
            //
            resamplup = _mxarray6_;
        } else {
        }
    //
    // end 
    //
    }
    //
    // 
    // 
    // %if FileLength(inname)<600000
    // %	mydat = bload(inname,[numchannel inf],0);
    // 
    // 
    // 
    // % open input file and output file
    // datafile = fopen(inname,'r');
    //
    datafile = fopen(mwVa(inname, "inname"), _mxarray7_);
    //
    // outfile = fopen(outname,'w');
    //
    outfile = fopen(mwVa(outname, "outname"), _mxarray9_);
    //
    // %
    // buffersize = 2^12;
    //
    buffersize = _mxarray11_;
    //
    // overlaporder   = lcm(8,resamplup);
    //
    overlaporder = lcm(_mxarray12_, mwVa(resamplup, "resamplup"));
    //
    // overlaporder2  = overlaporder/2;
    //
    overlaporder2 = mwVv(overlaporder, "overlaporder") / _mxarray13_;
    //
    // overlaporder21 = overlaporder2+1;
    //
    overlaporder21 = mwVv(overlaporder2, "overlaporder2") + _mxarray6_;
    //
    // obufsize = overlaporder * resampldown/resamplup ;
    //
    obufsize
      = mwVv(overlaporder, "overlaporder") * mwVa(resampldown, "resampldown")
        / mwVa(resamplup, "resamplup");
    //
    // obufsize11 = obufsize - 1;
    //
    obufsize11 = mwVv(obufsize, "obufsize") - _mxarray6_;
    //
    // 
    // % the first buffer
    // 
    // [obuf,count] = fread(datafile,[numchannel,obufsize],'int16');
    //
    obuf
    = fread(
        &count,
        mwVv(datafile, "datafile"),
        horzcat(
          mwVarargin(
            mwVa(numchannel, "numchannel"), mwVv(obufsize, "obufsize"))),
        _mxarray14_);
    //
    // obuf = fliplr(obuf);
    //
    obuf = fliplr(mwVv(obuf, "obuf"));
    //
    // frewind(datafile);
    //
    frewind(mwVv(datafile, "datafile"));
    //
    // [datasegment,count] = fread(datafile,[numchannel,buffersize],'int16');  
    //
    datasegment
    = fread(
        &count,
        mwVv(datafile, "datafile"),
        horzcat(
          mwVarargin(
            mwVa(numchannel, "numchannel"), mwVv(buffersize, "buffersize"))),
        _mxarray14_);
    //
    // datasegment2 = [obuf,datasegment]';
    //
    datasegment2
      = ctranspose(
          horzcat(
            mwVarargin(mwVv(obuf, "obuf"), mwVv(datasegment, "datasegment"))));
    //
    // resampled = Sresample(datasegment2,resamplup,resampldown);
    //
    resampled
      = Sresample(
          NULL,
          mwVv(datasegment2, "datasegment2"),
          mwVa(resamplup, "resamplup"),
          mwVa(resampldown, "resampldown"));
    //
    // count2 = fwrite(outfile,resampled(overlaporder+1:size(resampled,1)-overlaporder2,:)','int16');
    //
    count2
      = fwrite(
          mwVv(outfile, "outfile"),
          ctranspose(
            mwVe(
              mclArrayRef(
                mwVsv(resampled, "resampled"),
                colon(
                  mwVv(overlaporder, "overlaporder") + _mxarray6_,
                  mwVe(
                    size(
                      mwValueVarargout(),
                      mwVv(resampled, "resampled"),
                      _mxarray6_))
                  - mwVv(overlaporder2, "overlaporder2")),
                colon()))),
          _mxarray14_);
    //
    // obuf = datasegment2(size(datasegment2,1)-obufsize11:size(datasegment2,1),:);
    //
    obuf
      = mclArrayRef(
          mwVsv(datasegment2, "datasegment2"),
          colon(
            mwVe(
              size(
                mwValueVarargout(),
                mwVv(datasegment2, "datasegment2"),
                _mxarray6_))
            - mwVv(obufsize11, "obufsize11"),
            mwVe(
              size(
                mwValueVarargout(),
                mwVv(datasegment2, "datasegment2"),
                _mxarray6_))),
          colon());
    //
    // % do the rest
    // 
    // while ~feof(datafile),
    //
    while (mclNotBool(mwVe(feof(mwVv(datafile, "datafile"))))) {
        //
        // [datasegment,count] = fread(datafile,[numchannel,buffersize],'int16');  
        //
        datasegment
        = fread(
            &count,
            mwVv(datafile, "datafile"),
            horzcat(
              mwVarargin(
                mwVa(numchannel, "numchannel"),
                mwVv(buffersize, "buffersize"))),
            _mxarray14_);
        //
        // datasegment2 = [obuf;datasegment'];
        //
        datasegment2
          = vertcat(
              mwVarargin(
                mwVv(obuf, "obuf"),
                ctranspose(mwVv(datasegment, "datasegment"))));
        //
        // resampled = Sresample(datasegment2,resamplup,resampldown);
        //
        resampled
          = Sresample(
              NULL,
              mwVv(datasegment2, "datasegment2"),
              mwVa(resamplup, "resamplup"),
              mwVa(resampldown, "resampldown"));
        //
        // count2 = fwrite(outfile,resampled(overlaporder21:size(resampled,1)-overlaporder2,:)','int16');
        //
        count2
          = fwrite(
              mwVv(outfile, "outfile"),
              ctranspose(
                mwVe(
                  mclArrayRef(
                    mwVsv(resampled, "resampled"),
                    colon(
                      mwVv(overlaporder21, "overlaporder21"),
                      mwVe(
                        size(
                          mwValueVarargout(),
                          mwVv(resampled, "resampled"),
                          _mxarray6_))
                      - mwVv(overlaporder2, "overlaporder2")),
                    colon()))),
              _mxarray14_);
        //
        // obuf = datasegment2(size(datasegment2,1)-obufsize11:size(datasegment2,1),:);
        //
        obuf
          = mclArrayRef(
              mwVsv(datasegment2, "datasegment2"),
              colon(
                mwVe(
                  size(
                    mwValueVarargout(),
                    mwVv(datasegment2, "datasegment2"),
                    _mxarray6_))
                - mwVv(obufsize11, "obufsize11"),
                mwVe(
                  size(
                    mwValueVarargout(),
                    mwVv(datasegment2, "datasegment2"),
                    _mxarray6_))),
              colon());
    //
    // end  
    //
    }
    //
    // 
    // % add the last unprocessed portion 
    // resampled = Sresample(obuf,resamplup,resampldown);
    //
    resampled
      = Sresample(
          NULL,
          mwVv(obuf, "obuf"),
          mwVa(resamplup, "resamplup"),
          mwVa(resampldown, "resampldown"));
    //
    // count2 = fwrite(outfile,resampled(overlaporder21:end,:)','int16');
    //
    count2
      = fwrite(
          mwVv(outfile, "outfile"),
          ctranspose(
            mwVe(
              mclArrayRef(
                mwVsv(resampled, "resampled"),
                colon(
                  mwVv(overlaporder21, "overlaporder21"),
                  end(mwVv(resampled, "resampled"), _mxarray6_, _mxarray13_)),
                colon()))),
          _mxarray14_);
    //
    // fclose(outfile);
    //
    ans.EqAns(fclose(mwVv(outfile, "outfile")));
    //
    // 
    //
    return_:;
}
