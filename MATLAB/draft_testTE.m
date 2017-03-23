figure(225)
sjn=abs(hf.nte-hf.me)./hf.ste;
for k=1:9
    subplot(3,3,k)
    imagesc(1:39,1:32,sq(sjn(k,:,:)),[1 3])
    hold on
    plot([1 39],[9 14; 9 14],'w')
    xlabel(lnames{k})
end
legend('lgamma','hgamma')%'ltheta','htheta','beta',,'hfr'
%% see the average nTE--> didn't show relation to the frequency, nor to the layer 
figure(226)
sjn=abs(hf.me)./hf.ste;%;hf.nte-
for k=1:9
    subplot(3,3,k)
    imagesc(1:39,1:32,sq(sjn(k,:,:)))%,[1 3]
    hold on
    plot([1 39],[9 14; 9 14],'w')
    xlabel(lnames{k})
end
legend('lgamma','hgamma')%'ltheta','htheta','beta',,'hfr'

%% then I check the "manifolds"
figure(2)
hold on
k=2;
n=10;
m=27;
plot3(angle(nLFP(:,3,4,40)),angle(fLFP(:,k,n,m)),angle(nLFP(:,3,4,m)),'r.')
xlabel('effect')
ylabel('cause')
zlabel('condition')
X=[angle(nLFP(:,3,4,40)),angle(fLFP(:,k,n,m)),angle(nLFP(:,3,4,m))];
mf=mean(X,1);
dX=bsxfun(@minus,X ,mf);
[u,v,~]=svd(cov(dX));
figure(2)
hold on
colors={'r+-','k+-','g+-'};
for k=1:3
plot3(mf(1)+[0 u(1,k)]',mf(1)+[0 u(2,k)]',mf(1)+[0 u(3,k)]',colors{k})
end
hold off
figure(3)
nX=dX*u;
subplot(311)
plot(nX(:,1),nX(:,2),'.')
xlabel('1st PC')
ylabel('2nd PC')
subplot(312)
plot(nX(:,2),nX(:,3),'.')
xlabel('2nd PC')
ylabel('3rd PC')
subplot(313)
plot(nX(:,1),nX(:,3),'.')
xlabel('1st PC')
ylabel('3rd PC')