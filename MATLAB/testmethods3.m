clear all
close all
funclist={'ar'};
[xt,y]=ARsequence(5000);
lf=1;
np=30;% lags to be calculated
figure; plot(real(xt))
sps=[800,1600,2400];
nsps=length(sps);
nci=zeros(np,lf,7,4,nsps);
par.width=.3;
stt=2;
pl=zeros(np,lf,2,nsps);
MI=zeros(np,lf,2,nsps);
nte=zeros(np,lf,2,nsps);
me=zeros(np,lf,2,nsps);
ste=zeros(np,lf,2,nsps);
pval=zeros(np,lf,2,nsps);
h=cell(np,lf,2,nsps);

A=zeros(np,lf,2,nsps);
NI=zeros(np,lf,2,nsps);
NIP=zeros(np,lf,2,nsps);
for k=1:lf%5%32%
    xn=fangle(xt([1:end]'));
    y=fangle(y([1:end]'));
    if k==1
        lt=length(y);
    end
    for n=1:np%3%
        % !, 5, 7
        X=xn(stt:(end-n));
        Y=y((n+stt):end);
        iX=y(stt:(end-n));
        iY=xn((n+stt):end);
        for m=1:nsps
        pl(n,k,1,m)=X(1:sps(m))'*Y(1:sps(m))/(lt-stt-n+1);
        pl(n,k,2,m)=iX(1:sps(m))'*iY(1:sps(m))/(lt-stt-n+1);
        MI(n,k,1,m)=MutualInformation(angle(X(1:sps(m))),angle(Y(1:sps(m))),11,11);
        MI(n,k,2,m)=MutualInformation(angle(iX(1:sps(m))),angle(iY(1:sps(m))),11,11);
%         nci(n,k,:,1)=KCIcausal_new(X,Y,[xn(1:(end-n-stt+1)),y((stt-1+n):(end-1)),y((stt-2+n):(end-2))],par,1:(lt-n),0);%,y(stt:(end-n))
%         nci(n,k,:,2)=KCIcausal_new(iX,iY,[y(1:(end-n-stt+1)),xn((stt-1+n):(end-1)),xn((stt-2+n):(end-2))],par,1:(lt-n),0);%xn(stt:(end-n)),
        nci(n,k,:,1,m)=KCIcausal_new(X(1:sps(m)),Y(1:sps(m)),[iX(1:sps(m)),[1:sps(m)]'],par,1:(lt-n),0);%,y(stt:(end-n))
        nci(n,k,:,2,m)=KCIcausal_new(iX(1:sps(m)),iY(1:sps(m)),[X(1:sps(m)),[1:sps(m)]'],par,1:(lt-n),0);%xn(stt:(end-n)),
        [nte(n,k,1,m), me(n,k,1,m), ste(n,k,1,m), pval(n,k,1,m), h{n,k,1,m}, ~, ~, ~, ~]=nTE_n(Y(1:sps(m)),X(1:sps(m)),iX(1:sps(m)),400);
        [nte(n,k,2,m), me(n,k,2,m), ste(n,k,2,m), pval(n,k,2,m), h{n,k,2,m}, ~, ~, ~, ~]=nTE_n(iY(1:sps(m)),iX(1:sps(m)),X(1:sps(m)),400);
%         [Ress, A(n,k,1)]=BasicRegression(X,Y);
        Ress=fangle(Y(1:sps(m)).*conj(X(1:sps(m))));
        [NIP(n,k,1,m),NI(n,k,1,m)]=UInd_KCItest(X(1:sps(m)), Ress);
%         [Ress, A(n,k,2)]=BasicRegression(iX,iY);
        [NIP(n,k,2,m),NI(n,k,2,m)]=UInd_KCItest(iX(1:sps(m)), Ress);
        end
    end
end
for k=[1, 2, 3, 5, 7]
figure(10+k)
plot(1:np,sq(nci(:,:,k,1)))
hold on
plot(1:np,sq(nci(:,:,k,2)),'+-')
legend(funclist)
end