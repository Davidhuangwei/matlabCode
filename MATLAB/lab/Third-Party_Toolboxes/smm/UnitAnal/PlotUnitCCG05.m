% function PlotUnitCCG03(analDirs,spectAnalDir,statsAnalFunc,...
%     analRoutine,normalization,binSize,timeLim,biasCorrBool,rateMin,varargin)
% saveDir = DefaultArgs(varargin,{'/u12/smm/public_html/REMPaper/UnitAnal05/'});
function PlotUnitCCG03(analDirs,spectAnalDir,statsAnalFunc,...
    analRoutine,normalization,binSize,timeLim,biasCorrBool,rateMin,varargin)
[timeRangeCell reportFigBool saveDir] = ...
    DefaultArgs(varargin,{{[-8 8],[-25 25],[-250 250]},...
    1,'/u12/smm/public_html/NewFigs/REMPaper/UnitAnal05/'});
prevWarnSettings = SetWarnings({'off','LoadDesigVar:fileNotFound';...
   'off', 'MATLAB:divideByZero'});

cwd = pwd;

if biasCorrBool
    bcText = 'BC';
else
    bcText = '';
end
btwrates = [];
btwacgs = [];
btwccgs = [];

wInrates = [];
wInacgs = [];
wInccgs = [];
for j=1:length(analDirs)
    cd(analDirs{j})
    selChan = Struct2CellArray(LoadVar('ChanInfo/SelChan.eeg.mat'),[],1);
    load(['TrialDesig/' statsAnalFunc '/' analRoutine '.mat'])
    tempRate = Struct2CellArray(MeanDesigVar(1,fileBaseCell,spectAnalDir,...
        ['unitRate'],trialDesig),[],1);

    if strcmp(normalization,'count')
        tempCCG = Struct2CellArray(SumDesigVar(1,fileBaseCell,spectAnalDir,...
            ['unitCCGBin' num2str(binSize) normalization bcText '.yo'],trialDesig),[],1);
        time = Struct2CellArray(LoadDesigVar(fileBaseCell,spectAnalDir,...
            ['time'],trialDesig),[],1);
        %%%%%%%%% Nomalize using "scale" method (see CCG.m) %%%%%%%%%%%%%%%%%%%%%%%%%
        binSec = binSize/1000;
        winLen = LoadField([fileBaseCell{1} '/' spectAnalDir '/' 'infoStruct.winLength']);
        eegSamp = LoadField([fileBaseCell{1} '/' spectAnalDir '/' 'infoStruct.eegSamp']);
        for k=1:size(tempCCG,1)
            for m=1:size(tempRate{k,end},2)
                for n=1:size(tempRate{k,end},2)
                    numSec = length(time{k,end}) * winLen / eegSamp;
                    scaleFactor = 1 / (binSec * numSec * tempRate{k,end}(1,m) * tempRate{k,end}(1,n));
                    tempCCG{k,end}(1,m,n,:) = tempCCG{k,end}(1,m,n,:) * scaleFactor;
                end
            end
        end
    else % already normalized
        tempCCG = Struct2CellArray(MeanDesigVar(1,fileBaseCell,spectAnalDir,...
            ['unitCCGBin' num2str(binSize) normalization bcText '.yo'],trialDesig),[],1);
    end
    
    wInKeepInd = ones(size(tempRate{1,end}));
    for k=1:size(tempCCG,1)
        wInKeepInd = wInKeepInd & tempRate{k,end} >= rateMin;
    end

    btwtempRate = tempRate;
    btwtempCCG = tempCCG;
    wIntempRate = tempRate;
    wIntempCCG = tempCCG;
    for k=1:size(tempCCG,1)
        % remove cells with rate < rateMin
        btwKeepInd = tempRate{k,end} >= rateMin;
        cellLayers = LoadCellLayers([fileBaseCell{1} '/' fileBaseCell{1} '.cellLayer']);
        cellTypes = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
        
        btwtempRate{k,end} = tempRate{k,end}(1,btwKeepInd);
        btwtempCCG{k,end} = tempCCG{k,end}(1,btwKeepInd,btwKeepInd,:);
        btwcellLayers = cellLayers(btwKeepInd,:);
        btwcellTypes = cellTypes(btwKeepInd,:);
        
        wIntempRate{k,end} = tempRate{k,end}(1,wInKeepInd);
        wIntempCCG{k,end} = tempCCG{k,end}(1,wInKeepInd,wInKeepInd,:);
        wIncellLayers = cellLayers(wInKeepInd,:);
        wIncellTypes = cellTypes(wInKeepInd,:);
        % sort cells by layer/type
        if isempty(btwccgs)
            btwrates = btwtempRate;
            btwacgs = btwtempCCG;
            btwccgs = btwtempCCG;
            
            wInrates = wIntempRate;
            wInacgs = wIntempCCG;
            wInccgs = wIntempCCG;
        end
        if ~isstruct(btwccgs{k,end})
            btwrates{k,end} = struct([]);
            btwacgs{k,end} = struct([]);
            btwccgs{k,end} = struct([]);
            
            wInrates{k,end} = struct([]);
            wInacgs{k,end} = struct([]);
            wInccgs{k,end} = struct([]);
        end
        btwrates{k,end} = UnionStructMatCat(1,btwrates{k,end},SortRates2LayerTypes(squeeze(btwtempRate{k,end}),btwcellLayers,btwcellTypes));
        btwacgs{k,end} = UnionStructMatCat(1,btwacgs{k,end},SortACG2LayerTypes(squeeze(btwtempCCG{k,end}),btwcellLayers,btwcellTypes));
        btwccgs{k,end} = UnionStructMatCat(1,btwccgs{k,end},SortCCG2LayerTypes(squeeze(btwtempCCG{k,end}),btwcellLayers,btwcellTypes));
        
        wInrates{k,end} = UnionStructMatCat(1,wInrates{k,end},SortRates2LayerTypes(squeeze(wIntempRate{k,end}),wIncellLayers,wIncellTypes));
        wInacgs{k,end} = UnionStructMatCat(1,wInacgs{k,end},SortACG2LayerTypes(squeeze(wIntempCCG{k,end}),wIncellLayers,wIncellTypes));
        wInccgs{k,end} = UnionStructMatCat(1,wInccgs{k,end},SortCCG2LayerTypes(squeeze(wIntempCCG{k,end}),wIncellLayers,wIncellTypes));
    end
    size(btwtempCCG{1,2})
    size(wIntempCCG{1,2})
end
to = LoadField([fileBaseCell{1} '/' spectAnalDir '/' 'unitCCGBin' num2str(binSize) normalization bcText '.to']);
cd(cwd)
cellLayers = selChan(:,1);


%%%%%%%%%% plot average CCGs %%%%%%%%
colNamesCell{1} = {'w','n'};
colNamesCell{2} = {'w','n'};
colNamesCell{3} = cellLayers;
colNamesCell{4} = cellLayers;
colNamesCell{5} = btwccgs(:,1);
dataCell = CellArray2Struct(btwccgs);
dataCell = Struct2CellArray(dataCell,[],1);
dataCell = cat(2,dataCell(:,[5 3 4 2]),dataCell(:,[1 6]));

infoText = {['Unit Firing CCG'];...
    [normalization ' bin=' num2str(binSize) ' ' bcText ' minRate=' num2str(rateMin)]};
figName = ['UnitCCG_' normalization bcText ...
    '_bin' num2str(binSize)];
    outDir = [saveDir SC(analRoutine) 'CCG/'];

UnitSpectrumPlotHelper(dataCell,to,[-timeLim timeLim],infoText,figName,colNamesCell,reportFigBool,outDir)
if reportFigBool
    close all
end


%%%%%%%%%% plot time range CCG boxplots %%%%%%%%%%%%% 
% btw cell
for j=1:length(timeRangeCell)
    timeRange = timeRangeCell{j};
    for k=1:length(colNamesCell{1})
    for m=1:length(colNamesCell{2})
        dataCell2 = dataCell(strcmp(dataCell(:,1),colNamesCell{1}{k})...
            & strcmp(dataCell(:,2),colNamesCell{2}{m}),:);

    infoText = {['Unit Firing CCG - btwCell']; ['timeRange=' num2str(timeRange{1}(1)) '-' num2str(timeRange{1}(2)) 'ms']; ...
        [normalization ' bin=' num2str(binSize) ' ' bcText ' minRate=' num2str(rateMin)]};
    figName = ['UnitCCG_btwCell_' num2str(timeRange{1}(1)) '-' num2str(timeRange{1}(2)) 'ms_' normalization bcText ...
        '_bin' num2str(binSize)];
    outDir = [saveDir SC(analRoutine) 'CCG/'];
    
           cMap = LoadVar('ColorMapSean6');
        tempDataCell = UnitMeanHelper(dataCell2,2,to,timeRange);
        tempDataCell = UnitMedianHelper(tempDataCell,1);
        UnitColorPlotHelper(tempDataCell,[],1,0,cMap,cat(1,'btw medians',infoText),figName,colNamesCell,reportFigBool,outDir)

        cMap = flipud(LoadVar('ColorMapSean6'));
        tempDataCell = UnitMeanHelper(dataCell2,2,to,timeRange);
        UnitKWPlotHelper(tempDataCell,[-3 0],1,0,cMap,cat(1,'btw KW p-values',infoText),figName,colNamesCell,reportFigBool,outDir)

    
    tempDataCell = UnitMeanHelper(dataCell2,2,to,timeRange);
%     tempDataCell = UnitLog10Helper(tempDataCell);
    UnitBoxPlotHelper(tempDataCell,infoText,figName,colNamesCell,reportFigBool,outDir)
    end
    end
end
if reportFigBool
    close all
end

% wIn cell
colNamesCell{1} = {'w','n'};
colNamesCell{2} = {'w','n'};
colNamesCell{3} = cellLayers;
colNamesCell{4} = cellLayers;
colNamesCell{5} = wInccgs(:,1);
dataCell = CellArray2Struct(wInccgs);
dataCell = Struct2CellArray(dataCell,[],1);
dataCell = cat(2,dataCell(:,[5 3 4 2]),dataCell(:,[1 6]));

for j=1:length(timeRangeCell)
    timeRange = timeRangeCell{j};
    for k=1:length(colNamesCell{1})
    for m=1:length(colNamesCell{2})
        dataCell2 = dataCell(strcmp(dataCell(:,1),colNamesCell{1}{k})...
            & strcmp(dataCell(:,2),colNamesCell{2}{m}),:);

    infoText = {['Unit Firing CCG - wInCell']; ['timeRange=' num2str(timeRange{1}(1)) '-' num2str(timeRange{1}(2)) 'ms']; ...
        [normalization ' bin=' num2str(binSize) ' ' bcText ' minRate=' num2str(rateMin)]};
    figName = ['UnitCCG_wInCell_' num2str(timeRange{1}(1)) '-' num2str(timeRange{1}(2)) 'ms_' normalization bcText ...
        '_bin' num2str(binSize)];
    outDir = [saveDir SC(analRoutine) 'CCG/'];

            cMap = LoadVar('ColorMapSean6');
        tempDataCell = UnitMeanHelper(dataCell2,2,to,timeRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        tempDataCell = UnitMedianHelper(tempDataCell,1);
        UnitColorPlotHelper(tempDataCell,[-0.75 .75],1,1,cMap,cat(1,'w/in medians',infoText),figName,colNamesCell,reportFigBool,outDir)

        cMap = flipud(LoadVar('ColorMapSean6'));
        tempDataCell = UnitMeanHelper(dataCell2,2,to,timeRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        tempDataCell = UnitSignRankHelper(tempDataCell);
        tempDataCell = UnitLog10Helper(tempDataCell);
        UnitColorPlotHelper(tempDataCell,[-3 0],1,0,cMap,cat(1,'w/in ranksign p-values',infoText),figName,colNamesCell,reportFigBool,outDir)

        tempDataCell = UnitMeanHelper(dataCell2,2,to,timeRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        UnitKWPlotHelper(tempDataCell,[-3 0],1,0,cMap,cat(1,'w/in KW p-values',infoText),figName,colNamesCell,reportFigBool,outDir)

    
    tempDataCell = UnitMeanHelper(dataCell2,2,to,timeRange);
    tempDataCell = UnitWInCellHelper(tempDataCell);
    UnitBoxPlotHelper(tempDataCell,infoText,figName,colNamesCell,reportFigBool,outDir)
    end
    end
end
if reportFigBool
    close all
end


%%%%%%%%%% plot ACGs %%%%%%%%%%%%%%%%%%%%%%%
colNamesCell{1} = {''};
colNamesCell{2} = {''};
colNamesCell{3} = cellLayers;
colNamesCell{4} = {'w','n','x'};
colNamesCell{5} = btwacgs(:,1);
dataCell = CellArray2Struct(btwacgs);
dataCell = Struct2CellArray(dataCell,[],1);
dataCell = cat(2,repmat({''},size(dataCell(:,[1 2]))),...
    dataCell(:,[2 3]),dataCell(:,[1 4]));

infoText = {['Unit Firing ACG'];...
    [normalization ' bin=' num2str(binSize) ' ' bcText ' minRate=' num2str(rateMin)]};
figName = ['UnitACG_' normalization bcText ...
    '_bin' num2str(binSize)];
    outDir = [saveDir SC(analRoutine) 'ACG/'];

UnitSpectrumPlotHelper(dataCell,to,[-timeLim timeLim],infoText,figName,colNamesCell,reportFigBool,outDir)


%%%%%%%%%% plot time range ACG boxplots %%%%%%%%%%%%% 
% btw cell
for j=1:length(timeRangeCell)
    timeRange = timeRangeCell{j};

    infoText = {['Unit Firing ACG - btwCell']; ['timeRange=' num2str(timeRange{1}(1)) '-' num2str(timeRange{1}(2)) 'ms']; ...
        [normalization ' bin=' num2str(binSize) ' ' bcText ' minRate=' num2str(rateMin)]};
    figName = ['UnitACG_btwCell_' num2str(timeRange{1}(1)) '-' num2str(timeRange{1}(2)) 'ms_' normalization bcText ...
        '_bin' num2str(binSize)];
    outDir = [saveDir SC(analRoutine) 'ACG/'];
    
    cMap = LoadVar('ColorMapSean6');
        tempDataCell = UnitMeanHelper(dataCell,2,to,timeRange);
        tempDataCell = UnitMedianHelper(tempDataCell,1);
        UnitColorPlotHelper(tempDataCell,[],1,0,cMap,cat(1,'btw medians',infoText),figName,colNamesCell,reportFigBool,outDir)

        cMap = flipud(LoadVar('ColorMapSean6'));
        tempDataCell = UnitMeanHelper(dataCell,2,to,timeRange);
        UnitKWPlotHelper(tempDataCell,[-3 0],1,0,cMap,cat(1,'btw KW p-values',infoText),figName,colNamesCell,reportFigBool,outDir)

    
    tempDataCell = UnitMeanHelper(dataCell,2,to,timeRange);
    UnitBoxPlotHelper(tempDataCell,infoText,figName,colNamesCell,reportFigBool,outDir)
end

% wIn cell
colNamesCell{1} = {''};
colNamesCell{2} = {''};
colNamesCell{3} = cellLayers;
colNamesCell{4} = {'w','n','x'};
colNamesCell{5} = wInacgs(:,1);
dataCell = CellArray2Struct(wInacgs);
dataCell = Struct2CellArray(dataCell,[],1);
dataCell = cat(2,repmat({''},size(dataCell(:,[1 2]))),...
    dataCell(:,[2 3]),dataCell(:,[1 4]));

for j=1:length(timeRangeCell)
    timeRange = timeRangeCell{j};

    infoText = {['Unit Firing ACG - wInCell']; ['timeRange=' num2str(timeRange{1}(1)) '-' num2str(timeRange{1}(2)) 'ms']; ...
        [normalization ' bin=' num2str(binSize) ' ' bcText ' minRate=' num2str(rateMin)]};
    figName = ['UnitACG_wInCell_' num2str(timeRange{1}(1)) '-' num2str(timeRange{1}(2)) 'ms_' normalization bcText ...
        '_bin' num2str(binSize)];
    outDir = [saveDir SC(analRoutine) 'ACG/'];

                cMap = LoadVar('ColorMapSean6');
        tempDataCell = UnitMeanHelper(dataCell,2,to,timeRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        tempDataCell = UnitMedianHelper(tempDataCell,1);
        UnitColorPlotHelper(tempDataCell,[-0.75 .75],1,1,cMap,cat(1,'w/in medians',infoText),figName,colNamesCell,reportFigBool,outDir)

        cMap = flipud(LoadVar('ColorMapSean6'));
        tempDataCell = UnitMeanHelper(dataCell,2,to,timeRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        tempDataCell = UnitSignRankHelper(tempDataCell);
        tempDataCell = UnitLog10Helper(tempDataCell);
        UnitColorPlotHelper(tempDataCell,[-3 0],1,0,cMap,cat(1,'w/in ranksign p-values',infoText),figName,colNamesCell,reportFigBool,outDir)

        tempDataCell = UnitMeanHelper(dataCell,2,to,timeRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        UnitKWPlotHelper(tempDataCell,[-3 0],1,0,cMap,cat(1,'w/in KW p-values',infoText),figName,colNamesCell,reportFigBool,outDir)    
    
    tempDataCell = UnitMeanHelper(dataCell,2,to,timeRange);
    tempDataCell = UnitWInCellHelper(tempDataCell);
    UnitBoxPlotHelper(tempDataCell,infoText,figName,colNamesCell,reportFigBool,outDir)
end

if reportFigBool
    close all
end

SetWarnings(prevWarnSettings);

