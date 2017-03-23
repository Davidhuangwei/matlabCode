function PlotSpikeChanDist(fileBaseCell,fileName,varargin)
[firstFig,plotSize,colorLimits] = DefaultArgs(varargin,...
    {1,[10 8],[]});

chanInfoDir = 'ChanInfo/';
eegOffset = load([chanInfoDir 'Offset.eeg.txt']);
eegChanMat = LoadVar([chanInfoDir 'ChanMat.eeg.mat']);
chanMat = LoadVar([chanInfoDir 'ChanMat.eeg.mat']);
badChans = load([chanInfoDir 'BadChan.eeg.txt']);

jbStat = [];
for f=1:length(fileBaseCell)
%    cd(fileBaseCell{f});
    temp = load([fileBaseCell{f} '/' fileName]);
    if isempty(jbStat)
        numMeas = temp.infoStruct.numMeas;
        jbStat = temp.jbStat;
        lillieStat = temp.lillieStat;
        spikes = temp.spikes;
    else
        numMeas = numMeas + temp.infoStruct.numMeas;
        jbStat = jbStat + temp.jbStat;
        lillieStat = lillieStat + temp.lillieStat;
        spikes = spikes + temp.spikes;
    end
%    cd ..
end
figure(firstFig)
clf
set(gcf,'name','PlotSpikeChanDist_LillieStat')
colormap(LoadVar('ColorMapSean6.mat'));
imagesc(Make2DPlotMat(log(lillieStat/numMeas),chanMat,badChans));
PlotAnatCurves([chanInfoDir 'AnatCurves.mat'],size(eegChanMat),0.5-eegOffset)
set(gca,'xtick',[1:size(chanMat,2)],'ytick',[1:size(chanMat,1)])
PlotGrid

%set(gca,'clim',[2 9])
% colorLim = get(gca,'clim');
% set(gca,'clim',[colorLim(1) colorLim(1)+0.1])
 colorbar
        set(gcf,'PaperPosition',[(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)]);
set(gcf, 'Units', 'inches')
set(gcf, 'Position', [(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)])

figure(firstFig+1)
colormap(LoadVar('ColorMapSean6.mat'));
clf
set(gcf,'name','PlotSpikeChanDist_SpikesPerThresh')
normSpikes = (spikes+1)./repmat(median(spikes+1,1),size(spikes,1),1);
plotSpikes = MakeBufferedPlotMat(permute(normSpikes,[1,3,2]),chanMat,[0.1 0.1]);
ImageScRmNaN(plotSpikes,[0 5],[1 0 1])
PlotAnatCurves([chanInfoDir 'AnatCurves.mat'],...
    [size(eegChanMat,1) size(plotSpikes,2)],...
    [0.5+eegOffset(1)*size(plotSpikes,1)/size(chanMat,1) 0.5+eegOffset(2)*size(plotSpikes,2)/size(chanMat,2)]);
% PlotAnatCurves([chanInfoDir 'AnatCurves.mat'],...
%     [size(plotSpikes,1)/size(eegChanMat,1)*size(chanMat,1) size(plotSpikes,2)],...
%     [0.5+eegOffset(1)*(size(plotSpikes,1)/size(eegChanMat,1)) 0.5+eegOffset(2)]);
set(gca,'xtick',[1:size(plotSpikes,2)/size(chanMat,2):size(plotSpikes,2)]+size(plotSpikes,2)/size(chanMat,2)/2)
set(gca,'ytick',[1:size(chanMat,1)]);
%set(gca','xticklabel',[1:size(chanMat,1)]);
PlotGrid
        set(gcf,'PaperPosition',[(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)]);
set(gcf, 'Units', 'inches')
set(gcf, 'Position', [(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)])
return
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
figure
imagesc(Make2DPlotMat(log(jbStat/numMeas),MakeChanMat(6,16)));
set(gca,'clim',[2 9])
colorbar
figure
imagesc(Make2DPlotMat(lillieStat/numMeas,MakeChanMat(6,16)));
set(gca,'clim',[0.005 .01])
colorbar

% spikes = spikes';
normSpikes = (spikes+1)./repmat(median(spikes+1,1),size(spikes,1),1);
% numShanks = 6;
% chansPerShank = 16;
% chans = 1:96;
% subplotChanMat = MakeChanMat(chansPerShank,numShanks)';
% subplotChans = subplotChanMat(:);
% figure
% clf
chanInfoDir = 'ChanInfo/';
eegOffset = load([chanInfoDir 'Offset.eeg.txt']);
eegChanMat = LoadVar([chanInfoDir 'ChanMat.eeg.mat']);
chanMat = LoadVar([chanInfoDir 'ChanMat.eeg.mat']);
plotSpikes = MakeBufferedPlotMat(permute(normSpikes,[1,3,2]),[0.1 0.1],chanMat);
ImageScRmNaN(plotSpikes,[0 5],[1 0 1])
PlotAnatCurvesNew([chanInfoDir 'AnatCurvesNew.mat'],...
    [size(plotSpikes,1)/size(eegChanMat,1)*size(chanMat,1) size(plotSpikes,2)],...
    [0.5+eegOffset(1)*size(plotSpikes,1)/size(chanMat,1) 0.5+eegOffset(2)*size(plotSpikes,2)/size(chanMat,2)]);
set(gca,'xtick',[]);

for j=1:length(chans)
    subplot(chansPerShank,numShanks,subplotChans(j))
    %hold on
    set(gca,'xlim',[1 25],'fontsize',5)%,'ylim',[0 max(max(normSpikes))])
    imagesc(normSpikes(:,chans(j))')
    set(gca,'clim',[0 5],'ytick',[])
    %colorbar
    %plot(normSpikes(:,chans(j)));
    ylabel(['ch' num2str(chans(j))])
    %plot((spikes(:,j)+1)./mean(spikes+1,2));
    %plot([1 25],[1 1],'r')
    %set(gca,'xlim',[1 25])%,'ylim',[0 max(max(normSpikes))])
end
plotPspec = permute(pSpec(fo>200,:)',[1,3,2]);
plotPspec = MakeBufferedPlotMat(plotPspec.*...
    repmat(permute(fo(fo>200).^2,[3 2 1]),[size(plotPspec,1),1,1]),...
    [0.1 0.1],chanMat);
ImageScRmNaN(plotPspec,[],[1 0 1])
PlotAnatCurvesNew([chanInfoDir 'AnatCurvesNew.mat'],...
    [size(plotPspec,1)/size(eegChanMat,1)*size(chanMat,1) size(plotPspec,2)],...
    [0.5+eegOffset(1)*(size(plotPspec,1)/size(eegChanMat,1)) 0.5]);

figure
test = sum(pSpec(find(fo<700 & fo>300),:)); 
imagesc(Make2DPlotMat(test',MakeChanMat(6,16)))
set(gca,'clim',[3.5e4 7e4])



