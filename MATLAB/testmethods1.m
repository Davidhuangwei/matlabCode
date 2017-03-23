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
% 
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
b=[0.001,.01,.01,1,exp(-[0:.5:10])];% [0.001,exp(-[0:5:30])];
a=1;
funclist={'freal', 'orix', 'dfangle', 'ffangle', 'fabs',};
lf=length(funclist);
np=12;% lags to be calculated
nlevel=.3;
st=randi(800,1)*pi;%randi(size(x,1)-np*400,1);
% t=st:(st+800-1);
xt=(exp(-([1:800]'-300).^2/200^2/2)+exp(-([1:800]'-500).^2/200^2/2)*.7).*exp(sqrt(-1)*(pi*40/650*[1:800]'+st));
xt=xt+std(abs(xt))*nlevel*rand(800,1);%+0.3*rand(800,1);%x(t);
figure; plot(real(xt))
nci=zeros(np,lf,7,4);
par.width=.3;
noif=exp(sqrt(-1)*(rand(800,1)-.5)*pi*.3);
stt=5;
bins=linspace(-pi,pi,10);
pl=zeros(np,lf,4);
MI=zeros(np,lf,2);
for k=1:lf%5%32%
    istest=false;
    y=feval(funclist{k},xt,b,a,istest);
    y=y.*noif+std(abs(y))*nlevel*rand(800,1);
    xn=fangle(xt([1:2:end]'));
    y=fangle(y([1:2:end]'));
    if k==1
        lt=length(y);
    end
    for n=1:np%3%
        % !, 5, 7
        pl(n,k,1)=xn(stt:(end-n))'*y((n+stt):end)/(lt-stt-n+1);
        pl(n,k,2)=y(stt:(end-n))'*xn((n+stt):end)/(lt-stt-n+1);
        pl(n,k,3)=xn(stt:(end-n))'*xn((n+stt):end)/(lt-stt-n+1);
        pl(n,k,4)=y(stt:(end-n))'*y((n+stt):end)/(lt-stt-n+1);
        MI(n,k,1)=MutualInformation(angle(xn(stt:(end-n))),angle(y((n+stt):end)),11,11);
        MI(n,k,2)=MutualInformation(angle(y(stt:(end-n))),angle(xn((n+stt):end)),11,11);
        nci(n,k,:,1)=KCIcausal_new(xn(stt:(end-n)),y((n+stt):end),[xn(1:(end-n-stt+1)),y(stt:(end-n)),y((stt-1):(end-n-1))],par,1:(lt-n),0);
        nci(n,k,:,3)=KCIcausal_new(y(stt:(end-n)),xn((n+stt):end),[y(1:(end-n-stt+1)),xn(stt:(end-n)),xn((stt-1):(end-n-1))],par,1:(lt-n),0);
%         pxn=feval(funclist{k},xn,b,a,1);xn(3:(end-n+1)),y(3:(end-n+1)),%
%         nci(n,k,:,2)=KCIcausal_new(pxn(2:(end-n)),y((n+2):end),[pxn(3:(end-n+1)),pxn(1:(end-n-1)),y(2:(end-n))],par,1:(lt-n),0);
%         nci(n,k,:,4)=KCIcausal_new(y(2:(end-n)),pxn((n+2):end),[y(3:(end-n+1)),y(1:(end-n-1)),pxn(2:(end-n))],par,1:(lt-n),0);
    end
end
for k=[1, 2, 3, 5, 7]
figure(10+k)
plot(1:np,sq(nci(:,:,k,1)))
hold on
plot(1:np,sq(nci(:,:,k,3)),'+-')
legend(funclist)
end
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