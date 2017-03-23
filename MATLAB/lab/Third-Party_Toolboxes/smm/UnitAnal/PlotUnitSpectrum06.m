function PlotUnitSpectrum05(analDirs,spectAnalDir,statsAnalFunc,...
    analRoutine,trialRateMin,cellRateMin,ntapers,varargin)

[freqLim,freqRangeCell,reportFigBool,saveDir,screenHeight,xyFactor] = ...
    DefaultArgs(varargin,{1000,{[4 12],[40 120]},...
    1,'/u12/smm/public_html/NewFigs/REMPaper/UnitAnal06/',15,1.1});

prevWarnSettings = SetWarnings({'off','LoadDesigVar:fileNotFound';...
   'off', 'MATLAB:divideByZero'});

cwd = pwd;

rates = [];
acgs = [];
for j=1:length(analDirs)
    cd(analDirs{j})
    load(['TrialDesig/' statsAnalFunc '/' analRoutine '.mat'])
    selChan = Struct2CellArray(LoadVar('ChanInfo/SelChan.eeg.mat'),[],1);
    
    [tempCCG keptIndexes] = MeanDesigUnitThresh(fileBaseCell,spectAnalDir,...
        ['unitPowSpec_tapers' num2str(ntapers) '.yo'],...
        ['unitPowSpec_tapers' num2str(ntapers) '.rate'],...
        trialRateMin,trialDesig);
    tempCCG = Struct2CellArray(tempCCG,[],1);

    tempRate = Struct2CellArray(MeanDesigUnitIndexes(fileBaseCell,spectAnalDir,...
        ['unitPowSpec_tapers' num2str(ntapers) '.rate'],...
        keptIndexes,trialDesig),[],1);
    
    for k=1:size(tempCCG,1)
         % normalize by firing rate
         tempCCG{k,end} = tempCCG{k,end} ./ repmat(tempRate{k,end},[1,1,1,size(tempCCG{k,end},4)]);
%        tempCCG{k,end} = tempCCG{k,end} ./ repmat(tempRate{k,end},[1,1,1,size(tempCCG{k,end},4)])...
%            ./ repmat(tempRate{k,end},[1,1,1,size(tempCCG{k,end},4)]);
    end
    for k=1:size(tempCCG,1)
        cellLayers = LoadCellLayers([fileBaseCell{1} '/' fileBaseCell{1} '.cellLayer']);
        cellTypes = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
        % sort cells by layer/type
        if isempty(acgs)
            rates = tempRate;
            acgs = tempCCG;
        end
        if ~isstruct(acgs{k,end})
            rates{k,end} = struct([]);
            acgs{k,end} = struct([]);
        end
        rates{k,end} = UnionStructMatCat(1,rates{k,end},SortRates2LayerTypes(squeeze(tempRate{k,end}),cellLayers,cellTypes));
        acgs{k,end} = UnionStructMatCat(1,acgs{k,end},SortUnitSpec2LayerTypes(squeeze(tempCCG{k,end}),cellLayers,cellTypes));
    end
    size(tempCCG{1,end})
end
fo = LoadField([fileBaseCell{1} '/' spectAnalDir '/' 'unitPowSpec_tapers' num2str(ntapers) '.fo']);
cd(cwd)

cellLayers = selChan(:,1);
cellTypes = {'w' 'n' 'x'};

% cellLayers = {'ca1Pyr';'gran';'ca3Pyr'};
% cellTypes = {'w' 'n'}


colNamesCell{1} = {''};
colNamesCell{2} = {''};
colNamesCell{3} = cellLayers;
colNamesCell{4} = cellTypes;
colNamesCell{5} = acgs(:,1);
dataCell = CellArray2Struct(acgs);
dataCell = Struct2CellArray(dataCell,[],1);
dataCell = cat(2,repmat({''},size(dataCell(:,[1 2]))),...
    dataCell(:,[2 3]),dataCell(:,[1 4]));
rateCell = CellArray2Struct(rates);
rateCell = Struct2CellArray(rateCell,[],1);
rateCell = cat(2,repmat({''},size(rateCell(:,[1 2]))),rateCell(:,[2 3]),...
    rateCell(:,[1 4]));
%%%%%%%%%% plot spectrum %%%%%%%%%%%%%%%%%%%%%%%

infoText = {['Unit Spectrum ' ];...
    [' trialMinRate=' num2str(trialRateMin)...
    ' cellMinRate=' num2str(cellRateMin)]};
figName =  ['UnitSpect_tMin' num2str(trialRateMin) '_cMin'...
    num2str(cellRateMin) '_' ...
    'tapers' num2str(ntapers)]
outDir = [saveDir SC(analRoutine) SC('UnitSpect')];

% keyboard

tempDataCell = UnitCellRateThreshHelper(dataCell,cellRateMin,rateCell,1);

tempDataCell = UnitCellRateThreshHelper(dataCell,cellRateMin,rateCell,0);
tempDataCell = UnitExpSmoothHelper(tempDataCell,ones(1,3)/3,5);
% UnitSpectrumPlotHelper(tempDataCell,fo,[0 freqLim],infoText,figName,colNamesCell,reportFigBool,outDir)
UnitSpectrumPlotHelper(tempDataCell,fo,[0 freqLim],[0.5 3],infoText,figName,colNamesCell,reportFigBool,outDir,[],[],[],1)


wInBool = 1;
btwBool = 0;
%%%%%%%%%%%%%%%%% freqRange
for j=1:length(freqRangeCell)
    

    freqRange = freqRangeCell{j};
        dataCell2 = dataCell;
        rateCell2 = rateCell;

%     infoText = {['Unit Spectrum ' num2str(freqRange{1}(1)) '-' num2str(freqRange{1}(2)) 'Hz' ];...
%         [' trialMinRate=' num2str(trialRateMin)...
%         ' cellMinRate=' num2str(cellRateMin)]};
    infoText = {[['Unit Spectrum ' num2str(freqRange{1}(1)) '-' num2str(freqRange{1}(2)) 'Hz' ],...
        [' trialMinRate=' num2str(trialRateMin)...
        ' cellMinRate=' num2str(cellRateMin)]]};
    figName =  ['UnitSpect_' num2str(freqRange{1}(1)) '-' num2str(freqRange{1}(2)) 'Hz'...
        '_tMin' num2str(trialRateMin) '_cMin'...
        num2str(cellRateMin) '_' ...
        'tapers' num2str(ntapers)];
    outDir = [saveDir SC(analRoutine) SC('UnitSpect')];

    
        %%%%%%%%%%%%%%%%%% bar fig printing %%%%%%%%%%%%%%%%
        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);

bonfFactor = 1;

UnitBarPlotHelper(tempDataCell,[],0,infoText,figName,colNamesCell,reportFigBool,outDir,0.05,bonfFactor,2,1.1)

if reportFigBool
    close all
end
end

return


