
% figure(325)
% stt=20;
% n=15;
% plot(angle(xt(stt:(end-n))),angle(y((n+stt):end,:)),'.')
% axis tight
% legend(funclist)
% xlabel('phase of cause')
% ylabel('phase of effect')


figure(328)
subplot(321)
nsps=2;
plot(1:np,sq(abs(pl(:,:,1,:))))
hold on
plot(1:np,sq(abs(pl(:,:,2,:))),'+-')
[mv,md]=max(sq(abs(pl(:,:,1,:))));
plot(md,mv,'ro')
legend(funclist)
axis([1,np,0,1])
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:np))
ylabel('resultant length','FontSize',12)
title('phase locking value','FontSize',12)
hold off
subplot(322)
plot(1:np,sq(MI(:,:,1,:)))
hold on
plot(1:np,sq(MI(:,:,2,:)),'+-')
[mv,md]=max(sq(MI(:,:,1,:)));
plot(md,mv,'ro')
legend(funclist)
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:np))
ylabel('MI','FontSize',12)
title('mutual information','FontSize',12)
hold off
subplot(323)
plot(1:np,sq(abs(nte(:,:,1,:))))%-abs(me(:,:,1,:))
hold on
plot(1:np,sq(abs(nte(:,:,2,:))),'+-')%-abs(me(:,:,2,:))-me(:,:,2,:)
[mv,md]=max(sq(abs(nte(:,:,1,:))));%-abs(me(:,:,1,:))
plot(md,mv,'ro')
legend(funclist)
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:np))
ylabel('nTE(bits)','FontSize',12)%-mean(nTE)
title('nTE')
% plot(1:np,sq(abs(nte(:,:,1,:))-abs(me(:,:,1,:))))%
% hold on
% plot(1:np,sq(abs(nte(:,:,2,:)-abs(me(:,:,2,:)))),'+-')%-me(:,:,2,:)
% [mv,md]=max(sq(abs(nte(:,:,1,:))-abs(me(:,:,1,:))));
% plot(md,mv,'ro')
% legend(funclist)
% axis tight
% xlabel('timelags','FontSize',12)
% set(gca,'XTick',1:np,'XTicklabel',-(1:np))
% ylabel('nTE-mean(nTE)','FontSize',12)
% title('nTE')
hold off
% pval=1-pval;
subplot(324)
plot(1:np,sq(1/sps(nsps)*nci(:,:,3,1,:)))
hold on
plot(1:np,sq(1/sps(nsps)*nci(:,:,3,2,:)),'+-')
[mv,md]=max(sq(1/sps(nsps)*nci(:,:,3,1,:)));
plot(md,mv,'ro')
legend(funclist)
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:np))
ylabel('tr','FontSize',12)% p-val
title('conditional independency test','FontSize',12)
subplot(325)
plot(1:np,sq(abs(pval(:,:,1,:))))
hold on
plot(1:np,sq(abs(pval(:,:,2,:))),'+-')
[mv,md]=min(sq(abs(pval(:,:,1,:))));
plot(md,mv,'ro')
legend(funclist)
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:np))
ylabel('p-val','FontSize',12)
title('pval-nTE','FontSize',12)
subplot(326)
plot(1:np,sq(1/sps(nsps)*nci(:,:,2,1,:)))
hold on
plot(1:np,sq(1/sps(nsps)*nci(:,:,2,2,:)),'+-')
[mv,md]=max(sq(1/sps(nsps)*nci(:,:,2,1,:)));
plot(md,mv,'ro')
legend(funclist)
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:np))
ylabel('Tr','FontSize',12)% p-val
title('nonconditional independency test','FontSize',12)

% show results for KCI
figure(329)
subplot(221)
plot(1:np,sq(nci(:,:,1,1,:)))
hold on
plot(1:np,sq(nci(:,:,1,2,:)),'+-')
[mv,md]=min(sq(nci(:,:,1,1,:)));
plot(md,mv,'ro')
legend(funclist)
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:np))
ylabel('p-val','FontSize',12)% p-val
title('unconditional independency p','FontSize',12)
subplot(222)
plot(1:np,sq(1/sps(nsps)*nci(:,:,2,1,:)))
hold on
plot(1:np,sq(1/sps(nsps)*nci(:,:,2,2,:)),'+-')
[mv,md]=max(sq(1/sps(nsps)*nci(:,:,2,1,:)));
plot(md,mv,'ro')
legend(funclist)
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:np))
ylabel('tr','FontSize',12)% p-val
title('unconditional independent test sta','FontSize',12)
subplot(223)
plot(1:np,sq(nci(:,:,5,1,:)))
hold on
plot(1:np,sq(nci(:,:,5,2,:)),'+-')
[mv,md]=min(sq(nci(:,:,5,1,:)));
plot(md,mv,'ro')
legend(funclist)
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:np))
ylabel('p-val','FontSize',12)% p-val
title('conditional independent test','FontSize',12)
subplot(224)
plot(1:np,sq(1/sps(nsps)*nci(:,:,3,1,:)))
hold on
plot(1:np,sq(1/sps(nsps)*nci(:,:,3,2,:)),'+-')
[mv,md]=max(sq(1/sps(nsps)*nci(:,:,3,1,:)));
plot(md,mv,'ro')
legend(funclist)
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:np))
ylabel('tr','FontSize',12)% p-val
title('conditional independent test sta','FontSize',12)