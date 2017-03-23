    
fileExt = '.eeg';
selChans = load(['ChanInfo/SelectedChannels' fileExt '.txt']);
anatCurvesName = 'ChanInfo/AnatCurves.mat';
plotSize = [16.5,6.5];
offset = load(['ChanInfo/OffSet' fileExt '.txt']);
chanMat = LoadVar(['ChanInfo/ChanMat' fileExt '.mat']);
figure(1)
clf
selChanNames = {'pyr1','rad','lm','mol','gran','pyr3'}
for j=1:length(selChans)
    subplot(length(selChans),1,j);
    hold on
    plotMat = zeros(size(chanMat));
%    plotMat = ones(size(chanMat));
    %plotMat(:) = NaN;
    %plotMat(find(chanMat~=selChans(j))) = 0;
    ImageScMask(plotMat,logical(plotMat),[-1 1],[0 0 1]);
    PlotAnatCurves(anatCurvesName,plotSize,offset)
    ylabel(selChanNames{j})
    set(gca,'ytick',[],'xtick',[])
    set(gca,'ylim',[0.5 size(chanMat,1)+0.5],'xlim',[0.5 size(chanMat,2)+0.5])
    DrawElectrodes(chanMat,[0 0 0],1,2,[],.26)
    [m n] = find(chanMat==selChans(j))
    plot(n,m,'ro','markersize',7,'linewidth',3);
    %set(gca,'ytick',0.5+1:size(chanMat,1),'xtick',0.5+1:size(chanMat,2),'yticklabel',[],'xticklabel',[])
    %grid on

end
%ReportFig(1,'/u12/smm/public_html/NewFigs/MazePaper/CohPhaseExamples/'

