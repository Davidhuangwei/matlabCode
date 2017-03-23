function PlotUnitSpectrum01(analDirs,spectAnalDir,statsAnalFunc,...
    analRoutine,trialRateMin,cellRateMin,ntapers,varargin)

[freqLim, reportFigBool,saveDir,screenHeight, xyFactor] = ...
    DefaultArgs(varargin,{1000,1,'/u12/smm/public_html/NewFigs/REMPaper/UnitAnal06/',10.5,1.1});

prevWarnSettings = SetWarnings({'off','LoadDesigVar:fileNotFound';...
   'off', 'MATLAB:divideByZero'});

cwd = pwd;

rates = [];
acgs = [];
for j=1:length(analDirs)
    cd(analDirs{j})
    load(['TrialDesig/' statsAnalFunc '/' analRoutine '.mat'])
%     tempRate = Struct2CellArray(MeanDesigVar(1,fileBaseCell,spectAnalDir,...
%         ['unitPowSpec_tapers' num2str(ntapers) '.rate'],trialDesig),[],1);
%     tempCCG = Struct2CellArray(MeanDesigVar(1,fileBaseCell,spectAnalDir,...
%         ['unitPowSpec_tapers' num2str(ntapers) '.yo'],trialDesig),[],1);
    
    tempRate = Struct2CellArray(MeanDesigUnitThresh(fileBaseCell,spectAnalDir,...
        ['unitPowSpec_tapers' num2str(ntapers) '.rate'],...
        ['unitPowSpec_tapers' num2str(ntapers) '.rate'],...
        trialRateMin,trialDesig),[],1);
    tempCCG = Struct2CellArray(MeanDesigUnitThresh(fileBaseCell,spectAnalDir,...
        ['unitPowSpec_tapers' num2str(ntapers) '.yo'],...
        ['unitPowSpec_tapers' num2str(ntapers) '.rate'],...
        trialRateMin,trialDesig),[],1);
    
    keepInd = ones(size(tempRate{1,end}));
    for k=1:size(tempCCG,1)
        % calculate cells with rate < rateMin (in any condition)
%         size(tempCCG{k,end})
        keepInd = keepInd & tempRate{k,end} >= cellRateMin;
%         size(find(keepInd))
        %keepInd
    end
    keyboard
    for k=1:size(tempCCG,1)
         % normalize by firing rate
       tempCCG{k,end} = tempCCG{k,end} ./ repmat(tempRate{k,end},[1,1,size(tempCCG{k,end},3)]);
    end
    for k=1:size(tempCCG,1)
        % remove cells with rates < rateMin
        tempRate{k,end} = tempRate{k,end}(1,keepInd);
        tempCCG{k,end} = tempCCG{k,end}(1,keepInd,:);
        cellLayers = LoadCellLayers([fileBaseCell{1} '/' fileBaseCell{1} '.cellLayer']);
        cellTypes = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
        cellLayers = cellLayers(keepInd,:);
        cellTypes = cellTypes(keepInd,:);
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
fo = LoadField([fileBaseCell{1} '/' spectAnalDir '/' 'unitPowSpec.fo']);
cd(cwd)

keyboard

cellLayers = {'or','ca1Pyr','rad','mol','gran','hil','ca3Pyr'};
cellTypes = {'w' 'n'};
plotColors = 'rgbk';



figure
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
                    {['Unit Spectrum'];...
                    [ 'minRate=' num2str(rateMin)]};
            end
            if isfield(acgs{p,end},cellLayers{j}) & isfield(acgs{p,end}.(cellLayers{j}),cellTypes{k})...

            temp1 = mean(acgs{p,end}.(cellLayers{j}).(cellTypes{k}));
            plot(fo,temp1,'color',plotColors(p))
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
            set(gca,'xlim',[0 freqLim])
        end
    end
end


cellLayers = {'or','ca1Pyr','rad','mol','gran','hil','ca3Pyr'};
cellTypes = {'w' 'n' 'x'}
figure
set(gcf,'units','inches')
set(gcf,'position',[0.5,0.5,screenHeight/length(cellLayers)*length(cellTypes)*xyFactor,screenHeight])
set(gcf,'paperposition',get(gcf,'position'))
minVal = 0;
maxVal = 1;
%cellLayers = fieldnames(rates{1,end});
for m=1:length(cellLayers)
    %cellTypes = rates{1,end}.(cellLayers{m});
    for n=1:length(cellTypes)
            subplot(length(cellLayers),length(cellTypes),(m-1)*length(cellTypes)+n)
            hold on
        if isfield(rates{1,end},cellLayers{m}) & isfield(rates{1,end}.(cellLayers{m}),cellTypes{n})
            plot(rates{1,end}.(cellLayers{m}).(cellTypes{n}),...
                rates{2,end}.(cellLayers{m}).(cellTypes{n}),'.')
            minVal = min([rates{1,end}.(cellLayers{m}).(cellTypes{n});...
                rates{2,end}.(cellLayers{m}).(cellTypes{n})]);
            maxVal = max([rates{1,end}.(cellLayers{m}).(cellTypes{n});...
                rates{2,end}.(cellLayers{m}).(cellTypes{n})]);
            minVal = minVal-.1*(maxVal-minVal);
            maxVal = maxVal+.1*(maxVal-minVal);
            plot([minVal maxVal],[minVal maxVal])
            title(['n=' num2str(size(rates{1,end}.(cellLayers{m}).(cellTypes{n}),1))])
        end 
        if n==1 & m==1
            title({'Unit Spectrum'; 'Firing Rates'})
        end
        if n==1
            ylabel({cellLayers{m},rates{2,1}})
        end
        if m==length(cellLayers)
            xlabel({rates{1,1},cellTypes{n}})
        end
        set(gca,'xlim',[minVal maxVal],'ylim',[minVal maxVal])
    end
end

figure
set(gcf,'units','inches')
set(gcf,'position',[0.5,0.5,screenHeight/length(cellLayers)*length(cellTypes)*xyFactor,screenHeight])
set(gcf,'paperposition',get(gcf,'position'))
minVal = 0;
maxVal = 1;
for m=1:length(cellLayers)
    for n=1:length(cellTypes)
            subplot(length(cellLayers),length(cellTypes),(m-1)*length(cellTypes)+n)
            hold on
            catPlot = [];
            catGroup = {};
            titleText = {};
            if n==1 & m==1
                titleText = cat(2,titleText,{'Unit Spectrum'; 'Firing Rates'});
            end

            for p=1:size(rates,1)
                if isfield(rates{p,end},cellLayers{m}) & isfield(rates{p,end}.(cellLayers{m}),cellTypes{n})
                    catPlot = cat(1,catPlot,rates{p,end}.(cellLayers{m}).(cellTypes{n}));
                    catGroup = cat(1,catGroup,repMat({[rates{p,1:end-1}]},size(rates{p,end}.(cellLayers{m}).(cellTypes{n}))));
                    if p==1
                    titleText = cat(2,titleText,['n=' num2str(size(rates{1,end}.(cellLayers{m}).(cellTypes{n}),1))]);
                    end
                end
            end
            boxplot(catPlot,catGroup)
            ylabel('')
            title(titleText);
                if n==1
                    ylabel(cellLayers{m})
                end
                if m==length(cellLayers)
                    xlabel(cellTypes{n})
                end
%         set(gca,'xlim',[minVal maxVal],'ylim',[minVal maxVal])
    end
end


return


