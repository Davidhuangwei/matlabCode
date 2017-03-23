% nc=3;
% nl=2;
% k=1:nl;
% for m=1:2
%     figure(225+ln)
%     subplot(nl,nc,(m-1)*nc+1)
%     imagesc(sq(abs(pl(:,m,:))))%,[0,.26]
%     set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
%     if m==1
%         title(['pair independent', labels{ln}])
%     else
%         title('inv pair independent')
%     end
%     subplot(nl,nc,(m-1)*nc+2)
%     imagesc(sq(pval(:,m,:)),[0, .05])
%     set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
%     if m==1
%         title('pair independent')
%     else
%         title('inv pair independent')
%     end
%     subplot(nl,nc,(m-1)*nc+3)
%     imagesc(sq(cci(:,m,:)),[0, .05])
%     set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
%     if m==1
%         title('c independent')
%     else
%         title('inv c independent')
%     end
% end
% for m=1:2
%     figure(235+ln)
%     subplot(nl,nc,(m-1)*nc+1)
%     imagesc(sq(abs(pl(:,m,:))))%,[0,.26]
%     set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
%     if m==1
%         title(['pair independent', labels{ln}])
%     else
%         title('inv pair independent')
%     end
%     subplot(nl,nc,(m-1)*nc+2)
%     imagesc(sq(abs(nte(:,m,:))))
%     colorbar
%     set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
%     if m==1
%         title('pair independent')
%     else
%         title('inv pair independent')
%     end
%     subplot(nl,nc,(m-1)*nc+3)
%     imagesc(sq(cst(:,m,:)))
%     colorbar
%     set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
%     if m==1
%         title('c independent')
%     else
%         title('inv c independent')
%     end
% end


% marks={'-','+-'};
% xl=([1:(2*nlag-1)]-nlag)*stp;
% for m=1:2
%     figure(245+ln)
%     subplot(1,nc,1)
%     plot(xl,sq(abs(pl(:,m,:))),marks{m})%,[0,.26]
%     hold on
% %     set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
%     legend('12Hz','15Hz','20Hz')
%     if m==1
%         title(['pair independent', labels{ln}])
%     else
%         title('inv pair independent')
%     end
%     subplot(1,nc,2)
%     plot(xl,sq(abs(nte(:,m,:))),marks{m})
%     hold on
%     if m==1
%         title('transfer entropy')
%     else
%         title('inv transfer entropy')
%     end
%     subplot(1,nc,3)
%     plot(xl,sq(cst(:,m,:)),marks{m})
%    hold on
%     if m==1
%         title('c independent')
%     else
%         title('inv c independent')
%     end
% end
% marks={'-','+-'};
% xl=([1:(2*nlag-1)]-nlag)*stp;
% for m=1:2
%     figure(235+ln)
%     subplot(1,nc,1)
%     plot(xl,sq(abs(pl(:,m,:))),marks{m})%,[0,.26]
%     hold on
% %     set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
%     legend('12Hz','15Hz','20Hz')
%     if m==1
%         title(['pair independent', labels{ln}])
%     else
%         title('inv pair independent')
%     end
%     subplot(1,nc,2)
%     plot(xl,sq(abs(nte(:,m,:))-abs(me(:,m,:))),marks{m})
%     hold on
%     if m==1
%         title('transfer entropy')
%     else
%         title('inv transfer entropy')
%     end
%     subplot(1,nc,3)
%     plot(xl,sq(cci(:,m,:)),marks{m})
%    hold on
%     if m==1
%         title('c independent')
%     else
%         title('inv c independent')
%     end
% end
% marks={'-','+-'};
% xl=([1:(2*nlag-1)]-nlag)*stp;
% ps=1:(nlag-1);
% for kkk=1:3
%     load(['compLFP37-78.', States{kkk}, '.basictests.dtl.mat'])
%    
%     nc=4;
%     for m=1:2
%         figure(224)
%         subplot(3,nc,1+nc*(kkk-1))
%         plot(xl(ps),sq(abs(pl(:,m,ps))),marks{m})%,[0,.26]
%         hold on
%         %     set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
%         legend('12Hz','15Hz','20Hz')
%         ylabel(States{kkk})
%         axis tight
%         if kkk==1
%         title(['phase locking', labels{ln}])
%         end
%         
%         subplot(3,nc,2+nc*(kkk-1))
%         plot(xl(ps),sq(abs(nte(:,m,ps))-abs(me(:,m,ps))),marks{m})
%         hold on
%         ylabel('nTE-mean(nTE)')
%         axis tight
%         if kkk==1
%         title('transfer entropy')
%         end
%         
%         subplot(3,nc,3+nc*(kkk-1))
%         plot(xl(ps),sq(cst(:,m,ps)),marks{m})
%         ylabel('TR')
%         hold on
%         axis tight
%         if kkk==1
%         title('c independent meansure')
%         end
%         
%         subplot(3,nc,4+nc*(kkk-1))
%         plot(xl(ps),sq(cci(:,m,ps)),marks{m})
%         hold on
%         ylabel('p-val')
%         axis tight
%         if kkk==1
%         title('c independent test')
%         end
%     end
% end
States={'RUN','REM','SWS'};
marks={'-','+-'};
for kkk=1:3
    load(['compLFP37-78.', States{kkk}, '.basictests.dtl.mat'])
   
xl=[-nlag : (-1)]*stp;%([1:(2*nlag-1)]-nlag)*stp;
ps=1:nlag;%1:(nlag-1);
    nc=4;
    for m=1:2
        figure(224)
        subplot(3,nc,1+nc*(kkk-1))
        plot(xl(ps),sq(abs(pl(:,m,ps))),marks{m})%,[0,.26]
        hold on
        %     set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
        legend('12Hz','15Hz','20Hz')
        ylabel(States{kkk})
        axis tight
        if kkk==1
        title(['phase locking', labels{ln}])
        end
        
        subplot(3,nc,2+nc*(kkk-1))
        plot(xl(ps),sq(abs(nte(:,m,ps))-abs(me(:,m,ps))),marks{m})
        hold on
        ylabel('nTE-mean(nTE)')
        axis tight
        if kkk==1
        title('transfer entropy')
        end
        
        subplot(3,nc,3+nc*(kkk-1))
        plot(xl(ps),sq(cst(:,m,ps)),marks{m})
        ylabel('TR')
        hold on
        axis tight
        if kkk==1
        title('c independent meansure')
        end
        
        subplot(3,nc,4+nc*(kkk-1))
        plot(xl(ps),sq(cci(:,m,ps)),marks{m})
        hold on
        ylabel('p-val')
        axis tight
        if kkk==1
        title('c independent test')
        end
    end
end
States={'RUN','REM','SWS'};
tlg=-12;
hfrb=[2,1,1];
for kkk=1:3
    load(['compLFP37-78.', States{kkk}, '.mat'])
    figure(kkk)
   plot3(cangle(sq(LFP(:,201+tlg,2*hfrb))),cangle(sq(LFP(:,201+tlg,2*hfrb-1))),cangle(sq(LFP(:,201,2*hfrb-1))),'b.')
   xlabel('CA3 past')
   ylabel('CA1 past')
   zlabel('CA1 at bursts')
   title(States{kkk})
   figure(kkk+10)
   plot3(cangle(sq(LFP(:,201+tlg,2*hfrb-1))),cangle(sq(LFP(:,201+tlg,2*hfrb))),cangle(sq(LFP(:,201,2*hfrb))),'r.')
   xlabel('CA1 past')
   ylabel('CA3 past')
   zlabel('CA3 at bursts')
   title(States{kkk})
end
xl=[-nlag : (-1)]*stp;%([1:(2*nlag-1)]-nlag)*stp;
ps=1:nlag;%1:(nlag-1);
    nc=4;
    