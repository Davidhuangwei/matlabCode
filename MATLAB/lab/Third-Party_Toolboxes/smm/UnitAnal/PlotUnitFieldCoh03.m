function PlotUnitFieldCoh03(analDirs,fileExt,spectAnalDir,statsAnalFunc,...
    analRoutine,freqLim,trialRateMin,cellRateMin,cohName,ntapers,varargin)
[reportFigBool saveDir] = DefaultArgs(varargin,{1,'/u12/smm/public_html/NewFigs/REMPaper/UnitAnal05/'});

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
    keyboard
end
fo = LoadField([fileBaseCell{1} '/' spectAnalDir '/' 'unitFieldCoh_' cohName '_tapers' num2str(ntapers) '.fo']);
cd(cwd)

if reportFigBool
    close all
end

%%%%%%%%%%%%%%%%% unit Field coh mean %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cellLayers = {'or','ca1Pyr','rad','mol','gran','hil','ca3Pyr'};
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
                        ylabel(selChanCell{m,1})
                    set(gca,'xlim',[0 freqLim])
%                     set(gca,'ylim',[0 1])
                end
            end
        end

end
if reportFigBool
numFigs = length(cellLayers)*length(cellTypes);
ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldCoh') SC(GenFieldName(fileExt))],...
    repmat({['unitFieldCoh' ...
    '_tMin' num2str(trialRateMin) '_cMin'...
    num2str(cellRateMin) '_' cohName '_'...
    'tapers' num2str(ntapers)]},[numFigs 1]));
close all
end

%%%%%%%%%%%%%%%%% unit Field coh mean freqRange %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
freqRangeCell = {[4 12],[40 120]};
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
                tempData = [];
                tempGroup = {};
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
                        tempData = cat(1,tempData,temp1);
                        tempGroup = cat(1,tempGroup,repmat({[ccgs{p,1:end-1}]},size(temp1)));
                        if p==1
                            titleText = cat(1,titleText,...
                            ['n=' num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1))]);
                        end
                    end
                    title(SaveTheUnderscores(titleText))
%                     if p==m 
%                         text(xLimits(1)+0.1*xLimits(2),0,[ccgs{p,1:end-1}],'color',plotColors(p))
%                     end
%                         ylabel(selChanCell{m,1})
%                     set(gca,'xlim',xLimits)
%                     set(gca,'ylim',[0 1])
                end
                if ~isempty(tempData)
                try 
                    boxplot(tempData,tempGroup)
                end
                end
                ylabel(selChanCell{m,1})
            end
    end
end
if reportFigBool
    numFigs = length(cellLayers)*length(cellTypes);
    ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldCoh') SC(GenFieldName(fileExt))],...
        repmat({['unitFieldCoh' ...
        num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'...
        '_tMin' num2str(trialRateMin) '_cMin'...
        num2str(cellRateMin) '_' cohName '_'...
        'tapers' num2str(ntapers)]},[numFigs 1]));
    close all
end
end



%%%%%%%%%%%% plot coh layerXcell %%%%%%%%%%%
cellLayers = {'or','ca1Pyr','rad','mol','gran','hil','ca3Pyr'};
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
                            ylabel({selChanCell{m,1}})
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

if reportFigBool
numFigs = length(cellLayers)*length(cellTypes);
ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldCoh') SC(GenFieldName(fileExt))],...
    repmat({['unitFieldCoh_eachCell' ...
    '_tMin' num2str(trialRateMin) '_cMin'...
    num2str(cellRateMin) '_' cohName '_'...
    'tapers' num2str(ntapers)]},[numFigs 1]));
close all
end


return





