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
    selChanCell = Struct2CellArray(LoadVar(['ChanInfo/SelChan' fileExt '.mat']));
    
    [tempCCG keptIndexes] = LoadDesigUnitPhaseThresh(fileBaseCell,spectAnalDir,...
        ['unitFieldPhase'  '_tapers' num2str(ntapers) '.yo'],...
        ['unitRate'],trialRateMin,trialDesig);
    tempCCG = Struct2CellArray(tempCCG,[],1);
    
    tempRate = Struct2CellArray(MeanDesigUnitIndexes(fileBaseCell,spectAnalDir,...
        ['unitRate'],keptIndexes,trialDesig),[],1);

%     keyboard
%     [tempCCG2 keptIndexes] = LoadDesigUnitThetaPeakPhaseThresh(fileBaseCell,spectAnalDir,...
%         ['unitFieldPhase'  '_tapers' num2str(ntapers)],'thetaFreqLM4-12Hz',...
%         ['unitRate'],trialRateMin,trialDesig);
%     tempCCG2 = Struct2CellArray(tempCCG2,[],1);
   
    %     keepInd = ones(size(tempRate{1,end}));
%     for k=1:size(tempCCG,1)
% %         size(tempCCG{k,end})
%         % calculate cells with rate < cellRateMin (in any condition)
%         keepInd = keepInd & tempRate{k,end} >= cellRateMin;
% %          size(find(keepInd))
%         %keepInd
%     end
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



% keyboard

if reportFigBool
    close all
end

%%%%%%%%%%%% plot phase hist over all trials (normalize total by number of trials) %%%%%%%%%%%
nBins = 10;
xLimits = [-pi pi];
bins = HistBins(nBins,xLimits);
for q=1:length(freqRangeCell)
    freqRange = freqRangeCell{q};
    figTitle = ['unitFieldPhase_normByTrial' ...
        num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'...
        '_tMin' num2str(trialRateMin) '_cMin'...
        num2str(cellRateMin) '_' ...
        'tapers' num2str(ntapers)];
    for j=1:length(cellLayers)
        for k=1:length(cellTypes)
            figure
            title(figTitle)
            screenHeight = 11;
            xyFactor = 2;
            set(gcf,'units','inches')
            set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*xyFactor,screenHeight])
            set(gcf,'paperposition',get(gcf,'position'))

            for m=1:size(selChanCell,1)
                subplot(size(selChanCell,1),1,m)
                hold on
                titleText = {};
                nText = ['n='];
                for p=1:size(ccgs,1)
                    if m==1 & p==1
                        titleText = cat(1,titleText,...
                            {[cellLayers{j} ',' cellTypes{k}];...
                            ['Unit Field Phase ' ...
                            num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz ' ...
                            fileExt];...
                            ['tapers=' num2str(ntapers) ' trialMinRate=' num2str(trialRateMin)...
                            ' cellMinRate=' num2str(cellRateMin)]});
                    end
                    if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
                            & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1}))
                        
                        temp1 = cat(1,ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){:});
                        [num,xPos] = hist(angle(mean(Angle2Complex(temp1...
                            (:,fo>=freqRange(1) & fo<=freqRange(2))),2)),bins);
                        [bsErrors] = BsErrBars(@median,95,1000,@hist,1,angle(mean(Angle2Complex(temp1...
                            (:,fo>=freqRange(1) & fo<=freqRange(2))),2)),bins);
                        normFactor = size(temp1,1);
                        
                        PhasePlot(repmat(xPos,[size(bsErrors,1) 1])',bsErrors'/normFactor,[plotColors(p) ':'])
                        PhasePlot(xPos',num'/normFactor,plotColors(p))
                        
                        nText = cat(2,nText,...
                            num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1)),',');
                    end
                    title(SaveTheUnderscores(cat(1,titleText,nText)))
                    if p==m
                        text(xLimits(2)+0.1*xLimits(2),0,[ccgs{p,1:end-1}],'color',plotColors(p))
                    end
                end
                yLimits = get(gca,'ylim');
                ylabel({selChanCell{m,1},ccgs{1,1}})
                set(gca,'xlim',xLimits)
                yLimits = [max([yLimits(1) 0]) min([yLimits(2) 1])];
                set(gca,'ylim',yLimits)
            end
        end
    end
if reportFigBool
    numFigs = length(cellLayers)*length(cellTypes);
    ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldPhase') SC(Dot2Underscore(fileExt))],...
        repmat({figTitle},[numFigs 1]));
    close all
end
end


%%%%%%%%%%%% plot phase hist over all trials (average hists norm by trials) %%%%%%%%%%%
nBins = 10;
xLimits = [-pi pi];
bins = HistBins(nBins,xLimits);
for q=1:length(freqRangeCell)
    freqRange = freqRangeCell{q};
    figTitle = ['unitFieldPhase_aveCellNormByTrial' ...
        num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'...
        '_tMin' num2str(trialRateMin) '_cMin'...
        num2str(cellRateMin) '_' ...
        'tapers' num2str(ntapers)];
    for j=1:length(cellLayers)
        for k=1:length(cellTypes)
            figure
            title(figTitle)
            screenHeight = 11;
            xyFactor = 2;
            set(gcf,'units','inches')
            set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*xyFactor,screenHeight])
            set(gcf,'paperposition',get(gcf,'position'))

            for m=1:size(selChanCell,1)
                subplot(size(selChanCell,1),1,m)
                hold on
                titleText = {};
                nText = ['n='];
                for p=1:size(ccgs,1)
                    if m==1 & p==1
                        titleText = cat(1,titleText,...
                            {[cellLayers{j} ',' cellTypes{k}];...
                            ['Unit Field Phase ' ...
                            num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz ' ...
                            fileExt];...
                            ['tapers=' num2str(ntapers) ' trialMinRate=' num2str(trialRateMin)...
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
%                             PhasePlot([xPos;xPos]',...
%                                 [mean(catHist,1)+std(catHist,[],1);...
%                                 mean(catHist,1)-std(catHist,[],1)]',...
%                                 [plotColors(p) ':'])
                            PhasePlot(xPos',mean(catHist,1)',plotColors(p))
                         nText = cat(2,nText,...
                            num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1)),',');
                       end
                    end
                    title(SaveTheUnderscores(cat(1,titleText,nText)))
                    if p==m
                        text(xLimits(2)+0.1*xLimits(2),0,[ccgs{p,1:end-1}],'color',plotColors(p))
                    end
                end
                yLimits = get(gca,'ylim');
                ylabel({selChanCell{m,1},ccgs{1,1}})
                set(gca,'xlim',xLimits)
                yLimits = [max([yLimits(1) 0]) min([yLimits(2) 1])];
                set(gca,'ylim',yLimits)
            end
        end
    end
if reportFigBool
    numFigs = length(cellLayers)*length(cellTypes);
    ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldPhase') SC(Dot2Underscore(fileExt))],...
        repmat({figTitle},[numFigs 1]));
    close all
end
end

%%%%%%%%%%%% plot phase hist over cells %%%%%%%%%%%
nBins = 10;
xLimits = [-pi pi];
bins = HistBins(nBins,xLimits);
for q=1:length(freqRangeCell)
    freqRange = freqRangeCell{q};
    figTitle = ['unitFieldPhase_normByCell' ...
        num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'...
        '_tMin' num2str(trialRateMin) '_cMin'...
        num2str(cellRateMin) '_' ...
        'tapers' num2str(ntapers)];
    for j=1:length(cellLayers)
        for k=1:length(cellTypes)
            figure
            title(figTitle)
            screenHeight = 11;
            xyFactor = 2;
            set(gcf,'units','inches')
            set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*xyFactor,screenHeight])
            set(gcf,'paperposition',get(gcf,'position'))

            for m=1:size(selChanCell,1)
                subplot(size(selChanCell,1),1,m)
                hold on
                titleText = {};
                nText = ['n='];
                for p=1:size(ccgs,1)
                    if m==1 & p==1
                        titleText = cat(1,titleText,...
                            {[cellLayers{j} ',' cellTypes{k}];...
                            ['Unit Field Phase ' ...
                            num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz ' ...
                            fileExt];...
                            ['tapers=' num2str(ntapers) ' trialMinRate=' num2str(trialRateMin)...
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
                        PhasePlot(xPos',num'/normFactor,plotColors(p))
                         nText = cat(2,nText,...
                            num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1)),',');
                    end
                    title(SaveTheUnderscores(cat(1,titleText,nText)))
                    if p==m
                        text(xLimits(2)+0.1*xLimits(2),0,[ccgs{p,1:end-1}],'color',plotColors(p))
                    end
                end
                yLimits = get(gca,'ylim');
                ylabel({selChanCell{m,1},ccgs{1,1}})
                set(gca,'xlim',xLimits)
                yLimits = [max([yLimits(1) 0]) min([yLimits(2) 1])];
                set(gca,'ylim',yLimits)
            end
        end
    end
if reportFigBool
    numFigs = length(cellLayers)*length(cellTypes);
    ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldPhase') SC(Dot2Underscore(fileExt))],...
        repmat({figTitle},[numFigs 1]));
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
        figTitle = ['unitFieldPhase_spect' ...
            num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'...
            '_tMin' num2str(trialRateMin) '_cMin'...
            num2str(cellRateMin) '_' ...
            'tapers' num2str(ntapers)];

        for m=1:size(selChanCell,1)
                subplot(size(selChanCell,1),1,m)
                hold on
                titleText = {};
                nText = 'n=';
                for p=1:size(ccgs,1)
                    if m==1 & p==1
                        titleText = cat(1,titleText,{[cellLayers{j} ',' cellTypes{k}];...
                            ['Unit Field Phase ' fileExt];...
                            ['tapers=' num2str(ntapers) ' trialMinRate=' num2str(trialRateMin)...
                            ' cellMinRate=' num2str(cellRateMin)]});
                    end
                    if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
                            & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1})) 
                        temp1 = cat(1,ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){:});
                        plot(fo,angle(mean(Angle2Complex(temp1),1)),['.' plotColors(p)])
                            nText = cat(2,nText,...
                            [num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1)) ',']);
                    end
                    title(SaveTheUnderscores(cat(1,titleText,nText)))
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
    ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldPhase') SC(Dot2Underscore(fileExt))],...
        repmat({figTitle},[numFigs 1]));
    close all
end


keyboard
%%%%%%%%%%%% plot phase hist for each cell norm by trial %%%%%%%%%%%
nBins = 10;
xLimits = [-pi pi];
bins = HistBins(nBins,xLimits);
for q=1:length(freqRangeCell)
    freqRange = freqRangeCell{q}{1};
    figTitle = ['unitFieldPhase_eachCellNormByTrial' ...
        num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'...
        '_tMin' num2str(trialRateMin) '_cMin'...
        num2str(cellRateMin) '_' ...
        'tapers' num2str(ntapers)];
    for j=2:2%1:length(cellLayers)
        for k=1:1%:length(cellTypes)
            for m=2:2%1:size(selChanCell,1)


                for p=1:size(ccgs,1)
                    %                     if m==1 & p==1
                    %                         titleText = cat(1,titleText,...
                    %                             {[cellLayers{j} ',' cellTypes{k}];...
                    %                             ['Unit Field Phase ' ...
                    %                             num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz ' ...
                    %                             fileExt];...
                    %                             ['tapers=' num2str(ntapers) ' trialMinRate=' num2str(trialRateMin)...
                    %                             ' cellMinRate=' num2str(cellRateMin)]});
                    %                     end
                    if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
                            & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1}))
                        figure
                        title(figTitle)
                        nCells = length(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}));
                        screenHeight = 1.5;
                        xyFactor = 2;
                        set(gcf,'units','inches')
                        set(gcf,'position',[0.5,0.5,screenHeight*nCells*xyFactor,screenHeight])
                        set(gcf,'paperposition',get(gcf,'position'))
                        for r=1:nCells
                         titleText = {};
                        nText = ['n='];
                           subplot(1,nCells,r)
                            temp1 = ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){r};
                            [num,xPos] = hist(angle(mean(Angle2Complex(temp1...
                                (:,fo>=freqRange(1) & fo<=freqRange(2))),2)),bins);
                            normFactor = size(temp1,1);
%                             PhasePlot(xPos',num'/normFactor,plotColors(p))
                            polar([xPos xPos+2*pi],[num num]/normFactor,plotColors(p))
                            %                             catHist = cat(1,catHist,num/normFactor);
                            %                         if ~isempty(catHist)
                            %                             PhasePlot([xPos;xPos]',...
                            %                                 [mean(catHist,1)+std(catHist,[],1);...
                            %                                 mean(catHist,1)-std(catHist,[],1)]',...
                            %                                 [plotColors(p) ':'])
                            %                             PhasePlot(xPos',mean(catHist,1)',plotColors(p))
                            nText = cat(2,nText,...
                                num2str(normFactor),',');
                            title(SaveTheUnderscores(cat(1,titleText,nText)))
                            if p==m
                                text(xLimits(2)+0.1*xLimits(2),0,[ccgs{p,1:end-1}],'color',plotColors(p))
                            end
                        end
%                         yLimits = get(gca,'ylim');
%                         ylabel({selChanCell{m,1},ccgs{1,1}})
%                         set(gca,'xlim',xLimits)
%                         yLimits = [max([yLimits(1) 0]) min([yLimits(2) 1])];
%                         set(gca,'ylim',yLimits)
                    end
                end
            end
        end
    end
if reportFigBool
    numFigs = length(cellLayers)*length(cellTypes);
    ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldPhase') SC(Dot2Underscore(fileExt))],...
        repmat({figTitle},[numFigs 1]));
    close all
end
end

% nBins = 10;
% xLimits = [-pi pi];
% screenHeight = 10;
% xyFactor = 1.5;
% bins = HistBins(nBins,xLimits);
% for q=1:length(freqRangeCell)
%     freqRange = freqRangeCell{q};
% for j=1:length(cellLayers)
%     for k=1:length(cellTypes)
%         figure
%         titleText = {};
%         for m=1:size(selChanCell,1)
%             for p=1:size(ccgs,1)
%                 if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
%                         & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1}))
% 
%                     numCell = length(ccgs{1,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}));
%                     nText = 'n=';
%                     for r=1:numCell
%                         subplot(size(selChanCell,1),numCell,(m-1)*numCell+r)
%                         hold on
% 
%                         temp1 = angle(mean(Angle2Complex(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){r}...
%                             (:,fo>=freqRange(1) & fo<=freqRange(2))),2));
%                         [num,xPos] = hist(temp1,bins);
%                         normFactor = length(temp1);
%                         PhasePlot(xPos',num'/normFactor,plotColors(p))
%                         if m==1
%                             nText = cat(2,nText,[num2str(length(temp1)),',']);
%                             if p==length(selChanCell{m,1})
%                             xlabel(nText)
%                             end
%                         end
%                         if r==1
%                             ylabel({selChanCell{m,1}})
%                             if m==1 & p==1
%                                 titleText = cat(1,titleText,{[cellLayers{j} ',' cellTypes{k}];...
%                                     ['Unit Field Phase ' fileExt];...
%                                     [' trialMinRate=' num2str(trialRateMin)...
%                                     ' cellMinRate=' num2str(cellRateMin)]});
%                                 title(SaveTheUnderscores(titleText))
% %                                 title(SaveTheUnderscores(cat(1,titleText,nText)))
%                                                     
%                             end
%                         end
%                         set(gca,'xlim',xLimits)
%                     end
%                     set(gcf,'units','inches')
%                     set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*numCell*xyFactor,screenHeight])
%                     set(gcf,'paperposition',get(gcf,'position'))
% 
% 
%                     if p==m
%                         text(freqLim+0.1*freqLim,0,[ccgs{p,1:end-1}],'color',plotColors(p))
%                     end
%                     
%                 end
%             end
%         end
%     end
% end
% if reportFigBool
%     numFigs = length(cellLayers)*length(cellTypes);
%     ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldPhase') SC(Dot2Underscore(fileExt))],...
%         repmat({['unitFieldPhase_eachCell' ...
%         num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'...
%         '_tMin' num2str(trialRateMin) '_cMin'...
%         num2str(cellRateMin) '_' ...
%         'tapers' num2str(ntapers)]},[numFigs 1]));
%     close all
% end
% end





