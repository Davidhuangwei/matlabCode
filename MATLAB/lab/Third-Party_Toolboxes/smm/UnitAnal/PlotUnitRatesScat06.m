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
cellTypes = {'w' 'n' 'x'}
if reportFigBool
    close all
end

% keyboard
cellLayers = {'ca1Pyr';'gran';'ca3Pyr'};
cellTypes = {'w' 'n'}

colNamesCell{1} = {''};
colNamesCell{2} = {''};
colNamesCell{3} = cellLayers;
colNamesCell{4} = cellTypes;
colNamesCell{5} = rates(:,1);

rateCell = CellArray2Struct(rates);
rateCell = Struct2CellArray(rateCell,[],1);
rateCell = cat(2,repmat({''},size(rateCell(:,[1 2]))),rateCell(:,[2 3]),...
    rateCell(:,[1 4]));

figName = 'UnitRates';
infoText = {'UnitRates'};
outDir = [saveDir SC(analRoutine)];

        %%% w/in %%%    
        cMap = LoadVar('ColorMapSean6');
        tempDataCell = UnitWInCellHelper(rateCell);
        tempDataCell = UnitMedianHelper(tempDataCell,1);
        UnitColorPlotHelper(tempDataCell,[],1,1,cMap,cat(1,'w/in medians',infoText),figName,colNamesCell,reportFigBool,outDir)

        cMap = flipud(LoadVar('ColorMapSean6'));
        tempDataCell = UnitWInCellHelper(rateCell);
        tempDataCell = UnitSignRankHelper(tempDataCell);
        tempDataCell = UnitLog10Helper(tempDataCell);
        UnitColorPlotHelper(tempDataCell,[-3 0],1,0,cMap,cat(1,'w/in ranksign p-values',infoText),figName,colNamesCell,reportFigBool,outDir)

        tempDataCell = UnitWInCellHelper(rateCell);
        UnitKWPlotHelper(tempDataCell,[-3 0],1,0,cMap,cat(1,'w/in KW p-values',infoText),figName,colNamesCell,reportFigBool,outDir)
% keyboard
        tempDataCell = UnitCellRateThreshHelper(rateCell,0.000001,rateCell,1);
        tempDataCell = UnitLog10Helper(tempDataCell);
tempDataCell = UnitPairwiseWInCellHelper(tempDataCell)
colNamesCell{5} = unique(tempDataCell(:,5));
tempDataCell = tempDataCell(:,[1,2,5,4,3,6]);
tempColNamesCell = colNamesCell([1,2,5,4,3]);
% UnitBoxPlotHelper(tempDataCell,{'UnitRate'; ' w/in Cell'},figName,tempColNamesCell,reportFigBool,outDir)
UnitBarPlotHelper(tempDataCell,{'UnitRate'; ' w/in Cell'},figName,tempColNamesCell,reportFigBool,outDir)

%         tempRateCell = UnitWInCellHelper(rateCell);
%         UnitBoxPlotHelper(tempRateCell,{'UnitRate'; ' w/in Cell'},figName,colNamesCell,reportFigBool,outDir)


        %%% Log10 w/in %%%
        cMap = LoadVar('ColorMapSean6');
        tempDataCell = UnitCellRateThreshHelper(rateCell,0.000001,rateCell,1);
        tempDataCell = UnitLog10Helper(tempDataCell);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        tempDataCell = UnitMedianHelper(tempDataCell,1);
        UnitColorPlotHelper(tempDataCell,[],1,1,cMap,cat(1,'Log10 w/in medians',infoText),figName,colNamesCell,reportFigBool,outDir)

        cMap = flipud(LoadVar('ColorMapSean6'));
        tempDataCell = UnitCellRateThreshHelper(rateCell,0.000001,rateCell,1);
        tempDataCell = UnitLog10Helper(tempDataCell);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        tempDataCell = UnitSignRankHelper(tempDataCell);
        tempDataCell = UnitLog10Helper(tempDataCell);
        UnitColorPlotHelper(tempDataCell,[-3 0],1,0,cMap,cat(1,'Log10 w/in ranksign p-values',infoText),figName,colNamesCell,reportFigBool,outDir)

        tempDataCell = UnitCellRateThreshHelper(rateCell,0.000001,rateCell,1);
        tempDataCell = UnitLog10Helper(tempDataCell);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        UnitKWPlotHelper(tempDataCell,[-3 0],1,0,cMap,cat(1,'Log10 w/in KW p-values',infoText),figName,colNamesCell,reportFigBool,outDir)

        tempDataCell = UnitCellRateThreshHelper(rateCell,0.000001,rateCell,1);
        tempRateCell = UnitLog10Helper(tempDataCell);
        tempRateCell = UnitWInCellHelper(tempRateCell);
        UnitBoxPlotHelper(tempRateCell,{'UnitRate log10'; ' w/in Cell'},figName,colNamesCell,reportFigBool,outDir)
        
        
        %%% btw %%%
        cMap = LoadVar('ColorMapSean6');
        tempDataCell = UnitMedianHelper(rateCell,1);
        UnitColorPlotHelper(tempDataCell,[],1,0,cMap,cat(1,'btw medians',infoText),figName,colNamesCell,reportFigBool,outDir)

        cMap = flipud(LoadVar('ColorMapSean6'));
        UnitKWPlotHelper(rateCell,[-3 0],1,0,cMap,cat(1,'btw KW p-values',infoText),figName,colNamesCell,reportFigBool,outDir)

        UnitBoxPlotHelper(rateCell,{'UnitRate'; 'btw'},figName,colNamesCell,reportFigBool,outDir)


        %%% Log10 btw %%%
        cMap = LoadVar('ColorMapSean6');
        tempDataCell = UnitCellRateThreshHelper(rateCell,0.000001,rateCell,0);
        tempDataCell = UnitLog10Helper(tempDataCell);
        tempDataCell = UnitMedianHelper(tempDataCell,1);
        UnitColorPlotHelper(tempDataCell,[],1,0,cMap,cat(1,'Log10 btw medians',infoText),figName,colNamesCell,reportFigBool,outDir)

        cMap = flipud(LoadVar('ColorMapSean6'));
        tempDataCell = UnitCellRateThreshHelper(rateCell,0.000001,rateCell,0);
        tempDataCell = UnitLog10Helper(tempDataCell);
        UnitKWPlotHelper(tempDataCell,[-3 0],1,0,cMap,cat(1,'Log10 btw KW p-values',infoText),figName,colNamesCell,reportFigBool,outDir)
         
        tempDataCell = UnitCellRateThreshHelper(rateCell,0.000001,rateCell,0);
        tempRateCell = UnitLog10Helper(tempDataCell);
        UnitBoxPlotHelper(tempRateCell,{'UnitRate'; 'Log10 btw'},figName,colNamesCell,reportFigBool,outDir)

if reportFigBool
    close all
end
return


