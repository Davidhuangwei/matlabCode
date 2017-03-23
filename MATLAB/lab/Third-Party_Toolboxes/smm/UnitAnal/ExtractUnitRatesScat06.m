% function PlotUnitRateScats04(analDirs,spectAnalDir,statsAnalFunc,...
%     analRoutine,varargin)
% [saveDir,screenHeight, xyFactor] = DefaultArgs(varargin,...
%     {'/u12/smm/public_html/NewFigs/REMPaper/UnitAnal05/',10.5,1.1});
function PlotUnitRateScats04(analDirs,spectAnalDir,statsAnalFunc,...
    analRoutine,varargin)
[reportFigBool,saveDir,screenHeight, xyFactor] = DefaultArgs(varargin,...
    {1,'/u12/smm/public_html/NewFigs/REMPaper/UnitAnal06/',10.5,1.1});

prevWarnSettings = SetWarnings({'off','LoadDesigVar:fileNotFound';...
   'off', 'MATLAB:divideByZero'});

cwd = pwd;

rates = [];
for j=1:length(analDirs)
    cd(analDirs{j})
    selChan = Struct2CellArray(LoadVar('ChanInfo/SelChan.eeg.mat'),[],1);
    load(['TrialDesig/' statsAnalFunc '/' analRoutine '.mat'])
    cellLayers = LoadCellLayers([fileBaseCell{1} '/' fileBaseCell{1} '.cellLayer']);
    cellTypes = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
    
    tempRate = Struct2CellArray(MeanDesigVar(1,fileBaseCell,spectAnalDir,...
        ['unitRate'],trialDesig),[],1);
    for k=1:size(tempRate,1)
        if isempty(rates)
            rates = tempRate;
        end
        if ~isstruct(rates{k,end})
            rates{k,end} = struct([]);
        end
        % sort cells by layer/type
        rates{k,end} = UnionStructMatCat(1,rates{k,end},SortRates2LayerTypes(squeeze(tempRate{k,end}),cellLayers,cellTypes));
    end
    size(tempRate{1,2})
end
cd(cwd)

% 2 axis scatter plot
cellLayers = selChan(:,1);
cellTypes = {'w' 'n'}
if reportFigBool
    close all
end

% keyboard

colNamesCell{1} = {''};
colNamesCell{2} = {''};
colNamesCell{3} = cellLayers;
colNamesCell{4} = cellTypes;
colNamesCell{5} = rates(:,1);

rateCell = CellArray2Struct(rates);
rateCell = Struct2CellArray(rateCell,[],1);
rateCell = cat(2,repmat({''},size(rateCell(:,[1 2]))),rateCell(:,[2 3]),...
    rateCell(:,[1 4]));

figName = 'UnitRates_wIn';
infoText = {'UnitRates'};
outDir = [saveDir SC(analRoutine)];

tempDataCell = UnitCellRateThreshHelper(rateCell,0.000001,rateCell,1);
tempDataCell = UnitLog10Helper(tempDataCell);
tempDataCell = UnitWInCellHelper(tempDataCell);
        tempDataCell = UnitZScoreHelper(tempDataCell,1);
% tempDataCell = UnitMedianHelper(tempDataCell,1);

        tempDataCell = UnitTrimDataCellHelper(tempDataCell,colNamesCell);
        tempDataCell(:,strcmp(tempDataCell(1,:),'')) = [];
        tempDataCell = tempDataCell(:,~strcmp(tempDataCell(1,:),''));
        saveDataCell = cat(2,repmat(infoText,[size(tempDataCell,1),1]),tempDataCell);
        mkdir(outDir)
        save([outDir figName '.mat'],SaveAsV6,'saveDataCell');


        
return


