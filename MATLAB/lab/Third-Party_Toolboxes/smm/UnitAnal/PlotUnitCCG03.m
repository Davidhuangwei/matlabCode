% function PlotUnitCCG03(analDirs,spectAnalDir,statsAnalFunc,...
%     analRoutine,normalization,binSize,timeLim,biasCorrBool,rateMin,varargin)
% saveDir = DefaultArgs(varargin,{'/u12/smm/public_html/REMPaper/UnitAnal05/'});
function PlotUnitCCG03(analDirs,spectAnalDir,statsAnalFunc,...
    analRoutine,normalization,binSize,timeLim,biasCorrBool,rateMin,varargin)
saveDir = DefaultArgs(varargin,{'/u12/smm/public_html/NewFigs/REMPaper/UnitAnal05/'});
prevWarnSettings = SetWarnings({'off','LoadDesigVar:fileNotFound';...
   'off', 'MATLAB:divideByZero'});

cwd = pwd;

if biasCorrBool
    bcText = 'BC';
else
    bcText = '';
end
rates = [];
acgs = [];
ccgs = [];
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
%     keepInd = ones(size(tempRate{1,end}));
%     for k=1:size(tempCCG,1)
% %         size(tempCCG{k,end})
%         % calculate cells with rate < rateMin (in any condition)
%         try
%         keepInd = keepInd & tempRate{k,end} >= rateMin;
%         catch 
%             keyboard
%         end
% %          size(find(keepInd))
%         %keepInd
%     end

    for k=1:size(tempCCG,1)
        % remove cells with rate < rateMin
%         keepInd = tempRate{k,end} >= rateMin;
%         tempRate{k,end} = tempRate{k,end}(1,keepInd);
%         tempCCG{k,end} = tempCCG{k,end}(1,keepInd,keepInd,:);
        cellLayers = LoadCellLayers([fileBaseCell{1} '/' fileBaseCell{1} '.cellLayer']);
        cellTypes = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
%         cellLayers = cellLayers(keepInd,:);
%         cellTypes = cellTypes(keepInd,:);
        % sort cells by layer/type
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
        acgs{k,end} = UnionStructMatCat(1,acgs{k,end},SortACG2LayerTypes(squeeze(tempCCG{k,end}),cellLayers,cellTypes));
        ccgs{k,end} = UnionStructMatCat(1,ccgs{k,end},SortCCG2LayerTypes(squeeze(tempCCG{k,end}),cellLayers,cellTypes));
    end
    size(tempCCG{1,2})
end
to = LoadField([fileBaseCell{1} '/' spectAnalDir '/' 'unitCCGBin' num2str(binSize) normalization bcText '.to']);
cd(cwd)
cellLayers = selChan(:,1);
cellTypes = {'w' 'n'};
% plotColors = 'rgbk';

keyboard


%%%%%%%%%% plot average CCGs %%%%%%%%
colNamesCell{1} = cellLayers;
colNamesCell{2} = {'w','n'};
colNamesCell{3} = cellLayers;
colNamesCell{4} = {'w','n'};
colNamesCell{5} = ccgs(:,1);
dataCell = CellArray2Struct(ccgs);
dataCell = Struct2CellArray(dataCell,[],1);
dataCell = cat(2,dataCell(:,[2 3 4 5]),dataCell(:,[1 6]));


infoText = {['Unit Firing CCG'];...
    [normalization ' bin=' num2str(binSize) ' ' bcText ' minRate=' num2str(rateMin)]});
figName = {['UnitCCG_' normalization bcText ...
    '_bin' num2str(binSize)]};

tempDataCell = UnitCellRateThreshHelper(dataCell,rateMin,rateCell1,rateCell2,0);


UnitSpectrumPlotHelper(dataCell,to,[0 timeLim],infoText,figName,colNamesCell)

ReportFigSM(1:length(cellLayers)*length(cellTypes),...
    [saveDir SC(analRoutine)],repMat({['UnitCCG_' normalization bcText ...
    '_bin' num2str(binSize)]},[length(cellLayers)*length(cellTypes),1]));

%%%%%%%%%% plot time range CCG boxplots %%%%%%%%%%%%% 
UnitBoxPlotHelper(dataCell,to,[-8 8],[],colNamesCell)

%%%%%%%%%% plot ACGs %%%%%%%%%%%%%%%%%%%%%%%
colNamesCell{1} = {''};
colNamesCell{2} = {''};
colNamesCell{3} = cellLayers;
colNamesCell{4} = {'w','n'};
colNamesCell{5} = acgs(:,1);
dataCell = CellArray2Struct(acgs);
dataCell = Struct2CellArray(dataCell,[],1);
dataCell = cat(2,repmat({''},size(dataCell(:,[1 2]))),...
    dataCell(:,[2 3]),dataCell(:,[1 4]));

UnitSpectrumPlotHelper(dataCell,to,[],[0 150],colNamesCell)

%%%%%%%%%% plot time range CCG boxplots %%%%%%%%%%%%% 
UnitBoxPlotHelper(dataCell,to,[-8 8],[],colNamesCell)

return


rateCell = CellArray2Struct(rates);
rateCell = Struct2CellArray(rateCell,[],1);
rateCell = cat(2,repmat({''},size(rateCell(:,[1 2]))),rateCell(:,[2 3]),...
    rateCell(:,[1 4]));
UnitBoxPlotHelper(rateCell,1,[],[],colNamesCell)



UnitBoxPlotHelper(dataCell,xVal,varargin)
[xMeanRange infoText colNamesCell screenHeight xyFactor] = ...
    DefaultArgs(varargin,{[min(xVal) max(xVal)],{'noInfo'},{},11,1.5});
close all
% cellLayers = {'or','ca1Pyr','rad','lm','mol','gran','hil','ca3Pyr','noLayer'};
% cellTypes = {'w' 'n' 'x'};
%cellLayers = fieldnames(acgs{1,end});
for j=1:length(cellLayers)
    %cellTypes = acgs{1,end}.(cellLayers{m});
    for k=1:length(cellTypes)
        figure
        screenHeight = 11;
        xyFactor = 1.1;
        set(gcf,'units','inches')
        set(gcf,'position',[0.5,0.5,screenHeight/length(cellLayers)*length(cellTypes)*xyFactor,screenHeight])
        set(gcf,'paperposition',get(gcf,'position'))

        for m=1:length(cellLayers)
            for n=1:length(cellTypes)
                subplot(length(cellLayers),length(cellTypes),(m-1)*length(cellTypes)+n)
                hold on
                titleText = {};
                for p=1:size(ccgs,1)
                    if n==1 & m==1 & p==1
                        titleText = cat(1,titleText,{[cellLayers{j} ',' cellTypes{k}];...
                            ['Unit Firing CCG'];...
                            [normalization ' bin=' num2str(binSize) ' ' bcText ' minRate=' num2str(rateMin)]});
                    end
                    if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
                            & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(cellLayers{m})) ...
                            & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(cellLayers{m}),cellTypes{n})
                        %                             & ~isempty(find(~isnan(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(cellLayers{m}).(cellTypes{n}))))


                        temp1 = mean(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(cellLayers{m}).(cellTypes{n}));
                        %                     temp1 = temp1(~isnan(temp1));
                        %                     temp2 = temp1(~isnan(temp2));

                        plot(to,temp1,'color',plotColors(p))
                        %                     minVal = min([temp1;temp2]);
                        %                     maxVal = max([temp1;temp2]);
                        %                     if minVal == maxVal
                        %                         maxVal = minVal + 1;
                        %                     end
                        %                     minVal = minVal-.1*(maxVal-minVal);
                        %                     maxVal = maxVal+.1*(maxVal-minVal);
                        %                     plot([minVal maxVal],[minVal maxVal])
                        titleText = cat(1,titleText,...
                            ['n=' num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(cellLayers{m}).(cellTypes{n}),1))]);
                    end
                    title(titleText)
                    if p==m & n==1
                        text(timeLim+0.1*timeLim,0,[ccgs{p,1:end-1}],'color',plotColors(p))
                    end
                    if n==1
                        ylabel({cellLayers{m},ccgs{1,1}})
                    end
                    if m==length(cellLayers)
                        xlabel({ccgs{2,1},cellTypes{n}})
                    end
                    set(gca,'xlim',[-timeLim timeLim])
                end
            end
        end
    end
end
ReportFigSM(1:length(cellLayers)*length(cellTypes),...
    [saveDir SC(analRoutine)],repMat({['UnitCCG_' normalization bcText ...
    '_bin' num2str(binSize)]},[length(cellLayers)*length(cellTypes),1]));

close all
%%%%%%% mean ACGs %%%%%%%%%%%%%%%%%%%%
figure
screenHeight = 11;
xyFactor = 1.1;
set(gcf,'units','inches')
set(gcf,'position',[0.5,0.5,screenHeight/length(cellLayers)*length(cellTypes)*xyFactor,screenHeight])
set(gcf,'paperposition',get(gcf,'position'))

for j=1:length(cellLayers)
    for k=1:length(cellTypes)
        subplot(length(cellLayers),length(cellTypes),(j-1)*length(cellTypes)+k)
        hold on
        titleText = {};
        for p=1:size(acgs,1)
            if k==1 & j==1 & p==1
                titleText = ...
                    {['Unit Firing ACG'];...
                    [normalization ' bin=' num2str(binSize) ' ' bcText ' minRate=' num2str(rateMin)]};
            end
            if isfield(acgs{p,end},cellLayers{j}) & isfield(acgs{p,end}.(cellLayers{j}),cellTypes{k})...

            temp1 = mean(acgs{p,end}.(cellLayers{j}).(cellTypes{k}));
            plot(to,temp1,'color',plotColors(p))
            titleText = cat(1,titleText,...
                ['k=' num2str(size(acgs{p,end}.(cellLayers{j}).(cellTypes{k}),1))]);
            end
            title(titleText)
            if p==j & k==1
                text(timeLim+0.1*timeLim,0,[acgs{p,1:end-1}],'color',plotColors(p))
            end
            if k==1
                ylabel({cellLayers{j},acgs{1,1}})
            end
            if j==length(cellLayers)
                xlabel({acgs{2,1},cellTypes{k}})
            end
            set(gca,'xlim',[-timeLim timeLim])
        end
    end
end
ReportFigSM(1,...
    [saveDir SC(analRoutine)],repMat({['UnitACG_' normalization bcText ...
    '_bin' num2str(binSize)]},[1,1]));



close all
%%%%%%%%%%%%%%%%%%%%%%%%%% ACGs for each cellxlayer
% cellLayers = {'or','ca1Pyr','rad','lm','mol','gran','hil','ca3Pyr','noLayer'};
% cellTypes = {'w' 'n' 'x'};
screenHeight = 3;
xyFactor = 1.1;
for j=1:length(cellLayers)
    for k=1:length(cellTypes)
        figure
        for p=1:size(acgs,1)
            if IsBranch(acgs{p,end},cellLayers{j},cellTypes{k})
                for c=1:size(acgs{p,end}.(cellLayers{j}).(cellTypes{k}),1)
                    subplot(1,size(acgs{p,end}.(cellLayers{j}).(cellTypes{k}),1),c)
                    hold on
                    titleText = {};
                    rateTemp = rates{p,end}.(cellLayers{j}).(cellTypes{k})(c);
                    if c==1 & p==1
                        titleText = ...
                            {['Unit Firing ACG'];...
                            [normalization ' bin=' num2str(binSize) ' ' bcText ' minRate=' num2str(rateMin)]};
                        set(gcf,'units','inches')
                        set(gcf,'position',[0.5,0.5,screenHeight*...
                            size(acgs{p,end}.(cellLayers{j}).(cellTypes{k}),1)*xyFactor,screenHeight])
                        set(gcf,'paperposition',get(gcf,'position'))

                    end
                    titleText = cat(1,titleText,num2str(rateTemp));
                    if p==size(acgs,1)
                        title(titleText)
                    end
                    temp1 = acgs{p,end}.(cellLayers{j}).(cellTypes{k})(c,:);
                    plot(to,temp1,'color',plotColors(p))
                    %                     titleText = cat(1,titleText,...
                    %                         ['k=' num2str(size(acgs{p,end}.(cellLayers{j}).(cellTypes{k}),1))]);
                    if c==1
                        text(timeLim+0.1*timeLim,0,[acgs{p,1:end-1}],'color',plotColors(p))
                    end
                    if c==1
                        ylabel({cellLayers{j},acgs{1,1}})
                    end
                    xlabel({acgs{2,1},cellTypes{k}})
                    set(gca,'xlim',[-timeLim timeLim])
                end
            end
        end
    end
end

ReportFigSM(1:length(cellLayers)*length(cellTypes),...
    [saveDir SC(analRoutine)],repMat({['UnitACG_eachCell_' normalization bcText ...
    '_bin' num2str(binSize)]},[length(cellLayers)*length(cellTypes),1]));
close all




