thetaFreqRange = [6 12];
gammaFreqRange = [60 120];
maxFreq = 150;
spectAnal = 'CalcRunningSpectra9_noExp_MidPoints_MinSpeed0Win626';
analRoutine = 'AlterGood';

mfilename = 'GlmWholeModel05';
load(['TrialDesig/' mfilename '/' analRoutine '.mat'])
fileExtCell = {...
    '_LinNearCSD121.csd'...
     '.eeg',...
     '_NearAveCSD1.csd',...
    }
for m=1:length(fileExtCell)
    fileExt = fileExtCell{m}
    selChans = load(['ChanInfo/SelectedChannels' fileExt '.txt']);
    chanMat = LoadVar(['ChanInfo/ChanMat' fileExt '.mat']);
    badChans = load(['ChanInfo/BadChan' fileExt '.txt']);
%    analDir = ['RemVsRun_noExp_MinSpeed0Win1250' fileExt];
    analDir = [spectAnal fileExt];
    anatCurvesName = 'ChanInfo/AnatCurves.mat';
    plotSize = [16.5,6.5];
    offset = load(['ChanInfo/OffSet' fileExt '.txt']);
    normBool = 1;
    fs = LoadField([fileBaseMat(1,:) '/' analDir '/cohSpec.fo']);

%     if allFreqBool
%         for j=1:length(selChans)
%             selChanNames{j} = ['ch' num2str(selChans(j))];
%             cohere.(selChanNames{j}) = LoadDesigVar(fileBaseMat,analDir,['cohSpec.yo.' selChanNames{j}] ,trialDesig);
%             phase.(selChanNames{j}) = LoadDesigVar(fileBaseMat,analDir,['phaseSpec.yo.' selChanNames{j}] ,trialDesig);
%         end
%     end
    for j=1:length(selChans)
        selChanNames{j} = ['ch' num2str(selChans(j))];
        gammaCohere.(selChanNames{j}) = LoadDesigVar(fileBaseMat,analDir,...
            ['gammaCohMean' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.' selChanNames{j}] ,trialDesig);
        gammaPhase.(selChanNames{j}) = LoadDesigVar(fileBaseMat,analDir,...
            ['gammaPhaseMean' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.' selChanNames{j}] ,trialDesig);
    end
    for j=1:length(selChans)
        selChanNames{j} = ['ch' num2str(selChans(j))];
        thetaCohere.(selChanNames{j}) = LoadDesigVar(fileBaseMat,analDir,...
            ['thetaCohMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.' selChanNames{j}] ,trialDesig);
        thetaPhase.(selChanNames{j}) = LoadDesigVar(fileBaseMat,analDir,...
            ['thetaPhaseMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.' selChanNames{j}] ,trialDesig);
    end
selChNames = fieldnames(thetaCohere)
figure(1)
clf
colormap(LoadVar('ColorMapSean6.mat'))
set(gcf,'name','thetaCohMean')
for j=1:length(selChNames)
    mazeRegions = fieldnames(thetaCohere.(selChNames{j}));
    for k=1:length(mazeRegions)
        subplot(length(selChNames),length(mazeRegions),(j-1)*length(mazeRegions)+k)
        imagesc(Make2DPlotMat(UnATanCoh(mean(thetaCohere.(selChNames{j}).(mazeRegions{k}))),chanMat,badChans,'linear'))
        set(gca,'clim',[0.9 1])
        PlotAnatCurves(anatCurvesName,plotSize,offset)
        colorbar
        if j==1
            title(mazeRegions{k})
        end
    end
end
figure(2)
clf
colormap(LoadVar('ColorMapSean6.mat'))
set(gcf,'name','gammaCohMean')
for j=1:length(selChNames)
    mazeRegions = fieldnames(thetaCohere.(selChNames{j}));
    for k=1:length(mazeRegions)
        subplot(length(selChNames),length(mazeRegions),(j-1)*length(mazeRegions)+k)
        imagesc(Make2DPlotMat(UnATanCoh(mean(gammaCohere.(selChNames{j}).(mazeRegions{k}))),chanMat,badChans,'linear'))
        set(gca,'clim',[0 1])
        PlotAnatCurves(anatCurvesName,plotSize,offset)
        colorbar
        if j==1
            title(mazeRegions{k})
        end
    end
end
figure(3)
clf
colormap(LoadVar('CircularColorMap.mat'))
set(gcf,'name','thetaPhaseMean')
for j=1:length(selChNames)
    mazeRegions = fieldnames(thetaCohere.(selChNames{j}));
    for k=1:length(mazeRegions)
        subplot(length(selChNames),length(mazeRegions),(j-1)*length(mazeRegions)+k)
        imagesc(Make2DPlotMat(angle(mean(thetaPhase.(selChNames{j}).(mazeRegions{k}))),chanMat,badChans,'linear'))
        set(gca,'clim',[-pi pi])
        PlotAnatCurves(anatCurvesName,plotSize,offset)
        colorbar
        if j==1
            title(mazeRegions{k})
        end
    end
end
figure(4)
clf
colormap(LoadVar('CircularColorMap.mat'))
set(gcf,'name','gammaPhaseMean')
for j=1:length(selChNames)
    mazeRegions = fieldnames(thetaCohere.(selChNames{j}));
    for k=1:length(mazeRegions)
        subplot(length(selChNames),length(mazeRegions),(j-1)*length(mazeRegions)+k)
        imagesc(Make2DPlotMat(angle(mean(gammaPhase.(selChNames{j}).(mazeRegions{k}))),chanMat,badChans,'linear'))
        set(gca,'clim',[-pi pi])
        PlotAnatCurves(anatCurvesName,plotSize,offset)
        colorbar
        if j==1
            title(mazeRegions{k})
        end
    end
end
ReportFigSM([1:4],GenFieldName(['/u12/smm/public_html/NewFigs/MazePaper/CohPhaseExamples/' fileExtCell{m} '/']) )


clear gammaCohere
clear gammaPhase
clear thetaCohere
clear thetaPhase
end

