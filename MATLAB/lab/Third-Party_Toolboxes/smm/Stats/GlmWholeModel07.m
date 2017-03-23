function GlmWholeModel07(spectAnalDir,analRoutine,outNameNote,fileExt,depVar,varargin)
%function GlmWholeModel07(description,fileBaseCell,fileExt,midPointsBool,minSpeed,winLength,thetaNW,gammaNW,w0,depVar,contIndepNames,varargin)
%[nChan,freqBool,maxFreq,nonParamBool,adjDayMedBool,adjDayZbool] = DefaultArgs(varargin,{96,0,150,0,0,0});
[phaseMeanBool,nChan,freqBool,maxFreq,midPointsBool,minSpeed,winLength,saveInputData] ...
    = DefaultArgs(varargin,{0,96,0,150,1,0,626,0});
if midPointsBool
    midPointsText = '_MidPoints';
else
    midPointsText = [];
end
%maxFreq = 150;
chanDir = 'ChanInfo/';
selChans = load([chanDir 'SelChan' fileExt '.mat']);


%addpath(genpath('/u12/smm/matlab/econometrics/'))
outDir = [mfilename '/' analRoutine '_' outNameNote '/' fileExt '/'];
outName = [mfilename '/' analRoutine '_' outNameNote '/' fileExt '/' depVar '.mat'];

addpath(genpath('/u12/smm/matlab/econometrics/'))

dirName = [spectAnalDir midPointsText '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) fileExt];

%%%%%% load TrialDesig %%%%%%
load(['TrialDesig/' mfilename '/' analRoutine '.mat'])
if ~exist('fileBaseCell','var') % support for legacy data types
    fileBaseCell = mat2cell(fileBaseMat,ones(size(fileBaseMat,1),1),size(fileBaseMat,2));
end

%%%%%% load fs %%%%%%%%
fprintf('Reading from: %s\n',dirName);
if freqBool
    fileName = ParseStructName(depVar);
    fo = LoadField([fileBaseCell{1} '/' dirName '/' fileName{1} '.fo']);
    fo = fo(fo<=maxFreq)
else
    fo = 1;
end

% load selected data
if isempty(contIndepNames)
    contCellStruct = {};
else
    for i=1:length(contIndepNames)
        contCellStruct{i} = LoadDesigVar(fileBaseCell,dirName,contIndepNames{i},trialDesig);
    end
end
depStruct = LoadDesigVar(fileBaseCell,dirName,depVar,trialDesig);

% replace non-finite data with a random number
tempCell= Struct2CellArray(depStruct,[],1);
for i=1:size(tempCell,1)
    tempCell{i,end}(~isfinite(tempCell{i,end})) = rand;
end
depStruct = CellArray2Struct(tempCell);

% equalize the N in each group by randomly subsampling
if ~exist('equalNbool','var'); equalNbool = 0; end
if exist('equalNbool','var') & equalNbool==1
    data = EqualizeN(cat(2,{depStruct},contCellStruct),outlierDepth);
    depStruct = data{1};
    contCellStruct = data(2:end);
end

% extract subset of contCellStruct for contintuous variable analysis
if ~exist('contVarSub','var'); contVarSub = {}; end
if ~isempty(contVarSub)
    for j=1:length(contIndepNames)
        if ~strcmp(contVarSub{j},'jibe')
            for k=1:length(contVarSub{j})
                if isnumeric(contVarSub{j}{k})
                    temp(k) = contVarSub{j}{k};
                elseif strncmp(contVarSub{j}{k},'SelChan_',8)
%                     temp(k) = selChans(str2num(contVarSub{j}{k}(6:end)));
                    temp(k) = selChans.(contVarSub{j}{k}(9:end));
                end
            end
            contCellStruct{j} = GetStructMatSub(contCellStruct{j},temp);
        end
    end
end

if phaseMeanBool
    temp = Struct2CellArray(depStruct,[],1);
    tempCat = [];
    for j=1:size(temp,1)
        tempCat = cat(1,tempCat,temp{j,end});
    end
    meanPhase = mean(tempCat);
    for j=1:size(temp,1)
        temp{j,end} = angle(temp{j,end})-repmat(angle(meanPhase),size(temp{j,end},1),1);
        temp{j,end} = angle(complex(cos(temp{j,end}),sin(temp{j,end})));
    end
    depStruct = CellArray2Struct(temp);
end

c1 = clock;
for ch=1:nChan
    fprintf('ch%i;',ch)
    if mod(ch,10) == 0
        c2 = clock-c1;
        c1 = clock;
        fprintf('\n%s\n%s',pwd,outName)
        disp(' ')
        disp(num2str(c2))
    end
    for f=1:length(fo)
        %fprintf('\n---- Channel %ch ----\n',ch)
        % extract all trials from specific channel/freq
        try depStructSub = GetStructMatSub(depStruct,[2,ch; 3,f]);
        catch
            fprintf('\nproblem with GetStructMatSub(depStruct,[2,ch; 3,f])\n')
            keyboard
        end
        
        % extract subset of contCellStruct corresponding to ch & f
        contCellStructSub = {};
        for j=1:length(contIndepNames)
            if ~isempty(contVarSub) & strcmp(contVarSub{j},'jibe')
                contCellStructSub{j} = GetStructMatSub(contCellStruct{j},[2,ch; 3,f]);
            else
                contCellStructSub{j} = contCellStruct{j};
            end
        end

        % remove outliers
        [tempCellStruct outlierStruct(:,ch,f)] = RemoveOutliers(cat(2,contCellStructSub,{depStructSub}),outlierDepth,3);
        goodContCellStruct(1:length(contCellStructSub)) = tempCellStruct(1:length(contCellStructSub));
        goodDepStruct = tempCellStruct{end};

        if saveInputData
            inputContCellStruct{:,ch,f} = goodContCellStruct;
            inputDepStruct(ch,f) = goodDepStruct;
        end
        % convert data from structs to matrices for stat analysis
        goodDepCell = Struct2CellArray(goodDepStruct);
        depData = cell2mat(goodDepCell(:,end));
        categData = goodDepCell(:,1:end-1);

        % make continuous data matrix
        contData = [];
        for j=1:length(goodContCellStruct)
            [goodContCell] = Struct2CellArray(goodContCellStruct{j});
            CheckCellArraySim(categData,goodContCell(:,1:end-1));
            contData(:,j) = cell2mat(goodContCell(:,end));
            %contData = cat(2,contData,contTemp);
        end

        % re-sort categData so each column is in separate cells
        for j=1:size(categData,2)
            anovaCategData(j) = {categData(:,j)};
        end
        
        % calculate trial means
        if trialMeanBool
            mazeRegionNames = fieldnames(trialDesig);
            if isstruct(eval(['trialDesig.' mazeRegionNames{1}]))
                ERROR_MEANING_OF_TRIAL_MEAN_UNCLEAR
            else
                tempDep = [];
                for j=1:length(mazeRegionNames)
                    tempDep = cat(ndims(getfield(goodDepStruct,mazeRegionNames{j}))+1,...
                        tempDep,getfield(goodDepStruct,mazeRegionNames{j}));
                end
                trialMeanDep = mean(tempDep,ndims(getfield(goodDepStruct,mazeRegionNames{j}))+1);
                trialMeanDep = repmat(trialMeanDep,length(mazeRegionNames),1);
            end
        end

        % create stat input mats
        yVar = depData;
        if trialMeanBool
            contXvarNames = [{'trialMean'}, contIndepNames];
            contXvar = [trialMeanDep, contData];
        else
            contXvarNames = [contIndepNames];
            contXvar = [contData];
        end
        if exist('categIndepNames','var') & ~isempty(categIndepNames)
            categNames = categIndepNames;
        else
            categNames = {};
            for j=1:size(anovaCategData,2)
                categNames{j} = ['categ' num2str(j)];
            end
        end
        % fit continuous and categorical data using ANOVAN
        wholeXvar = {};
        contVector = [];
        for j=1:size(contXvar,2);
            wholeXvar = cat(2,wholeXvar,{contXvar(:,j)});
            contVector = [contVector j];
        end
        %for j=1:size(anovaCategData,2)
        %    wholeXvar = cat(2,wholeXvar,{anovaCategData(:,j)});
        %end
        wholeXvar = cat(2,wholeXvar,anovaCategData);

        [model.pVals(:,ch,f), model.anovaTable{ch,f}, modelStats(ch,f)] = ...
            anovan(yVar,wholeXvar,'continuous',contVector,'varnames',[contXvarNames categNames],'sstype',ssType,'model',modelSpec,'display','off');
            
        nWayComps = {};
        if length(fieldnames(goodDepStruct))>1
            for j=1:size(anovaCategData,2)
                nWayComps = cat(1,nWayComps,num2cell(nchoosek([1:size(anovaCategData,2)],j),2));
            end

            for j=1:size(nWayComps,1)
                [junk model.categMeans{j}(:,:,ch,f) junk2 model.categNames{j}] = ...
                    multcompare(modelStats(ch,f),'dimension',nWayComps{j}+length(contXvarNames),'display','off');
            end
        else
            model.categMeans = [];
            model.categNames = [];
        end
            
        model.varNames = modelStats(ch,f).varnames;
        model.coeffs(:,ch,f) = modelStats(ch,f).coeffs;
        model.coeffNames = modelStats(ch,f).coeffnames;
        model.contVarNames = contXvarNames;
        model.categVarNames = categNames;
        table = model.anovaTable{ch,f};
        for j=2:size(table,1)-2
            sumSqCol = find(strcmp(table(1,:),'Sum Sq.'));
            totalRow = find(strcmp(table(:,1),'Total'));
            model.rSq(j-1,ch,f) = table{j,sumSqCol}/table{totalRow,sumSqCol};
            model.rSqNames{j-1,1} = table{j,find(strcmp(table(1,:),'Source'))};
        end
        model.varNames = model.rSqNames;
        % test normality mean and var of final residuals (jbtest & kstest)
        if isempty(contXvarNames)
            iStruct = [];
        else
            iStruct = CellArray2Struct([categData mat2cell(contXvar,ones(size(contXvar,1),1),size(contXvar,2))]);
        end
        %dStruct = CellArray2Struct([categData mat2cell(yVar,ones(size(yVar,1),1),size(yVar,2))]);
        %%%% don't understand why, but if you only have 1 categ var, resid
        %%%% matrix is transposed!!
        if size(modelStats(ch,f).resid,2) > size(modelStats(ch,f).resid,1)
            modelStats(ch,f).resid = modelStats(ch,f).resid';
        end
        residStruct = CellArray2Struct(cat(2,categData,mat2cell(modelStats(ch,f).resid,...
            repmat(1,size(modelStats(ch,f).resid,1),1),1)));
        % 1) test normality of residuals
        assumTest.residNormPs(ch,f) = TestNormality(residStruct);
        % 2) test means are all zero
        assumTest.residMeanPs(ch,f) = TestZeroMeans(residStruct);
        % 3) test homoscedasticity (homo variance) for categs and conts
        % (but not interactions)
        [assumTest.residCategVarPs(ch,f) assumTest.residCategVarZs(ch,f) assumTest.residContVarPs(ch,f)] = ...
            TestHomoScedasticity(modelStats(ch,f).resid,categData,contXvar,contXvarNames);
        % 4) test non-parallel treatment
        [assumTest.prllPvals(ch,f) assumTest.PrllBetas{ch,f}] = TestParallelGroup(residStruct,iStruct,{contXvarNames});
        % 5) test for correlated errors for each categ
        [assumTest.categDwPvals(ch,f) assumTest.contDwPvals(ch,f)] = ...
            CalcDurbinWatson(yVar,modelStats(ch,f).resid,categData,contXvar,contXvarNames);

    end
end
if ~exist(mfilename,'dir')
    eval(['!mkdir ' mfilename]);
end
if ~exist([mfilename '/' analRoutine '_' outNameNote],'dir')
    eval(['!mkdir ' mfilename '/' analRoutine '_' outNameNote]);
end
if ~exist([mfilename '/' analRoutine '_' outNameNote '/' fileExt],'dir')
    eval(['!mkdir ' mfilename '/' analRoutine '_' outNameNote '/' fileExt]);
end


infoStruct.spectAnalDir = spectAnalDir;
infoStruct.analRoutine = analRoutine;
infoStruct.outNameNote = outNameNote;
infoStruct.fileBaseCell = fileBaseCell;
infoStruct.fileExt = fileExt;
infoStruct.depVar = depVar;
infoStruct.contIndepNames = contIndepNames;
infoStruct.categIndepNames = categIndepNames;
infoStruct.nChan = nChan;
infoStruct.fo = fo;
infoStruct.freqBool = freqBool;
infoStruct.maxFreq = maxFreq;
infoStruct.contVarSub = contVarSub;
infoStruct.equalNbool = equalNbool;
infoStruct.modelSpec = modelSpec;
infoStruct.ssType = ssType;
infoStruct.minSpeed = minSpeed;
infoStruct.winLength = winLength;
infoStruct.outlierDepth = outlierDepth;
infoStruct.trialMeanBool = trialMeanBool;
infoStruct.trialDesig = trialDesig;
infoStruct.dirName = dirName;
infoStruct.nWayComps = nWayComps;
infoStruct.outName = outName;
infoStruct.outDir = outDir;

fprintf('\nSaving: %s\n',outName);

if ~exist(outDir,'dir')
    mkdir(outDir);
end

if saveInputData
    save(outName,SaveAsV6,'infoStruct', ...
    'inputContCellStruct','inputDepStruct','modelStats', ...
    'outlierStruct','model','assumTest');
else
    save(outName,SaveAsV6,'infoStruct', ...
    'modelStats', ...
    'outlierStruct','model','assumTest');
end
% save(outName,SaveAsV6,'infoStruct','dayStruct','depStruct','contCellStruct', ...
%     'inputContCellStruct','inputDepStruct','inputDayStruct','modelStats', ...
%     'outlierStruct','model','assumTest','fo');
return






