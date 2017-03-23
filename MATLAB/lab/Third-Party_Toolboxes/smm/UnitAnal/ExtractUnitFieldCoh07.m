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
   
    [tempCCG keptIndexes] = MeanDesigUnitThresh(fileBaseCell,spectAnalDir,...
        ['unitFieldCoh_' cohName '_tapers' num2str(ntapers) '.yo'],...
        ['unitRate'],trialRateMin,trialDesig);
    tempCCG = Struct2CellArray(tempCCG,[],1);
         
    tempRate = Struct2CellArray(MeanDesigUnitIndexes(fileBaseCell,spectAnalDir,...
        ['unitRate'],keptIndexes,trialDesig),[],1);

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
cellTypes = {'w' 'n'};


colNamesCell{1} = {''};
colNamesCell{2} = {'w','n'};
colNamesCell{3} = cellLayers;
colNamesCell{4} = cellLayers;
colNamesCell{5} = ccgs(:,1);

dataCell = CellArray2Struct(ccgs);
dataCell = Struct2CellArray(dataCell,[],1);
dataCell = cat(2,repmat({''},size(dataCell(:,1))),dataCell(:,[3 4 2]),...
    dataCell(:,[1 5]));

rateCell = CellArray2Struct(rates);
rateCell = Struct2CellArray(rateCell,[],1);
rateCell = cat(2,repmat({''},size(rateCell(:,[1]))),rateCell(:,[3]),...
    repmat({''},size(rateCell(:,[1]))),...
    rateCell(:,[2]),...
    rateCell(:,[1 4]));

%%%%%%%%%%%%%%%%% unit Field coh mean %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wInBool = 1;
btwBool = 0;
%%%%%%%%%%%%%%%%% freqRange
for j=1:length(freqRangeCell)
    freqRange = freqRangeCell{j};


        infoText = GenFieldName({['Unit Field Coh' ],...
            ['f' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'], fileExt})
        figName =  ['unitFieldCoh_wIn_' num2str(freqRange(1))...
            '-' num2str(freqRange(2)) 'Hz'...
            '_tMin' num2str(trialRateMin) '_cMin'...
            num2str(cellRateMin) '_' cohName '_'...
            'tapers' num2str(ntapers) fileExt];
        
        outDir = [saveDir SC(analRoutine)];

        tempDataCell = UnitCellRateThreshHelper(dataCell,cellRateMin,rateCell,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        tempDataCell = UnitZScoreHelper(tempDataCell,1);
        
        tempDataCell = UnitTrimDataCellHelper(tempDataCell,colNamesCell);
        tempDataCell(:,strcmp(tempDataCell(1,:),'')) = [];
        tempDataCell = tempDataCell(:,~strcmp(tempDataCell(1,:),''));
        saveDataCell = cat(2,repmat(infoText,[size(tempDataCell,1),1]),tempDataCell);
        mkdir(outDir)
        save([outDir figName '.mat'],SaveAsV6,'saveDataCell');

        
end


return
