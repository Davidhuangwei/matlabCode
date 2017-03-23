function PlotUnitFieldPhase02(analDirs,fileExt,spectAnalDir,statsAnalFunc,...
    analRoutine,freqLim,trialRateMin,cellRateMin,ntapers,varargin)
[freqRangeCell reportFigBool saveDir] = ...
    DefaultArgs(varargin,{{[4 12],[40 120]},...
    1,'/u12/smm/public_html/NewFigs/REMPaper/UnitAnal05/'});

prevWarnSettings = SetWarnings({'off','LoadDesigVar:fileNotFound';...
   'off', 'MATLAB:divideByZero'});

cwd = pwd;

rates = [];
acgs = [];
ccgs = [];
for j=1:length(analDirs)
    cd(analDirs{j})
    load(['TrialDesig/' statsAnalFunc '/' analRoutine '.mat'])
    
    tempCCG = Struct2CellArray(LoadDesigUnitPhaseThresh(fileBaseCell,spectAnalDir,...
        ['unitFieldPhase'  '_tapers' num2str(ntapers) '.yo'],...
        ['unitRate'],trialRateMin,trialDesig),[],1);
    
    tempRate = Struct2CellArray(MeanDesigUnitThresh(fileBaseCell,spectAnalDir,...
        ['unitRate'],['unitRate'],trialRateMin,trialDesig),[],1);
    
%     keepInd = ones(size(tempRate{1,end}));
%     for k=1:size(tempCCG,1)
% %         size(tempCCG{k,end})
%         % calculate cells with rate < cellRateMin (in any condition)
%         keepInd = keepInd & tempRate{k,end} >= cellRateMin;
% %          size(find(keepInd))
%         %keepInd
%     end
    selChanCell = Struct2CellArray(LoadVar(['ChanInfo/SelChan' fileExt '.mat']));
    for k=1:size(tempCCG,1)
        % remove cells with rate < cellRateMin
        keepInd = tempRate{k,end} >= cellRateMin;
        tempRate{k,end} = tempRate{k,end}(1,keepInd);
        tempCCG{k,end} = tempCCG{k,end}(keepInd);
        cellLayers = LoadCellLayers([fileBaseCell{1} '/' fileBaseCell{1} '.cellLayer']);
        cellTypes = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
        cellLayers = cellLayers(keepInd,:);
        cellTypes = cellTypes(keepInd,:);
%         % sort cells by layer/type
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
%         acgs{k,end} = UnionStructMatCat(1,acgs{k,end},SortACG2LayerTypes(squeeze(tempCCG{k,end}),cellLayers,cellTypes));
        ccgs{k,end} = UnionStructMatCat(1,ccgs{k,end},SortUnitFieldPhase2LayerTypes(squeeze(tempCCG{k,end}),cellLayers,cellTypes,selChanCell));
    end
    size(tempCCG{1,2})
end
fo = LoadField([fileBaseCell{1} '/' spectAnalDir '/' 'unitFieldPhase'  '_tapers' num2str(ntapers) '.fo']);
cd(cwd)
cellLayers = {'or','ca1Pyr','rad','mol','gran','hil','ca3Pyr'};
cellTypes = {'w' 'n'};
plotColors = 'rgbk';
% keyboard

% %%%% simple plotting of phase %%%%%%
% plotColor = 'rkg';
% nbins = 20;
% clf
% for m=1:size(tempCCG,1)
%     for n=1:length(tempCCG{m,end})
%         for j=1:size(tempCCG{m,end}{n},2)
%             subplot(size(tempCCG{m,end}{n},2),length(tempCCG{m,end}),(j-1)*length(tempCCG{m,end})+n)
%             hold on
%             [num, xpos] = hist(angle(mean(Angle2Complex(tempCCG{m,end}{n}(:,j,fo>40 & fo<120)),1)),...
%                 [-pi:2*pi/(nbins-1):pi]);
%             bar(xpos,num,plotColor(m));
%             set(gca,'xlim',[-pi pi])
%         end
%     end
% end



 keyboard

if reportFigBool
    close all
end

%%%%%%%%%%%% plot phase hist over all trials (normalize total by number of trials) %%%%%%%%%%%
nBins = 10;
xLimits = [-pi pi];
bins = HistBins(nBins,xLimits);
for q=1:length(freqRangeCell)
    freqRange = freqRangeCell{q};
    for j=1:length(cellLayers)
        for k=1:length(cellTypes)
            figure
            screenHeight = 11;
            xyFactor = 2;
            set(gcf,'units','inches')
            set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*xyFactor,screenHeight])
            set(gcf,'paperposition',get(gcf,'position'))

            for m=1:size(selChanCell,1)
                subplot(size(selChanCell,1),1,m)
                hold on
                titleText = {};
                for p=1:size(ccgs,1)
                    if m==1 & p==1
                        titleText = cat(1,titleText,{[cellLayers{j} ',' cellTypes{k}];...
                            ['Unit Field Coh ' fileExt];...
                            [' trialMinRate=' num2str(trialRateMin)...
                            ' cellMinRate=' num2str(cellRateMin)]});
                    end
                    if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
                            & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1}))
                        %                             & ~isempty(find(~isnan(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(cellLayers{m}).(cellTypes{n}))))
                        temp1 = cat(1,ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){:});
                        [num,xPos] = hist(angle(mean(Angle2Complex(temp1...
                            (:,fo>=freqRange(1) & fo<=freqRange(2))),2)),bins);
                        normFactor = size(temp1,1);
                        PhasePlot(xPos,num/normFactor,plotColors(p))
                        if p==1
                            titleText = cat(1,titleText,...
                                ['n=' num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1))]);
                        end
                    end
                    title(titleText)
                    if p==m
                        text(xLimits(2)+0.1*xLimits(2),0,[ccgs{p,1:end-1}],'color',plotColors(p))
                    end
                    ylabel({selChanCell{m,1},ccgs{1,1}})
                    set(gca,'xlim',xLimits)
                    %                     set(gca,'ylim',[0 1])
                end
            end
        end
    end
if reportFigBool
    numFigs = length(cellLayers)*length(cellTypes);
    ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldPhase') SC(GenFieldName(fileExt))],...
        repmat({['unitFieldPhase_normByTrial' ...
        num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'...
        '_tMin' num2str(trialRateMin) '_cMin'...
        num2str(cellRateMin) '_' ...
        'tapers' num2str(ntapers)]},[numFigs 1]));
    close all
end
end


%%%%%%%%%%%% plot phase hist over all trials (average hists norm by trials) %%%%%%%%%%%
nBins = 10;
xLimits = [-pi pi];
bins = HistBins(nBins,xLimits);
for q=1:length(freqRangeCell)
    freqRange = freqRangeCell{q};
    for j=1:length(cellLayers)
        for k=1:length(cellTypes)
            figure
            screenHeight = 11;
            xyFactor = 2;
            set(gcf,'units','inches')
            set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*xyFactor,screenHeight])
            set(gcf,'paperposition',get(gcf,'position'))

            for m=1:size(selChanCell,1)
                subplot(size(selChanCell,1),1,m)
                hold on
                titleText = {};
                for p=1:size(ccgs,1)
                    if m==1 & p==1
                        titleText = cat(1,titleText,{[cellLayers{j} ',' cellTypes{k}];...
                            ['Unit Field Coh ' fileExt];...
                            [' trialMinRate=' num2str(trialRateMin)...
                            ' cellMinRate=' num2str(cellRateMin)]});
                    end
                    if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
                            & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1}))
                        catHist = [];
                        for r=1:length(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}))
                            temp1 = ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){r};
                            [num,xPos] = hist(angle(mean(Angle2Complex(temp1...
                                (:,fo>=freqRange(1) & fo<=freqRange(2))),2)),bins);
                            normFactor = size(temp1,1);
                            catHist = cat(1,catHist,num/normFactor);
                        end
                        if ~isempty(catHist)
                        PhasePlot(xPos,mean(catHist,1),plotColors(p))
                        end
                        if p==1
                            titleText = cat(1,titleText,...
                                ['n=' num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1))]);
                        end
                    end
                    title(titleText)
                    if p==m
                        text(xLimits(2)+0.1*xLimits(2),0,[ccgs{p,1:end-1}],'color',plotColors(p))
                    end
                    ylabel({selChanCell{m,1},ccgs{1,1}})
                    set(gca,'xlim',xLimits)
                end
            end
        end
    end
if reportFigBool
    numFigs = length(cellLayers)*length(cellTypes);
    ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldPhase') SC(GenFieldName(fileExt))],...
        repmat({['unitFieldPhase_aveCellNormByTrial' ...
        num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'...
        '_tMin' num2str(trialRateMin) '_cMin'...
        num2str(cellRateMin) '_' ...
        'tapers' num2str(ntapers)]},[numFigs 1]));
    close all
end
end


%%%%%%%%%%%% plot phase hist over cells %%%%%%%%%%%
nBins = 10;
xLimits = [-pi pi];
bins = HistBins(nBins,xLimits);
for q=1:length(freqRangeCell)
    freqRange = freqRangeCell{q};
for j=1:length(cellLayers)
    for k=1:length(cellTypes)
        figure
        screenHeight = 11;
        xyFactor = 2;
        set(gcf,'units','inches')
        set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*xyFactor,screenHeight])
        set(gcf,'paperposition',get(gcf,'position'))

        for m=1:size(selChanCell,1)
                subplot(size(selChanCell,1),1,m)
                hold on
                titleText = {};
                for p=1:size(ccgs,1)
                    if m==1 & p==1
                        titleText = cat(1,titleText,{[cellLayers{j} ',' cellTypes{k}];...
                            ['Unit Field Coh ' fileExt];...
                            [' trialMinRate=' num2str(trialRateMin)...
                            ' cellMinRate=' num2str(cellRateMin)]});
                    end
                    if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
                            & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1}))
                        temp1 = [];
                        for r=1:length(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}))
                            temp1(r) = angle(mean(mean(Angle2Complex(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){r}...
                                (:,fo>=freqRange(1) & fo<=freqRange(2))),2),1));
                        end
                        [num,xPos] = hist(temp1,bins);
                        normFactor = size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1);
                        PhasePlot(xPos,num/normFactor,plotColors(p))
                        if p==1
                            titleText = cat(1,titleText,...
                                ['n=' num2str(length(temp1))]);
                        end
                    end
                    title(titleText)
                    if p==m 
                        text(freqLim+0.1*freqLim,0,[ccgs{p,1:end-1}],'color',plotColors(p))
                    end
                        ylabel({selChanCell{m,1},ccgs{1,1}})
                    set(gca,'xlim',xLimits)
                end
            end
    end
end
if reportFigBool
    numFigs = length(cellLayers)*length(cellTypes);
    ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldPhase') SC(GenFieldName(fileExt))],...
        repmat({['unitFieldPhase_normByCell' ...
        num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'...
        '_tMin' num2str(trialRateMin) '_cMin'...
        num2str(cellRateMin) '_' ...
        'tapers' num2str(ntapers)]},[numFigs 1]));
    close all
end
end


%%%%%%%%%%%% plot phase hist layerXcell over trials %%%%%%%%%%%
nBins = 10;
xLimits = [-pi pi];
screenHeight = 10;
xyFactor = 1.5;
bins = HistBins(nBins,xLimits);
for q=1:length(freqRangeCell)
    freqRange = freqRangeCell{q};
for j=1:length(cellLayers)
    for k=1:length(cellTypes)
        figure
        titleText = {};

        for m=1:size(selChanCell,1)
            for p=1:size(ccgs,1)
                if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
                        & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1}))

                    numCell = length(ccgs{1,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}));
                    for r=1:numCell
                        subplot(size(selChanCell,1),numCell,(m-1)*numCell+r)
                        hold on

                        temp1 = angle(mean(Angle2Complex(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){r}...
                            (:,fo>=freqRange(1) & fo<=freqRange(2))),2));
                        [num,xPos] = hist(temp1,bins);
                        normFactor = length(temp1);
                        PhasePlot(xPos,num/normFactor,plotColors(p))
                        if m==1 & p==length(selChanCell{m,1})
                            titleText = cat(1,titleText,...
                                ['n=' num2str(length(temp1))]);
                            xlabel(titleText)
                        end
                        if r==1
                            ylabel({selChanCell{m,1}})
                            if m==1 & p==1
                                titleText = cat(1,titleText,{[cellLayers{j} ',' cellTypes{k}];...
                                    ['Unit Field Coh ' fileExt];...
                                    [' trialMinRate=' num2str(trialRateMin)...
                                    ' cellMinRate=' num2str(cellRateMin)]});
                                title(titleText)
                                                    
                            end
                        end
                        set(gca,'xlim',xLimits)
                    end
                    set(gcf,'units','inches')
                    set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*numCell*xyFactor,screenHeight])
                    set(gcf,'paperposition',get(gcf,'position'))


                    if p==m
                        text(freqLim+0.1*freqLim,0,[ccgs{p,1:end-1}],'color',plotColors(p))
                    end
                    
                end
            end
        end
    end
end
if reportFigBool
    numFigs = length(cellLayers)*length(cellTypes);
    ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldPhase') SC(GenFieldName(fileExt))],...
        repmat({['unitFieldPhase_eachCell' ...
        num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'...
        '_tMin' num2str(trialRateMin) '_cMin'...
        num2str(cellRateMin) '_' ...
        'tapers' num2str(ntapers)]},[numFigs 1]));
    close all
end
end


%%%%%%%%%%%% plot average phase spectrum for all cells %%%%%%%%%%%
plotColors = 'rgbk';
for j=1:length(cellLayers)
    for k=1:length(cellTypes)
        figure
        screenHeight = 11;
        xyFactor = 2;
        set(gcf,'units','inches')
        set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*xyFactor,screenHeight])
        set(gcf,'paperposition',get(gcf,'position'))

        for m=1:size(selChanCell,1)
                subplot(size(selChanCell,1),1,m)
                hold on
                titleText = {};
                for p=1:size(ccgs,1)
                    if m==1 & p==1
                        titleText = cat(1,titleText,{[cellLayers{j} ',' cellTypes{k}];...
                            ['Unit Field Coh ' fileExt];...
                            [' trialMinRate=' num2str(trialRateMin)...
                            ' cellMinRate=' num2str(cellRateMin)]});
                    end
                    if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
                            & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1})) 
                        temp1 = cat(1,ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){:});
                        plot(fo,angle(mean(Angle2Complex(temp1),1)),['.' plotColors(p)])
                        if p==1
                            titleText = cat(1,titleText,...
                            ['n=' num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1))]);
                        end
                    end
                    title(titleText)
                    if p==m 
                        text(freqLim+0.1*freqLim,0,[ccgs{p,1:end-1}],'color',plotColors(p))
                    end
                        ylabel({selChanCell{m,1}})
                    set(gca,'xlim',[0 freqLim])
                    set(gca,'ylim',[-pi pi])
                end
            end
    end
end
if reportFigBool
    numFigs = length(cellLayers)*length(cellTypes);
    ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldPhase') SC(GenFieldName(fileExt))],...
        repmat({['unitFieldPhase_spect' ...
        '_tMin' num2str(trialRateMin) '_cMin'...
        num2str(cellRateMin) '_' ...
        'tapers' num2str(ntapers)]},[numFigs 1]));
    close all
end




