% function PlotUnitCCG03(analDirs,spectAnalDir,statsAnalFunc,...
%     analRoutine,normalization,binSize,timeLim,biasCorrBool,rateMin,varargin)
% saveDir = DefaultArgs(varargin,{'/u12/smm/public_html/REMPaper/UnitAnal05/'});
function PlotUnitISIDist01(analDirs,spectAnalDir,statsAnalFunc,...
    analRoutine,binSize,timeLim,rateMin,varargin)
[timeRangeCell reportFigBool saveDir] = ...
    DefaultArgs(varargin,{{[0 6]},...
    1,'/u12/smm/public_html/NewFigs/REMPaper/UnitAnal05/'});
prevWarnSettings = SetWarnings({'off','LoadDesigVar:fileNotFound';...
   'off', 'MATLAB:divideByZero'});

cwd = pwd;

rates = [];
acgs = [];
for j=1:length(analDirs)
    cd(analDirs{j})
    selChan = Struct2CellArray(LoadVar('ChanInfo/SelChan.eeg.mat'),[],1);
    load(['TrialDesig/' statsAnalFunc '/' analRoutine '.mat'])
    tempRate = Struct2CellArray(MeanDesigVar(1,fileBaseCell,spectAnalDir,...
        ['unitRate'],trialDesig),[],1);

        tempCCG = Struct2CellArray(SumDesigVar(1,fileBaseCell,spectAnalDir,...
            ['unitISIDistBin' num2str(binSize) '.yo'],trialDesig),[],1);
        %%%%%%%%% Nomalize using "scale" method (see CCG.m) %%%%%%%%%%%%%%%%%%%%%%%%%
        for k=1:size(tempCCG,1)
            for m=1:size(tempCCG{k,end},2)
                tempCCG{k,end}(1,m,:) = tempCCG{k,end}(1,m,:) / sum(tempCCG{k,end}(1,m,:),3);
            end
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
keyboard
    to = LoadField([fileBaseCell{1} '/' spectAnalDir '/' 'unitISIDistBin' num2str(binSize) '.to']);
cd(cwd)
cellLayers = selChan(:,1);
cellTypes = {'w' 'n' 'x'};

cellLayers = {'ca1Pyr';'gran';'ca3Pyr'};
cellTypes = {'w' 'n'}


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
%%%%%%%%%% plot average ISI dist %%%%%%%%


infoText = {['Unit Firing ACG'];...
    [ ' bin=' num2str(binSize)  ' minRate=' num2str(rateMin)]};
figName = ['UnitACG_' ...
    '_bin' num2str(binSize)];
    outDir = [saveDir SC(analRoutine) 'ACG/'];
    
    tempDataCell = UnitCellRateThreshHelper(dataCell,rateMin,rateCell,1);
%    tempDataCell = UnitCellRateThreshHelper(dataCell,rateMin,rateCell,0);

UnitACGPlotHelper(tempDataCell,to,[0 timeLim],infoText,figName,colNamesCell,reportFigBool,outDir,[],[],[],0)

if reportFigBool
    close all
end


wInBool = 1;
btwBool = 0;
%%%%%%%%%%%%%%%%% freqRange
for j=1:length(timeRangeCell)
    timeRange = timeRangeCell{j};
        dataCell2 = dataCell;
        rateCell2 = rateCell;

    infoText = {['Unit Spectrum ' num2str(timeRange{1}(1)) '-' num2str(timeRange{1}(2)) 'Hz' ];...
        [' minRate=' num2str(rateMin)...
        ]};
    figName =  ['UnitSpect_' num2str(timeRange{1}(1)) '-' num2str(timeRange{1}(2)) 'Hz'...
        '_rMin' num2str(rateMin) ];
    outDir = [saveDir SC(analRoutine) SC('UnitSpect')];

    
%         infoText = {['Unit Field Coh' fileExt];...
%             [' tapers=' num2str(ntapers) ', ' num2str(timeRange{1}(1)) '-' num2str(timeRange{1}(2)) 'Hz'];...
%             [' trialMinRate=' num2str(trialRateMin)...
%             ' cellMinRate=' num2str(cellRateMin)]};
%         figName =  ['unitFieldCoh_' colNamesCell{2}{k} '_' num2str(timeRange{1}(1))...
%             '-' num2str(timeRange{1}(2)) 'Hz'...
%             '_tMin' num2str(trialRateMin) '_cMin'...
%             num2str(cellRateMin) '_' cohName '_'...
%             'tapers' num2str(ntapers)];
%         outDir = [saveDir SC(analRoutine) SC('UnitFieldCoh') SC(Dot2Underscore(fileExt))];
        cMap = LoadVar('ColorMapSean6');
        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,timeRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        tempDataCell = UnitMedianHelper(tempDataCell,1);
        UnitColorPlotHelper(tempDataCell,[],1,1,cMap,cat(1,'w/in medians',infoText),figName,colNamesCell,reportFigBool,outDir)

        cMap = flipud(LoadVar('ColorMapSean6'));
        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,timeRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        tempDataCell = UnitSignRankHelper(tempDataCell);
        tempDataCell = UnitLog10Helper(tempDataCell);
        UnitColorPlotHelper(tempDataCell,[-3 0],1,0,cMap,cat(1,'w/in ranksign p-values',infoText),figName,colNamesCell,reportFigBool,outDir)

        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,timeRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        UnitKWPlotHelper(tempDataCell,[-3 0],1,0,cMap,cat(1,'w/in KW p-values',infoText),figName,colNamesCell,reportFigBool,outDir)

         tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,timeRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        UnitBoxPlotHelper(tempDataCell,cat(1,'w/in medians',infoText),figName,colNamesCell,reportFigBool,outDir)

       cMap = LoadVar('ColorMapSean6');
        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,btwBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,timeRange);
        tempDataCell = UnitMedianHelper(tempDataCell,1);
        UnitColorPlotHelper(tempDataCell,[],1,0,cMap,cat(1,'btw medians',infoText),figName,colNamesCell,reportFigBool,outDir)

        cMap = flipud(LoadVar('ColorMapSean6'));
        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,btwBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,timeRange);
        UnitKWPlotHelper(tempDataCell,[-3 0],1,0,cMap,cat(1,'btw KW p-values',infoText),figName,colNamesCell,reportFigBool,outDir)
         
        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,btwBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,timeRange);
        UnitBoxPlotHelper(tempDataCell,cat(1,'btw medians',infoText),figName,colNamesCell,reportFigBool,outDir)
        %%%%%%%%%%%%%%%%%% bar fig printing %%%%%%%%%%%%%%%%
        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
% tempDataCell = UnitPairwiseWInCellHelper(tempDataCell,'minus');
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
bonfFactor = 1;
% tempDataCell = UnitMedianHelper(tempDataCell,1);
% tempMedErr = UnitBsErrBarsHelper(tempDataCell,@median,95,1000,@median,1,1)
% tempPvals = UnitSignRankHelper(tempDataCell)
UnitBarPlotHelper(tempDataCell,[-0.5 .5],infoText,figName,tempColNamesCell,reportFigBool,outDir,0.05,bonfFactor,2,1.1)
UnitBarPlotHelper(tempDataCell,[-0.25 .25],infoText,figName,tempColNamesCell,reportFigBool,outDir,0.05,bonfFactor,2,1.1)
        
        %%%%%%%%%%%%%%%%%% line fig printing %%%%%%%%%%%%%%%%
        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
% tempDataCell = UnitPairwiseWInCellHelper(tempDataCell,'minus');
goodInd = ...
    strcmp(tempDataCell(:,3),'ca1Pyr') & strcmp(tempDataCell(:,4),'w') | ...
     strcmp(tempDataCell(:,3),'gran') & strcmp(tempDataCell(:,4),'n') | ...
     strcmp(tempDataCell(:,3),'ca3Pyr') & strcmp(tempDataCell(:,4),'w');
tempDataCell = tempDataCell(goodInd,:);
tempDataCell(:,4) = {'w'};
bonfFactor = 1;
% tempDataCell = UnitMedianHelper(tempDataCell,1);
% tempMedErr = UnitBsErrBarsHelper(tempDataCell,@median,95,1000,@median,1,1)
% tempPvals = UnitSignRankHelper(tempDataCell)
UnitLineShapePlotHelper(tempDataCell,[-0.3 .3],infoText,figName,colNamesCell,reportFigBool,outDir,0.05,bonfFactor,2,1.1)
UnitLineShapePlotHelper(tempDataCell,[-0.15 .15],infoText,figName,colNamesCell,reportFigBool,outDir,0.05,bonfFactor,2,1.1)


        %%%%%%%%%%%%%%%%%% w/in spectrum fig printing %%%%%%%%%%%%%%%%
        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,wInBool);
%         tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
% tempDataCell = UnitPairwiseWInCellHelper(tempDataCell,'minus');
goodInd = ...
    strcmp(tempDataCell(:,3),'ca1Pyr') & strcmp(tempDataCell(:,4),'w') | ...
     strcmp(tempDataCell(:,3),'gran') & strcmp(tempDataCell(:,4),'n') | ...
     strcmp(tempDataCell(:,3),'ca3Pyr') & strcmp(tempDataCell(:,4),'w');
tempDataCell = tempDataCell(goodInd,:);
tempDataCell(:,4) = {'w'};
bonfFactor = 1;
UnitSpectrumPlotHelper(tempDataCell,fo,[0 freqLim],infoText,figName,colNamesCell,reportFigBool,outDir)

UnitLineShapePlotHelper(tempDataCell,[-0.3 .3],infoText,figName,colNamesCell,reportFigBool,outDir,0.05,bonfFactor,2,1.1)
UnitLineShapePlotHelper(tempDataCell,[-0.15 .15],infoText,figName,colNamesCell,reportFigBool,outDir,0.05,bonfFactor,2,1.1)

        %%%%%%%%%%%%%%%%%% kw test + multcompare spectrum fig printing %%%%%%%%%%%%%%%%

        
        tempDataCell = UnitCellRateThreshHelper(dataCell2,rateMin,rateCell2,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,timeRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        
goodInd = ...
    strcmp(tempDataCell(:,3),'ca1Pyr') & strcmp(tempDataCell(:,4),'w') | ...
     strcmp(tempDataCell(:,3),'gran') & strcmp(tempDataCell(:,4),'n') | ...
     strcmp(tempDataCell(:,3),'ca3Pyr') & strcmp(tempDataCell(:,4),'w');
tempDataCell = tempDataCell(goodInd,:);
tempDataCell(:,4) = {'w'};
bonfFactor = 1;
[pValCell anovaTabCell statsCell]= UnitKWHelper(tempDataCell,bonfFactor);
multcompare(statsCell{1,6})

pValCell = UnitSignRankHelper(tempDataCell,bonfFactor)

end

if reportFigBool
    close all
end


return

