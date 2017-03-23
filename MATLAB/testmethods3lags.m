clear all
close all
funclist={'ar'};
[xt,y]=ARsequence(5000);
np=30;% lags to be calculated
figure; plot(real(xt))
sps=[400,800,1200,1600,2000,2400,2800,3200];
nsps=length(sps);
nci=zeros(np,7,4,nsps);
par.width=.3;
stt=2;
pl=zeros(np,2,nsps);
MI=zeros(np,2,nsps);
nte=zeros(np,2,nsps);
me=zeros(np,2,nsps);
ste=zeros(np,2,nsps);
pval=zeros(np,2,nsps);
h=cell(np,2,nsps);

A=zeros(np,2,nsps);
NI=zeros(np,2,nsps);
NIP=zeros(np,2,nsps);
xn=fangle(xt([1:end]'));
y=fangle(y([1:end]'));
lt=length(y);
for n=1:np%3%
    % !, 5, 7
    X=xn(stt:(end-n));
    Y=y((n+stt):end);
    iX=y(stt:(end-n));
    iY=xn((n+stt):end);
    for m=1:nsps
        pl(n,1,m)=X(1:sps(m))'*Y(1:sps(m))/(lt-stt-n+1);
        pl(n,2,m)=iX(1:sps(m))'*iY(1:sps(m))/(lt-stt-n+1);
        MI(n,1,m)=MutualInformation(angle(X(1:sps(m))),angle(Y(1:sps(m))),11,11);
        MI(n,2,m)=MutualInformation(angle(iX(1:sps(m))),angle(iY(1:sps(m))),11,11);
        %         nci(n,:,1)=KCIcausal_new(X,Y,[xn(1:(end-n-stt+1)),y((stt-1+n):(end-1)),y((stt-2+n):(end-2))],par,1:(lt-n),0);%,y(stt:(end-n))
        %         nci(n,:,2)=KCIcausal_new(iX,iY,[y(1:(end-n-stt+1)),xn((stt-1+n):(end-1)),xn((stt-2+n):(end-2))],par,1:(lt-n),0);%xn(stt:(end-n)),
        nci(n,:,s1,m)=KCIcausal_new(X(1:sps(m)),Y(1:sps(m)),iX(1:sps(m)),par,1:(lt-n),0);%,y(stt:(end-n))
        nci(n,:,2,m)=KCIcausal_new(iX(1:sps(m)),iY(1:sps(m)),X(1:sps(m)),par,1:(lt-n),0);%xn(stt:(end-n)),
        [nte(n,1,m), me(n,1,m), ste(n,1,m), pval(n,1,m), h{n,1,m}, ~, ~, ~, ~]=nTE_n(Y(1:sps(m)),X(1:sps(m)),iX(1:sps(m)),400);
        [nte(n,2,m), me(n,2,m), ste(n,2,m), pval(n,2,m), h{n,2,m}, ~, ~, ~, ~]=nTE_n(iY(1:sps(m)),iX(1:sps(m)),X(1:sps(m)),400);
        %         [Ress, A(n,1)]=BasicRegression(X,Y);
        Ress=fangle(Y(1:sps(m)).*conj(X(1:sps(m))));
        [NIP(n,1,m),NI(n,1,m)]=UInd_KCItest(X(1:sps(m)), Ress);
        %         [Ress, A(n,2)]=BasicRegression(iX,iY);
        [NIP(n,2,m),NI(n,2,m)]=UInd_KCItest(iX(1:sps(m)), Ress);
    end
end

figure(1)
plot(1:np,sq(nci(:,5,1,:)))
hold on
plot(1:np,sq(nci(:,5,2,:)),'+-')
legend(num2str(sps))