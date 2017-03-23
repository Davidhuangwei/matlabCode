function PlotRippTrigAveSeg(animalDirs,fileExt,segLen,segRestriction,varargin)
chanLocVersion = DefaultArgs(varargin,'Min');

[outSpec fo to coi outSeg] = LoadRippTrigAveSegs(animalDirs,fileExt,segLen,segRestriction,chanLocVersion);
[stdSpec fo to coi outSeg2] = LoadRippTrigStdSegs(animalDirs,fileExt,segLen,segRestriction,chanLocVersion);

chanLoc = Struct2CellArray(LoadVar(['ChanInfo/ChanLoc_' chanLocVersion fileExt ]));
eegSamp = 1250;
fo = fliplr(fo);
for j=1:length(outSpec)
    outSpec{j} = flipdim(outSpec{j},2);
    stdSpec{j} = flipdim(stdSpec{j},2);    
end

figNumStart = 4;

titleBase = {'Ripple Triggered Ave Spectrogram',[segRestriction,num2str(segLen),fileExt]};
figTitleBase = ['RippTrigSeg_' segRestriction num2str(segLen) fileExt];

screenHeight = 11;
xyFactor = 1.5;


figure(figNumStart + 0)
    set(gcf,'units','inches')
    set(gcf,'position',[0.5,0.5,screenHeight*xyFactor,screenHeight])
    set(gcf,'paperposition',get(gcf,'position'))
set(gcf,'name',figTitleBase)
for j=1:length(outSpec)
    subplot(length(outSpec),1,j)
    meanSpec = mean(outSpec{j});
    imagesclogy(to,fo,squeeze(meanSpec...
        - repmat(mean(meanSpec,3),[1,1,size(meanSpec,3)])));
        hold on
    plot(to,eegSamp./coi,'k')
%     set(gca,'ylim',[0 250])
    set(gca,'clim',[-5 5])
    ylabel({chanLoc{j,1},['n=' num2str(sum(outSeg{j}))]})
    grid on
    colorbar
    if j==1
        title(cat(2,titleBase,'x - mean(timeWin)'))
    end
end

figure(figNumStart + 1)
    set(gcf,'units','inches')
    set(gcf,'position',[0.5,0.5,screenHeight*xyFactor,screenHeight])
    set(gcf,'paperposition',get(gcf,'position'))
set(gcf,'name',figTitleBase)
for j=1:length(outSpec)
    subplot(length(outSpec),1,j)
    imagesclogy(to,fo,squeeze(std(outSpec{j},[],1)));
        hold on
    plot(to,eegSamp./coi,'k')
%     set(gca,'ylim',[0 250])
     set(gca,'clim',[0 8])
    ylabel({chanLoc{j,1},['n=' num2str(sum(outSeg{j}))]})
    colorbar
    grid on
    if j==1
        title(cat(2,titleBase,'std(shanksXanimals)'))
    end
end

figure(figNumStart + 2)
    set(gcf,'units','inches')
    set(gcf,'position',[0.5,0.5,screenHeight*xyFactor,screenHeight])
    set(gcf,'paperposition',get(gcf,'position'))
set(gcf,'name',figTitleBase)
for j=1:length(outSpec)
    subplot(length(outSpec),1,j)
    meanSpec = mean(outSpec{j});
    imagesclogy(to,fo,squeeze((meanSpec...
        - repmat(mean(meanSpec,3),[1,1,size(meanSpec,3)]))...
        ./ std(outSpec{j},[],1)));
        hold on
    plot(to,eegSamp./coi,'k')
%     set(gca,'ylim',[0 250])
    set(gca,'clim',[-1 1])
    ylabel({chanLoc{j,1},['n=' num2str(sum(outSeg{j}))]})
    colorbar
    grid on
    if j==1
        title(cat(2,titleBase,'(x - mean(timeWin))/std(shanksXanimals)'))
    end
end

figure(figNumStart + 3)
    set(gcf,'units','inches')
    set(gcf,'position',[0.5,0.5,screenHeight*xyFactor,screenHeight])
    set(gcf,'paperposition',get(gcf,'position'))
set(gcf,'name',figTitleBase)
for j=1:length(outSpec)
    subplot(length(outSpec),1,j)
    meanSpec = mean(outSpec{j},3);
    plotSpec = squeeze(mean(stdSpec{j})) ;
    imagesclogy(to,fo,plotSpec);
        hold on
    plot(to,eegSamp./coi,'k')
%     set(gca,'ylim',[0 250])
%      set(gca,'clim',[0 8])
    ylabel({chanLoc{j,1},['n=' num2str(sum(outSeg{j}))]})
    grid on
    colorbar
    if j==1
        title(cat(2,titleBase,'std(trials)'))
    end
end

figure(figNumStart + 4)
    set(gcf,'units','inches')
    set(gcf,'position',[0.5,0.5,screenHeight*xyFactor,screenHeight])
    set(gcf,'paperposition',get(gcf,'position'))
set(gcf,'name',figTitleBase)
for j=1:length(outSpec)
    subplot(length(outSpec),1,j)
    meanSpec = mean(outSpec{j},3);
    plotSpec = squeeze(mean((outSpec{j} - repmat(meanSpec,[1,1,size(outSpec{j},3)])) ...
        ./ stdSpec{j} ,1)) ;
    imagesclogy(to,fo,plotSpec);
        hold on
    plot(to,eegSamp./coi,'k')
%     set(gca,'ylim',[0 250])
    set(gca,'clim',[-1 1])
    ylabel({chanLoc{j,1},['n=' num2str(sum(outSeg{j}))]})
    grid on
    colorbar
    if j==1
        title(cat(2,titleBase,'mean(x - mean(timeWin)/std(trials)shanksXanimals)'))
    end
end

% 
% nPlots = 8;
%     screenHeight = 11;
%     xyFactor = 1.5;
%     set(gcf,'units','inches')
%     set(gcf,'position',[0.5,0.5,screenHeight,screenHeight])
%     set(gcf,'paperposition',get(gcf,'position'))
% 
% maxWin = 
% for j=1:6
%     figure(j)
% 
%     set(gcf,'units','inches')
%     set(gcf,'position',[0.5,0.5,screenHeight*xyFactor,screenHeight])
%     set(gcf,'paperposition',get(gcf,'position'))
% end

% figure(4)
% for j=1:length(outSpec)
%     subplot(length(outSpec),1,j)
%     meanSpec = mean(outSpec{j});
%     imagesclogy(to,fliplr(fo),flipud(squeeze((meanSpec...
%         - repmat(mean(meanSpec,3),[1,1,size(meanSpec,3)]))...
%         ./ std(outSpec{j},[],1))));
%     %set(gca,'ylim',[0 250])
%     %shading interp
%     set(gca,'clim',[-3 3])
%     hold on
%     plot(to,eegSamp./coi,'k')
%     ylabel(chanLoc{j,1})
%     colorbar
% end
