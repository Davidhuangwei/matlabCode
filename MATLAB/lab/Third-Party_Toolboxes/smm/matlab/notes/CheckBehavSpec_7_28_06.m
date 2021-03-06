maxFreq = 150;
spectAnal = 'CalcRunningSpectra9_noExp_MidPoints_MinSpeed0Win626';
analRoutine = 'MazeCenter_S0_A0_TT';

anal = 'GlmWholeModel05';
load(['TrialDesig/' anal '/' analRoutine '.mat'])
fileExtCell = {...
     '.eeg',...
     '_NearAveCSD1.csd',...
    '_LinNearCSD121.csd'...
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
    fs = LoadField([fileBaseMat(1,:) '/' analDir '/powSpec.fo']);
    for j=1:length(selChans)
        powSpec = LoadDesigVar(fileBaseMat,analDir,['powSpec.yo.'] ,trialDesig);
    end

    figure(1)
    clf
    set(gcf,'name',Dot2Underscore(fileExt))
    plotColors = [0 0 1;1 0 0;0 1 0; 0 0 0];
    catData = [];
    fields = fieldnames(powSpec);
    for j=1:length(fields)
        for k=1:length(selChans);
         subplot(2,length(selChans),k+length(selChans))
        hold on
        plot(fs(fs<=maxFreq),squeeze(mean(powSpec.(fields{j})(:,selChans(k),fs<=maxFreq))),'color',plotColors(j,:))
        plot(fs(fs<=maxFreq),squeeze(mean(powSpec.(fields{j})(:,selChans(k),fs<=maxFreq)))...
            + squeeze(std(powSpec.(fields{j})(:,selChans(k),fs<=maxFreq)))./sqrt(size(powSpec.(fields{j}),1)),':','color',plotColors(j,:))
        plot(fs(fs<=maxFreq),squeeze(mean(powSpec.(fields{j})(:,selChans(k),fs<=maxFreq)))...
            - squeeze(std(powSpec.(fields{j})(:,selChans(k),fs<=maxFreq)))./sqrt(size(powSpec.(fields{j}),1)),':','color',plotColors(j,:))
        set(gca,'ylim',[40 90],'xtick',[0:20:140]);
        grid on
        catData = cat(1,catData,powSpec.(fields{j}));
        end
    end
    for k=1:length(selChans);
        subplot(2,length(selChans),k)
        plot(fs(fs<=maxFreq),squeeze(mean(catData(:,selChans(k),fs<=maxFreq))),'k')
        set(gca,'ylim',[40 90],'xtick',[0:20:140]);
         grid on
   end
   %keyboard
    ReportFigSM(1,Dot2Underscore(['/u12/smm/public_html/NewFigs/MazePaper/misc/' mfilename '/' analRoutine '/']))
end
            