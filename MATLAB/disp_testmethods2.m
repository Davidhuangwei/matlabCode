figure(325)
% plot(1:800,angle(xt),'LineWidth',2)
yy=zeros(800,3);
% for k=1:lf%5%32%
%     istest=false;
%     yy(:,k)=feval(funclist([1,3]){k},xt,b,a,istest);
% end
hold on

% figure(325)
% stt=20;
% n=15;
% plot(angle(xt(stt:(end-n))),angle(yy((n+stt):end,:)),'.')
% axis tight
% legend(funclist([1,3]))
% xlabel('phase of cause')
% ylabel('phase of effect')


figure(325)
subplot(421)
plot(1:np,sq(std(abs(pl(:,[1 3],1,:)),[],4)))
hold on
plot(1:np,sq(std(abs(pl(:,[1 3],2,:)),[],4)),'+-')
legend(funclist([1,3]))
axis([1,np,0,1])
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:2:(2*np)))
ylabel('resultant length','FontSize',12)
title('phase locking value','FontSize',12)
subplot(422)
plot(1:np,sq(std(MI(:,[1 3],1,:),[],4)))
hold on
plot(1:np,sq(std(MI(:,[1 3],2,:),[],4)),'+-')
legend(funclist([1,3]))
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:2:(2*np)))
ylabel('MI','FontSize',12)
title('mutual information','FontSize',12)
subplot(423)
plot(1:np,sq(std(abs(nte(:,[1 3],1,:))-abs(me(:,[1 3],1,:)),[],4)))%
hold on
plot(1:np,sq(std(abs(nte(:,[1 3],2,:))-abs(me(:,[1 3],2,:)),[],4)),'+-')%
legend(funclist([1,3]))
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:2:(2*np)))
ylabel('|nTE-std(nTE)|','FontSize',12)
title('nTE')
subplot(424)
plot(1:np,sq(std(nci(:,[1 3],4,1,:),[],5)))
hold on
plot(1:np,sq(std(nci(:,[1 3],4,2,:),[],5)),'+-')
legend(funclist([1,3]))
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:2:(2*np)))
ylabel('tr','FontSize',12)% p-val
title('conditional independency test','FontSize',12)
subplot(425)
plot(1:np,sq(std(abs(NIP(:,[1 3],1,:)),[],4)))
hold on
plot(1:np,sq(std(abs(NIP(:,[1 3],2,:)),[],4)),'+-')
legend(funclist([1,3]))
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:2:(2*np)))
ylabel('TR','FontSize',12)
title('noise independency test','FontSize',12)
subplot(426)
plot(1:np,sq(std(nci(:,[1 3],2,1,:),[],5)))
hold on
plot(1:np,sq(std(nci(:,[1 3],2,2,:),[],5)),'+-')
legend(funclist([1,3]))
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:2:(2*np)))
ylabel('TR','FontSize',12)% p-val
title('non-conditional independency test','FontSize',12)
subplot(427)
plot(1:np,sq(std(nci(:,[1 3],1,1,:),[],5)))
hold on
plot(1:np,sq(std(nci(:,[1 3],1,2,:),[],5)),'+-')
legend(funclist([1,3]))
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:2:(2*np)))
ylabel('p-val','FontSize',12)% p-val
title('non-conditional independency test','FontSize',12)
subplot(428)
plot(1:np,sq(std(nci(:,[1 3],5,1,:),[],5)))
hold on
plot(1:np,sq(std(nci(:,[1 3],5,2,:),[],5)),'+-')
legend(funclist([1,3]))
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:2:(2*np)))
ylabel('p-val','FontSize',12)% p-val
title('conditional independency test','FontSize',12)