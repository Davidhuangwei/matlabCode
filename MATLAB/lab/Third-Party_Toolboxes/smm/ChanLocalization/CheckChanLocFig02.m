function CheckChanLocFig02(fileExt,chanLocVersion)
addpath /u12/smm/matlab/Plotting/Bar/
chanInfoDir = 'ChanInfo/';
chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']);
badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);
if exist([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat'],'file')
    chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
else
    ERROR
end

selChans = load([chanInfoDir 'SelectedChannels' fileExt '.txt']);

plotAnatBool = 1;
anatOverlayName = [chanInfoDir 'AnatCurves.mat'];
plotSize = [16.5,6.5];
plotOffset = load([chanInfoDir 'OffSet' fileExt '.txt']);
 
plotMat(odd(chanMat(:,odd(1:size(chanMat,2)-1))-1)+1) = -inf;
plotMat(odd(chanMat(:,odd(1:size(chanMat,2)-1))-1)) = -inf;
plotMat(odd(chanMat(:,odd(1:size(chanMat,2)-1)+1)-1)) = -inf;
plotMat(odd(chanMat(:,odd(1:size(chanMat,2)-1)+1)-1)+1) = -inf;
%plotMat(selChans) = -2;
%plotMat(badChans) = inf;
%plotMat(setdiff(chanLoc.(fields{j}),badChans)) = inf;
%figure

% figure(1)
% clf
% imagesc(Make2DPlotMat(plotMat,chanMat));
% set(gca,'clim',[-4 3])
% XYPlotAnatCurves({anatOverlayName},gca,plotSize,plotOffset);
% for m=1:size(chanMat,2)
%     for k=1:size(chanMat,1)
%         text(m,k,num2str(chanMat(k,m)),'color','w');
%     end
% end
% set(gca,'ytick',1:size(chanMat,1))
% grid on

figure(1)
clf
    hold on
fields = fieldnames(chanLoc);
newPlotMat = plotMat;
%chanLocCscaling = [-8 -4 -7 -3 -6 -2 -5 -1];
%chanLocCscaling = [-1 -5 -2 -6 -3 -7 -8 -4];
chanLocCscaling = [-8 -7 -6 -5 -4 -3 -2 -1];
cMap = [...
    1.0, 1.0, 1.0;...
    1.0, 0.0, 0.0;...
    0.0, 1.0, 0.0;...
    0.0, 1.0, 1.0;...
    0.4, 0.4, 0.0;...
    1.0, 0.4, 0.0;...
    0.0, 0.0, 1.0;...
    1.0, 0.0, 1.0;...
    1.0, 1.0, 0.0;...
    ];
    colormap(cMap);
    plotMat = zeros(size(chanMat));
    ImageScMask(plotMat,logical(plotMat),[-1 1],[0 0 1]);
    PlotAnatCurves(anatOverlayName,plotSize,plotOffset)
    set(gca,'ytick',[],'xtick',[])
    set(gca,'ylim',[0.5 size(chanMat,1)+0.5],'xlim',[0.5 size(chanMat,2)+0.5])
for j=1:length(fields)
    %chanLoc.(fields{j})
    for k=1:length(chanLoc.(fields{j}));
        [m n] = find(chanMat==chanLoc.(fields{j})(k));
        plot(n,m,'.','color',cMap(j,:),'markersize',20,'linewidth',2);
    end

end
    DrawElectrodes(chanMat,[0 0 0],1,2,[],.26)

return
