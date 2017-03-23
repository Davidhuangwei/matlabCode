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

    infoText = GenFieldName({['Unit_CCG'], ['t' num2str(timeRange(1)) '-' num2str(timeRange(2))]});
    figName = ['UnitCCG_wIn_' num2str(timeRange(1)) '-' num2str(timeRange(2)) 'ms_' normalization bcText ...
        '_bin' num2str(binSize)];
    outDir = [saveDir SC(analRoutine)];

        tempDataCell = UnitMeanHelper(dataCell,2,to,timeRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        tempDataCell = UnitMedianHelper(tempDataCell,1);
        
        tempDataCell = UnitTrimDataCellHelper(tempDataCell,colNamesCell);
        tempDataCell(:,strcmp(tempDataCell(1,:),'')) = [];
        tempDataCell = tempDataCell(:,~strcmp(tempDataCell(1,:),''));
        saveDataCell = cat(2,repmat(infoText,[size(tempDataCell,1),1]),tempDataCell);
        mkdir(outDir)
        save([outDir figName '.mat'],SaveAsV6,'saveDataCell');

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

    infoText = GenFieldName({['Unit ACG'], ['t' num2str(timeRange(1)) '-' num2str(timeRange(2))]});
    figName = ['UnitACG_wIn_' num2str(timeRange(1)) '-' num2str(timeRange(2)) 'ms_' normalization bcText ...
        '_bin' num2str(binSize)];
    outDir = [saveDir SC(analRoutine)];

        tempDataCell = UnitMeanHelper(dataCell,2,to,timeRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        tempDataCell = UnitZScoreHelper(tempDataCell,1);
%         tempDataCell = UnitMedianHelper(tempDataCell,1);
        
        tempDataCell = UnitTrimDataCellHelper(tempDataCell,colNamesCell);
        tempDataCell(:,strcmp(tempDataCell(1,:),'')) = [];
        tempDataCell = tempDataCell(:,~strcmp(tempDataCell(1,:),''));
        saveDataCell = cat(2,repmat(infoText,[size(tempDataCell,1),1]),tempDataCell);
        mkdir(outDir)
        save([outDir figName '.mat'],SaveAsV6,'saveDataCell');

 end

SetWarnings(prevWarnSettings);

