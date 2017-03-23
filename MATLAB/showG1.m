mks={'-','+-'};
sfr=[55 90];
mm=1;
%     load(['compLFP6-43.', num2str(sfr(mm)), 'Hz.basictests.hphase.mat'])
    for nn=1:2
    figure(227)
    subplot(nl,nc,(mm-1)*nc+1)
    hold on
    plot(x,sq(abs(pl(:,nn,:))),mks{nn})%,[0,.26]
    legend(num2str(FreqBins(:,2)))
        title('phase locking value')
        axis tight
        ylabel(['from', num2str(sfr(mm)), 'Hz'])
    subplot(nl,nc,(mm-1)*nc+2)
    hold on
    plot(x,sq(pci(:,nn,:)),mks{nn})
    ylabel('p-val')
axis tight
        title('pair independent')
    subplot(nl,nc,(mm-1)*nc+3)
    hold on
    plot(x,sq(cci(:,nn,:)),mks{nn})
    ylabel('p-val')
axis tight
        title('c independent')
    end
mm=2;
%     load(['compLFP6-43.', num2str(sfr(mm)), 'Hz.basictests.hphase.mat'])
    for nn=1:2
    figure(227)
    subplot(nl,nc,(mm-1)*nc+1)
    hold on
    plot(x,sq(pst(:,nn,:)),mks{nn})%sq(angle(conj(pl(:,nn,:)))),[0,.26]
    legend(num2str(FreqBins(:,2)))
        title('stat of nonconditional dependency test')%phase difference
        axis tight
        ylabel(['from', num2str(sfr(mm)), 'Hz'])
    subplot(nl,nc,(mm-1)*nc+2)
    hold on
    plot(x,(sq(abs(nte(:,nn,:)))-sq(abs(me(:,nn,:))))./sq(ste(:,nn,:)),mks{nn})
    ylabel('nte-mean(nte) (bits)')
axis tight
        title('nTE')
    subplot(nl,nc,(mm-1)*nc+3)
    hold on
    plot(x,sq(cst(:,nn,:)),mks{nn})
    ylabel('p-val')
axis tight
        title('c independent stat')
    end