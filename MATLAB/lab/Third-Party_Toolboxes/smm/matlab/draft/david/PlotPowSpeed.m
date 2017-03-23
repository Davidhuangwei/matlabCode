function PlotPowSpeed(fileBaseMat,winLength,NW,lowCut,highCut,plotColor)

markerSize = 4;
yoTotal = [];
speedTotal = [];
integPowTotal = [];
peakPowTotal = [];
for i=1:size(fileBaseMat,1)
    inName = [fileBaseMat(i,:) '_Speed_mtSpect_Win_' num2str(winLength) '_NW_' num2str(NW) '.mat'];
    fprintf('\nLoading: %s\n',inName);
    load(inName);
    
    integPow = sum(log(yo(find(fo>=lowCut & fo<=highCut),:,:)));
    peakPow = max(log(yo(find(fo>=lowCut & fo<=highCut),:,:)));

    yoTotal = [yoTotal yo];
    speedTotal = [speedTotal ; speed];
    integPowTotal = [integPowTotal integPow];
    peakPowTotal = [peakPowTotal peakPow];   
end

figure(1)
for j=1:length(channels)
    subplot(1,length(channels),j)
    hold on
    plot(fo(find(fo>=0 & fo<=100)),log(mean(yoTotal(find(fo>=0 & fo<=100),:,j),2)),plotColor);
    title(['Chan: ', num2str(channels(j))]);
end

figure(2)
for j=1:length(channels)
    subplot(2,length(channels),j)
    hold on
    plot(speedTotal,integPowTotal(:,:,j)',['.' plotColor],'markersize',markerSize);
    [p s] = polyfit(speedTotal,squeeze(integPowTotal(:,:,j))',1);
    plot([min(speedTotal) max(speedTotal)],p(1).*[min(speedTotal) max(speedTotal)]+p(2),plotColor);
    %set(gca,'xlim',[0 100],'ylim',[170 220]);
    %set(gca,'xlim',[0 100],'ylim',[75 105]);
    set(gca,'xlim',[0 100]);
    title(['integ Chan: ', num2str(channels(j))]);

    subplot(2,length(channels),j+length(channels))
    hold on
    plot(speedTotal,peakPowTotal(:,:,j)',['.' plotColor],'markersize',markerSize);
    [p s] = polyfit(speedTotal,squeeze(peakPowTotal(:,:,j))',1);
    plot([min(speedTotal) max(speedTotal)],p(1).*[min(speedTotal) max(speedTotal)]+p(2),plotColor);
    set(gca,'xlim',[0 100],'ylim',[14 19]);
    title(['peak Chan: ', num2str(channels(j))]);
end

%keyboard
return

figure(3)
for j=1:100
plot(fo(1:40),log(yo(1:40,j,4)))
hold on
plot(fo(find(fo>=lowCut & fo<=highCut)),log(yo(find(fo>=lowCut & fo<=highCut),j,4)),'r')
plot(20,peakPow(1,j,4),'.')
plot(24,max(log(yo(find(fo>=lowCut & fo<=highCut),j,4)),[],1),'r.')
set(gca,'ylim',[10 20])
%log(yo(find(fo>=lowCut & fo<=highCut),j,4))
%max(log(yo(find(fo>=lowCut & fo<=highCut),j,4)),[],1)
pause
clf
end