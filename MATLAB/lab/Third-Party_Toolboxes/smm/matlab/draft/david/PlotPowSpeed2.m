function PlotPowSpeed(fileBaseMat,minSpeed,winLength,NW,lowCut,highCut,markerStyle,markerColor)

markerSize = 4;
yoTotal = [];
speedTotal = [];
integPowTotal = [];
peakPowTotal = [];
for i=1:size(fileBaseMat,1)
    inName = [fileBaseMat(i,:) '_Speed_mtSpect_Win_' num2str(winLength) '_NW_' num2str(NW) '.mat'];
    fprintf('\nLoading: %s\n',inName);
    load(inName);
    
    integPow = sum(10.*log10(yo(find(fo>=lowCut & fo<=highCut),:,:)));
    peakPow = max(10.*log10(yo(find(fo>=lowCut & fo<=highCut),:,:)));

    yoTotal = [yoTotal yo];
    speedTotal = [speedTotal ; speed];
    integPowTotal = [integPowTotal integPow];
    peakPowTotal = [peakPowTotal peakPow];   
end
speedIndexes = find(speedTotal>=minSpeed);
%speedTotal = log10(speedTotal);

figure(1)
for j=1:length(channels)
    subplot(1,length(channels),j)
    hold on
    plot(fo(find(fo>=0 & fo<=200)),10.*log10(mean(yoTotal(find(fo>=0 & fo<=200),:,j),2)),markerColor);
    %plot(fo(find(fo>=0 & fo<=200)),10.*log10(mean(yoTotal(find(fo>=0 & fo<=200),speedIndexes,j),2)),markerColor);
    %set(gca,'ylim',[10 18]);
    title(['Chan: ', num2str(channels(j))]);
    set(gcf,'name',['PlotPowSpeed2' fileBaseMat(1,1:6) '_minspeed' num2str(minSpeed) '_win' ...
        num2str(winLength) '_NW'  num2str(NW) '_lowCut' num2str(lowCut) '_highCut' num2str(highCut)]);
end


figure(2)
for j=1:length(channels)
    subplot(2,length(channels),j)
    semilogx(speedTotal(speedIndexes),integPowTotal(:,speedIndexes,j)',[markerStyle markerColor],'markersize',markerSize);
    hold on
    [p s] = polyfit(log10(speedTotal(speedIndexes)),squeeze(integPowTotal(:,speedIndexes,j))',1);
    semilogx([minSpeed 100],p(1).*log10([minSpeed 100])+p(2),markerColor);
    %set(gca,'xlim',[0 100],'ylim',[170 220]);
    %set(gca,'xlim',[0 100],'ylim',[75 105]);
    set(gca,'xlim',[minSpeed 100]);
    title(['integ Chan: ', num2str(channels(j))]);

    subplot(2,length(channels),j+length(channels))
    semilogx(speedTotal(speedIndexes),peakPowTotal(:,speedIndexes,j)',[markerStyle markerColor],'markersize',markerSize);
    hold on
    [p s] = polyfit(log10(speedTotal(speedIndexes)),squeeze(peakPowTotal(:,speedIndexes,j))',1);
    semilogx([minSpeed 100],p(1).*log10([minSpeed 100])+p(2),markerColor);
    %set(gca,'xlim',[minSpeed 100],'ylim',[14 19]);
    title(['peak Chan: ', num2str(channels(j))]);
    set(gcf,'name',['PlotPowSpeed2' fileBaseMat(1,1:6) '_minspeed' num2str(minSpeed) '_win' ...
        num2str(winLength) '_NW'  num2str(NW) '_lowCut' num2str(lowCut) '_highCut' num2str(highCut)]);
end

if 1
    j=1;
    
    figure(3)
    minFreq = 0;
    maxFreq = 25;
    plot(fo(find(fo>=minFreq & fo<=maxFreq)),10.*log10(mean(yoTotal(find(fo>=minFreq & fo<=maxFreq),:,j),2)),markerColor);
    %semilogx(fo(find(fo>=minFreq & fo<=maxFreq)),10.*log10(mean(yoTotal(find(fo>=minFreq & fo<=maxFreq),:,j),2)),markerColor);
    hold on
    %plot(fo(find(fo>=0 & fo<=200)),10.*log10(mean(yoTotal(find(fo>=0 & fo<=200),speedIndexes,j),2)),markerColor);
    %set(gca,'ylim',[10 18]);
    set(gca,'xlim',[minFreq maxFreq]);
    title(['Chan: ', num2str(channels(j))]);
    set(gcf,'name',['PlotPowSpeed2' fileBaseMat(1,1:6) '_minspeed' num2str(minSpeed) '_win' ...
        num2str(winLength) '_NW'  num2str(NW) '_lowCut' num2str(lowCut) '_highCut' num2str(highCut)]);   


    figure(4)
    semilogx(speedTotal(speedIndexes),peakPowTotal(:,speedIndexes,j)',[markerStyle markerColor],'markersize',markerSize);
    hold on
    [p s] = polyfit(log10(speedTotal(speedIndexes)),squeeze(peakPowTotal(:,speedIndexes,j))',1);
    semilogx([minSpeed 100],p(1).*log10([minSpeed 100])+p(2),markerColor);
    %set(gca,'xlim',[minSpeed 100],'ylim',[14 19]);
    title(['peak Chan: ', num2str(channels(j))]);
    set(gcf,'name',['PlotPowSpeed2' fileBaseMat(1,1:6) '_minspeed' num2str(minSpeed) '_win' ...
        num2str(winLength) '_NW'  num2str(NW) '_lowCut' num2str(lowCut) '_highCut' num2str(highCut)]);

end

return
keyboard



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