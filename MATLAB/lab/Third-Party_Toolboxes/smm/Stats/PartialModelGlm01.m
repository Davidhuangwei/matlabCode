function GlmPartialModel01(dataDescription,outNameNote,fileBaseMat,fileExt,depVar,contIndepCell,varargin)
%function glmtrial11(description,fileBaseMat,fileExt,midPointsBool,minSpeed,winLength,thetaNW,gammaNW,w0,depVar,contIndepCell,varargin)
%[nChan,freqBool,maxFreq,nonParamBool,adjDayMedBool,adjDayZbool] = DefaultArgs(varargin,{96,0,150,0,0,0});
[nChan,freqBool,maxFreq,modelSpec,ssType,nonParamBool,adjDayMedBool,adjDayZbool,midPointsBool,minSpeed,winLength] ...
    = DefaultArgs(varargin,{96,0,150,1,3,0,0,0,1,0,626});

if midPointsBool
    midPointsText = '_MidPoints';
else
    midPointsText = [];
end
maxFreq = 150;

addpath(genpath('/u12/smm/matlab/econometrics/'))

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

trialDesig = [];

if 0
    trialDesig.alter.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.alter.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.circle.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
    trialDesig.circle.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
    outlierDepth = 2;
    trialMeanBool = 0;
end
if 0
    trialDesig.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
    trialDesig.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
    trialMeanBool = 1;
    outlierDepth = 1;
    outNameNote = ['Alter_' outNameNote '_']
end
if 0
    %trialDesig.alter.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.centerArm =  {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.q12 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.4},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5});
    trialMeanBool = 0;
    removeOutliersBool = 0;
end
if 0
    trialDesig.err.returnArm = {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.err.centerArm = {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.err.Tjunction = {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 1 0 0 0 0 0],.9};
    trialDesig.err.goalArm =   {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 0 0 1 1 0 0],.9};
    trialDesig.corr.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.corr.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.corr.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
    trialDesig.corr.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
    trialMeanBool = 0;
    outlierDepth = 0;
    outNameNote = [ 'AlterCorr_v_AlterErr_' outNameNote '_']

end
if 0
    trialDesig.circle.q1 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5});
    trialDesig.circle.q2 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5});
    trialDesig.circle.q3 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5});
    trialDesig.circle.q4 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5});
    trialMeanBool = 1;
    outlierDepth = 1;
        outNameNote = ['Circle_' outNameNote '_']
end
if 1
    trialDesig.alter.q1 = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.alter.q2 = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.alter.q3 = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
    trialDesig.alter.q4 =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
    trialDesig.circle.q1 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5});
    trialDesig.circle.q2 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5});
    trialDesig.circle.q3 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5});
    trialDesig.circle.q4 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5});
    trialMeanBool = 0;
    outlierDepth = 1;
        outNameNote = ['Alter_Vs_Circle_EachRegion_' outNameNote '_']
end



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

c1 = clock;
for ch=1:nChan
    fprintf('ch%i;',ch)
    if mod(ch,10) == 0
        c2 = clock-c1;
        c1 = clock;
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
            goodDayStruct = DeleteOutliers(dayStruct,outlierStruct(ch,f));
            goodDepStruct(ch,f) = DayZscoreTemp(goodDepStruct(ch,f),goodDayStruct,adjDayZbool);
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
            contXvarNames = [{'ones'}, contIndepCell, {'trialMean'}];
            contXvar = [ones(size(contData,1),1),contData,trialMeanDep];
        else
            contXvarNames = [{'ones'}, contIndepCell];
            contXvar = [ones(size(contData,1),1),contData];
        end
        categNames = {};
        for j=1:size(anovaCategData,2)
            categNames{j} = ['categ' num2str(j)];
        end
        % perform "ANCOVA", regressing continuous data and running
        % ANOVA on residuals
        contStats(ch,f) = ols(yVar,contXvar);
        model.pVals(1:size(contXvar,2),ch,f) = tcdf(-abs(contStats(ch,f).tstat),length(yVar)-1)'.*2;
        model.coeffs(1:size(contXvar,2),ch,f) = contStats(ch,f).beta;
        model.varNames(1:size(contXvar,2)) = contXvarNames;
        
        % calculate the number of main effects+interactions in specified model
        if length(modelSpec) == 1
            modelSize = 0;
            for j=1:modelSpec
                modelSize = modelSize + nchoosek(length(anovaCategData),j);
            end
        else
            modelSize = size(modelSpec,2);
        end
        
        if ~nonParamBool
            %% anova for parametric analysis %%
            [model.pVals(size(contXvar,2)+1:size(contXvar,2)+modelSize,ch,f), model.anovaTable{ch,f}, categStats(ch,f)] = ...
                anovan(contStats(ch,f).resid,anovaCategData,'varnames', categNames,'sstype',ssType,'model',modelSpec,'display','off');
        else
            %% kruskalwallis for non-parametric analysis %%
            [model.pVals(size(contXvar,2)+1:size(contXvar,2)+size(anovaCategData,2),ch,f), junk, categStats(ch,f)] = ...
                kruskalwallis(contStats(ch,f).resid,anovaCategData{1},'off');
        end

        model.varNames(size(contXvar,2)+1:size(contXvar,2)+length(categStats(ch,f).varnames)) = categStats(ch,f).varnames;
        model.coeffs(size(contXvar,2)+1:size(contXvar,2)+length(categStats(ch,f).coeffs),ch,f) = categStats(ch,f).coeffs;
        model.coeffNames = cat(1, contXvarNames', categStats(ch,f).coeffnames);
        model.contVarNames = contXvarNames;
        model.categVarNames = categNames;
        table = model.anovaTable{ch,f};
        for j=2:size(table,1)-2
            sumSqCol = find(strcmp(table(1,:),'Sum Sq.'));
            totalRow = find(strcmp(table(:,1),'Total'));
            model.rSq(j-1,ch,f) = table{j,sumSqCol}/table{totalRow,sumSqCol};
            model.rSqNames{j-1,ch,f} = table{j,find(strcmp(table(1,:),'Source'))};
        end
       
        nWayComps = {};
        for j=1:size(anovaCategData,2)
            nWayComps = cat(1,nWayComps,num2cell(nchoosek([1:size(anovaCategData,2)],j),2));
        end
        for j=1:size(nWayComps,1)
            [junk model.categMeans{j}(:,:,ch,f) junk2 model.categNames{j}] = ...
                multcompare(categStats(ch,f),'dimension',nWayComps{j},'display','off');
        end
        
        %%%%%% test assumptions %%%%%%
        % test normality mean and var of final residuals (jbtest & kstest)
        indepStruct = CellArray2Struct([categData mat2cell(contXvar,ones(size(contXvar,1),1),size(contXvar,2))]);
        %dStruct = CellArray2Struct([categData mat2cell(yVar,ones(size(yVar,1),1),size(yVar,2))]);
        residStruct = CellArray2Struct(cat(2,categData,mat2cell(categStats(ch,f).resid,...
            repmat(1,size(categStats(ch,f).resid,1),1),1)));
        % 1) test normality of residuals
        assumTest.residNormPs(ch,f) = TestNormality(residStruct);
        % 2) test means are all zero
        assumTest.residMeanPs(ch,f) = TestZeroMeans(residStruct);
        % 3) test homoscedasticity (homo variance) for categs and conts
        % (but not interactions)
        [assumTest.residCategVarPs(ch,f) assumTest.residCategVarZs(ch,f) assumTest.residContVarPs(ch,f)] = ...
            TestHomoScedasticity(categStats(ch,f).resid,categData,contXvar,contXvarNames);
        % 4) test non-parallel treatment
        [assumTest.prllPvals(ch,f) assumTest.PrllBetas{ch,f}] = TestParallelGroup(residStruct,indepStruct,{contXvarNames});
        % 5) test for correlated errors for each categ
        [assumTest.categDwPvals(ch,f) assumTest.contDwPvals(ch,f)] = ...
            CalcDurbinWatson(categStats(ch,f).resid,categData,contXvar,contXvarNames);
    end
end

if ~exist(mfilename,'dir')
    eval(['!mkdir ' mfilename]);
end
if ~exist([mfilename '/' outNameNote],'dir')
    eval(['!mkdir ' mfilename '/' outNameNote]);
end
if ~exist([mfilename '/' outNameNote '/' fileExt],'dir')
    eval(['!mkdir ' mfilename '/' outNameNote '/' fileExt]);
end

outName = [mfilename '/' outNameNote '/' fileExt '/' depVar];
fprintf('\nSaving: %s\n',outName);

infoStruct.dataDescription = dataDescription;
infoStruct.outNameNote = outNameNote;
infoStruct.fileBaseMat = fileBaseMat;
infoStruct.fileExt = fileExt;
infoStruct.depVar = depVar;
infoStruct.contIndepCell = contIndepCell;
infoStruct.nChan = nChan;
infoStruct.freqBool = freqBool;
infoStruct.maxFreq = maxFreq;
infoStruct.modelSpec = modelSpec;
infoStruct.ssType = ssType;
infoStruct.nonParamBool = nonParamBool;
infoStruct.adjDayMedBool = adjDayMedBool;
infoStruct.adjDayZbool = adjDayZbool;
infoStruct.minSpeed = minSpeed;
infoStruct.winLength = winLength;
infoStruct.outlierDepth = outlierDepth;
infoStruct.trialMeanBool = trialMeanBool;
infoStruct.trialDesig = trialDesig;
infoStruct.dirName = dirName;
infoStruct.modelSize = modelSize;
infoStruct.nWayComps = nWayComps;
infoStruct.outName = outName;

save(outName,SaveAsV6,'infoStruct','dayStruct','depStruct','contCellStruct', ...
    'goodContCellStruct','goodDepStruct','contStats','categStats', ...
    'outlierStruct','model','assumTest','fs');
return

