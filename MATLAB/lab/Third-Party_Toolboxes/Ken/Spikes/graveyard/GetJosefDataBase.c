/*
 * MATLAB Compiler: 2.0.1
 * Date: Thu Mar 30 15:24:23 2000
 * Arguments: "-xw" "GetJosefDataBase" 
 */
#include "GetJosefDataBase.h"
#include "FileExists.h"
#include "LoadPar.h"
#include "LoadPar1.h"
#include "LoadStringList.h"
#include "textread.h"

static mxArray * MGetJosefDataBase_GetEpochs(int nargout_,
                                             mxArray * Base,
                                             mxArray * SampleRate);
static mxArray * mlfGetJosefDataBase_GetEpochs(mxArray * Base,
                                               mxArray * SampleRate);
static void mlxGetJosefDataBase_GetEpochs(int nlhs,
                                          mxArray * plhs[],
                                          int nrhs,
                                          mxArray * prhs[]);

/*
 * The function "MGetJosefDataBase" is the implementation version of the
 * "GetJosefDataBase" M-function from file
 * "/u5/b/ken/matlab/Spikes/GetJosefDataBase.m" (lines 1-101). It contains the
 * actual compiled code for that M-function. It is a static function and must
 * only be called from one of the interface functions, appearing below.
 */
/*
 * % DataBase = GetJosefDataBase
 * %
 * % extracts filenames from the list in MetaFile
 * 
 * function DataBase = GetJosefDataBase
 */
static mxArray * MGetJosefDataBase(int nargout_) {
    mxArray * DataBase = mclGetUninitializedArray();
    mxArray * BaseDir = mclGetUninitializedArray();
    mxArray * BigCellNo = mclGetUninitializedArray();
    mxArray * CellMap = mclGetUninitializedArray();
    mxArray * CellNo = mclGetUninitializedArray();
    mxArray * Des = mclGetUninitializedArray();
    mxArray * Directory = mclGetUninitializedArray();
    mxArray * ElecGpNo = mclGetUninitializedArray();
    mxArray * FileBase = mclGetUninitializedArray();
    mxArray * FileNo = mclGetUninitializedArray();
    mxArray * Line = mclGetUninitializedArray();
    mxArray * Location = mclGetUninitializedArray();
    mxArray * MetaFp = mclGetUninitializedArray();
    mxArray * SubType = mclGetUninitializedArray();
    mxArray * Type = mclGetUninitializedArray();
    mxArray * ans = mclInitializeAns();
    mclForLoopIterator iterator_0;
    mxArray * nc = mclGetUninitializedArray();
    mxArray * pos = mclGetUninitializedArray();
    mxArray * qFile = mclGetUninitializedArray();
    /*
     * 
     * BaseDir = '/u5/b/ken/Linkz/dbase';
     */
    mlfAssign(&BaseDir, mxCreateString("/u5/b/ken/Linkz/dbase"));
    /*
     * 
     * MetaFp = fopen([BaseDir '/prfiles'], 'r');
     */
    mlfAssign(
      &MetaFp,
      mlfFopen(
        NULL,
        NULL,
        mlfHorzcat(BaseDir, mxCreateString("/prfiles"), NULL),
        mxCreateString("r"),
        NULL));
    /*
     * 
     * FileNo = 0;
     */
    mlfAssign(&FileNo, mlfScalar(0.0));
    /*
     * while(1)
     */
    while (mlfTobool(mlfScalar(1.0))) {
        /*
         * % load in next line
         * Line = fgets(MetaFp)
         */
        mlfAssign(&Line, mlfFgets(NULL, MetaFp, NULL));
        mclPrintArray(Line, "Line");
        /*
         * 
         * % check end of file
         * if (feof(MetaFp))
         */
        if (mlfTobool(mlfFeof(MetaFp))) {
            /*
             * fclose(MetaFp);
             */
            mclAssignAns(&ans, mlfFclose(MetaFp));
            /*
             * return;
             */
            goto return_;
        /*
         * end
         */
        }
        /*
         * 
         * Directory = [BaseDir '/' strtok(Line)]; 
         */
        mlfAssign(
          &Directory,
          mlfHorzcat(
            BaseDir,
            mxCreateString("/"),
            mlfNStrtok(1, NULL, Line, NULL),
            NULL));
        /*
         * FileNo = FileNo + 1;
         */
        mlfAssign(&FileNo, mlfPlus(FileNo, mlfScalar(1.0)));
        /*
         * DataBase(FileNo).Directory = Directory;
         */
        mlfIndexAssign(&DataBase, "(?).Directory", FileNo, Directory);
        /*
         * FileBase = strtok(Line); 
         */
        mlfAssign(&FileBase, mlfNStrtok(1, NULL, Line, NULL));
        /*
         * DataBase(FileNo).FileBase = FileBase;
         */
        mlfIndexAssign(&DataBase, "(?).FileBase", FileNo, FileBase);
        /*
         * DataBase(FileNo).Par = LoadPar([Directory '/' FileBase '.par']);
         */
        mlfIndexAssign(
          &DataBase,
          "(?).Par",
          FileNo,
          mlfLoadPar(
            mlfHorzcat(
              Directory,
              mxCreateString("/"),
              FileBase,
              mxCreateString(".par"),
              NULL)));
        /*
         * 
         * % concatenate them for final Epochs structure
         * DataBase(FileNo).Epochs = GetEpochs([Directory '/' FileBase], ...
         */
        mlfIndexAssign(
          &DataBase,
          "(?).Epochs",
          FileNo,
          mlfGetJosefDataBase_GetEpochs(
            mlfHorzcat(Directory, mxCreateString("/"), FileBase, NULL),
            mlfFeval(
              mclValueVarargout(),
              mlxMrdivide,
              mlfScalar(1e6),
              mlfIndexRef(DataBase, "(?).Par.SampleTime", FileNo),
              NULL)));
        /*
         * 1e6/DataBase(FileNo).Par.SampleTime);
         * 
         * % set up ElecGp sub-structures (1 for each tetrode)
         * 
         * BigCellNo = 2; % this is used to count cells in the overall .clu file
         */
        mlfAssign(&BigCellNo, mlfScalar(2.0));
        /*
         * for ElecGpNo = 1:DataBase(FileNo).Par.nElecGps	
         */
        for (mclForStart(
               &iterator_0,
               mlfScalar(1.0),
               mlfIndexRef(DataBase, "(?).Par.nElecGps", FileNo),
               NULL);
             mclForNext(&iterator_0, &ElecGpNo);
             ) {
            /*
             * % load .par.n file
             * DataBase(FileNo).ElecGp(ElecGpNo).Par1 = ...
             */
            mlfIndexAssign(
              &DataBase,
              "(?).ElecGp(?).Par1",
              FileNo,
              ElecGpNo,
              mlfLoadPar1(
                mlfHorzcat(
                  Directory,
                  mxCreateString("/"),
                  FileBase,
                  mxCreateString(".par."),
                  mlfNum2str(ElecGpNo, NULL),
                  NULL)));
            /*
             * LoadPar1([Directory '/' FileBase '.par.' num2str(ElecGpNo)]);
             * 
             * % set location to '' - so it can be changed later by the .des file
             * DataBase(FileNo).ElecGp(ElecGpNo).Location = '';
             */
            mlfIndexAssign(
              &DataBase,
              "(?).ElecGp(?).Location",
              FileNo,
              ElecGpNo,
              mxCreateString(""));
            /*
             * 
             * % get n cells
             * DataBase(FileNo).ElecGp(ElecGpNo).nCells = ...
             */
            mlfIndexAssign(
              &DataBase,
              "(?).ElecGp(?).nCells",
              FileNo,
              ElecGpNo,
              mlfMinus(
                mlfNTextread(
                  0,
                  mclValueVarargout(),
                  mlfHorzcat(
                    Directory,
                    mxCreateString("/"),
                    FileBase,
                    mxCreateString(".clu."),
                    mlfNum2str(ElecGpNo, NULL),
                    NULL),
                  mxCreateString("%d"),
                  mlfScalar(1.0),
                  NULL),
                mlfScalar(1.0)));
        /*
         * textread([Directory '/' FileBase '.clu.' num2str(ElecGpNo)] ...
         * , '%d', 1) -1;
         * end
         */
        }
        /*
         * 
         * % construct CellMap
         * pos = 1;
         */
        mlfAssign(&pos, mlfScalar(1.0));
        /*
         * for ElecGpNo = 1:DataBase(FileNo).Par.nElecGps	
         */
        for (mclForStart(
               &iterator_0,
               mlfScalar(1.0),
               mlfIndexRef(DataBase, "(?).Par.nElecGps", FileNo),
               NULL);
             mclForNext(&iterator_0, &ElecGpNo);
             ) {
            /*
             * nc = DataBase(FileNo).ElecGp(ElecGpNo).nCells;
             */
            mlfAssign(
              &nc,
              mlfIndexRef(DataBase, "(?).ElecGp(?).nCells", FileNo, ElecGpNo));
            /*
             * if (nc>0) 
             */
            if (mlfTobool(mlfGt(nc, mlfScalar(0.0)))) {
                /*
                 * DataBase(FileNo).ElecGp(ElecGpNo).FirstCell = pos;
                 */
                mlfIndexAssign(
                  &DataBase, "(?).ElecGp(?).FirstCell", FileNo, ElecGpNo, pos);
            /*
             * end
             */
            }
            /*
             * CellMap(pos:pos+nc-1,1) = ElecGpNo; % set to this electrode group
             */
            mlfIndexAssign(
              &CellMap,
              "(?,?)",
              mlfColon(pos, mlfMinus(mlfPlus(pos, nc), mlfScalar(1.0)), NULL),
              mlfScalar(1.0),
              ElecGpNo);
            /*
             * CellMap(pos:pos+nc-1,2) = (2:nc+1)'; % set cluster no to 2...n
             */
            mlfIndexAssign(
              &CellMap,
              "(?,?)",
              mlfColon(pos, mlfMinus(mlfPlus(pos, nc), mlfScalar(1.0)), NULL),
              mlfScalar(2.0),
              mlfCtranspose(
                mlfColon(mlfScalar(2.0), mlfPlus(nc, mlfScalar(1.0)), NULL)));
            /*
             * pos = pos+nc;
             */
            mlfAssign(&pos, mlfPlus(pos, nc));
        /*
         * end
         */
        }
        /*
         * DataBase(FileNo).CellMap = CellMap;
         */
        mlfIndexAssign(&DataBase, "(?).CellMap", FileNo, CellMap);
        /*
         * DataBase(FileNo).nCells = pos-1;
         */
        mlfIndexAssign(
          &DataBase, "(?).nCells", FileNo, mlfMinus(pos, mlfScalar(1.0)));
        /*
         * 
         * % extract cell information from .des file
         * Des = LoadStringList([Directory '/' FileBase '.des']);
         */
        mlfAssign(
          &Des,
          mlfLoadStringList(
            mlfHorzcat(
              Directory,
              mxCreateString("/"),
              FileBase,
              mxCreateString(".des"),
              NULL)));
        /*
         * for CellNo = 1:(DataBase(FileNo).nCells) % this is cell number NOT counting the noise cluster
         */
        for (mclForStart(
               &iterator_0,
               mlfScalar(1.0),
               mlfIndexRef(DataBase, "(?).nCells", FileNo),
               NULL);
             mclForNext(&iterator_0, &CellNo);
             ) {
            /*
             * Type = Des{CellNo}(1);
             */
            mlfAssign(
              &Type, mlfIndexRef(Des, "{?}(?)", CellNo, mlfScalar(1.0)));
            /*
             * Location = Des{CellNo}(2);
             */
            mlfAssign(
              &Location, mlfIndexRef(Des, "{?}(?)", CellNo, mlfScalar(2.0)));
            /*
             * SubType = Des{CellNo}(3:end);
             */
            mlfAssign(
              &SubType,
              mlfIndexRef(
                Des,
                "{?}(?)",
                CellNo,
                mlfColon(
                  mlfScalar(3.0),
                  mlfFeval(
                    mclValueVarargout(),
                    mlxEnd,
                    mlfIndexRef(Des, "{?}", CellNo),
                    mlfScalar(1),
                    mlfScalar(1),
                    NULL),
                  NULL)));
            /*
             * 
             * % check location is the same as for previous cells on this tetrode
             * ElecGpNo = CellMap(CellNo,1);
             */
            mlfAssign(
              &ElecGpNo, mlfIndexRef(CellMap, "(?,?)", CellNo, mlfScalar(1.0)));
            /*
             * if isempty(DataBase(FileNo).ElecGp(ElecGpNo).Location) % if this is the first cell on this electrode
             */
            if (mlfTobool(
                  mlfFeval(
                    mclValueVarargout(),
                    mlxIsempty,
                    mlfIndexRef(
                      DataBase, "(?).ElecGp(?).Location", FileNo, ElecGpNo),
                    NULL))) {
                /*
                 * DataBase(FileNo).ElecGp(ElecGpNo).Location = Location;
                 */
                mlfIndexAssign(
                  &DataBase,
                  "(?).ElecGp(?).Location",
                  FileNo,
                  ElecGpNo,
                  Location);
            /*
             * elseif Location~=DataBase(FileNo).ElecGp(ElecGpNo).Location
             */
            } else if (mlfTobool(
                         mlfFeval(
                           mclValueVarargout(),
                           mlxNe,
                           Location,
                           mlfIndexRef(
                             DataBase,
                             "(?).ElecGp(?).Location",
                             FileNo,
                             ElecGpNo),
                           NULL))) {
                /*
                 * warning(sprintf('Elec %d location mismatch for cell %d', ElecGpNo, CellMap(CellNo,2)));
                 */
                mclAssignAns(
                  &ans,
                  mlfWarning(
                    NULL,
                    mlfSprintf(
                      NULL,
                      mxCreateString("Elec %d location mismatch for cell %d"),
                      ElecGpNo,
                      mlfIndexRef(CellMap, "(?,?)", CellNo, mlfScalar(2.0)),
                      NULL)));
            /*
             * end
             */
            }
            /*
             * 
             * DataBase(FileNo).Cell(CellNo).Type = Type;
             */
            mlfIndexAssign(&DataBase, "(?).Cell(?).Type", FileNo, CellNo, Type);
            /*
             * DataBase(FileNo).Cell(CellNo).SubType = SubType;	
             */
            mlfIndexAssign(
              &DataBase, "(?).Cell(?).SubType", FileNo, CellNo, SubType);
        /*
         * 
         * end
         */
        }
        /*
         * 
         * % load .qual file if it exists
         * if FileExists([Directory '/' FileBase '.qual'])
         */
        if (mlfTobool(
              mlfFileExists(
                mlfHorzcat(
                  Directory,
                  mxCreateString("/"),
                  FileBase,
                  mxCreateString(".qual"),
                  NULL)))) {
            /*
             * qFile = load([Directory '/' FileBase '.qual']);
             */
            mlfAssign(
              &qFile,
              mlfLoadStruct(
                mlfHorzcat(
                  Directory,
                  mxCreateString("/"),
                  FileBase,
                  mxCreateString(".qual"),
                  NULL),
                NULL));
        /*
         * else
         */
        } else {
            /*
             * qFile = zeros(DataBase(FileNo).nCells, 2);
             */
            mlfAssign(
              &qFile,
              mlfZeros(
                mlfIndexRef(DataBase, "(?).nCells", FileNo),
                mlfScalar(2.0),
                NULL));
        /*
         * end
         */
        }
        /*
         * 
         * for CellNo = 1:DataBase(FileNo).nCells	
         */
        for (mclForStart(
               &iterator_0,
               mlfScalar(1.0),
               mlfIndexRef(DataBase, "(?).nCells", FileNo),
               NULL);
             mclForNext(&iterator_0, &CellNo);
             ) {
            /*
             * DataBase(FileNo).Cell(CellNo).eDist = qFile(CellNo,1);
             */
            mlfIndexAssign(
              &DataBase,
              "(?).Cell(?).eDist",
              FileNo,
              CellNo,
              mlfIndexRef(qFile, "(?,?)", CellNo, mlfScalar(1.0)));
            /*
             * DataBase(FileNo).Cell(CellNo).bRat = qFile(CellNo,2);	
             */
            mlfIndexAssign(
              &DataBase,
              "(?).Cell(?).bRat",
              FileNo,
              CellNo,
              mlfIndexRef(qFile, "(?,?)", CellNo, mlfScalar(2.0)));
        /*
         * end
         */
        }
    /*
     * 
     * 
     * end
     */
    }
    /*
     * 
     * % subfunction to load up epochs - argument is [Directory '/' FileBase];
     * % and SampleRate (in Hz)
     * function Epochs = GetEpochs(Base, SampleRate)
     */
    return_:
    mclValidateOutputs("GetJosefDataBase", 1, nargout_, &DataBase);
    mxDestroyArray(BaseDir);
    mxDestroyArray(BigCellNo);
    mxDestroyArray(CellMap);
    mxDestroyArray(CellNo);
    mxDestroyArray(Des);
    mxDestroyArray(Directory);
    mxDestroyArray(ElecGpNo);
    mxDestroyArray(FileBase);
    mxDestroyArray(FileNo);
    mxDestroyArray(Line);
    mxDestroyArray(Location);
    mxDestroyArray(MetaFp);
    mxDestroyArray(SubType);
    mxDestroyArray(Type);
    mxDestroyArray(ans);
    mxDestroyArray(nc);
    mxDestroyArray(pos);
    mxDestroyArray(qFile);
    /*
     * 
     * Epochs = [];
     * Pos = 1; % where to write in epoch file
     * % loop thru types
     * for eType = {'sw', 'nsw', 'ssw', 'rem'}
     * 
     * % load epoch files - careful! .rem you look at different columns!
     * 
     * fName = [Base, '.', char(eType)];
     * if FileExists(fName)
     * eFile = load(fName);
     * for i=1:size(eFile,1);
     * Epochs(Pos+i-1).Type = eType;
     * Epochs(Pos+i-1).Start = eFile(i,1) / SampleRate;
     * % watch out for REM - end is column two
     * if strcmp(eType, 'rem')
     * Epochs(Pos+i-1).End = eFile(i,2) / SampleRate;
     * else
     * Epochs(Pos+i-1).End = eFile(i,3) / SampleRate;
     * end
     * end
     * Pos = Pos + size(eFile,1);
     * end
     * end
     */
    return DataBase;
}

/*
 * The function "mlfGetJosefDataBase" contains the normal interface for the
 * "GetJosefDataBase" M-function from file
 * "/u5/b/ken/matlab/Spikes/GetJosefDataBase.m" (lines 1-101). This function
 * processes any input arguments and passes them to the implementation version
 * of the function, appearing above.
 */
mxArray * mlfGetJosefDataBase(void) {
    int nargout = 1;
    mxArray * DataBase = mclGetUninitializedArray();
    mlfEnterNewContext(0, 0);
    DataBase = MGetJosefDataBase(nargout);
    mlfRestorePreviousContext(0, 0);
    return mlfReturnValue(DataBase);
}

/*
 * The function "mlxGetJosefDataBase" contains the feval interface for the
 * "GetJosefDataBase" M-function from file
 * "/u5/b/ken/matlab/Spikes/GetJosefDataBase.m" (lines 1-101). The feval
 * function calls the implementation version of GetJosefDataBase through this
 * function. This function processes any input arguments and passes them to the
 * implementation version of the function, appearing above.
 */
void mlxGetJosefDataBase(int nlhs,
                         mxArray * plhs[],
                         int nrhs,
                         mxArray * prhs[]) {
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: GetJosefDataBase Line: 5 Colum"
            "n: 0 The function \"GetJosefDataBase\" was called wi"
            "th more than the declared number of outputs (1)"));
    }
    if (nrhs > 0) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: GetJosefDataBase Line: 5 Colu"
            "mn: 0 The function \"GetJosefDataBase\" was called "
            "with more than the declared number of inputs (0)"));
    }
    for (i = 0; i < 1; ++i) {
        mplhs[i] = NULL;
    }
    mlfEnterNewContext(0, 0);
    mplhs[0] = MGetJosefDataBase(nlhs);
    mlfRestorePreviousContext(0, 0);
    plhs[0] = mplhs[0];
}

/*
 * The function "MGetJosefDataBase_GetEpochs" is the implementation version of
 * the "GetJosefDataBase/GetEpochs" M-function from file
 * "/u5/b/ken/matlab/Spikes/GetJosefDataBase.m" (lines 101-125). It contains
 * the actual compiled code for that M-function. It is a static function and
 * must only be called from one of the interface functions, appearing below.
 */
/*
 * function Epochs = GetEpochs(Base, SampleRate)
 */
static mxArray * MGetJosefDataBase_GetEpochs(int nargout_,
                                             mxArray * Base,
                                             mxArray * SampleRate) {
    mxArray * Epochs = mclGetUninitializedArray();
    mxArray * Pos = mclGetUninitializedArray();
    mxArray * eFile = mclGetUninitializedArray();
    mxArray * eType = mclGetUninitializedArray();
    mxArray * fName = mclGetUninitializedArray();
    mxArray * i = mclGetUninitializedArray();
    mclForLoopIterator iterator_0;
    mclForLoopIterator iterator_1;
    mclValidateInputs("GetJosefDataBase/GetEpochs", 2, &Base, &SampleRate);
    /*
     * 
     * Epochs = [];
     */
    mlfAssign(&Epochs, mclCreateEmptyArray());
    /*
     * Pos = 1; % where to write in epoch file
     */
    mlfAssign(&Pos, mlfScalar(1.0));
    /*
     * % loop thru types
     * for eType = {'sw', 'nsw', 'ssw', 'rem'}
     */
    for (mclForStart(
           &iterator_0,
           mlfCellhcat(
             mxCreateString("sw"),
             mxCreateString("nsw"),
             mxCreateString("ssw"),
             mxCreateString("rem"),
             NULL),
           NULL,
           NULL);
         mclForNext(&iterator_0, &eType);
         ) {
        /*
         * 
         * % load epoch files - careful! .rem you look at different columns!
         * 
         * fName = [Base, '.', char(eType)];
         */
        mlfAssign(
          &fName,
          mlfHorzcat(Base, mxCreateString("."), mlfChar(eType, NULL), NULL));
        /*
         * if FileExists(fName)
         */
        if (mlfTobool(mlfFileExists(fName))) {
            /*
             * eFile = load(fName);
             */
            mlfAssign(&eFile, mlfLoadStruct(fName, NULL));
            /*
             * for i=1:size(eFile,1);
             */
            for (mclForStart(
                   &iterator_1,
                   mlfScalar(1.0),
                   mlfSize(mclValueVarargout(), eFile, mlfScalar(1.0)),
                   NULL);
                 mclForNext(&iterator_1, &i);
                 ) {
                /*
                 * Epochs(Pos+i-1).Type = eType;
                 */
                mlfIndexAssign(
                  &Epochs,
                  "(?).Type",
                  mlfMinus(mlfPlus(Pos, i), mlfScalar(1.0)),
                  eType);
                /*
                 * Epochs(Pos+i-1).Start = eFile(i,1) / SampleRate;
                 */
                mlfIndexAssign(
                  &Epochs,
                  "(?).Start",
                  mlfMinus(mlfPlus(Pos, i), mlfScalar(1.0)),
                  mlfMrdivide(
                    mlfIndexRef(eFile, "(?,?)", i, mlfScalar(1.0)),
                    SampleRate));
                /*
                 * % watch out for REM - end is column two
                 * if strcmp(eType, 'rem')
                 */
                if (mlfTobool(mlfStrcmp(eType, mxCreateString("rem")))) {
                    /*
                     * Epochs(Pos+i-1).End = eFile(i,2) / SampleRate;
                     */
                    mlfIndexAssign(
                      &Epochs,
                      "(?).End",
                      mlfMinus(mlfPlus(Pos, i), mlfScalar(1.0)),
                      mlfMrdivide(
                        mlfIndexRef(eFile, "(?,?)", i, mlfScalar(2.0)),
                        SampleRate));
                /*
                 * else
                 */
                } else {
                    /*
                     * Epochs(Pos+i-1).End = eFile(i,3) / SampleRate;
                     */
                    mlfIndexAssign(
                      &Epochs,
                      "(?).End",
                      mlfMinus(mlfPlus(Pos, i), mlfScalar(1.0)),
                      mlfMrdivide(
                        mlfIndexRef(eFile, "(?,?)", i, mlfScalar(3.0)),
                        SampleRate));
                /*
                 * end
                 */
                }
            /*
             * end
             */
            }
            /*
             * Pos = Pos + size(eFile,1);
             */
            mlfAssign(
              &Pos,
              mlfPlus(
                Pos, mlfSize(mclValueVarargout(), eFile, mlfScalar(1.0))));
        /*
         * end
         */
        }
    /*
     * end
     */
    }
    mclValidateOutputs("GetJosefDataBase/GetEpochs", 1, nargout_, &Epochs);
    mxDestroyArray(Pos);
    mxDestroyArray(eFile);
    mxDestroyArray(eType);
    mxDestroyArray(fName);
    mxDestroyArray(i);
    return Epochs;
}

/*
 * The function "mlfGetJosefDataBase_GetEpochs" contains the normal interface
 * for the "GetJosefDataBase/GetEpochs" M-function from file
 * "/u5/b/ken/matlab/Spikes/GetJosefDataBase.m" (lines 101-125). This function
 * processes any input arguments and passes them to the implementation version
 * of the function, appearing above.
 */
static mxArray * mlfGetJosefDataBase_GetEpochs(mxArray * Base,
                                               mxArray * SampleRate) {
    int nargout = 1;
    mxArray * Epochs = mclGetUninitializedArray();
    mlfEnterNewContext(0, 2, Base, SampleRate);
    Epochs = MGetJosefDataBase_GetEpochs(nargout, Base, SampleRate);
    mlfRestorePreviousContext(0, 2, Base, SampleRate);
    return mlfReturnValue(Epochs);
}

/*
 * The function "mlxGetJosefDataBase_GetEpochs" contains the feval interface
 * for the "GetJosefDataBase/GetEpochs" M-function from file
 * "/u5/b/ken/matlab/Spikes/GetJosefDataBase.m" (lines 101-125). The feval
 * function calls the implementation version of GetJosefDataBase/GetEpochs
 * through this function. This function processes any input arguments and
 * passes them to the implementation version of the function, appearing above.
 */
static void mlxGetJosefDataBase_GetEpochs(int nlhs,
                                          mxArray * plhs[],
                                          int nrhs,
                                          mxArray * prhs[]) {
    mxArray * mprhs[2];
    mxArray * mplhs[1];
    int i;
    if (nlhs > 1) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: GetJosefDataBase/GetEpochs Line: 101 "
            "Column: 0 The function \"GetJosefDataBase/GetEpochs\" was c"
            "alled with more than the declared number of outputs (1)"));
    }
    if (nrhs > 2) {
        mlfError(
          mxCreateString(
            "Run-time Error: File: GetJosefDataBase/GetEpochs Line: 101 "
            "Column: 0 The function \"GetJosefDataBase/GetEpochs\" was c"
            "alled with more than the declared number of inputs (2)"));
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
    mplhs[0] = MGetJosefDataBase_GetEpochs(nlhs, mprhs[0], mprhs[1]);
    mlfRestorePreviousContext(0, 2, mprhs[0], mprhs[1]);
    plhs[0] = mplhs[0];
}
