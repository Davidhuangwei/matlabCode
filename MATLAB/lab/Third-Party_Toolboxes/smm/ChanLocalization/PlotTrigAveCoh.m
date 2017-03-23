function PlotTrigAveCoh(animalDirs,filesNameCell,fileExt,trigFileBase,varargin)
chanLocVersion = DefaultArgs(varargin,'Min');

% [outSpec1 fo to coi outNumSeg1] = LoadRippTrigAveSpec(animalDirs,fileExt,segLen,segRestriction{1},chanLocVersion);
% [stdSpec1 fo to coi outNumSeg1] = LoadRippTrigStdSpec(animalDirs,fileExt,segLen,segRestriction{1},chanLocVersion);
% [outSpec2 fo to coi outNumSeg2] = LoadRippTrigAveSpec(animalDirs,fileExt,segLen,segRestriction{2},chanLocVersion);
% [stdSpec2 fo to coi outNumSeg2] = LoadRippTrigStdSpec(animalDirs,fileExt,segLen,segRestriction{2},chanLocVersion);
% [outSeg1  outNumSeg1] = LoadRippTrigAveSegs(animalDirs,fileExt,segLen,segRestriction{1},chanLocVersion);
% [outSeg2  outNumSeg2] = LoadRippTrigAveSegs(animalDirs,fileExt,segLen,segRestriction{2},chanLocVersion);
% 
[outCoh fo to coi outNumSeg3] = LoadTrigAveCoh(animalDirs,filesNameCell,...
    fileExt,trigFileBase,chanLocVersion);
chanLoc = Struct2CellArray(LoadVar(['ChanInfo/ChanLoc_' chanLocVersion fileExt ]));
eegSamp = 1250;
fo = fliplr(fo);
% for j=1:length(outSpec1)
%     outSpec1{j} = flipdim(outSpec1{j},2);
%     outSpec2{j} = flipdim(outSpec2{j},2);    
%     stdSpec2{j} = flipdim(stdSpec2{j},2); 
% end
for j=1:length(outCoh)
    for k=1:length(outCoh)
        outCoh{j,k} = flipdim(outCoh{j,k},2);
    end
end

figNumStart = 1;

titleBase = SaveTheUnderscores({'Ripple Triggered Ave Cohereogram',...
    [segRestriction{1} ,num2str(segLen),fileExt]});
figTitleBase = ['RippTrigTrigCoh_' segRestriction{1} num2str(segLen) fileExt];

screenHeight = 11;
xyFactor = 1.5;


for k=1:size(outCoh,1)
    figure(figNumStart + k)
    set(gcf,'units','inches')
    set(gcf,'position',[0.5,0.5,screenHeight*xyFactor,screenHeight])
    set(gcf,'paperposition',get(gcf,'position'))
    set(gcf,'name',figTitleBase)
    for j=1:size(outCoh,2)
        subplot(length(outCoh),1,j)
        meanSpec = UnATanCoh(squeeze(mean(cat(1,outCoh{k,j},outCoh{j,k}),1)));
        imagesclogy(to,fo,meanSpec);
%         imagesclogy(to,fo,meanSpec-repmat(mean(meanSpec,2),[1 size(meanSpec,2)]));
        hold on
        plot(to,eegSamp./coi,'k')

        %     set(gca,'ylim',[0 250])
        set(gca,'clim',[0 1])
        ylabel({chanLoc{j,1},['n1=' num2str(sum(outNumSeg3{k,j}))],...
            ['ns=' num2str(size(outCoh{k,j},1) + size(outCoh{j,k},1))]})
        grid on
        colorbar
        if j==1
            title(cat(2,titleBase,'outCoh'))
        end
    end
end

for k=1:size(outCoh,1)
    figure(figNumStart + k + size(outCoh,1))
    set(gcf,'units','inches')
    set(gcf,'position',[0.5,0.5,screenHeight*xyFactor,screenHeight])
    set(gcf,'paperposition',get(gcf,'position'))
    set(gcf,'name',figTitleBase)
    for j=1:size(outCoh,2)
        subplot(length(outCoh),1,j)
        meanSpec = squeeze(mean(cat(1,outCoh{k,j},outCoh{j,k}),1));
        stdSpec = squeeze(std(cat(1,outCoh{k,j},outCoh{j,k}),[],1));
%         imagesclogy(to,fo,meanSpec);
        imagesclogy(to,fo,(meanSpec-repmat(mean(meanSpec,2),[1 size(meanSpec,2)]))...
            ./stdSpec);
        hold on
        plot(to,eegSamp./coi,'k')

        %     set(gca,'ylim',[0 250])
        set(gca,'clim',[-3 3])
        ylabel({chanLoc{j,1},['n1=' num2str(sum(outNumSeg3{k,j}))],...
            ['ns=' num2str(size(outCoh{k,j},1) + size(outCoh{j,k},1))]})
        grid on
        colorbar
        if j==1
            title(cat(2,titleBase,'(outCoh - mean(time))/std(animalxchanks)'))
        end
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
