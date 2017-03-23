function PlotRippTrigAveSegDiff(animalDirs,fileExt,segLen,segRestriction,varargin)
chanLocVersion = DefaultArgs(varargin,'Min');

[outSeg1  outNumSeg1] = LoadRippTrigAveSegs(animalDirs,fileExt,segLen,segRestriction{1},chanLocVersion);
[outSeg2  outNumSeg2] = LoadRippTrigAveSegs(animalDirs,fileExt,segLen,segRestriction{2},chanLocVersion);

chanLoc = Struct2CellArray(LoadVar(['ChanInfo/ChanLoc_' chanLocVersion fileExt ]));
eegSamp = 1250;

figNumStart = 1;

titleBase = {'Ripple Triggered Ave Seg',...
    [segRestriction{1} ' - ' segRestriction{2},num2str(segLen),fileExt]};
figTitleBase = ['RippTrigSeg_' segRestriction{1} '-' segRestriction{2} num2str(segLen) fileExt];

screenHeight = 11;
xyFactor = 1.5;
% segFactor = -(length(fo)/2)/max(max(cat(1,outSeg1{:},outSeg2{:})));
%segFactor = max(fo)/100000;
% segOffset = length(fo)/2;
segFactor = 1;
segOffset = 0;
plotSkip = 20;

to = [1:size(outSeg1{1},2)]/size(outSeg1{1},2)*segLen - segLen/2;

yLims = [-1000 1000;-3000 3000;-4000 4000;-2000 2000;-2000 2000;-2000 2000;-2000 2000;-2000 2000];
figure(figNumStart + 0)
    set(gcf,'units','inches')
    set(gcf,'position',[0.5,0.5,screenHeight*xyFactor,screenHeight])
    set(gcf,'paperposition',get(gcf,'position'))
set(gcf,'name',figTitleBase)
for j=1:length(outSeg1)
    subplot(length(outSeg1),1,j)
    hold on
    meanOutSeg1 = mean(outSeg1{j}*segFactor+segOffset,1);
    stdOutSeg1 = std(outSeg1{j}*segFactor+segOffset,[],1);
    plot(to,meanOutSeg1,'b')
    plot([to(round(plotSkip/2):plotSkip:end);to(round(plotSkip/2):plotSkip:end)],...
        [meanOutSeg1(round(plotSkip/2):plotSkip:end)+stdOutSeg1(round(plotSkip/2):plotSkip:end);...
        meanOutSeg1(round(plotSkip/2):plotSkip:end)-stdOutSeg1(round(plotSkip/2):plotSkip:end)],'b')
    ylabel({chanLoc{j,1},['n=' num2str(sum(outNumSeg1{j}))]})
    grid on
    set(gca,'ylim',yLims(j,:))
    if j==1
        title(cat(2,titleBase,segRestriction(1)))
    end
end


figure(figNumStart + 1)
    set(gcf,'units','inches')
    set(gcf,'position',[0.5,0.5,screenHeight*xyFactor,screenHeight])
    set(gcf,'paperposition',get(gcf,'position'))
set(gcf,'name',figTitleBase)
for j=1:length(outSeg1)
    subplot(length(outSeg1),1,j)
    hold on
    meanOutSeg1 = mean(outSeg2{j}*segFactor+segOffset,1);
    stdOutSeg1 = std(outSeg2{j}*segFactor+segOffset,[],1);
    plot(to,meanOutSeg1,'r')
    plot([to(plotSkip:plotSkip:end);to(plotSkip:plotSkip:end)],...
        [meanOutSeg1(plotSkip:plotSkip:end)+stdOutSeg1(plotSkip:plotSkip:end);...
        meanOutSeg1(plotSkip:plotSkip:end)-stdOutSeg1(plotSkip:plotSkip:end)],'r')
    ylabel({chanLoc{j,1},['n=' num2str(sum(outNumSeg2{j}))]})
    grid on
    %set(gca,'ylim',[-5000 5000])
    set(gca,'ylim',yLims(j,:))
    if j==1
        title(cat(2,titleBase,segRestriction(2)))
    end
end


figure(figNumStart + 2)
    set(gcf,'units','inches')
    set(gcf,'position',[0.5,0.5,screenHeight*xyFactor,screenHeight])
    set(gcf,'paperposition',get(gcf,'position'))
set(gcf,'name',figTitleBase)
for j=1:length(outSeg1)
    subplot(length(outSeg1),1,j)
    hold on
    meanOutSeg1 = mean(outSeg1{j}*segFactor+segOffset,1);
    stdOutSeg1 = std(outSeg1{j}*segFactor+segOffset,[],1);
    plot(to,meanOutSeg1,'b')
    plot([to(round(plotSkip/2):plotSkip:end);to(round(plotSkip/2):plotSkip:end)],...
        [meanOutSeg1(round(plotSkip/2):plotSkip:end)+stdOutSeg1(round(plotSkip/2):plotSkip:end);...
        meanOutSeg1(round(plotSkip/2):plotSkip:end)-stdOutSeg1(round(plotSkip/2):plotSkip:end)],'b')
    meanOutSeg1 = mean(outSeg2{j}*segFactor+segOffset,1);
    stdOutSeg1 = std(outSeg2{j}*segFactor+segOffset,[],1);
    plot(to,meanOutSeg1,'r')
    plot([to(plotSkip:plotSkip:end);to(plotSkip:plotSkip:end)],...
        [meanOutSeg1(plotSkip:plotSkip:end)+stdOutSeg1(plotSkip:plotSkip:end);...
        meanOutSeg1(plotSkip:plotSkip:end)-stdOutSeg1(plotSkip:plotSkip:end)],'r')
    ylabel({chanLoc{j,1},['n1=' num2str(sum(outNumSeg1{j}))],['n2=' num2str(sum(outNumSeg2{j}))]})
    grid on
    %set(gca,'ylim',[-5000 5000])
    set(gca,'ylim',yLims(j,:))
    if j==1
        title(cat(2,titleBase))
    end
end

