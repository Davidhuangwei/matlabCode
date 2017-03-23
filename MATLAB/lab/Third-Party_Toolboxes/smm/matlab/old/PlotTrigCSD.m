function PlotTrigCSD(eegSegs,csdSegs,varargin)
[colorLimits, eegChanMat,  eegOffset, csdChanMat, csdOffset] = ...
    DefaultArgs(varargin,{[],LoadVar('ChanInfo/ChanMat.eeg'),LoadVar('ChanInfo/Offset.eeg'),...
    LoadVar('ChanInfo/ChanMat_LinNearCSD121.csd'),LoadVar('ChanInfo/Offset_LinNearCSD121.csd')});

nVertChan = size(eegChanMat,1);


csdAveSeg = mean(csdSegs,3);

csdPlot = MakeBufferedPlotMat(permute(csdAveSeg,[1,3,2]),csdChanMat);
clf;
pcolor(1:size(csdPlot,2),-1-csdOffset(1):-1:-size(csdPlot,1)-csdOffset,csdPlot)
shading interp
hold on


eegAveSeg = mean(eegSegs,3);

eegPlot = MakeBufferedPlotMat(permute(eegAveSeg,[1,3,2]),eegChanMat);

normFactor = abs(max(max(eegPlot))-min(min(eegPlot)));
PlotAnatCurvesNew('ChanInfo/AnatCurvesNew.mat',[-nVertChan size(eegPlot,2)] ,[-0.5 0.5]);
for j=1:size(eegPlot,1)
    plot(1:size(eegPlot,2),eegPlot(j,:)/normFactor-j-eegOffset(1),'k');
end
badChanEegAveSeg = NaN*ones(size(eegAveSeg));
badChanEegAveSeg(eegBadChan,:) = eegAveSeg(eegBadChan,:);
badEegPlot = MakeBufferedPlotMat(permute(badChanEegAveSeg,[1,3,2]),eegChanMat);
for j=1:size(badEegPlot,1)
    plot(1:size(badEegPlot,2),badEegPlot(j,:)/normFactor-j-eegOffset(1),'color',[.65 .65 .65]);
end


set(gca,'ylim',[-nVertChan-1 0])
set(gca,'xtick',[],'ytick',[])
colormap(LoadVar('ColorMapSean6.mat'));
if ~isempty(colorLimits)
    set(gca,'clim',colorLimits)
end
colorbar
