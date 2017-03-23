function PlotUnitFieldCoh02(analDirs,fileExt,spectAnalDir,statsAnalFunc,...
    analRoutine,freqLim,trialRateMin,cellRateMin,cohName,ntapers)

prevWarnSettings = SetWarnings({'off','LoadDesigVar:fileNotFound';...
   'off', 'MATLAB:divideByZero'});

cwd = pwd;

rates = [];
acgs = [];
ccgs = [];
for j=1:length(analDirs)
    cd(analDirs{j})
    load(['TrialDesig/' statsAnalFunc '/' analRoutine '.mat'])
        
    tempRate = Struct2CellArray(MeanDesigUnitThresh(fileBaseCell,spectAnalDir,...
        ['unitRate'],['unitRate'],trialRateMin,trialDesig),[],1);
    
    tempCCG = Struct2CellArray(MeanDesigUnitThresh(fileBaseCell,spectAnalDir,...
        ['unitFieldCoh_' cohName '_tapers' num2str(ntapers) '.yo'],...
        ['unitRate'],trialRateMin,trialDesig),[],1);

    keepInd = ones(size(tempRate{1,end}));
    for k=1:size(tempCCG,1)
%         size(tempCCG{k,end})
        % calculate cells with rate < cellRateMin (in any condition)
        keepInd = keepInd & tempRate{k,end} >= cellRateMin;
%          size(find(keepInd))
        %keepInd
    end
   selChanCell = Struct2CellArray(LoadVar(['ChanInfo/SelChan' fileExt '.mat']));
    for k=1:size(tempCCG,1)
        % remove cells with rate < cellRateMin
        tempRate{k,end} = tempRate{k,end}(1,keepInd);
        tempCCG{k,end} = tempCCG{k,end}(1,keepInd,:,:);
        cellLayers = LoadCellLayers([fileBaseCell{1} '/' fileBaseCell{1} '.cellLayer']);
        cellTypes = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
        cellLayers = cellLayers(keepInd,:);
        cellTypes = cellTypes(keepInd,:);
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
%         rates{k,end} = UnionStructMatCat(1,rates{k,end},SortRates2LayerTypes(squeeze(tempRate{k,end}),cellLayers,cellTypes));
%         acgs{k,end} = UnionStructMatCat(1,acgs{k,end},SortACG2LayerTypes(squeeze(tempCCG{k,end}),cellLayers,cellTypes));
        ccgs{k,end} = UnionStructMatCat(1,ccgs{k,end},SortUnitFieldCoh2LayerTypes(squeeze(tempCCG{k,end}),cellLayers,cellTypes,selChanCell));
    end
    size(tempCCG{1,2})
end
fo = LoadField([fileBaseCell{1} '/' spectAnalDir '/' 'unitFieldCoh_' cohName '_tapers' num2str(ntapers) '.fo']);
cd(cwd)
cellLayers = {'or','ca1Pyr','rad','gran','hil','ca3Pyr'};
cellTypes = {'w' 'n'};
plotColors = 'rgbk';
keyboard

clf
plotColor = 'rgbk';
for k=1:size(tempCCG{1,end},2)
    for m=1:size(tempCCG{1,end},3)
        subplot(size(tempCCG{j,end},3),size(tempCCG{j,end},2),(m-1)*size(tempCCG{j,end},2)+k)
        hold on
        for j=1:size(tempCCG,1)
            %             plot(fo,UnATanCoh(squeeze(tempCCG{j,end}(1,k,m,:))),plotColor(j))
            plot(fo,squeeze(tempCCG{j,end}(1,k,m,:)),plotColor(j))
            if j==1
                titleText{k} = {[num2str(k) ': ']};
            end
            if m==1
                titleText{k} = cat(1,titleText{k},{num2str(tempRate{j,end}(1,k),2)});
            end
            if k==1
                ylabel(selChanCell{m,1})
            end
            set(gca,'xlim',[0 freqLim])
        end
        if m==1
            title(titleText{k})
        end
    end
end


% cellLayers = {'or','ca1Pyr','rad','lm','mol','gran','hil','ca3Pyr','noLayer'};
% cellTypes = {'w' 'n' 'x'};
%cellLayers = fieldnames(acgs{1,end});
for j=1:size(selChanCell,1)
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
                    titleText = cat(1,titleText,{selChanCell{j,1};...
                        ['Unit Firing CCG'];...
                        [normalization ' bin=' num2str(binSize) ' ' bcText ...
                        ' trialMinRate=' num2str(trialRateMin)...
                        ' cellMinRate=' num2str(cellRateMin)]});
                end
                if isfield(ccgs{p,end},cellLayers{m}) & isfield(ccgs{p,end}.(cellLayers{m}),cellTypes{n})...
                        & isfield(ccgs{p,end}.(cellLayers{m}).(cellTypes{n}),(selChanCell{j,1}))
                    %                             & ~isempty(find(~isnan(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(cellLayers{m}).(cellTypes{n}))))


                    temp1 = UnATanCoh(mean(ccgs{p,end}.(cellLayers{m}).(cellTypes{n}).(selChanCell{j,1}),1));
                    %                     temp1 = temp1(~isnan(temp1));
                    %                     temp2 = temp1(~isnan(temp2));

                    plot(fo,temp1,'color',plotColors(p))
                    %                     minVal = min([temp1;temp2]);
                    %                     maxVal = max([temp1;temp2]);
                    %                     if minVal == maxVal
                    %                         maxVal = minVal + 1;
                    %                     end
                    %                     minVal = minVal-.1*(maxVal-minVal);
                    %                     maxVal = maxVal+.1*(maxVal-minVal);
                    %                     plot([minVal maxVal],[minVal maxVal])
                    titleText = cat(1,titleText,...
                        ['n=' num2str(size(ccgs{p,end}.(cellLayers{m}).(cellTypes{n}).(selChanCell{j,1}),1))]);
                end
                title(titleText)
                if p==m & n==1
                    text(freqLim+0.1*freqLim,0,[ccgs{p,1:end-1}],'color',plotColors(p))
                end
                if n==1
                    ylabel({cellLayers{m},ccgs{1,1}})
                end
                if m==length(cellLayers)
                    xlabel({ccgs{2,1},cellTypes{n}})
                end
                set(gca,'xlim',[0 freqLim],'ylim',[0 1])
            end
        end
    end

end


%%%%%%%%%%%%%%%%% unit Field coh mean %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
cellLayers = {'or','ca1Pyr','rad','gran','mol','hil','ca3Pyr'};
cellTypes = {'w' 'n'};
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
                        %                             & ~isempty(find(~isnan(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(cellLayers{m}).(cellTypes{n}))))


                        temp1 = mean(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1);
%                          temp1 = UnATanCoh(mean(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1));
                       
                        %                     temp1 = temp1(~isnan(temp1));
                        %                     temp2 = temp1(~isnan(temp2));

                        plot(fo,temp1,'color',plotColors(p))
                        %                     minVal = min([temp1;temp2]);
                        %                     maxVal = max([temp1;temp2]);
                        %                     if minVal == maxVal
                        %                         maxVal = minVal + 1;
                        %                     end
                        %                     minVal = minVal-.1*(maxVal-minVal);
                        %                     maxVal = maxVal+.1*(maxVal-minVal);
                        %                     plot([minVal maxVal],[minVal maxVal])
                        if p==1
                            titleText = cat(1,titleText,...
                            ['n=' num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1))]);
                        end
                    end
                    title(titleText)
                    if p==m 
                        text(freqLim+0.1*freqLim,0,[ccgs{p,1:end-1}],'color',plotColors(p))
                    end
                        ylabel({selChanCell{m,1})
                    set(gca,'xlim',[0 freqLim])
%                     set(gca,'ylim',[0 1])
                end
            end
        end

end

ReportFigSM(

%%%%%%%%%%%%%%%%% unit Field coh mean freqRange %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
freqRange = [4 12]
nBins = 20;
xLimits = [0 1];
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


                        temp1 = mean(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1})...
                            (:,fo>=freqRange(1) & fo<=freqRange(2)),2);
                         [num,xPos] = hist(temp1,nBins);
                        normFactor = length(temp1);
                        bar(xPos+(p-1)*diff(xLimits)/nBins/size(ccgs,1),num/normFactor,1/size(ccgs,1),plotColors(p))
%                          temp1 = UnATanCoh(mean(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1));
                       
                        %                     temp1 = temp1(~isnan(temp1));
                        %                     temp2 = temp1(~isnan(temp2));

                        %                     minVal = min([temp1;temp2]);
                        %                     maxVal = max([temp1;temp2]);
                        %                     if minVal == maxVal
                        %                         maxVal = minVal + 1;
                        %                     end
                        %                     minVal = minVal-.1*(maxVal-minVal);
                        %                     maxVal = maxVal+.1*(maxVal-minVal);
                        %                     plot([minVal maxVal],[minVal maxVal])
                        if p==1
                            titleText = cat(1,titleText,...
                            ['n=' num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1))]);
                        end
                    end
                    title(titleText)
                    if p==m 
                        text(xLimits(1)+0.1*xLimits(2),0,[ccgs{p,1:end-1}],'color',plotColors(p))
                    end
                        ylabel({selChanCell{m,1},ccgs{1,1}})
                    set(gca,'xlim',xLimits)
%                     set(gca,'ylim',[0 1])
                end
            end
        end

end





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
                text(freqLim+0.1*freqLim,0,[acgs{p,1:end-1}],'color',plotColors(p))
            end
            if k==1
                ylabel({cellLayers{j},acgs{1,1}})
            end
            if j==length(cellLayers)
                xlabel({acgs{2,1},cellTypes{k}})
            end
            set(gca,'xlim',[-freqLim freqLim])
        end
    end
end

return


%%%%%%%%%%%% each cell plotting %%%%%%%%%%%%%%%

% for c=1:size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{1,1})
cellLayers = {'or','ca1Pyr','rad','gran','hil','ca3Pyr'};
cellTypes = {'w' 'n'};
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
                            %                             & ~isempty(find(~isnan(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(cellLayers{m}).(cellTypes{n}))))

                            try
                            temp1 = ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1})(c,:);
                            %                          temp1 = UnATanCoh(mean(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1));

                            %                     temp1 = temp1(~isnan(temp1));
                            %                     temp2 = temp1(~isnan(temp2));

                            plot(fo,temp1,'color',plotColors(p))
                            end
                            %                     minVal = min([temp1;temp2]);
                            %                     maxVal = max([temp1;temp2]);
                            %                     if minVal == maxVal
                            %                         maxVal = minVal + 1;
                            %                     end
                            %                     minVal = minVal-.1*(maxVal-minVal);
                            %                     maxVal = maxVal+.1*(maxVal-minVal);
                            %                     plot([minVal maxVal],[minVal maxVal])
                            if p==1
                                titleText = cat(1,titleText,...
                                    ['n=' num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1))]);
                            end
                        end
                        title(titleText)
                        if p==m
                            text(freqLim+0.1*freqLim,0,[ccgs{p,1:end-1}],'color',plotColors(p))
                        end
                        ylabel({selChanCell{m,1},ccgs{1,1}})
                        set(gca,'xlim',[0 freqLim])
                        %                     set(gca,'ylim',[0 1])
                end
            end
        end

end


%%%%%%%%%%%% plot coh layerXcell %%%%%%%%%%%
cellLayers = {'or','ca1Pyr','rad','gran','hil','ca3Pyr'};
cellTypes = {'w' 'n'};
plotColors = 'rgbk';
screenHeight = 10;
xyFactor = 1.5;
for j=1:length(cellLayers)
    for k=1:length(cellTypes)
        figure
        titleText = {};

        for m=1:size(selChanCell,1)
            for p=1:size(ccgs,1)
                if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
                        & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1}))

                    numCell = size(ccgs{1,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1);
                    for r=1:numCell
                        subplot(size(selChanCell,1),numCell,(m-1)*numCell+r)
                        hold on

                        temp1 = ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1})(r,:);
                        plot(fo,temp1,'color',plotColors(p))
                            
                        if p==1
                            titleText = cat(1,titleText,...
                                ['n=' num2str(length(temp1))]);
                        end
                        if r==1
                            ylabel({selChanCell{m,1},ccgs{1,1}})
                            if m==1 & p==1
                                titleText = cat(1,titleText,{[cellLayers{j} ',' cellTypes{k}];...
                                    ['Unit Field Coh ' fileExt];...
                                    [' trialMinRate=' num2str(trialRateMin)...
                                    ' cellMinRate=' num2str(cellRateMin)]});
                                title(titleText)
                                                    
                            end
                        end
                        set(gca,'xlim',[0 freqLim])
                    end
                    set(gcf,'units','inches')
                    set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*numCell*xyFactor,screenHeight])
                    set(gcf,'paperposition',get(gcf,'position'))


                    if p==m
                        text(freqLim+0.1*freqLim,0,[ccgs{p,1:end-1}],'color',plotColors(p))
                    end
                    
                    %                     set(gca,'ylim',[0 1])
                end
            end
        end
    end
end





