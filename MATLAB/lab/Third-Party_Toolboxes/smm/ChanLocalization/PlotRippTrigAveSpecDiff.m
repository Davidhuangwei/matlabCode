function PlotRippTrigAveSpecDiff(animalDirs,fileExt,segLen,segRestriction,varargin)
chanLocVersion = DefaultArgs(varargin,'Min');

[outSpec1 fo to coi outNumSeg1] = LoadRippTrigAveSpec(animalDirs,fileExt,segLen,segRestriction{1},chanLocVersion);
[stdSpec1 fo to coi outNumSeg1] = LoadRippTrigStdSpec(animalDirs,fileExt,segLen,segRestriction{1},chanLocVersion);
[outSpec2 fo to coi outNumSeg2] = LoadRippTrigAveSpec(animalDirs,fileExt,segLen,segRestriction{2},chanLocVersion);
[stdSpec2 fo to coi outNumSeg2] = LoadRippTrigStdSpec(animalDirs,fileExt,segLen,segRestriction{2},chanLocVersion);

chanLoc = Struct2CellArray(LoadVar(['ChanInfo/ChanLoc_' chanLocVersion fileExt ]));
eegSamp = 1250;
fo = fliplr(fo);
for j=1:length(outSpec1)
    outSpec1{j} = flipdim(outSpec1{j},2);
    stdSpec1{j} = flipdim(stdSpec1{j},2); 
    outSpec2{j} = flipdim(outSpec2{j},2);    
    stdSpec2{j} = flipdim(stdSpec2{j},2); 
end

figNumStart = 1;

titleBase = SaveTheUnderscores({'Ripple Triggered Ave Spectrogram Diff',...
    [segRestriction{1} ' - ' segRestriction{2},num2str(segLen),fileExt]});
figTitleBase = ['RippTrigAveSpecDiff_' segRestriction{1} '-' segRestriction{2} num2str(segLen) fileExt];

screenHeight = 11;
xyFactor = 1.5;
% segFactor = -(length(fo)/2)/max(max(cat(1,outSeg1{:},outSeg2{:})));
%segFactor = max(fo)/100000;
% segOffset = length(fo)/2;
% plotSkip = 40;


figure(figNumStart + 0)
    set(gcf,'units','inches')
    set(gcf,'position',[0.5,0.5,screenHeight*xyFactor,screenHeight])
    set(gcf,'paperposition',get(gcf,'position'))
set(gcf,'name',figTitleBase)
for j=1:length(outSpec1)
    subplot(length(outSpec1),1,j)
    imagesclogy(to,fo,squeeze(mean(outSpec1{j},1) - mean(outSpec2{j},1)));
        hold on
    plot(to,eegSamp./coi,'k')
    
%     set(gca,'ylim',[0 250])
    set(gca,'clim',[-3 3])
    ylabel({chanLoc{j,1},['n1=' num2str(sum(outNumSeg1{j}))],['n2=' num2str(sum(outNumSeg2{j}))]})
    grid on
    colorbar
    if j==1
        title(cat(2,titleBase,'outSpec1 - outSpec2'))
    end
end

figure(figNumStart + 1)
    set(gcf,'units','inches')
    set(gcf,'position',[0.5,0.5,screenHeight*xyFactor,screenHeight])
    set(gcf,'paperposition',get(gcf,'position'))
set(gcf,'name',figTitleBase)
for j=1:length(outSpec1)
    subplot(length(outSpec1),1,j)
    imagesclogy(to,fo,squeeze((mean(outSpec1{j},1) - mean(outSpec2{j},1))...
        ./mean(cat(1,stdSpec1{j},stdSpec2{j}),1)));
        hold on
    plot(to,eegSamp./coi,'k')
%     set(gca,'ylim',[0 250])
    set(gca,'clim',[-1 1])
    ylabel({chanLoc{j,1},['n1=' num2str(sum(outNumSeg1{j}))],['n2=' num2str(sum(outNumSeg2{j}))]})
    grid on
    colorbar
    if j==1
        title(cat(2,titleBase,'(outSpec1 - outSpec2) / mean(stdSpec1,stdSpec2)'))
    end
end

figure(figNumStart + 2)
    set(gcf,'units','inches')
    set(gcf,'position',[0.5,0.5,screenHeight*xyFactor,screenHeight])
    set(gcf,'paperposition',get(gcf,'position'))
set(gcf,'name',figTitleBase)
for j=1:length(outSpec1)
    subplot(length(outSpec1),1,j)
    imagesclogy(to,fo,squeeze((mean(outSpec1{j},1) - mean(outSpec2{j},1))...
        ./std(cat(1,outSpec1{j},outSpec2{j}),[],1)));
        hold on
    plot(to,eegSamp./coi,'k')
%     set(gca,'ylim',[0 250])
    set(gca,'clim',[-1 1])
    ylabel({chanLoc{j,1},['n1=' num2str(sum(outNumSeg1{j}))],['n2=' num2str(sum(outNumSeg2{j}))]})
    grid on
    colorbar
    if j==1
        title(cat(2,titleBase,'(outSpec1 - outSpec2) / std(outSpec1,outSpec2)'))
    end
end

