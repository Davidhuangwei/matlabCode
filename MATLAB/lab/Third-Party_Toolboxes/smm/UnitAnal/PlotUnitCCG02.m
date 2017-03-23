function PlotUnitCCG01(analDirs,fileBaseCell,winLen,spectAnalDir,varargin)


prevWarnSettings = SetWarnings({'off','LoadDesigVar:fileNotFound'});


analDirs = {...
    '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-17-04/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/',...
    };

% spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
% analRoutine = 'AlterGood_S0_A0_MR'
% statsAnalFunc = 'GlmWholeModel05';
%spectAnalDir = 'CalcRunningSpectra14_noExp_MinSpeed5wavParam6Win1250.eeg/';
spectAnalDir = 'RemVsRun03_noExp_MinSpeed5wavParam6Win1250.eeg';
analRoutine = 'RemVsMaze_Beh'
statsAnalFunc = 'GlmWholeModel08';
% spectAnalDir = 'RemVsRun02_noExp_MinSpeed0Win1250wavParam6.eeg/';
% analRoutine = 'RemVsMaze_Beh';
% statsAnalFunc = 'GlmWholeModel07';
%load(['TrialDesig/' statsAnalFunc '/' analRoutine '.mat'])

selAnatRegions = {'or','ca1Pyr','rad','lm','mol','gran','hil','ca3Pyr','noLayer'};
cellTypeLabels = {'w' 'n' 'x'}

cwd = pwd;
datSamp = 20000;
eegSamp = 1250;
winLen = 626;
normalization = 'scale';
binSize = 3;

Behave X Layer X Type X Layer X Type


% rates = [];
% rates = EmptyStruct({selAnatRegions,cellTypeLabels});
% acgs = EmptyStruct({selAnatRegions,cellTypeLabels});
% ccgs = EmptyStruct({selAnatRegions,cellTypeLabels,selAnatRegions,cellTypeLabels});
rates = struct([]);
acgs = struct([]);
ccgs = struct([]);
rates = [];
acgs = [];
ccgs = [];
for j=1:length(analDirs)
    cd(analDirs{j})
    load(['TrialDesig/' statsAnalFunc '/' analRoutine '.mat'])
    cellLayers = LoadField([fileBaseCell{1} '/' spectAnalDir '/unitCCGBin' num2str(binSize) normalization '.cellLayer']);
    cellTypes = LoadField([fileBaseCell{1} '/' spectAnalDir '/unitCCGBin' num2str(binSize) normalization '.cellType']);
    tempRate = Struct2CellArray(MeanDesigVar(1,fileBaseCell,spectAnalDir,['unitCCGBin' num2str(binSize) normalization '.rate'],trialDesig),[],1);
    tempCCG = Struct2CellArray(MeanDesigVar(1,fileBaseCell,spectAnalDir,['unitCCGBin' num2str(binSize) normalization '.yo'],trialDesig),[],1);
    size(tempRate{1,2})
    for k=1:size(tempRate,1)
        if isempty(rates) 
            rates = tempRate;
            acgs = tempRate;
            ccgs = tempRate;
        end
        if ~isstruct(rates{k,end})
            rates{k,end} = struct([]);
            acgs{k,end} = struct([]);
            ccgs{k,end} = struct([]);
        end
       rates{k,end} = UnionStructMatCat(1,rates{k,end},SortRates2LayerTypes(tempRate{k,end},cellLayers,cellTypes));
       acgs{k,end} = UnionStructMatCat(1,acgs{k,end},SortACG2LayerTypes(squeeze(tempCCG{k,end}),cellLayers,cellTypes));
      ccgs{k,end} = UnionStructMatCat(1,ccgs{k,end},SortCCG2LayerTypes(squeeze(tempCCG{k,end}),cellLayers,cellTypes));
    end
end
cd(cwd)

% 2 axis scatter plot
figure(1)
clf
cellLayers = {'or','ca1Pyr','rad','lm','mol','gran','hil','ca3Pyr','noLayer'};
cellTypes = {'w' 'n' 'x'}
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
            title('Unit Firing Rates')
        end
        if n==1
            ylabel({cellLayers{m},rates{1,1}})
        end
        if m==length(cellLayers)
            xlabel({rates{2,1},cellTypes{n}})
        end
        set(gca,'xlim',[minVal maxVal],'ylim',[minVal maxVal])
    end
end


% acg plot
figure(1)
clf
cellLayers = {'or','ca1Pyr','rad','lm','mol','gran','hil','ca3Pyr','noLayer'};
cellTypes = {'w' 'n' 'x'}
plotColors = 'rgbk';
for j=1:size(acgs,1)
for m=1:length(cellLayers)
    for n=1:length(cellTypes)
            subplot(length(cellLayers),length(cellTypes),(m-1)*length(cellTypes)+n)
            hold on
        if isfield(acgs{1,end},cellLayers{m}) & isfield(acgs{1,end}.(cellLayers{m}),cellTypes{n})
            plot(acgs{1,end}.(cellLayers{m}).(cellTypes{n}),...
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
            title('Unit Firing Rates')
        end
        if n==1
            ylabel({cellLayers{m},rates{1,1}})
        end
        if m==length(cellLayers)
            xlabel({rates{2,1},cellTypes{n}})
        end
        set(gca,'xlim',[minVal maxVal],'ylim',[minVal maxVal])
    end
end




    
    
    junk = CCG2LayerTypes(squeeze(tempCCG.maze),cellLayer,cellType);
rates = SortRates2LayerTypes(squeeze(tempRate.maze),cellLayers,cellTypes);
 plot(to,ConvTrim(median(junk.ca1Pyr.w.ca3Pyr.w),ones(3,1)))

CCGCells2LayerTypes
    for k=1:length(cellLayer)
        
    
    
    
    if isempty(meanCCG)
        meanCCG = tempCCG;
    else
        meanCCG = CatStruct(1,meanCCG,tempCCG);
    end
end
        
        
        sumCCG = [];
        sumRate = [];
        catN = 0;
        for k=1:length(fileBaseCell)
%             tempCCG = LoadVar([analDirs{j} fileBaseCell{k} '/' ...
%                 spectAnalDir 'unitCCGBin' num2str(binSize) normalization '.mat']);


            tempCCG = Struct2CellArray(LoadDesigVar(fileBaseCell(k),spectAnalDir,['unitCCGBin' num2str(binSize) normalization '.yo'],trialDesig),[],1);
            tempCCG = Struct2CellArray(LoadDesigVar(fileBaseCell(k),spectAnalDir,['unitCCGBin' num2str(binSize) normalization '.yo'],trialDesig),[],1);
            tempRate = Struct2CellArray(LoadDesigVar(fileBaseCell(k),spectAnalDir,['unitCCGBin' num2str(binSize) normalization '.rate'],trialDesig),[],1);
            tempTo = LoadField([fileBaseCell{k} '/' spectAnalDir '/unitCCGBin' num2str(binSize) normalization '.to']);
            for m=1:size(tempCCGCell,1)
                if ~isempty(tempCCG{m,2})
                    tempCCG{m,2}(isnan(tempCCG{m,2}(:))) = 0;
                    if isempty(sumCCG)
                        sumCCG(m,:,:,:) = sum(tempCCG{m,2});
                        sumRate(m) = sum(tempRate{m,2});
                    else
                        sumCCG(m,:,:,:) = sumCCG + sum(tempCCG{m,2});
                        sumRate(m) = sumRate + sum(tempRate{m,2});
                    end
                    catN(m) = catN(m) + size(tempRate{m,2},1);
                    if ~isempty(to) & to~=tempTo
                        ERROR_to~=to
                    else
                        to = tempTo;
                    end
                end
        end
        meanCCG{m} = cat(1,meanCCG{m},squeeze(sumCCG/catN));
        meanRate{m} = cat(1,meanRate{m},squeeze(sumRate/catN));
        cellLayers = cat(1,cellLayers,...
            LoadField([fileBaseCell{k} '/' spectAnalDir '/unitCCGBin' num2str(binSize) normalization '.cellLayer']););
        cellTypes = cat(1,cellTypes,...
            LoadField([fileBaseCell{k} '/' spectAnalDir '/unitCCGBin' num2str(binSize) normalization '.cellType']););
    end
end

    m=1
for y=1:27
    for z=1:27
        if z<=y
            if sum(meanRate{m}(:,y))>0 & sum(meanRate{m}(:,z))>0 & sum(meanCCG{m}(y,z,:))>0
                subplot(27,27,(y-1)*27+z)
                plot(to,squeeze(meanCCG{m}(y,z,:)))
                title(['ch:' num2str(y) ',' num2str(meanRate{m}(:,y),2) ...
                    ';' num2str(z) ',' num2str(meanRate{m}(:,z),2)])
                set(gca,'xlim',[-200 200])
            end
        end
    end
end
   


%%% plot CCG scaled %%%
figure
clf
set(gcf,'name','UnitPopACGScaled')
set(gcf,'unit','inches')
set(gcf,'position',[0.5 0.5 3*length(cellTypeLabels) 1.1*length(selAnatRegions) ])
set(gcf,'paperposition',[0.5 0.5 3*length(cellTypeLabels) 1.1*length(selAnatRegions)])
timeInterval = [0 200];
plotColors = 'bgrcmk'
warning('off','MATLAB:divideByZero')
% cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        for j=1:length(mazeLocFieldNames)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
%             plot(to,squeeze(sum(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k})))...
%                 ,'color',plotColors(j));
            scaleFactor = winLen/eegSamp*datSamp*...
                size(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}),1)/...
                (binSize*(sum(winLen/eegSamp*...
                firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))).^2);

            plot(to,squeeze(sum(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))./...
                repmat(scaleFactor, ...
                [1,1,size(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}),3)])),'color',plotColors(j));
            
%             plot(to,squeeze(mean(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))),'color',plotColors(j));
            if j==1
            titleText = [titleText cellTypeLabels{k} '=' num2str(sum(nCellsStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ',trialn='];
            end
            titleText = [titleText num2str(length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ','];
            
            ylabel(selAnatRegions{m})
            set(gca,'xlim',timeInterval)
           xLimits = get(gca,'xlim');
            if m==1 & k==1
                text(xLimits(2),0-j*diff(get(gca,'ylim'))/2,mazeLocFieldNames{j},'color',plotColors(j))
            end
            if m==length(selAnatRegions) & k==2
                xlabel(['binSize=' num2str(binSize) 'ms, rateThresh=' num2str(rateThresh)])
            end
            %set(gca,'xlim',[to(1) to(end)],'ylim',[0.5 1.5]);
        end
        title(titleText)
    end
end









    meanRate = mean(unitCCG.rate,across trials)
    if ~isempty(to) & to~=unitCCG.to
        ERROR_to~=to
    else
        to = unitCCG.to
    end
    for length(selAnatRegions)
        for length(cellTypeLabels)
            rate
    

cellTypesVecAll = {};
chanLayerVecAll = {};
firingRateStruct = [];
trialsByCellsAll = [];
rateThresh = 10;
for a=1:length(analDirs)
    cd(analDirs{a})
    fileBaseCell = LoadVar('FileInfo/AlterFiles');
%     timeWin = LoadField([fileBaseCell{1} '/' spectAnalDir 'unitPopACGBin' num2str(binSize)  normalization '.infoStruct.timeWin']);
    datSamp = LoadField([fileBaseCell{1} '/' spectAnalDir 'unitPopACGBin' num2str(binSize)  normalization '.infoStruct.datSamp']);
    %chanLoc = LoadVar(['ChanInfo/ChanLoc_' chanLocVersion '.eeg.mat']);
    chanLocNames = selAnatRegions;
    %chanLocNames = fieldnames(chanLoc);
    rateTrialsByCells = [];
    spectTrialsByCells = [];
    mazeLocVec = {};
    dirName = [spectAnalDir];
    load(['TrialDesig/' statsAnalFunc '/' analRoutine '.mat'])
    for m=1:length(chanLocNames)
        for n=1:length(cellTypeLabels)
            rateTrialsByCells = LoadDesigVar(fileBaseCell,dirName,['unitPopACGBin' num2str(binSize)  '.' chanLocNames{m} '.' cellTypeLabels{n} '.rate'],trialDesig);
            spectTrialsByCells = LoadDesigVar(fileBaseCell,dirName,['unitPopACGBin' num2str(binSize)  '.' chanLocNames{m} '.' cellTypeLabels{n} '.yo'],trialDesig);
            to = LoadField([fileBaseCell{1} '/' spectAnalDir 'unitPopACGBin' num2str(binSize)  '.' chanLocNames{m} '.' cellTypeLabels{n} '.to']);
            nCells = LoadField([fileBaseCell{1} '/' spectAnalDir 'unitPopACGBin' num2str(binSize)  '.' chanLocNames{m} '.' cellTypeLabels{n} '.nCells']);
%             rateTrialsByCells = LoadDesigVar(fileBaseCell,dirName,['unitPopACGBin' num2str(binSize) normalization '.' chanLocNames{m} '.' cellTypeLabels{n} '.rate'],trialDesig);
%             spectTrialsByCells = LoadDesigVar(fileBaseCell,dirName,['unitPopACGBin' num2str(binSize) normalization '.' chanLocNames{m} '.' cellTypeLabels{n} '.yo'],trialDesig);
%             to = LoadField([fileBaseCell{1} '/' spectAnalDir 'unitPopACGBin' num2str(binSize) normalization '.' chanLocNames{m} '.' cellTypeLabels{n} '.to']);
%             nCells = LoadField([fileBaseCell{1} '/' spectAnalDir 'unitPopACGBin' num2str(binSize) normalization '.' chanLocNames{m} '.' cellTypeLabels{n} '.nCells']);

            mazeLocFieldNames = fieldnames(rateTrialsByCells);
            for j=1:length(mazeLocFieldNames)
                if a==1 
                    firingRateStruct.(mazeLocFieldNames{j}).(chanLocNames{m}).(cellTypeLabels{n}) = ...
                        (rateTrialsByCells.(mazeLocFieldNames{j})(rateTrialsByCells.(mazeLocFieldNames{j})>rateThresh));
                    firingSpectStruct.(mazeLocFieldNames{j}).(chanLocNames{m}).(cellTypeLabels{n}) = ...
                        (spectTrialsByCells.(mazeLocFieldNames{j})(rateTrialsByCells.(mazeLocFieldNames{j})>rateThresh,:,:));
                    nCellsStruct.(mazeLocFieldNames{j}).(chanLocNames{m}).(cellTypeLabels{n}) = nCells;
                else
                    firingRateStruct.(mazeLocFieldNames{j}).(chanLocNames{m}).(cellTypeLabels{n}) = ...
                        cat(1,firingRateStruct.(mazeLocFieldNames{j}).(chanLocNames{m}).(cellTypeLabels{n}),...
                        (rateTrialsByCells.(mazeLocFieldNames{j})(rateTrialsByCells.(mazeLocFieldNames{j})>rateThresh)));
                    firingSpectStruct.(mazeLocFieldNames{j}).(chanLocNames{m}).(cellTypeLabels{n}) = ...
                        cat(1,firingSpectStruct.(mazeLocFieldNames{j}).(chanLocNames{m}).(cellTypeLabels{n}),...
                        (spectTrialsByCells.(mazeLocFieldNames{j})(rateTrialsByCells.(mazeLocFieldNames{j})>rateThresh,:,:)));
                    nCellsStruct.(mazeLocFieldNames{j}).(chanLocNames{m}).(cellTypeLabels{n}) = ...
                        cat(1,nCellsStruct.(mazeLocFieldNames{j}).(chanLocNames{m}).(cellTypeLabels{n}),nCells);
                end

            end
           cellTypesVecAll = cat(2,cellTypesVecAll,cellTypeLabels{n});
            chanLayerVecAll = cat(2,chanLayerVecAll,chanLocNames{m});
        end
    end
end
cd(cwd);


%%% plot CCG scaled %%%
figure
clf
set(gcf,'name','UnitPopACGScaled')
set(gcf,'unit','inches')
set(gcf,'position',[0.5 0.5 3*length(cellTypeLabels) 1.1*length(selAnatRegions) ])
set(gcf,'paperposition',[0.5 0.5 3*length(cellTypeLabels) 1.1*length(selAnatRegions)])
timeInterval = [0 200];
plotColors = 'bgrcmk'
warning('off','MATLAB:divideByZero')
% cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        for j=1:length(mazeLocFieldNames)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
%             plot(to,squeeze(sum(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k})))...
%                 ,'color',plotColors(j));
            scaleFactor = winLen/eegSamp*datSamp*...
                size(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}),1)/...
                (binSize*(sum(winLen/eegSamp*...
                firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))).^2);

            plot(to,squeeze(sum(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))./...
                repmat(scaleFactor, ...
                [1,1,size(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}),3)])),'color',plotColors(j));
            
%             plot(to,squeeze(mean(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))),'color',plotColors(j));
            if j==1
            titleText = [titleText cellTypeLabels{k} '=' num2str(sum(nCellsStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ',trialn='];
            end
            titleText = [titleText num2str(length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ','];
            
            ylabel(selAnatRegions{m})
            set(gca,'xlim',timeInterval)
           xLimits = get(gca,'xlim');
            if m==1 & k==1
                text(xLimits(2),0-j*diff(get(gca,'ylim'))/2,mazeLocFieldNames{j},'color',plotColors(j))
            end
            if m==length(selAnatRegions) & k==2
                xlabel(['binSize=' num2str(binSize) 'ms, rateThresh=' num2str(rateThresh)])
            end
            %set(gca,'xlim',[to(1) to(end)],'ylim',[0.5 1.5]);
        end
        title(titleText)
    end
end


%%%% plot rate boxplot %%%%
figure
clf
set(gcf,'name','UnitPopRate')
set(gcf,'unit','inches')
set(gcf,'position',[0.5 0.5 3*length(cellTypeLabels) 1.1*length(selAnatRegions) ])
set(gcf,'paperposition',[0.5 0.5 3*length(cellTypeLabels) 1.1*length(selAnatRegions)])
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
        hold on
        catRate = [];
        catGroup = {};
        for j=1:length(mazeLocFieldNames)
            if length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))
                catRate = cat(1,catRate,firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}));
                catGroup = cat(1,catGroup,repmat(mazeLocFieldNames(j),...
                    [length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k})),1]));
            else
                catRate = cat(1,catRate,1);
                catGroup = cat(1,catGroup,mazeLocFieldNames(j));
            end
            if j==1
                titleText = [titleText cellTypeLabels{k} '=' num2str(sum(nCellsStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ',trialn='];
            end
            titleText = [titleText num2str(length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ','];
            if m==length(selAnatRegions)
                text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
            end
        end
        if ~isempty(catRate)
           boxplot(catRate,catGroup,'grouporder',mazeLocFieldNames)
        end
        set(gca,'xtick',[]);
        set(gca,'xlim',[0 length(mazeLocFieldNames)+1]);
        ylabel(selAnatRegions{m})
        if m==1 & k==2
            titleText = {['binSize=' num2str(binSize) 'ms, ' normalization ', rateThresh=' num2str(rateThresh) ]; titleText};
        end
        title(titleText)
    end
end


%%% plot rate %%%
figure
clf
set(gcf,'name','UnitPopRate')
set(gcf,'unit','inches')
set(gcf,'position',[0.5 0.5 3*length(cellTypeLabels) 1.1*length(selAnatRegions) ])
set(gcf,'paperposition',[0.5 0.5 3*length(cellTypeLabels) 1.1*length(selAnatRegions)])
plotColors = 'bgrcmk'
%cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        catRate = [];
        catGroup = {};
        subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
        for j=1:length(mazeLocFieldNames)
%             hold on
%             plot(j,mean(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))...
%                 ,'o');
            catRate = cat(1,catRate,firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}));
            catGroup = cat(1,catGroup,repmat(mazeLocFieldNames(j),...
                [length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k})),1]));
            if j==1
                titleText = [titleText cellTypeLabels{k} '=' num2str(sum(nCellsStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ',trialn='];
            end
            titleText = [titleText num2str(length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ','];
            if m==length(selAnatRegions)
                text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
            end
        end
        if ~isempty(catRate)
           boxplot(catRate,catGroup,'grouporder',mazeLocFieldNames)
        end
        ylabel(selAnatRegions{m})
        set(gca,'xtick',[],'xlim',[0 length(mazeLocFieldNames)+1]);
        if m==1 & k==2
            titleText = {['rateThresh=' num2str(rateThresh)]; titleText};
        end
        title(titleText)
    end
end


%%%% plot theta modulation %%%%
thetaFreqRange = [6 12];
figure
clf
set(gcf,'name','UnitPopThetaACG')
set(gcf,'unit','inches')
set(gcf,'position',[0.5 0.5 3*length(cellTypeLabels) 1.1*length(selAnatRegions) ])
set(gcf,'paperposition',[0.5 0.5 3*length(cellTypeLabels) 1.1*length(selAnatRegions)])
plotColors = 'bgrcmk'
%cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
        hold on
        catSpect = [];
        catGroup = {};
        for j=1:length(mazeLocFieldNames)
            if length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))
                temp = squeeze(sum(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))./...
                    repmat(binSize/datSamp*sum(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k})).^2, ...
                    [1,1,size(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}),3)]));
                catSpect = cat(1,catSpect,mean(temp(to<=1/thetaFreqRange(1)*1000 & to>=1/thetaFreqRange(2)*1000)));

                catGroup = cat(1,catGroup,mazeLocFieldNames(j));
%                 catSpect = cat(1,catSpect,squeeze(mean(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k})...
%                     (:,:,to<=1/thetaFreqRange(1)*1000 & to>=1/thetaFreqRange(2)*1000),3)));
%                 ./repmat(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}),...
%                     [1,1,sum(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))]),3)));
%                 catGroup = cat(1,catGroup,repmat(mazeLocFieldNames(j),...
%                     [length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k})),1]));
            else
                catSpect = cat(1,catSpect,1);
                catGroup = cat(1,catGroup,mazeLocFieldNames(j));
            end
            if j==1
                titleText = [titleText cellTypeLabels{k} '=' num2str(sum(nCellsStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ',trialn='];
            end
            titleText = [titleText num2str(length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ','];
            if m==length(selAnatRegions)
                text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
            end
        end
        if ~isempty(catSpect)
           boxplot(catSpect,catGroup,'grouporder',mazeLocFieldNames)
        end
        set(gca,'xtick',[]);
        set(gca,'xlim',[0 length(mazeLocFieldNames)+1]);
        ylabel(selAnatRegions{m})
        if m==1 & k==2
            titleText = {['thetaFreqRange=' num2str(thetaFreqRange) ', binSize=' num2str(binSize) 'ms, ' normalization ', rateThresh=' num2str(rateThresh) ]; titleText};
        end
        title(titleText)
    end
end


%%%% plot Gamma modulation %%%%
gammaFreqRange = [40 100];
figure
clf
set(gcf,'name','UnitPopGammaACG')
set(gcf,'unit','inches')
set(gcf,'position',[0.5 0.5 3*length(cellTypeLabels) 1.1*length(selAnatRegions) ])
set(gcf,'paperposition',[0.5 0.5 3*length(cellTypeLabels) 1.1*length(selAnatRegions)])
plotColors = 'bgrcmk'
%cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
        hold on
        catSpect = [];
        catGroup = {};
        for j=1:length(mazeLocFieldNames)
            if length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))
                catSpect = cat(1,catSpect,squeeze(mean(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k})...
                    (:,:,to<=1/gammaFreqRange(1)*1000 & to>=1/gammaFreqRange(2)*1000),3)));
%                 ./repmat(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}),...
%                     [1,1,sum(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))]),3)));
                catGroup = cat(1,catGroup,repmat(mazeLocFieldNames(j),...
                    [length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k})),1]));
            else
                catSpect = cat(1,catSpect,1);
                catGroup = cat(1,catGroup,mazeLocFieldNames(j));
            end
            if j==1
                titleText = [titleText cellTypeLabels{k} '=' num2str(sum(nCellsStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ',trialn='];
            end
            titleText = [titleText num2str(length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ','];
            if m==length(selAnatRegions)
                text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
            end
        end
        if ~isempty(catSpect)
           boxplot(catSpect,catGroup,'grouporder',mazeLocFieldNames)
        end
        set(gca,'xtick',[]);
        set(gca,'xlim',[0 length(mazeLocFieldNames)+1]);
        ylabel(selAnatRegions{m})
        if m==1 & k==2
            titleText = {['gammaFreqRange=' num2str(gammaFreqRange) ', binSize=' num2str(binSize) 'ms, ' normalization ', rateThresh=' num2str(rateThresh) ]; titleText};
        end
        title(titleText)
    end
end


%%%% plot Burst modulation %%%%
burstFreqRange = [100 10000];
figure
clf
set(gcf,'name','UnitPopBurstACG')
set(gcf,'unit','inches')
set(gcf,'position',[0.5 0.5 3*length(cellTypeLabels) 1.1*length(selAnatRegions) ])
set(gcf,'paperposition',[0.5 0.5 3*length(cellTypeLabels) 1.1*length(selAnatRegions)])
plotColors = 'bgrcmk'
%cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
        hold on
        catSpect = [];
        catGroup = {};
        for j=1:length(mazeLocFieldNames)
            if length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))
                catSpect = cat(1,catSpect,squeeze(mean(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k})...
                    (:,:,to<=1/burstFreqRange(1)*1000 & to>=1/burstFreqRange(2)*1000),3)));
%                 ./repmat(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}),...
%                     [1,1,sum(fo>=burstFreqRange(1) & fo<=burstFreqRange(2))]),3)));
                catGroup = cat(1,catGroup,repmat(mazeLocFieldNames(j),...
                    [length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k})),1]));
            else
                catSpect = cat(1,catSpect,1);
                catGroup = cat(1,catGroup,mazeLocFieldNames(j));
            end
            if j==1
                titleText = [titleText cellTypeLabels{k} '=' num2str(sum(nCellsStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ',trialn='];
            end
            titleText = [titleText num2str(length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ','];
            if m==length(selAnatRegions)
                text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
            end
        end
        if ~isempty(catSpect)
           boxplot(catSpect,catGroup,'grouporder',mazeLocFieldNames)
        end
        set(gca,'xtick',[]);
        set(gca,'xlim',[0 length(mazeLocFieldNames)+1]);
        ylabel(selAnatRegions{m})
        if m==1 & k==2
            titleText = {['burstFreqRange=' num2str(burstFreqRange) ', binSize=' num2str(binSize) 'ms, ' normalization ', rateThresh=' num2str(rateThresh) ]; titleText};
        end
        title(titleText)
    end
end



%%%%%%%%%%%%%%%%%%


% %%%% plot theta modulation %%%%
% thetaFreqRange = [6 10];
% figure
% clf
% set(gcf,'name','UnitPopThetaACG')
% plotColors = 'bgrcmk'
% %cellTypeLabels = ['w' 'n']
% for m=1:length(selAnatRegions)
%     for k=1:length(cellTypeLabels)
%         titleText = [];
%         for j=1:length(mazeLocFieldNames)
%             subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
%             hold on
%             meanSpect = squeeze(mean(mean(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k})...
%                 (:,:,to<=1/thetaFreqRange(1)*1000 & to>=1/thetaFreqRange(2)*1000),1),3));
%             plot([j j],meanSpect,'o');
%             if j==1
%                 titleText = [titleText cellTypeLabels{k} '=' num2str(sum(nCellsStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ',trialn='];
%             end
%             titleText = [titleText num2str(length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ','];
%             ylabel(selAnatRegions{m})
%             set(gca,'xtick',[],'xlim',[0 length(mazeLocFieldNames)+1]);
%             if m==length(selAnatRegions)
%                 text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
%             end
%         end
%         if m==1 & k==2
%             titleText = {['thetaFreqRange=' num2str(thetaFreqRange) ', binSize=' num2str(binSize) 'ms' ', rateThresh=' num2str(rateThresh) ]; titleText};
%         end
%         title(titleText)
%     end
% end


%%%% plot theta modulation %%%%
thetaFreqRange = [8 12];
figure
clf
set(gcf,'name','UnitPopThetaACG')
plotColors = 'bgrcmk'
%cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        for j=1:length(mazeLocFieldNames)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            meanSpect = squeeze(mean(mean(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k})...
                (:,:,to<=1/thetaFreqRange(1)*1000 & to>=1/thetaFreqRange(2)*1000),3),1));
            stdSpect = squeeze(std(mean(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k})...
                (:,:,to<=1/thetaFreqRange(1)*1000 & to>=1/thetaFreqRange(2)*1000),3)));
            plot([j j],meanSpect,'o');
            plot([j j],meanSpect+[stdSpect -stdSpect],'-');

            if j==1
                titleText = [titleText cellTypeLabels{k} '=' num2str(sum(nCellsStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ',trialn='];
            end
            titleText = [titleText num2str(length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ','];
            ylabel(selAnatRegions{m})
            set(gca,'xtick',[],'xlim',[0 length(mazeLocFieldNames)+1]);
            if m==length(selAnatRegions)
                text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
            end
        end
        if m==1 & k==2
            titleText = {['thetaFreqRange=' num2str(thetaFreqRange) ', binSize=' num2str(binSize) 'ms' ', rateThresh=' num2str(rateThresh) ]; titleText};
        end
        title(titleText)
    end
end

%%%% plot gamma modulation %%%%
gammaFreqRange = [40 100];
figure
clf
set(gcf,'name','UnitPopGammaACG')
plotColors = 'bgrcmk'
%cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        for j=1:length(mazeLocFieldNames)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            meanSpect = squeeze(mean(mean(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k})...
                (:,:,to<=1/gammaFreqRange(1)*1000 & to>=1/gammaFreqRange(2)*1000),3),1));
            stdSpect = squeeze(std(mean(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k})...
                (:,:,to<=1/gammaFreqRange(1)*1000 & to>=1/gammaFreqRange(2)*1000),3)));
            plot([j j],meanSpect,'o');
            plot([j j],meanSpect+[stdSpect -stdSpect],'-');

            if j==1
                titleText = [titleText cellTypeLabels{k} '=' num2str(sum(nCellsStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ',trialn='];
            end
            titleText = [titleText num2str(length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ','];
            ylabel(selAnatRegions{m})
            set(gca,'xtick',[],'xlim',[0 length(mazeLocFieldNames)+1]);
            if m==length(selAnatRegions)
                text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
            end
        end
        if m==1 & k==2
            titleText = {['gammaFreqRange=' num2str(gammaFreqRange) ', binSize=' num2str(binSize) 'ms' ', rateThresh=' num2str(rateThresh) ]; titleText};
        end
        title(titleText)
    end
end


burstTimeRange = [0 10];
figure
clf
set(gcf,'name','UnitPopBurstACG')
plotColors = 'bgrcmk'
%cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        for j=1:length(mazeLocFieldNames)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            meanSpect = squeeze(mean(mean(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k})...
                (:,:,to>=burstTimeRange(1) & to<=burstTimeRange(2)),3),1));
            stdSpect = squeeze(std(mean(firingSpectStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k})...
                (:,:,to>=burstTimeRange(1) & to<=burstTimeRange(2)),3)));
            plot([j j],meanSpect,'o');
            plot([j j],meanSpect+[stdSpect -stdSpect],'-');

            if j==1
                titleText = [titleText cellTypeLabels{k} '=' num2str(sum(nCellsStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ',trialn='];
            end
            titleText = [titleText num2str(length(firingRateStruct.(mazeLocFieldNames{j}).(selAnatRegions{m}).(cellTypeLabels{k}))) ','];
            ylabel(selAnatRegions{m})
            set(gca,'xtick',[],'xlim',[0 length(mazeLocFieldNames)+1]);
            if m==length(selAnatRegions)
                text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
            end
        end
        if m==1 & k==2
            titleText = {['burstTimeRange=' num2str(burstTimeRange) ', binSize=' num2str(binSize) 'ms' ', rateThresh=' num2str(rateThresh) ]; titleText};
        end
        title(titleText)
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%% plot CCG norm by rate %%%
figure
clf
timeInterval = [-250 250];
plotColors = 'bgrcmk'
%cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        for j=1:length(mazeLocFieldNames)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            chanInd = strcmp(chanLayerVecAll,selAnatRegions{m})...
                    & strcmp(cellTypesVecAll,cellTypeLabels{k})...
                    & firingRateStruct.(mazeLocFieldNames{j})(1,:)>0;
            if sum(chanInd)>0
                plot(to,squeeze(mean(firingSpectStruct.(mazeLocFieldNames{j})(:,chanInd,:)./...
                    repmat(firingRateStruct.(mazeLocFieldNames{j})(:,chanInd),...
                    [1,1,size(firingSpectStruct.(mazeLocFieldNames{j}),3)]),2)),'color',plotColors(j));
            end
            titleText = [titleText ',' cellTypeLabels{k} '=' num2str(sum(chanInd))];
            ylabel(selAnatRegions{m})
            set(gca,'xlim',timeInterval)
            xLimits = get(gca,'xlim');
            if m==1 & k==1
                text(xLimits(2),0-j*diff(get(gca,'ylim'))/2,mazeLocFieldNames{j},'color',plotColors(j))
            end
            %set(gca,'xlim',[to(1) to(end)],'ylim',[0.5 1.5]);
        end
        title(titleText)
    end
end

%%% plot raw CCG %%%
figure
clf
timeInterval = [-250 250];
plotColors = 'bgrcmk'
% cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        for j=1:length(mazeLocFieldNames)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            chanInd = strcmp(chanLayerVecAll,selAnatRegions{m})...
                    & strcmp(cellTypesVecAll,cellTypeLabels{k})...
                    & firingRateStruct.(mazeLocFieldNames{j})(1,:)>0.1;
            if sum(chanInd)>0
                plot(to,squeeze(mean(firingSpectStruct.(mazeLocFieldNames{j})(:,chanInd,:),2)),'color',plotColors(j));
            end
            titleText = [titleText ',' cellTypeLabels{k} '=' num2str(sum(chanInd))];
            ylabel(selAnatRegions{m})
            set(gca,'xlim',timeInterval)
           xLimits = get(gca,'xlim');
            if m==1 & k==1
                text(xLimits(2),0-j*diff(get(gca,'ylim'))/2,mazeLocFieldNames{j},'color',plotColors(j))
            end
            %set(gca,'xlim',[to(1) to(end)],'ylim',[0.5 1.5]);
        end
        title(titleText)
    end
end

%%% plot rate %%%
figure
clf
%cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        for j=1:length(mazeLocFieldNames)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            chanInd = strcmp(chanLayerVecAll,selAnatRegions{m})...
                    & strcmp(cellTypesVecAll,cellTypeLabels{k})...
                    & firingRateStruct.(mazeLocFieldNames{j})(1,:)>0;
            if sum(chanInd)>0
                plot(j,mean(firingRateStruct.(mazeLocFieldNames{j})(:,chanInd),2),'o');
            end
            titleText = [titleText ',' cellTypeLabels{k} '=' num2str(sum(chanInd))];
            ylabel(selAnatRegions{m})
            %if m==1 & k==1
            %    text(to(end),0-j*diff(get(gca,'ylim'))/2,mazeLocFieldNames{j},'color',plotColors(j))
            %end
            %set(gca,'xlim',[to(1) to(end)],'ylim',[0.5 1.5]);
            set(gca,'xtick',[],'xlim',[0 length(mazeLocFieldNames)+1]);
            if m==length(selAnatRegions)
                text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
            end
        end
        title(titleText)
    end
end


%%% plot rate1 vs rate2 %%%
figure
clf
%cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
        hold on
        chanInd = strcmp(chanLayerVecAll,selAnatRegions{m})...
            & strcmp(cellTypesVecAll,cellTypeLabels{k});
        %                    & firingRateStruct.(mazeLocFieldNames{j})(1,:)>0;
        plot(firingRateStruct.(mazeLocFieldNames{2})(:,chanInd),firingRateStruct.(mazeLocFieldNames{1})(:,chanInd),'.');
        titleText = [titleText ',' cellTypeLabels{k} '=' num2str(sum(chanInd))];
        ylabel({selAnatRegions{m},mazeLocFieldNames{1}})
        xlabel(mazeLocFieldNames{2});
        %if m==1 & k==1
        %    text(to(end),0-j*diff(get(gca,'ylim'))/2,mazeLocFieldNames{j},'color',plotColors(j))
        %end
        %set(gca,'xlim',[to(1) to(end)],'ylim',[0.5 1.5]);
        yLimits = get(gca,'ylim');
        xLimits = get(gca,'xlim');
        plot(xLimits,xLimits,'k--')
        %set(gca,'ylim',[0 yLimits(2)]);
        %set(gca,'xtick',[],'xlim',[0 length(mazeLocFieldNames)+1]);
%         if m==length(selAnatRegions)
%             text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
%         end
        
        title(titleText)
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
clf
%cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        titleText = [];
        for j=1:length(mazeLocFieldNames)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            chanInd = strcmp(chanLayerVecAll,selAnatRegions{m})...
                    & strcmp(cellTypesVecAll,cellTypeLabels(k));
%                    & firingRateStruct.(mazeLocFieldNames{j})(1,:)>0;
            plot(j,firingRateStruct.(mazeLocFieldNames{j})(:,chanInd),2),'o');
            titleText = [titleText ',' cellTypeLabels(k) '=' num2str(sum(chanInd))];
            ylabel(selAnatRegions{m})
            %if m==1 & k==1
            %    text(to(end),0-j*diff(get(gca,'ylim'))/2,mazeLocFieldNames{j},'color',plotColors(j))
            %end
            %set(gca,'xlim',[to(1) fo(end)],'ylim',[0.5 1.5]);
            yLimits = get(gca,'ylim');
            set(gca,'ylim',[0 yLimits(2)]);
            set(gca,'xtick',[],'xlim',[0 length(mazeLocFieldNames)+1]);
            if m==length(selAnatRegions)
                text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
            end
        end
        title(titleText)
    end
end

iter = 1;
plot(fo,squeeze(mean(spectTrialsByCells(:,iter,:)./repmat(rateTrialsByCells(:,iter),[1,1,size(spectTrialsByCells,3)])))); title([chanLayerVec{iter} ' ' cellTypesVec(iter) ' ' num2str(cluLoc(iter,3))]); iter=iter+1;
plot(fo,squeeze(mean(spectTrialsByCells(:,iter,:)))./repmat(squeeze(mean(rateTrialsByCells(:,iter))),[size(spectTrialsByCells,3),1])); title([chanLayerVec{iter} ' ' cellTypesVec(iter) ' ' num2str(cluLoc(iter,3))]); iter=iter+1;
plot(fo,squeeze(mean(spectTrialsByCells(:,iter,:)))); title([chanLayerVec{iter} ' ' cellTypesVec(iter) ' ' num2str(cluLoc(iter,3))]); iter=iter+1;

figure
plotColors = 'bgrcmk'
cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for j=1:length(mazeLocFieldNames)
        for k=1:length(cellTypeLabels)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            if sum(strcmp(chanLayerVecAll,selAnatRegions{m})...
                    & strcmp(cellTypesVecAll,cellTypeLabels(k)))>0
                plot(fo,squeeze(mean(firingRateStruct.(mazeLocFieldNames{j})(:,strcmp(chanLayerVecAll,selAnatRegions{m})...
                    & strcmp(cellTypesVecAll,cellTypeLabels(k)),:),2)),'color',plotColors(j));
            end
            title([cellTypeLabels(k) '=' num2str(sum(strcmp(chanLayerVecAll,selAnatRegions{m})...
                & strcmp(cellTypesVecAll,cellTypeLabels(k))))])
            ylabel(selAnatRegions{m})
            if m==1 & k==1
                text(1,0-j,mazeLocFieldNames{j},'color',plotColors(j))
            end
            set(gca,'xlim',[fo(1) fo(end)]);
%             set(gca,'xtick',[],'xlim',[0 length(mazeLocFieldNames)+1]);
%             if m==length(selAnatRegions)
%                 text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
%             end
            %set(gca,'xtick',[1:length(mazeLocFieldNames)],'xticklabel',mazeLocFieldNames(:))
        end
    end
end


catFiringRate = [];
for j=1:length(mazeLocFieldNames)
    catFiringRate = cat(1,catFiringRate,firingRateStruct.(mazeLocFieldNames{j}));
end
meanFiringRate = mean(catFiringRate);
plotColors = 'bgrcmk'
cellTypeLabels = ['w' 'n']
figure
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
        for j=1:length(mazeLocFieldNames)
            nPF = [];
            pfThresh = 1:0.1:7;
            selCells = strcmp(chanLayerVecAll,selAnatRegions{m})...
                & strcmp(cellTypesVecAll,cellTypeLabels(k));
            for n=pfThresh
                if sum(selCells)>0
                    nPF = cat(1,nPF,sum(firingRateStruct.(mazeLocFieldNames{j})(selCells)>n*meanFiringRate(:,selCells)));
                else
                    nPF = cat(1,nPF,0);
                end
            end
            plot(pfThresh,nPF,'color',plotColors(j))
            if m==1 & k==1
                text(max(pfThresh),0-j,mazeLocFieldNames{j},'color',plotColors(j))
            end
            ylabel(selAnatRegions{m})
            set(gca,'xlim',[1 max(pfThresh)])
            title([cellTypeLabels(k) '=' num2str(sum(strcmp(chanLayerVecAll,selAnatRegions{m})...
                & strcmp(cellTypesVecAll,cellTypeLabels(k))))])
            hold on
        end
    end
end
 
figure
cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for j=1:length(mazeLocFieldNames)
        for k=1:length(cellTypeLabels)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            if sum(strcmp(chanLayerVecAll,selAnatRegions{m})...
                    & strcmp(cellTypesVecAll,cellTypeLabels(k)))>0
                plot(j,sum(firingRateStruct.(mazeLocFieldNames{j})(strcmp(chanLayerVecAll,selAnatRegions{m})...
                    & strcmp(cellTypesVecAll,cellTypeLabels(k))))...
                    /sum(strcmp(chanLayerVecAll,selAnatRegions{m})...
                    & strcmp(cellTypesVecAll,cellTypeLabels(k))),'o');
            end
            title([cellTypeLabels(k) '=' num2str(sum(strcmp(chanLayerVecAll,selAnatRegions{m})...
                & strcmp(cellTypesVecAll,cellTypeLabels(k))))])
            ylabel(selAnatRegions{m})
            set(gca,'xtick',[],'xlim',[0 length(mazeLocFieldNames)+1]);
            if m==length(selAnatRegions)
                text(j,0,[mazeLocFieldNames{j} ' '],'horizontalalignment','right','rotation',90)
            end
            %set(gca,'xtick',[1:length(mazeLocFieldNames)],'xticklabel',mazeLocFieldNames(:))
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure
cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for k=1:length(cellTypeLabels)
        popFiringRate = mean(trialsByCellsAll(:,strcmp(chanLayerVecAll,selAnatRegions{m})...
                & strcmp(cellTypesVecAll,cellTypeLabels(k))),2);
        for j=1:length(mazeLocFieldNames)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            plot([j,j],[-std(trialsByCellsAll(strcmp(mazeLocVecAll,mazeLocFieldNames{j}))),...
                std(trialsByCellsAll(strcmp(mazeLocVecAll,mazeLocFieldNames{j})))]+...
                mean(trialsByCellsAll(strcmp(mazeLocVecAll,mazeLocFieldNames{j}))),'k')
            plot(j,mean(trialsByCellsAll(strcmp(mazeLocVecAll,mazeLocFieldNames{j}))),'r')
            
            title([cellTypeLabels(k) '=' num2str(sum(strcmp(chanLayerVecAll,selAnatRegions{m})...
                & strcmp(cellTypesVecAll,cellTypeLabels(k))))])
            ylabel(selAnatRegions{m})
            set(gca,'xtick',[1:length(mazeLocFieldNames)],'xticklabel',mazeLocFieldNames(:))
        end
    end
end







for a=1:length(analDirs)
    cd(analDirs{a})
fileBaseCell = LoadVar('FileInfo/AlterFiles');
spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
selAnatRegions = {'mol','gran','hil','ca3Pyr'};
chanLocVersion = 'Full';
chanLoc = LoadVar(['ChanInfo/ChanLoc_' chanLocVersion '.eeg.mat']);
cellType = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
% anatNames = fieldnames(chanLoc);
% selAnat
cluLoc = load([fileBaseCell{1} '/' fileBaseCell{1} '.cluloc']);
for k=1:length(selAnatRegions)
    selInd = ismember(cluLoc(:,3),[chanLoc.(selAnatRegions{k}){:}]);
    selFetClu{k} = cluLoc(selInd,1:2);
    if a==1
        selCellType{k} = [];
    end
    selCellType{k} = cat(1,selCellType{k},cellType(selInd,3);
end

mazeLocName = LoadVar([fileBaseCell{1} '/' spectAnalDir 'mazeLocName.mat']);
for m=1:length(mazeLocFieldNames)
    for j=1:length(fileBaseCell)
        fileBase = fileBaseCell{j};
        firingRateStruct.(mazeLocFieldNames{m}){j} = [];
        firingRate = LoadVar([fileBase '/' spectAnalDir 'firingRate.mat']);
        for k=1:length(selAnatRegions)
            mazeLocFieldNames = unique(mazeLocName);
            for n=1:length(selFetClu{k})
                firingRateStruct.(mazeLocFieldNames{m}){j} = cat(1,firingRateStruct.(mazeLocFieldNames{m}){j}...
                    ,sum(firingRate.(['elec' num2str(selFetClu{k}(n,1))]).(['clu' num2str(selFetClu{k}(n,2))])...
                    (strcmp(mazeLocFieldNames{m},mazeLocName)))...
                    /sum(strcmp(mazeLocFieldNames{m},mazeLocName)));
            end
        end
    end
    if a==1
        firingRateStruct2.(mazeLocFieldNames{m}) = [];
    end
    firingRateStruct2.(mazeLocFieldNames{m}) = cat(1,firingRateStruct2.(mazeLocFieldNames{m}),...
        mean(cat(2,firingRateStruct.(mazeLocFieldNames{m}){:}),2));    
end
for m=1:length(mazeLocFieldNames)
    if a==1
        firingRateStruct2.(mazeLocFieldNames{m}) = [];
    end
    firingRateStruct2.(mazeLocFieldNames{m}) = cat(1,firingRateStruct2.(mazeLocFieldNames{m}),...
        mean(cat(2,firingRateStruct.(mazeLocFieldNames{m}){:}),2));
end
selCellType2{m} = cat(1,selCellType2{m},selCellType

figure
cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for j=1:length(mazeLocFieldNames)
        for k=1:length(cellTypeLabels)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            plot(j,sum(firingRateStruct2.(mazeLocFieldNames{j})([selCellType2{m}{:}]==...
                cellTypeLabels(k)))/sum([selCellType2{m}{:}]==cellTypeLabels(k)),'o')
            title([cellTypeLabels(k) '=' num2str(sum([selCellType2{m}{:}]==cellTypeLabels(k)))])
            ylabel(selAnatRegions{m})
            set(gca,'xtick',[1:length(mazeLocFieldNames)],'xticklabel',mazeLocFieldNames(:))
        end
    end
end

%         for m=unique(selFetClu{k}(:,1))'
%             clu = load([fileBase '.clu.' num2str(m)]);
%             res = load([fileBase '.res.' num2str(m)]);
%             for n=[selFetClu{k}(ismember(selFetClu{k}(:,1),m),2)]'
%                 selRes = res(clu(2:end)==n);
%                 fprintf('%i,%i\n',m,n);
%             end
%         end
%     end
% end
% 

