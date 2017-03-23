function LoadGlmWholeModelData06(dataDescription,analRoutine,outNameNote,fileExt,depVar,varargin)
%function GlmWholeModel06(description,fileBaseCell,fileExt,midPointsBool,minSpeed,winLength,thetaNW,gammaNW,w0,depVar,contIndepCell,varargin)
%[nChan,freqBool,maxFreq,nonParamBool,adjDayMedBool,adjDayZbool] = DefaultArgs(varargin,{96,0,150,0,0,0});
outName = ['GlmWholeModel05' '/' analRoutine '_' outNameNote '/' fileExt '/' depVar '.mat'];

[phaseMeanBool,nChan,freqBool,maxFreq,midPointsBool,minSpeed,winLength,saveInputData] ...
    = DefaultArgs(varargin,{0,96,0,150,1,0,626,0});

if midPointsBool
    midPointsText = '_MidPoints';
else
    midPointsText = [];
end
%maxFreq = 150;
chanDir = 'ChanInfo/';
selChans = LoadVar([chanDir 'SelChan' fileExt '.mat']);

addpath(genpath('/u12/smm/matlab/econometrics/'))

dirName = [dataDescription midPointsText '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) fileExt];
fprintf('Reading from: %s\n',dirName);

%%%%%% load TrialDesig %%%%%%%%%%%
load(['TrialDesig/' GlmWholeModel05 '/' analRoutine '.mat'])
if ~exist('fileBaseCell','var') % support for legacy data types
    fileBaseCell = mat2cell(fileBaseMat,ones(size(fileBaseMat,1),1),size(fileBaseMat,2));
end

% load selected data
if isempty(contIndepCell)
    contCellStruct = {};
else
    for i=1:length(contIndepCell)
        contCellStruct{i} = LoadDesigVar(fileBaseCell,dirName,contIndepCell{i},trialDesig);
    end
end
depStruct = LoadDesigVar(fileBaseCell,dirName,depVar,trialDesig);
% replace non-finite data with a random number
tempCell= Struct2CellArray(depStruct,[],1);
for i=1:size(tempCell,1)
    tempCell{i,end}(~isfinite(tempCell{i,end})) = rand;
end
depStruct = CellArray2Struct(tempCell);
keyboard
% equalize the N in each group by randomly subsampling
if ~exist('equalNbool','var'); equalNbool = 0; end
if exist('equalNbool','var') & equalNbool==1
    data = EqualizeN(cat(2,{depStruct},contCellStruct),outlierDepth);
    depStruct = data{1};
    contCellStruct = contCellStruct(2:end);
end

% extract subset of contCellStruct for contintuous variable analysis
if ~exist('contVarSub','var'); contVarSub = {}; end
if ~isempty(contVarSub)
    for j=1:length(contIndepCell)
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

%%%%%% load fo %%%%%%%%
% extract frequencies less than maxFreq
if freqBool
    fileName = ParseStructName(depVar);
    fo = LoadField([fileBaseCell{1,:} '/' dirName '/' fileName{1} '.fo']);
    fo = fo(fo<=maxFreq);
    tempCell= Struct2CellArray(depStruct,[],1);
    for i=1:size(tempCell,1)
        tempCell{i,end} = tempCell{i,end}(:,fo<=maxFreq);
    end
    depStruct = CellArray2Struct(tempCell);
else
    fo = 1;
end
newJunk(1:size(junk,1),1:size(junk,2)-1) = junk(1:end,1:end-1)
junk3 = Struct2CellArray(contCellStruct{2},[],1)

function GlmWholeModel06(depStruct,contCellStruct,varargin)
% function GlmWholeModel06(dataCellStruct,varNamesCell,varargin)
% [categIndepNamesCell,contIndepNamesCell,outName trialMeanBool modelSpec ssType outlierDepth infoStruct saveInputData] = ...
%     DefaultArgs(varagin,{[[],[],'./' mfilename '.mat'],0,1,3,0,[],1);
% 
% Description: Calculates a general linear model (GLM) using matlab's (>=v7.2) builtin
% anovan for the data passed in dataCellStruct and tests the assuptions of
% these calculations. 
% 
% The form of the GLM [Y = sum(Bi(Xi)) for all i] is primarily specified by 
% the content of the dataCellStruct. dataCellStruct should be a cell array of
% structures where dataCellStruct{1} contains a structure with the
% "dependent" Y variable data and dataCellStruct{2:end} (if specified) contains 
% structures with continuous "independent" X variable data. The categorical
% "independent" X variables are specified by the form of the structures
% in dataCellStruct.
% e.g.
% dataCellStruct{1} = 
% depStruct.task1.region1(theta power measurements from n Trials)
% depStruct.task1.region2(theta power measurements from m Trials)
% depStruct.task2.region1(theta power measurements from o Trials)
% depStruct.task2.region2(theta power measurements from p Trials)
% dataCellStruct{2} = 
% contStruct.task1.region1(running speed measurements from n Trials)
% contStruct.task1.region2(running speed measurements from m Trials)
% contStruct.task2.region1(running speed measurements from o Trials)
% contStruct.task2.region2(running speed measurements from p Trials)
% will calculate the GLM:
% thetaPower = B1*task + B2*region + B3*runningSpeed
% The depStruct can have a matrix at the end (up to 3D) e.g. [trials x
% channels x frequency] in which case a separate GLM will be fit for each
% channel x frequency pair.
% NOTE: the structures of dataCellStruct must have identical form and all 
% branches of the structs must be of equal length.
%
% OUTPUT:
% model: contains model statistics - coeffs (B), pVals, rSq, etc.
% outlierStruct: a structure deliniating which trials were removed as
%    outliers
% assumTest: a structure with the following assumption tests
%  1) test normality of residuals
%  2) test residual means are all zero
%  3) test homoscedasticity (homo variance) for categs and conts
%   (but not interactions...)
%  4) test non-parallel treatment (interaction of categ & cont)
%  5) test for correlated errors for each categ (dw test)
% modelStats: various extra information including residuals
% infoStruct: information about the parameters used for calculations

% In addition to model statistics returned (and or saved) in the "model"
% structure
%         save(outName,SaveAsV6,'infoStruct', ...
%            'modelStats', ...
 %           'outlierStruct','model','assumTest','fo');
%     end
% Parameters
% trialMean - same#trials
% modelSpec - interactions
% sstype - 
% outlierDepth
% outName
% assumptions
% 


[outName trialMeanBool modelSpec ssType outlierDepth infoStruct] = ...
    DefaultArgs(varagin,{['./' mfilename '.mat'],0,1,3,0,[]});

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
        if ~isempty(contVarSub)
            for j=1:length(contIndepCell)
                if strcmp(contVarSub{j},'jibe')
                    contCellStruct{j} = GetStructMatSub(contCellStruct{j},[2,ch; 3,f]);
                end
            end
        end

        % remove outliers
        [tempCellStruct outlierStruct(:,ch,f)] = RemoveOutliers(cat(2,contCellStruct,{depStructSub}),outlierDepth,3);
        goodContCellStruct{ch,f}(1:length(contCellStruct)) = tempCellStruct(1:length(contCellStruct));
        goodDepStruct = tempCellStruct{end};
        if saveInputData
        inputContCellStruct{:,ch,f} = goodContCellStruct;
        inputDepStruct(ch,f) = goodDepStruct;
        inputDayStruct(ch,f) = goodDayStruct;
        end
        % convert data from structs to matrices for stat analysis
        goodDepCell = Struct2CellArray(goodDepStruct);
        depData = cell2mat(goodDepCell(:,end));
        categData = goodDepCell(:,1:end-1);

        % make continuous data matrix
        contData = [];
        for j=1:length(goodContCellStruct{ch,f})
            [goodContCell] = Struct2CellArray(goodContCellStruct{ch,f}{j});
            CheckCellArraySim(categData,goodContCell(:,1:end-1));
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
% if ~exist(mfilename,'dir')
%     eval(['!mkdir ' mfilename]);
% end
% if ~exist([mfilename '/' analRoutine '_' outNameNote],'dir')
%     eval(['!mkdir ' mfilename '/' analRoutine '_' outNameNote]);
% end
% if ~exist([mfilename '/' analRoutine '_' outNameNote '/' fileExt],'dir')
%     eval(['!mkdir ' mfilename '/' analRoutine '_' outNameNote '/' fileExt]);
% end
% outName = [mfilename '/' analRoutine '_' outNameNote '/' fileExt '/' depVar '.mat'];

if ~isempty(outName)
    [dirName fileName] = SplitDirFileName(outName);
    if ~exist(dirName,'dir')
        mkdir(dirName);
    end
    fprintf('\nSaving: %s\n',outName);

    %infoStruct.dataDescription = dataDescription;
    %infoStruct.analRoutine = analRoutine;
    %infoStruct.outNameNote = outNameNote;
    % infoStruct.fileBaseCell = fileBaseCell;
    %infoStruct.fileExt = fileExt;
    % infoStruct.depVar = depVar;
    infoStruct.contIndepCell = contIndepCell;
    infoStruct.modelSpec = modelSpec;
    infoStruct.ssType = ssType;
    % infoStruct.minSpeed = minSpeed;
    % infoStruct.winLength = winLength;
    infoStruct.outlierDepth = outlierDepth;
    infoStruct.trialMeanBool = trialMeanBool;
    % infoStruct.trialDesig = trialDesig;
    % infoStruct.dirName = dirName;
    infoStruct.nWayComps = nWayComps;
    infoStruct.outName = outName;

    if saveInputData
        save(outName,SaveAsV6,'infoStruct', ...
            'inputContCellStruct','inputDepStruct','modelStats', ...
            'outlierStruct','model','assumTest','fo');
    else
        save(outName,SaveAsV6,'infoStruct', ...
            'modelStats', ...
            'outlierStruct','model','assumTest','fo');
    end
end
return






