function GlmWholeModel04(dataDescription,analRoutine,outNameNote,fileBaseMat,fileExt,depVar,varargin)
%function GlmWholeModel04(description,fileBaseMat,fileExt,midPointsBool,minSpeed,winLength,thetaNW,gammaNW,w0,depVar,contIndepCell,varargin)
%[nChan,freqBool,maxFreq,nonParamBool,adjDayMedBool,adjDayZbool] = DefaultArgs(varargin,{96,0,150,0,0,0});
[nChan,freqBool,maxFreq,midPointsBool,minSpeed,winLength] ...
    = DefaultArgs(varargin,{96,0,150,1,0,626});
if midPointsBool
    midPointsText = '_MidPoints';
else
    midPointsText = [];
end
maxFreq = 150;

addpath(genpath('/u12/smm/matlab/econometrics/'))
outName = [mfilename '/' analRoutine '_' outNameNote '/' fileExt '/' depVar '.mat'];

dirName = [dataDescription midPointsText '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) fileExt];
fprintf('Reading from: %s\n',dirName);
if freqBool
    %curr = pwd;
    %cd([fileBaseMat(1,:) '/' dirName '/'])
    %[depVar(1:end-3) '.fo.mat']
    fileName = ParseStructName(depVar);
    fs = LoadField([fileBaseMat(1,:) '/' dirName '/' fileName{1} '.fo']);
    %cd(curr)
else
    fs = 1;
end

load(['TrialDesig/' mfilename '/' analRoutine '.mat'])

% load selected data
for i=1:length(contIndepCell)
    contCellStruct{i} = LoadDesigVar(fileBaseMat,dirName,contIndepCell{i},trialDesig);
end
depStruct = LoadDesigVar(fileBaseMat,dirName,depVar,trialDesig);
% replace non-finite data with a random number
tempCell= Struct2CellArray(depStruct,[],1);
for i=1:size(tempCell,1)
    tempCell{i,end}(~isfinite(tempCell{i,end})) = rand;
end
depStruct = CellArray2Struct(tempCell);

dayStruct = LoadDesigVar(fileBaseMat,dirName,'day',trialDesig);
% keep order of depStruct and dayStruct fields the same
tempCell= Struct2CellArray(dayStruct,[],1); 
dayStruct = CellArray2Struct(tempCell);


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
    for f=find(fs<=maxFreq)
        %fprintf('\n---- Channel %ch ----\n',ch)
        % extract all trials from specific channel/freq
        try depStructSub = GetStructMatSub(depStruct,[2,ch; 3,f]);
        catch keyboard
        end
        
        %adjust for Day medians
        %depStructSub = DayZscoreTemp(depStructSub,{1:20,21:36},);
        
        % remove outliers
        [tempCellStruct outlierStruct(:,ch,f)] = RemoveOutliers(cat(2,contCellStruct,{depStructSub}),outlierDepth,3);
        goodContCellStruct{ch,f}(1:length(contCellStruct)) = tempCellStruct(1:length(contCellStruct));
        goodDepStruct(ch,f) = tempCellStruct{end};

        %adjust for Day medians
        %keyboard
        if adjDayMedBool
            try
            goodDayStruct = DeleteOutliers(dayStruct,outlierStruct(:,ch,f));
            goodDepStruct(ch,f) = DayNormalize(goodDepStruct(ch,f),goodDayStruct,adjDayZbool);
            catch keyboard
            end
        end
        keepContCellStruct{ch,f} = goodContCellStruct;
        keepDepStruct(ch,f) = goodDepStruct(ch,f);
       
        % convert data from structs to matrices for stat analysis
        goodDepCell = Struct2CellArray(goodDepStruct(ch,f));
        depData = cell2mat(goodDepCell(:,end));
        categData = goodDepCell(:,1:end-1);

        % make continuous data matrix
        contData = [];
        for j=1:length(goodContCellStruct{ch,f})
            [goodContCell] = Struct2CellArray(goodContCellStruct{ch,f}{j});
            contData(:,j) = cell2mat(goodContCell(:,end));
            %contData = cat(2,contData,contTemp);
        end

        % re-sort categData so each column is in separate cells
        anovaCategData = {};
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
                    tempDep = cat(ndims(getfield(goodDepStruct(ch,f),mazeRegionNames{j}))+1,...
                        tempDep,getfield(goodDepStruct(ch,f),mazeRegionNames{j}));
                end
                trialMeanDep = mean(tempDep,ndims(getfield(goodDepStruct(ch,f),mazeRegionNames{j}))+1);
                trialMeanDep = repmat(trialMeanDep,length(mazeRegionNames),1);
            end
        end

        % create stat input mats
        yVar = depData;
        if trialMeanBool
            contXvarNames = [{'trialMean'}, contIndepCell];
            contXvar = [trialMeanDep, contData];
        else
            contXvarNames = [contIndepCell];
            contXvar = [contData];
        end
        categNames = {};
        for j=1:size(anovaCategData,2)
            categNames{j} = ['categ' num2str(j)];
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
            anovan(yVar,wholeXvar,'continuous',contVector,'varnames',[contXvarNames categNames],'sstype',ssType,'model',wholeModelSpec,'display','off');

        nWayComps = {};
        for j=1:size(anovaCategData,2)
            nWayComps = cat(1,nWayComps,num2cell(nchoosek([1:size(anovaCategData,2)],j),2));
        end

        for j=1:size(nWayComps,1)
            [junk model.categMeans{j}(:,:,ch,f) junk2 model.categNames{j}] = ...
                multcompare(modelStats(ch,f),'dimension',nWayComps{j}+length(contXvarNames),'display','off');
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
        iStruct = CellArray2Struct([categData mat2cell(contXvar,ones(size(contXvar,1),1),size(contXvar,2))]);
        %dStruct = CellArray2Struct([categData mat2cell(yVar,ones(size(yVar,1),1),size(yVar,2))]);
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
            CalcDurbinWatson(modelStats(ch,f).resid,categData,contXvar,contXvarNames);

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

outName = [mfilename '/' analRoutine '_' outNameNote '/' fileExt '/' depVar '.mat'];
fprintf('\nSaving: %s\n',outName);

infoStruct.dataDescription = dataDescription;
infoStruct.analRoutine = analRoutine;
infoStruct.outNameNote = outNameNote;
infoStruct.fileBaseMat = fileBaseMat;
infoStruct.fileExt = fileExt;
infoStruct.depVar = depVar;
infoStruct.contIndepCell = contIndepCell;
infoStruct.nChan = nChan;
infoStruct.freqBool = freqBool;
infoStruct.maxFreq = maxFreq;
infoStruct.modelSpec = wholeModelSpec;
infoStruct.ssType = ssType;
infoStruct.adjDayMedBool = adjDayMedBool;
infoStruct.adjDayZbool = adjDayZbool;
infoStruct.minSpeed = minSpeed;
infoStruct.winLength = winLength;
infoStruct.outlierDepth = outlierDepth;
infoStruct.trialMeanBool = trialMeanBool;
infoStruct.trialDesig = trialDesig;
infoStruct.dirName = dirName;
infoStruct.nWayComps = nWayComps;
infoStruct.outName = outName;

save(outName,SaveAsV6,'infoStruct','dayStruct','depStruct','contCellStruct', ...
    'goodContCellStruct','goodDepStruct','modelStats', ...
    'outlierStruct','model','assumTest','fs');
return







infoStruct.contIndepCell = contIndepCell;
infoStruct.outlierDepth = outlierDepth;
infoStruct.trialMeanBool = trialMeanBool;
infoStruct.trialDesig = trialDesig;
infoStruct.dirName = dirName;
infoStruct.outNameNote = outNameNote;
infoStruct.fileBaseMat = fileBaseMat;
infoStruct.minSpeed = minSpeed;
infoStruct.dataDescription = dataDescription;
infoStruct.winLength = winLength;
infoStruct.midPointsText = midPointsText;
infoStruct.freqBool = freqBool;
infoStruct.nonParamBool = nonParamBool;
infoStruct.adjDayMedBool = adjDayMedBool;
infoStruct.adjDayZbool = adjDayZbool;
infoStruct.nWayComps = nWayComps;

if ~exist(mfilename,'dir')
    eval(['!mkdir ' mfilename]);
end
outName = [mfilename '/' outNameNote depVar fileExt];
fprintf('\nSaving: %s',outName);

save(outName,SaveAsV6,'infoStruct','dayStruct','depStruct',...
    'contCellStruct','keepContCellStruct','keepDepStruct','partialModel','contXvarNames',...
    'outlierStruct','model','categStats','assumTest','fs');
return

