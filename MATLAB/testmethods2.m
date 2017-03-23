% function testmethods()
% addpath(genpath('/gpfs01/sirota/homes/weiwei/matlab/'))
% addpath /gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big
% FileBase='4_16_05_merged';
% cd ~/data/sm/4_16_05_merged/
% 
% fnames=dir('4_16_05_merged.phase.ch51*');
% load(fnames.name)
% tfr=[11 11; 11 12; 11 13; 11 14;10 11; 10 12; 10 13; 10 14; 9 11; 9 12; 9 13; 9 14;8 14;7 14;11 16; 11 18; 11 20;11 22];
% ltfr=size(tfr,1);
% pw=sum(abs(out.LFPsig(:,9:14,1)),2);
% f
% Res=find(pw>prctile(pw,99.97));
% Res(Res<81)=[];
% nlag=40;
% LFP=zeros(length(Res),32,2,nlag);
% for k=1:nlag
%     LFP(:,:,:,k)=out.LFPsig(Res-80+2*k,:,:);
% end
% clear out
% nte=zeros(ltfr,ltfr,nlag-1);
% me=zeros(ltfr,ltfr,nlag-1);
% ste=zeros(ltfr,ltfr,nlag-1);
% pval=zeros(ltfr,ltfr,nlag-1);
% h=cell(ltfr,ltfr,nlag-1);
% t=1:length(Res);
% pci=zeros(ltfr,ltfr,nlag-1);
% pst=zeros(ltfr,ltfr,nlag-1);
% cst=zeros(ltfr,ltfr,nlag-1);
% cci=zeros(ltfr,ltfr,nlag-1);
% cpap=zeros(ltfr,ltfr,nlag-1);
% par.width=.4;
% for k=1:ltfr
%         X=fangle(sum(LFP(:,tfr(k,1):tfr(k,2),1,40),2));
%     for n=1:ltfr
%         for m=1:39
%             Z=fangle(sum(LFP(:,tfr(k,1):tfr(k,2),1,m),2));
%             Y=fangle(sum(LFP(:,tfr(n,1):tfr(n,2),2,m),2));
%             [nte(k,n,m), me(k,n,m), ste(k,n,m), pval(k,n,m), h{k,n,m}, XBins, YBins, ZBins, ~]=...
%                 nTE(X,Y,Z,400);
%              oci=...
%                 KCIcausal_new(X,Y,Z,par,t,0);
%             pci(k,n,m)=oci(1);
%             pst(k,n,m)=oci(2);
%             cst(k,n,m)=oci(3);
%             cci(k,n,m)=oci(5);
%             cpap(k,n,m)=oci(7);
%         end
%     end
% end
% for k=1:ltfr
%     
% end
% 
% State='RUN';
% [FeatData, FeatName] = mLoadBurst(FileBase, State);
% mrad=(strcmp(FeatData{15},'CA1rad')' & (abs(FeatData{2}-45)<15) & (FeatData{9}>40));
% [x, indx]=spkcount(FeatData{3}(mrad));
% 
% tst_x=sq(out.LFPsig(:,:,2));
% FreqB=out.FreqBins;
% clear out
% x=sum(tst_x(:,11:16),2);


% simulation
clear all
% close all
b=[0.001,.01,.01,exp(-[0:.5:10])];% [0.001,exp(-[0:5:30])];
a=1;
funclist={ 'orix', 'dfangle', 'ffangle'};% 'freal',, 'fabs',
lf=length(funclist);
np=30;% lags to be calculated
nlevel=.3;
tryn=50;
pl=zeros(np,lf,2,tryn);
MI=zeros(np,lf,2,tryn);
nte=zeros(np,lf,2,tryn);
me=zeros(np,lf,2,tryn);
ste=zeros(np,lf,2,tryn);
pval=zeros(np,lf,2,tryn);
h=cell(np,lf,2,tryn);

nci=zeros(np,lf,7,4,tryn);
A=zeros(np,lf,2,tryn);
NIP=zeros(np,lf,2,tryn);
NI=zeros(np,lf,2,tryn);
par.width=.3;
slth=1000;
stt=2;
for kkn=1:tryn
st=randn(slth,1);%*pirandi(size(x,1)-np*400,1);
% t=st:(st+slth-1);
xt=(exp(-([1:slth]'-300).^2/200^2/2)+exp(-([1:slth]'-500).^2/200^2/2)*.7).*cos((pi*40/650*[1:slth]')+st);%randn(slth,1)+1i*randn(slth,1);%
xt=xt+std(abs(xt))*nlevel*randn(slth,1);%+0.3*rand(slth,1);%x(t);
xt=hilbert(xt);%xt=xt./abs(xt);
% figure; plot(real(xt))
noif=exp(sqrt(-1)*(rand(slth,1)-.5)*pi*.5);%*2

for k=1:lf%5%32%
    istest=false;
    y=feval(funclist{k},xt,b,a,istest);
    y=y.*noif+std(abs(y))*nlevel*rand(slth,1);
    xn=fangle(xt([1:end]'));%:2
    y=fangle(y([1:end]'));%:2
    if k==1
        lt=length(y);
    end
    for n=1:np%3%
        % !, 5, 7
        X=xn(stt:(end-n));
        Y=y((n+stt):end);
        iX=y(stt:(end-n));
        iY=xn((n+stt):end);
        pl(n,k,1,kkn)=X'*Y/(lt-stt-n+1);
        pl(n,k,2,kkn)=iX'*iY/(lt-stt-n+1);
        MI(n,k,1,kkn)=MutualInformation(angle(X),angle(Y),6,6);
        MI(n,k,2,kkn)=MutualInformation(angle(iX),angle(iY),6,6);
        nci(n,k,:,1,kkn)=KCIcausal_new(X,Y,iX,par,1:(lt-n),0);%[xn(1:(end-n-stt+1)),y(stt:(end-n)),y((stt-1):(end-n-1))]
        nci(n,k,:,2,kkn)=KCIcausal_new(iX,iY,X,par,1:(lt-n),0);%[y(1:(end-n-stt+1)),xn(stt:(end-n)),xn((stt-1):(end-n-1))]
        [nte(n,k,1,kkn), me(n,k,1,kkn), ste(n,k,1,kkn), pval(n,k,1,kkn), ~, ~, ~, ~, ~]=nTE_n(Y,X,iX,400);
        [nte(n,k,2,kkn), me(n,k,2,kkn), ste(n,k,2,kkn), pval(n,k,2,kkn), ~, ~, ~, ~, ~]=nTE_n(iY,iX,X,400);
%         [Ress, A(n,k,1)]=BasicRegression(X,Y);
        Ress=X.*conj(Y);
        [NIP(n,k,1,kkn),NI(n,k,1,kkn)]=UInd_KCItest(X, Ress);
%         [Ress, A(n,k,2)]=BasicRegression(iX,iY);
        [NIP(n,k,2,kkn),NI(n,k,2,kkn)]=UInd_KCItest(iX, Ress);
%         pxn=feval(funclist{k},xn,b,a,1);xn(3:(end-n+1)),y(3:(end-n+1)),%
%         nci(n,k,:,2)=KCIcausal_new(pxn(2:(end-n)),y((n+2):end),[pxn(3:(end-n+1)),pxn(1:(end-n-1)),y(2:(end-n))],par,1:(lt-n),0);
%         nci(n,k,:,4)=KCIcausal_new(y(2:(end-n)),pxn((n+2):end),[y(3:(end-n+1)),y(1:(end-n-1)),pxn(2:(end-n))],par,1:(lt-n),0);
    end
    fprintf('*')
end
fprintf('%d',kkn)
end
fprintf('\n test methods2 finished\n')
% for k=[1, 2, 3, 5, 7]
% figure(10+k)
% plot(1:np,sq(nci(:,:,k,1)))
% hold on
% plot(1:np,sq(nci(:,:,k,2)),'+-')
% legend(funclist)
% end
% figure(158)
% subplot(211)
% plot(1:np,MI)
% legend('mutual I','inv')
% subplot(212)
% plot(1:np,abs (pl))
% legend('pl','inv pl','xn pwwwl','yn pl')



% for k=[1, 5, 7]
% figure(k+1)
% plot(1:np,sq(ci(:,:,k,1)))
% % hold on
% % plot(1:np,sq(ci(:,:,k,3)),'+-')
% legend(funclist)
% end