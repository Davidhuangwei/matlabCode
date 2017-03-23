function PlotMazeSpectrums(figTitle,fileName1,fileName2,channelPairs)

load(fileName1)
if ~exist('channelPairs','var') | isempty(channelPairs)
    channelPairs = [channels;channels]';
end

for i=1:size(channelPairs,1)
    figure(i)
    clf
    hold on
    plot(f(1:800),b(1:800,find(channels==channelPairs(i,1)),1),'k')
end

load(fileName2)
for i=1:size(channelPairs,1)
    figure(i)
    plot(f(1:800),b(1:800,find(channels==channelPairs(i,2)),1),'g')
    set(gca,'ylim',[10,55]);
    title(['Channel ' num2str(channelPairs(i,1)) ' (black) Vs. ' num2str(channelPairs(i,2)) ' (green)']);
    ylabel('Power');
    xlabel('Frequency');
    set(gcf,'name', figTitle)
end
