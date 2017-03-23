nHP=33:.5:40;
FRN=2;
figure(FRN)
for k=1:6
    subplot(3,7,k)
    plot(S(FRN).gbsnm(:,k),nHP,'Linewidth',3)
    hold on 
    plot(bsxfun(@times,S(FRN).nm{k},sign(S(FRN).gbsnm(:,k)'*S(FRN).nm{k})),nHP,':')
    axis tight 
    xlim([-.69 .69])
    plot([0 0],nHP([1 end]),':')
%     plot(S(FRN).muny(:,k),nHP,'g','Linewidth',3)
    hold off
    subplot(3,7,7+k)
    plot(S(FRN).rfA(:,k),nHP,'Linewidth',3)
    hold on
    axis tight 
    xlim([-.69 .69])
    plot([0 0],nHP([1 end]),':')
   
%     tnm=sprintf('Freq %d-%d Hz',FreqBins(FRN,:));
%     title(tnm)
    hold off
    subplot(3,7,14+k)
    plot(S(FRN).gbwnm(:,k),nHP,'Linewidth',3)
    hold on
    axis tight 
    xlim([-.69 .69])
    plot([0 0],nHP([1 end]),':')
   
%     tnm=sprintf('Freq %d-%d Hz',FreqBins(FRN,:));
%     title(tnm)
    hold off
end 
subplot(3,7,14)
    plot(S(FRN).rfA(:,7),nHP,'Linewidth',3)
    hold on
    axis tight 
    xlim([-.69 .69])
    plot([0 0],nHP([1 end]),':')
ForAllSubplots('axis xy')
ForAllSubplots('axis ij')
%phasediff=angle(exp(i*bsxfun(@minus,S(FRN).thetaphase,Par.thetaphase)));
% for k=6:12; [ui(1,k), up(1,k)]=UInd_KCItestnb(S(FRN).thetaphase(:,k),phasediff(:,k),.08);[ui(2,k),up(2,k)]=UInd_KCItestnb(Par.thetaphase,phasediff(:,k),.08);end;
up=S(FRN).up
% S(FRN).up(:,6:12)=up(:,6:12)
% S(FRN).ui(:,6:12)=ui(:,6:12);
