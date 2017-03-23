function PlotUnitFieldCoh07(analDirs,fileExt,spectAnalDir,statsAnalFunc,...
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


% keyboard
cellLayers = selChanCell(:,1);
cellTypes = {'w' 'n' 'x'};


% cellLayers = {'ca1Pyr';'gran';'ca3Pyr'};
% cellTypes = {'w' 'n'}

colNamesCell{1} = {''};
colNamesCell{2} = {'w','n'};
colNamesCell{3} = cellLayers;
colNamesCell{4} = selChanCell(:,1);
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

% keyboard


%%%%%%%%%%%%%%%%% unit Field coh mean %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% colNamesCell{1} = {''};
% colNamesCell{2} = {'n'};
% colNamesCell{3} = cellLayers(2);
% colNamesCell{4} = selChanCell([3,6,7],1);
% colNamesCell{5} = ccgs(:,1);
% 
% dataCell = CellArray2Struct(ccgs);
% dataCell = Struct2CellArray(dataCell,[],1);
% dataCell = cat(2,repmat({''},size(dataCell(:,1))),dataCell(:,[3 2 4]),...
%     dataCell(:,[1 5]));
% 
% rateCell = CellArray2Struct(rates);
% rateCell = Struct2CellArray(rateCell,[],1);
% rateCell = cat(2,repmat({''},size(rateCell(:,[1]))),...
%     rateCell(:,[3]),...
%     rateCell(:,[2]),...
%     repmat({''},size(rateCell(:,[1]))),...
%     rateCell(:,[1 4]));


infoText = {['Unit Field Coh ' fileExt];...
    [' tapers=' num2str(ntapers)];...
    [' trialMinRate=' num2str(trialRateMin)...
    ' cellMinRate=' num2str(cellRateMin)]};
figName =  ['unitFieldCoh_spec' ...
    '_tMin' num2str(trialRateMin) '_cMin'...
    num2str(cellRateMin) '_' cohName '_'...
    'tapers' num2str(ntapers)];
outDir = [saveDir SC(analRoutine) SC('UnitFieldCoh') SC(Dot2Underscore(fileExt))];

tempDataCell = UnitCellRateThreshHelper(dataCell,cellRateMin,rateCell,0);
tempDataCell = UnitExpSmoothHelper(tempDataCell,ones(1,3)/3,5);

% UnitSpectrumPlotHelper(tempDataCell,fo,[0 freqLim],infoText,figName,...
%     colNamesCell,reportFigBool,outDir,[],screenHeight,xyFactor)
UnitSpectrumPlotHelper(tempDataCell,fo,[0 freqLim],[0.4 0.9], infoText,figName,...
    colNamesCell,reportFigBool,outDir,[],screenHeight,xyFactor,1)


if reportFigBool
    close all
end

% keyboard

wInBool = 1;
btwBool = 0;
%%%%%%%%%%%%%%%%% freqRange
for j=1:length(freqRangeCell)
    for k=1:length(colNamesCell{2})
    j=1
    k=1
wInBool = 1;
btwBool = 0;

dataCell2 = dataCell;
rateCell2 = rateCell;

     freqRange = freqRangeCell{j};
%         dataCell2 = dataCell(...
%             (strcmp(dataCell(:,2),'w')...
%             & strcmp(dataCell(:,4),'ca1Pyr'))...
%             | (strcmp(dataCell(:,2),'w')...
%             & strcmp(dataCell(:,4),'ca3Pyr'))...
%             | (strcmp(dataCell(:,2),'n')...
%             & strcmp(dataCell(:,4),'gran'))...
%             ,:);
%         rateCell2 = rateCell(...
%             (strcmp(rateCell(:,2),'w')...
%             & strcmp(rateCell(:,4),'ca1Pyr'))...
%             | (strcmp(rateCell(:,2),'w')...
%             & strcmp(rateCell(:,4),'ca3Pyr'))...
%             | (strcmp(rateCell(:,2),'n')...
%             & strcmp(rateCell(:,4),'gran'))...
%             ,:);
%         dataCell2(:,2) = repmat({'w'},size(dataCell2(:,2)));
%         rateCell2(:,2) = repmat({'w'},size(rateCell2(:,2)));


        infoText = {['Unit Field Coh' fileExt];...
            [' tapers=' num2str(ntapers) ', ' num2str(freqRange{1}(1)) '-' num2str(freqRange{1}(2)) 'Hz'];...
            [' trialMinRate=' num2str(trialRateMin)...
            ' cellMinRate=' num2str(cellRateMin)]};
        figName =  ['unitFieldCoh_' colNamesCell{2}{k} '_' num2str(freqRange{1}(1))...
            '-' num2str(freqRange{1}(2)) 'Hz'...
            '_tMin' num2str(trialRateMin) '_cMin'...
            num2str(cellRateMin) '_' cohName '_'...
            'tapers' num2str(ntapers)];
        outDir = [saveDir SC(analRoutine) SC('UnitFieldCoh') SC(Dot2Underscore(fileExt))];
        cMap = LoadVar('ColorMapSean6');
        
        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
%         tempDataCell = UnitWInCellHelper(tempDataCell);
        tempDataCell = UnitMedianHelper(tempDataCell,1);
%         UnitColorPlotHelper(tempDataCell,[],1,1,cMap,cat(1,'w/in medians',infoText),figName,colNamesCell,reportFigBool,outDir)
%         UnitColorPlotHelper(tempDataCell,[0.55 0.75],1,1,cMap,cat(1,'btw medians',infoText),figName,colNamesCell,reportFigBool,outDir)
        UnitColorPlotHelper(tempDataCell,[0 1],1,1,cMap,cat(1,'btw medians',infoText),figName,colNamesCell,reportFigBool,outDir)
       
        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        tempDataCell = UnitMedianHelper(tempDataCell,1);
%         UnitColorPlotHelper(tempDataCell,[],1,1,cMap,cat(1,'w/in medians',infoText),figName,colNamesCell,reportFigBool,outDir)
        UnitColorPlotHelper(tempDataCell,[-0.1 0.1],1,1,cMap,cat(1,'w/in medians',infoText),figName,colNamesCell,reportFigBool,outDir)

        cMap = flipud(LoadVar('ColorMapSean6'));
        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        tempDataCell = UnitSignRankHelper(tempDataCell);
        tempDataCell = UnitLog10Helper(tempDataCell);
        UnitColorPlotHelper(tempDataCell,[-2 0],1,0,cMap,cat(1,'w/in ranksign p-values',infoText),figName,colNamesCell,reportFigBool,outDir)

        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        UnitKWPlotHelper(tempDataCell,[-3 0],1,0,cMap,cat(1,'w/in KW p-values',infoText),figName,colNamesCell,reportFigBool,outDir)

        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
        tempDataCell = UnitWInCellHelper(tempDataCell);
        UnitBoxPlotHelper(tempDataCell,cat(1,'w/in medians',infoText),figName,colNamesCell,reportFigBool,outDir)

        cMap = LoadVar('ColorMapSean6');
        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,btwBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
        tempDataCell = UnitMedianHelper(tempDataCell,1);
        UnitColorPlotHelper(tempDataCell,[],1,0,cMap,cat(1,'btw medians',infoText),figName,colNamesCell,reportFigBool,outDir)

        cMap = flipud(LoadVar('ColorMapSean6'));
        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,btwBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
        UnitKWPlotHelper(tempDataCell,[-3 0],1,0,cMap,cat(1,'btw KW p-values',infoText),figName,colNamesCell,reportFigBool,outDir)
         
        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,btwBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
        UnitBoxPlotHelper(tempDataCell,cat(1,'btw medians',infoText),figName,colNamesCell,reportFigBool,outDir)
    end
end


if reportFigBool
    close all
end

return

          %%%%%%%%%%%%%%%%%% fig printing %%%%%%%%%%%%%%%%
      
                tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
        
        tempDataCell = UnitWInCellHelper(tempDataCell);
bonfFactor = 1;
[pValCell anovaTabCell statsCell]= UnitKWHelper(tempDataCell,bonfFactor);
 tempDataCell = UnitMedianHelper(tempDataCell,1);

        tempDataCell = UnitPairwiseWInCellHelper(tempDataCell,'minus');
bonfFactor = 1/2;
 pValCell = UnitSignRankHelper(tempDataCell,bonfFactor);
 tempDataCell = UnitMedianHelper(tempDataCell,1);
        
% goodInd = ...
%     strcmp(tempDataCell(:,3),'ca1Pyr') & strcmp(tempDataCell(:,2),'w') | ...
%      strcmp(tempDataCell(:,3),'gran') & strcmp(tempDataCell(:,2),'n') | ...
%      strcmp(tempDataCell(:,3),'ca3Pyr') & strcmp(tempDataCell(:,2),'w');
% tempDataCell = tempDataCell(goodInd,:);
% tempDataCell(:,4) = {'w'};
colNamesCell{5} = unique(tempDataCell(:,5));
tempDataCell = tempDataCell(:,[1,2,4,3,5,6]);
pValCell = pValCell(:,[1,2,4,3,5,6]);
tempColNamesCell = colNamesCell([1,2,3,4,5]);

        outDir = [saveDir SC(analRoutine) SC('UnitFieldCoh') SC(Dot2Underscore(fileExt))];
        cMap = LoadVar('ColorMapSean6');
        UnitColorPlotHelper(tempDataCell,[],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)
        UnitColorPlotHelper(tempDataCell,[-0.075 0.075],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)
        UnitColorDotHelper(tempDataCell,pValCell,[-0.06 0.06],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)
        UnitColorDotHelper(tempDataCell,pValCell,[-0.05 0.05],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)

        
        
  %%%%%%%%%%%%%%%%%%% signrank plotting %%%%%%%%%%%%%%%%%%%      
                tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);

        tempDataCell = UnitPairwiseWInCellHelper(tempDataCell,'minus');
bonfFactor = 1/2;
 pValCell = UnitSignRankHelper(tempDataCell,bonfFactor);
 tempDataCell = UnitMedianHelper(tempDataCell,1);

colNamesCell{5} = unique(tempDataCell(:,5));
        tempDataCell = tempDataCell(:,[1,2,5,3,4,6]);
pValCell = pValCell(:,[1,2,5,3,4,6]);
tempColNamesCell = colNamesCell([1,2,5,4,3]);        

       UnitColorDotHelper(tempDataCell,pValCell,[-0.06 0.06],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)
        UnitColorDotHelper(tempDataCell,pValCell,[-0.05 0.05],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)
        UnitColorDotHelper(tempDataCell,pValCell,[-0.02 0.02],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)

        
        
        
            %%%%%%%%%%%%%%%%%% W/in cell printing %%%%%%%%%%%%%%%%
      
                tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
        tempDataCell = UnitAverageLayersHelper(tempDataCell,layerCombine,3);

        
        tempDataCell = UnitWInCellHelper(tempDataCell);
        
 %       tempDataCell = UnitPairwiseWInCellHelper(tempDataCell,'minus');
        
bonfFactor = 1;
[pValCell anovaTabCell statsCell]= UnitKWHelper(tempDataCell,bonfFactor);
 tempDataCell = UnitMedianHelper(tempDataCell,1);

        
% goodInd = ...
%     strcmp(tempDataCell(:,3),'ca1Pyr') & strcmp(tempDataCell(:,2),'w') | ...
%      strcmp(tempDataCell(:,3),'gran') & strcmp(tempDataCell(:,2),'n') | ...
%      strcmp(tempDataCell(:,3),'ca3Pyr') & strcmp(tempDataCell(:,2),'w');
% tempDataCell = tempDataCell(goodInd,:);
% tempDataCell(:,4) = {'w'};
colNamesCell{5} = unique(tempDataCell(:,5));
tempDataCell = tempDataCell(:,[1,2,4,3,5,6]);
pValCell = pValCell(:,[1,2,4,3,5,6]);
tempColNamesCell = colNamesCell([1,2,3,4,5]);

        outDir = [saveDir SC(analRoutine) SC('UnitFieldCoh') SC(Dot2Underscore(fileExt))];
        cMap = LoadVar('ColorMapSean6');
        UnitColorPlotHelper(tempDataCell,[],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)
        UnitColorPlotHelper(tempDataCell,[-0.075 0.075],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)
        UnitColorDotHelper(tempDataCell,pValCell,[-0.06 0.06],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)
        UnitColorDotHelper(tempDataCell,pValCell,[-0.05 0.05],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)
        UnitColorDotHelper(tempDataCell,pValCell,[-0.01 0.01],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)

        
            %%%%%%%%%%%%%%%%%%  kw printing %%%%%%%%%%%%%%%%
      
                tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
                
        tempDataCell = UnitPairwiseWInCellHelper(tempDataCell,'minus');
        
bonfFactor = 1;
[pValCell anovaTabCell statsCell]= UnitKWHelper(tempDataCell,bonfFactor);
 tempDataCell = UnitMedianHelper(tempDataCell,1);
colNamesCell{5} = unique(tempDataCell(:,5));
tempDataCell = tempDataCell(:,[1,2,5,3,4,6]);
pValCell = pValCell(:,[1,2,5,3,4,6]);
tempColNamesCell = colNamesCell([1,2,5,4,3]);        

       UnitColorDotHelper(tempDataCell,pValCell,[],1,1,cMap,cat(1,'w/in medians',infoText),figName,colNamesCell,reportFigBool,outDir)

       UnitColorDotHelper(tempDataCell,pValCell,[-0.06 0.06],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)
        UnitColorDotHelper(tempDataCell,pValCell,[-0.05 0.05],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)
        UnitColorDotHelper(tempDataCell,pValCell,[-0.04 0.04],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)
        UnitColorDotHelper(tempDataCell,pValCell,[-0.02 0.02],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)

        
        
        %%%%%%%%%%%%%%% summary figure %%%%%%%%%%%%%%%%%
                        tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,wInBool);
        tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
        layerCombine.ca1 = {'or','ca1Pyr','rad','lm'}
        layerCombine.dg = {'mol','gran','hil'}
        layerCombine.ca3 = {'ca3Pyr'}
        tempDataCell = UnitAverageLayersHelper(tempDataCell,layerCombine,3);

        
        tempDataCell = UnitWInCellHelper(tempDataCell);
        
 %       tempDataCell = UnitPairwiseWInCellHelper(tempDataCell,'minus');
        
bonfFactor = 1;
[pValCell anovaTabCell statsCell]= UnitKWHelper(tempDataCell,bonfFactor);
 tempDataCell = UnitMedianHelper(tempDataCell,1);

        
goodInd = ...
      strcmp(tempDataCell(:,4),'gran') & strcmp(tempDataCell(:,2),'w');
 tempDataCell = tempDataCell(goodInd,:);
% tempDataCell(:,4) = {'w'};
colNamesCell{5} = unique(tempDataCell(:,5));
tempDataCell = tempDataCell(:,[1,2,4,3,5,6]);
pValCell = pValCell(:,[1,2,4,3,5,6]);
tempColNamesCell = colNamesCell([1,2,3,4,5]);
tempColNamesCell{4} = {'ca1','dg','ca3'};

        outDir = [saveDir SC(analRoutine) SC('UnitFieldCoh') SC(Dot2Underscore(fileExt))];
        cMap = LoadVar('ColorMapSean6');
        UnitColorPlotHelper(tempDataCell,[],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)
        UnitColorPlotHelper(tempDataCell,[-0.075 0.075],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)
        UnitColorDotHelper(tempDataCell,pValCell,[-0.06 0.06],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)
        UnitColorDotHelper(tempDataCell,pValCell,[-0.05 0.05],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)
        UnitColorDotHelper(tempDataCell,pValCell,[-0.01 0.01],1,1,cMap,cat(1,'w/in medians',infoText),figName,tempColNamesCell,reportFigBool,outDir)

%         cMap = LoadVar('ColorMapSean6');
%         tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,0);
%         tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
%         tempDataCell = UnitMedianHelper(tempDataCell,1);
%         UnitColorPlotHelper(tempDataCell,[],1,0,cMap,cat(1,'btw medians',infoText),figName,colNamesCell)
%          
%         tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,1);
%         tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
%         tempDataCell = UnitWInCellHelper(tempDataCell);
%         tempDataCell = UnitMedianHelper(tempDataCell,1);
%         UnitColorPlotHelper(tempDataCell,[],1,1,cMap,cat(1,'w/in medians',infoText),figName,colNamesCell)
% 
%         cMap = flipud(LoadVar('ColorMapSean6'));
%         tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,1);
%         tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
%         tempDataCell = UnitWInCellHelper(tempDataCell);
%         tempDataCell = UnitSignRankHelper(tempDataCell);
%         tempDataCell = UnitLog10Helper(tempDataCell);
%         UnitColorPlotHelper(tempDataCell,[-3 0],1,0,cMap,cat(1,'w/in ranksign p-values',infoText),figName,colNamesCell)
% 
%         tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,1);
%         tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
%         tempDataCell = UnitWInCellHelper(tempDataCell);
%         UnitKWPlotHelper(tempDataCell,[-3 0],1,0,cMap,cat(1,'btw KW p-values',infoText),figName,colNamesCell)
% 
%         tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,0);
%         tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
%         UnitBoxPlotHelper(tempDataCell,cat(1,'btw medians',infoText),figName,colNamesCell,reportFigBool,outDir)
%         
%         tempDataCell = UnitCellRateThreshHelper(dataCell2,cellRateMin,rateCell2,1);
%         tempDataCell = UnitMeanHelper(tempDataCell,2,fo,freqRange);
%         tempDataCell = UnitWInCellHelper(tempDataCell);
%         UnitBoxPlotHelper(tempDataCell,cat(1,'w/in medians',infoText),figName,colNamesCell,reportFigBool,outDir)
%     end
% end


if reportFigBool
    close all
end

return
