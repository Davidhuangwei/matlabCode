function [normFactor colorLimits] = PlotTrigCSD(eegSegs,csdSegs,varargin)
[normFactor, colorLimits, traceChanMat,  traceOffset, colorChanMat, colorOffset traceBadChan,eegChanMat] = ...
    DefaultArgs(varargin,{[],[],LoadVar('ChanInfo/ChanMat.eeg.mat'),load('ChanInfo/Offset.eeg.txt'),...
    LoadVar('ChanInfo/ChanMat_LinNearCSD121.csd'),load('ChanInfo/Offset_LinNearCSD121.csd.txt'),...
    load('ChanInfo/BadChan.eeg.txt'),LoadVar('ChanInfo/ChanMat.eeg.mat')});

nVertChan = size(eegChanMat,1);

keyboard
csdAveSeg = mean(csdSegs,3);

csdPlot = MakeBufferedPlotMat(permute(csdAveSeg,[1,3,2]),colorChanMat);
pcolor(1:size(csdPlot,2),-1-colorOffset(1):-1:-size(csdPlot,1)-colorOffset,csdPlot)
shading interp
hold on


% max(Bits2mV(eegAveSeg(:)))-min(Bits2mV(eegAveSeg(:)))
% [x i]=max(Bits2mV(eegAveSeg(:)))
% [i j]=ind2sub(size(eegAveSeg),i)
% [x i]=min(Bits2mV(eegAveSeg(:)))
% [i j]=ind2sub(size(eegAveSeg),i)
% 
% plot(max(Bits2mV(eegAveSeg),[],2)-min(Bits2mV(eegAveSeg),[],2))


%%% mean %%%
eegAveSeg = mean(eegSegs,3);
% keyboard
eegPlot = MakeBufferedPlotMat(permute(Bits2mV(eegAveSeg),[1,3,2]),traceChanMat);
% eegPlot = MakeBufferedPlotMat(permute(eegAveSeg,[1,3,2]),traceChanMat);
normFactor
if isempty(normFactor)
    normFactor = abs(max(eegPlot(:))-min(eegPlot(:)))
end
xlimits = get(gca,'xlim');
for j=1:size(eegPlot,1)
    plot(1:size(eegPlot,2),eegPlot(j,:)/normFactor-j-traceOffset(1),'k');
end
xlimits = get(gca,'xlim');
PlotAnatCurvesNew('ChanInfo/AnatCurvesNew.mat',[-nVertChan size(eegPlot,2)] ,[-0.5 0.5]);

% badChanEegAveSeg = NaN*ones(size(eegAveSeg));
% badChanEegAveSeg(traceBadChan,:) = eegAveSeg(traceBadChan,:);
% badEegPlot = MakeBufferedPlotMat(permute(badChanEegAveSeg,[1,3,2]),traceChanMat);
% for j=1:size(badEegPlot,1)
%     plot(1:size(badEegPlot,2),badEegPlot(j,:)/normFactor-j-traceOffset(1),'color',[.65 .65 .65]);
% end

% 
% %%% mean - std %%%
% eegAveSeg = mean(eegSegs,3) - std(eegSegs,[],3);
% 
% eegPlot = MakeBufferedPlotMat(permute(eegAveclfSeg,[1,3,2]),traceChanMat);
% 
% %normFactor = abs(max(max(eegPlot))-min(min(eegPlot)));
% PlotAnatCurvesNew('ChanInfo/AnatCurvesNew.mat',[-nVertChan size(eegPlot,2)] ,[-0.5 0.5]);
% for j=1:size(eegPlot,1)
%     plot(1:size(eegPlot,2),eegPlot(j,:)/normFactor-j-traceOffset(1),':k');
% end
% badChanEegAveSeg = NaN*ones(size(eegAveSeg));
% badChanEegAveSeg(traceBadChan,:) = eegAveSeg(traceBadChan,:);
% badEegPlot = MakeBufferedPlotMat(permute(badChanEegAveSeg,[1,3,2]),traceChanMat);
% for j=1:size(badEegPlot,1)
%     plot(1:size(badEegPlot,2),badEegPlot(j,:)/normFactor-j-traceOffset(1),':','color',[.65 .65 .65]);
% end
% 
% %%% mean + std %%%
% eegAveSeg = mean(eegSegs,3) + std(eegSegs,[],3);
% 
% eegPlot = MakeBufferedPlotMat(permute(eegAveSeg,[1,3,2]),traceChanMat);
% 
% %normFactor = abs(max(max(eegPlot))-min(min(eegPlot)));
% PlotAnatCurvesNew('ChanInfo/AnatCurvesNew.mat',[-nVertChan size(eegPlot,2)] ,[-0.5 0.5]);
% for j=1:size(eegPlot,1)
%     plot(1:size(eegPlot,2),eegPlot(j,:)/normFactor-j-traceOffset(1),':k');
% end
% badChanEegAveSeg = NaN*ones(size(eegAveSeg));
% badChanEegAveSeg(traceBadChan,:) = eegAveSeg(traceBadChan,:);
% badEegPlot = MakeBufferedPlotMat(permute(badChanEegAveSeg,[1,3,2]),traceChanMat);
% for j=1:size(badEegPlot,1)
%     plot(1:size(badEegPlot,2),badEegPlot(j,:)/normFactor-j-traceOffset(1),':','color',[.65 .65 .65]);
% end
set(gca,'xlim',xlimits)
set(gca,'ylim',[-nVertChan-1 0])
set(gca,'xtick',[],'ytick',[])
colormap(LoadVar('ColorMapSean6.mat'));
if ~isempty(colorLimits)
    set(gca,'clim',colorLimits)
else
    colorLimits = abs(get(gca,'clim'));
    set(gca,'clim',[-min(colorLimits) min(colorLimits)])
end    
colorbar

return
