function showFiltLFP()
cd ~/data/sm/4_16_05_merged/
load 7_25
cnames={'pl','nte','me','ste','pci','cci','cpap'};
lcnames=length(cnames);
for n=1:2
    for k=1:lcnames
        figure(224)
        subplot(2,lcnames,k+(n-1)*lcnames)
        eval(['imagesc(sq(abs(', cnames{k}, '(:,', num2str(n), ',:))))'])
        set(gca,'Xtick', 1:(2*nlag-1),'Xticklabel',(-nlag+1):(nlag-1),'Ytick',1:length(b),'Yticklabel',FreqBins(:,2)-40)
        
        if (n==1) || (k==1)
            title(cnames{k})
        else
            title(['inv', cnames{k}])
        end
    end
end
saveas(gcf,['fltWidthSPL_', num2str(Channels(1)), '_',num2str(Channels(2)), '.fig'])
ytick=1:size(FreqBins,1);
xlabels=(-nlag+1):2:(nlag-1);
xticks=1:2:(2*nlag-1);
ylabels=FreqBins(:,2)-40;
for n=1:2
        figure(225)
        subplot(2,4,1+(n-1)*4)
        imagesc(sq(abs(pl(:,n,:))))%,[0,.26]
        set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
        title(cnames{1})
        subplot(2,4,2+(n-1)*4)
        imagesc(sq(abs(nte(:,n,:)-me(:,n,:))-ste(:,n,:)))
        set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
        if n==1
            title('nTE')
        else
            title('inv nTE')
        end
        subplot(2,4,3+(n-1)*4)
        imagesc(sq(pci(:,n,:)),[0, .05])
        set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
        if n==1
            title('pair independent')
        else
            title('inv pair independent')
        end
        subplot(2,4,4+(n-1)*4)
        imagesc(sq(cci(:,n,:)),[0, .05])
        set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
        if n==1
            title('c independent')
        else
            title('inv c independent')
        end
end
figure(223)
imagesc(sq(abs(nte(:,1,:)-me(:,1,:))-ste(:,1,:))-(sq(abs(nte(:,2,:)-me(:,2,:))-ste(:,2,:))))
set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
figure(222)
imagesc(sq(abs(nte(:,1,:)-me(:,1,:))./ste(:,1,:))-(sq(abs(nte(:,2,:)-me(:,2,:))./ste(:,2,:))))
set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
