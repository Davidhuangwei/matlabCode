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
%         if ~isnan(tempRate{k,end})
%             try
        rates{k,end} = UnionStructMatCat(1,rates{k,end},SortRates2LayerTypes(squeeze(tempRate{k,end}),cellLayers,cellTypes));
%             catch
%                 keyboard
%             end
%         end
    end
    tempRate
    size(tempRate{1,2})
end
cd(cwd)

% keyboard


% 2 axis scatter plot
cellLayers = selChan(:,1);
cellTypes = {'w' 'n' 'x'}
if reportFigBool
    close all
end
cellLayers = selChan(:,1)
% cellLayers = {'ca1Pyr';'gran';'ca3Pyr'};
% cellTypes = {'w' 'n'}

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





        %%%%%%%%%%%%%%%%%% btw mean w/in err bars printing %%%%%%%%%%%%%%%%
%  colNamesCell{5} = colNamesCell{5}([2,3,1])

tempDataCell = rateCell;
tempDataCell = UnitWInCellHelper(tempDataCell);
errBarsCell = UnitBsErrBarsHelper(tempDataCell,@median,95,1000,@median,1,varargin);
tempDataCell = rateCell; % reload btw mean mean

bonfFactor = 1;

UnitBarPlotHelper(tempDataCell,[],0,infoText,figName,colNamesCell,reportFigBool,outDir,0.05,bonfFactor,2,1.1,errBarsCell)

tempDataCell = UnitWInCellHelper(tempDataCell);
UnitBarPlotHelper(tempDataCell,[],0,infoText,figName,colNamesCell,reportFigBool,outDir,0.05,bonfFactor,2,1.1,errBarsCell)


if reportFigBool
    close all
end
return




         %%%%%%%%%%%%%%%%%% win kw stats %%%%%%%%%%%%%%%%
        tempDataCell = rateCell;
        tempDataCell = UnitWInCellHelper(tempDataCell);
%         goodInd = ...
%     strcmp(tempDataCell(:,3),'ca1Pyr') & strcmp(tempDataCell(:,4),'w') | ...
%      strcmp(tempDataCell(:,3),'gran') & strcmp(tempDataCell(:,4),'n') | ...
%      strcmp(tempDataCell(:,3),'ca3Pyr') & strcmp(tempDataCell(:,4),'w');
% tempDataCell = tempDataCell(goodInd,:);
% tempDataCell(:,4) = {'w'};

bonfFactor = 1;
[pValCell anovaTabCell statsCell]= UnitKWHelper(tempDataCell,bonfFactor);
multcompare(statsCell{1,6})


        
 tempDataCell = UnitPairwiseWInCellHelper(rateCell,'minus');
        tempDataCell = UnitCellRateThreshHelper(rateCell,0.000001,rateCell,1);
        tempDataCell = UnitLog10Helper(tempDataCell);
tempDataCell = UnitPairwiseWInCellHelper(tempDataCell,'minus');

goodInd = ...
    strcmp(tempDataCell(:,3),'ca1Pyr') & strcmp(tempDataCell(:,4),'w') | ...
     strcmp(tempDataCell(:,3),'gran') & strcmp(tempDataCell(:,4),'n') | ...
     strcmp(tempDataCell(:,3),'ca3Pyr') & strcmp(tempDataCell(:,4),'w');
tempDataCell = tempDataCell(goodInd,:);
tempDataCell(:,4) = {'w'};

colNamesCell{5} = unique(tempDataCell(:,5));
tempDataCell = tempDataCell(:,[1,2,5,4,3,6]);
tempColNamesCell = colNamesCell([1,2,5,4,3]);
bonfFactor = 1/2;
UnitBarPlotHelper(tempDataCell,[-0.8 0.8],{'UnitRate'; ' w/in Cell'},figName,tempColNamesCell,reportFigBool,outDir,0.05,bonfFactor,2,1.1)
UnitBarPlotHelper(tempDataCell,[-20 20 ],{'UnitRate'; ' w/in Cell'},figName,tempColNamesCell,reportFigBool,outDir,0.05,bonfFactor,2,1.1)

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
        UnitBoxPlotHelper(tempRateCell,{'UnitRate'; ' btw'},figName,colNamesCell,reportFigBool,outDir)

if reportFigBool
    close all
end
return


