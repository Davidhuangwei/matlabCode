figure(225)
% plot(1:800,angle(xt),'LineWidth',2)
yy=zeros(800,3);
for k=1:lf%5%32%
    istest=false;
    yy(:,k)=feval(funclist{k},xt,b,a,istest);
end
hold on

figure(225)
stt=20;
n=15;
plot(angle(xt(stt:(end-n))),angle(yy((n+stt):end,:)),'.')
axis tight
legend(funclist)
xlabel('phase of cause')
ylabel('phase of effect')


figure(226)
subplot(221)
plot(1:np,sq(abs(pl(:,:,1))))
hold on
plot(1:np,sq(abs(pl(:,:,2))),'+-')
legend(funclist)
axis([1,np,0,1])
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:2:(2*np)))
ylabel('resultant length','FontSize',12)
title('phase locking value','FontSize',12)
subplot(222)
plot(1:np,sq(MI(:,:,1)))
hold on
plot(1:np,sq(MI(:,:,2)),'+-')
legend(funclist)
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:2:(2*np)))
ylabel('MI','FontSize',12)
title('mutual information','FontSize',12)
subplot(223)
plot(1:np,sq(abs(nte(:,:,1)-me(:,:,1))))
hold on
plot(1:np,sq(abs(nte(:,:,2)-me(:,:,2))),'+-')
legend(funclist)
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:2:(2*np)))
ylabel('|nTE-mean(nTE)|','FontSize',12)
title('nTE')
subplot(224)
plot(1:np,sq(nci(:,:,4,1)))
hold on
plot(1:np,sq(nci(:,:,4,2)),'+-')
legend(funclist)
axis tight
xlabel('timelags','FontSize',12)
set(gca,'XTick',1:np,'XTicklabel',-(1:2:(2*np)))
ylabel('tr','FontSize',12)% p-val
title('conditional independency test','FontSize',12)