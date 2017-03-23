function PlotUnitFieldCoh03(analDirs,fileExt,spectAnalDir,statsAnalFunc,...
    analRoutine,freqLim,trialRateMin,cellRateMin,cohName,ntapers,varargin)
[freqRangeCell reportFigBool saveDir screenHeight xyFactor] = ...
    DefaultArgs(varargin,{{[4 12],[40 120]},...
    1,'/u12/smm/public_html/NewFigs/REMPaper/UnitAnal05/',15,1.5});

prevWarnSettings = SetWarnings({'off','LoadDesigVar:fileNotFound';...
   'off', 'MATLAB:divideByZero'});

cwd = pwd;

rates = [];
acgs = [];
ccgs = [];
for j=1:length(analDirs)
    cd(analDirs{j})
    load(['TrialDesig/' statsAnalFunc '/' analRoutine '.mat'])
    selChanCell = Struct2CellArray(LoadVar(['ChanInfo/SelChan' fileExt '.mat']));
   
    tempCCG = Struct2CellArray(MeanDesigUnitThresh(fileBaseCell,spectAnalDir,...
        ['unitFieldCoh_' cohName '_tapers' num2str(ntapers) '.yo'],...
        ['unitRate'],trialRateMin,trialDesig),[],1);
         
    tempRate = Struct2CellArray(MeanDesigUnitThresh(fileBaseCell,spectAnalDir,...
        ['unitRate'],['unitRate'],trialRateMin,trialDesig),[],1);
    
   for k=1:size(tempCCG,1)
        cellLayers = LoadCellLayers([fileBaseCell{1} '/' fileBaseCell{1} '.cellLayer']);
        cellTypes = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
        if isempty(ccgs)
            rates = tempRate;
            acgs = tempCCG;
            ccgs = tempCCG;
        end
        if ~isstruct(ccgs{k,end})
            rates{k,end} = struct([]);
            acgs{k,end} = struct([]);
            ccgs{k,end} = struct([]);
        end
        rates{k,end} = UnionStructMatCat(1,rates{k,end},SortRates2LayerTypes(squeeze(tempRate{k,end}),cellLayers,cellTypes));
        ccgs{k,end} = UnionStructMatCat(1,ccgs{k,end},SortUnitFieldCoh2LayerTypes(squeeze(tempCCG{k,end}),cellLayers,cellTypes,selChanCell));
    end
    size(tempCCG{1,2})
end
fo = LoadField([fileBaseCell{1} '/' spectAnalDir '/' 'unitFieldCoh_' cohName '_tapers' num2str(ntapers) '.fo']);
cd(cwd)

cellLayers = selChanCell(:,1);
cellTypes = {'w' 'n' 'x'};


colNamesCell{1} = cellLayers;
colNamesCell{2} = {'w','n'};
colNamesCell{3} = cellLayers;
colNamesCell{4} = {''};
colNamesCell{5} = ccgs(:,1);
% colNamesCell{1} = {''};
% colNamesCell{2} = {'w','n'};
% colNamesCell{3} = cellLayers;
% colNamesCell{4} = cellLayers;
% colNamesCell{5} = ccgs(:,1);
dataCell = CellArray2Struct(ccgs);
dataCell = Struct2CellArray(dataCell,[],1);
dataCell = cat(2,dataCell(:,[2 3 4]),repmat({''},size(dataCell(:,1))),...
    dataCell(:,[1 5]));
% dataCell = cat(2,repmat({''},size(dataCell(:,1))),dataCell(:,[3 4 2]),...
%     dataCell(:,[1 5]));

rateCell = CellArray2Struct(rates);
rateCell = Struct2CellArray(rateCell,[],1);
rateCell = cat(2,rateCell(:,[2 3]),repmat({''},size(rateCell(:,[1 2]))),...
    rateCell(:,[1 4]));
% rateCell = cat(2,repmat({''},size(rateCell(:,[1]))),...
%     rateCell(:,[3]),repmat({''},size(rateCell(:,[1]))),...
%     rateCell(:,[2]),rateCell(:,[1 4]));
 
%%%%%%%%%%%%%%%%% unit Field coh mean %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
infoText = {['Unit Field Coh ' fileExt];...
    [' tapers=' num2str(ntapers)];...
    [' trialMinRate=' num2str(trialRateMin)...
    ' cellMinRate=' num2str(cellRateMin)]}
figName =  ['unitFieldCoh' ...
    '_tMin' num2str(trialRateMin) '_cMin'...
    num2str(cellRateMin) '_' cohName '_'...
    'tapers' num2str(ntapers)]
outDir = [saveDir SC(analRoutine) SC('UnitFieldCoh') SC(GenFieldName(fileExt))];

tempDataCell = UnitCellRateThreshHelper(dataCell,cellRateMin,rateCell,0);
UnitSpectrumPlotHelper(tempDataCell,fo,[0 freqLim],infoText,figName,...
    colNamesCell,reportFigBool,outDir,[],screenHeight,xyFactor)

if reportFigBool
    close all
end


%%%%%%%%%% plot freq ranges %%%%%%%%%%%%%%%%%%%%%%%
% btw
for j=1:length(freqRangeCell)
    freqRange = freqRangeCell{j};
    
    infoText = {['Unit Field Coh_btw' fileExt];...
        [' tapers=' num2str(ntapers) ', ' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'];...
        [' trialMinRate=' num2str(trialRateMin)...
        ' cellMinRate=' num2str(cellRateMin)]}
    figName =  ['unitFieldCoh_btw_' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'...
        '_tMin' num2str(trialRateMin) '_cMin'...
        num2str(cellRateMin) '_' cohName '_'...
        'tapers' num2str(ntapers)]
    outDir = [saveDir SC(analRoutine) SC('UnitFieldCoh') SC(GenFieldName(fileExt))];

    tempDataCell = UnitCellRateThreshHelper(dataCell,cellRateMin,rateCell,0);
    tempDataCell = UnitMeanHelper(tempDataCell,fo,freqRange);
    UnitBoxPlotHelper(tempDataCell,infoText,figName,colNamesCell,reportFigBool,outDir)
end

if reportFigBool
    close all
end


% wIn
for j=1:length(freqRangeCell)
    freqRange = freqRangeCell{j};
    
    infoText = {['Unit Field Coh_wIn' fileExt];...
        [' tapers=' num2str(ntapers) ', ' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'];...
        [' trialMinRate=' num2str(trialRateMin)...
        ' cellMinRate=' num2str(cellRateMin)]}
    figName =  ['unitFieldCoh_wIn_' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'...
        '_tMin' num2str(trialRateMin) '_cMin'...
        num2str(cellRateMin) '_' cohName '_'...
        'tapers' num2str(ntapers)]
    outDir = [saveDir SC(analRoutine) SC('UnitFieldCoh') SC(GenFieldName(fileExt))];

    tempDataCell = UnitCellRateThreshHelper(dataCell,cellRateMin,rateCell,1);
    tempDataCell = UnitMeanHelper(tempDataCell,fo,freqRange);
    tempDataCell = UnitWInCellHelper(tempDataCell);
    UnitBoxPlotHelper(tempDataCell,infoText,figName,colNamesCell,reportFigBool,outDir)
end

if reportFigBool
    close all
end


return


