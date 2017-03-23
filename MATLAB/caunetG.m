cd ~/data/g09_20120330/
load('g09_20120330.RUN3.Burst4Info.[14-250].all.mat')
np=size(Period,1);
FS = Par.lfpSampleRate;
FileBase='g09-20120330';
addpath(genpath('/home/weiwei/MATLAB/old/GCCA'))
FreqBins=[50 200];
repch=RepresentChan(Par);
rpch=false(96,1);
rpch(repch)=true;
rpch(65:end)=false;
lfp= LoadBinary([FileBase '.lfp'],repch(repch<65),Par.nChannels,2,[],[],Period)';
% [lfp, A] = WhitenSignal(lfp(:,1));
wn = FreqBins/(FS/2);
[z, p, kk] = butter(4,wn,'bandpass');
sos=zp2sos(z,p,kk);
lfp = sosfilt(sos, lfp);
lfp=zscore(lfp);
% StatePeriod = load([FileBase '.sts.RUN']);
% np=size(StatePeriod,1);
% [runt, indt]=prd2t(StatePeriod);
% cd ChanInfo
% load ChanLoc_Full.eeg.mat
% chnum=[chanLoc.ca3Pyr, chanLoc.rad];
% lfp=lfp(runt,chnum);
% [~,rch]=find((chnum>=53)&(chnum<=54));
% [~,cch]=find((chnum>=60)&(chnum<=61));
% fpass=[4:1:10,20:2:40,40:5:100];
% optimize bic
% figure
% MapSilicon(repch,repch,par,[],1)
oPeriod=Period;
Period=ReshapePeriod(Period);
%%
testlag=1:15;
nlag=length(testlag);
aic=zeros(np,nlag);
bic=zeros(np,nlag);
for k=1:np
    for n=1:nlag
        data=zscore(lfp(Period(k,1):Period(k,2),:));
        [bic(k,n),aic(k,n)]=cca_find_model_order(data(1:4:end,:)',testlag(n),testlag(n));
    end
end

%% I find the LFP in the entorhinal cortex obey some special pattern, 
% as well as those in the HP. So it come back to the problem whether we can
% separate the activity into functional components? such as: channel 30,34
% related, 46 43, 8 9, 50 51; so I choose 51;9;43;46;30;34

kch=[51;9;43;46;30;34];
nkch=length(kch);
lagses=bsxfun(@plus,5:2:15,[-100; -20; 0; 20;100]);
llags=size(lagses,1);
kcomp=cell(nkch,llags);
% kegv=zeros(nkch,62,53);
% lags=-[3:10];%2:30[6:15]
ecs=repch(1:63)<33;
hps=repch(1:63)>32;
ecss{1}=repch(1:63)<17;
hpss{1}=repch(1:63)>32 & repch(1:63)<41;
ecss{2}=repch(1:63)<33 & repch(1:63)>16;
hpss{2}=repch(1:63)>40 & repch(1:63)<49;
hpss{3}=repch(1:63)>48 & repch(1:63)<57;
hpss{4}=repch(1:63)>56 & repch(1:63)<64;
% here is the first step: the most related PC for continuse time 
fprintf('\n')
for n=1:53
data=lfp(Period(n,1):Period(n+15,2),:);%
for k=1:nkch
    for m=1:llags
        lags=lagses(m,:);
    chi=repch(1:63)==kch(k);
%     for ee=1:2
    [e,egv]=CovPC(data(:,chi),data(:,(~chi) & ecs),lags,[]);
%     ends{ee}
%     legv=length(egv);
%     kegv(k,1:legv,n)=diag(egv);
    if n==1
        kcomp{k,m}.e=zeros(size(e,1),53);
    end
    kcomp{k,m}.e(:,n)=e(:,1);
    [h,egv]=CovPC(data(:,chi),data(:,(~chi)&hps),lags,[]);
%     kegv(k,(legv+1):end,n)=diag(egv);
    if n==1
        kcomp{k,m}.h=zeros(size(h,1),53);
    end
    kcomp{k,m}.h(:,n)=h(:,1);
    end
end
fprintf('%d-', n)
end
% figure;for k=1:6;subplot(2,6,k);imagesc(abs(kcomp{k}.e));subplot(2,6,6+k);imagesc(32+[1:length(kcomp{k}.h)],32+[1:length(kcomp{k}.h)],abs(kcomp{k}.h));title(num2str(kch(k)));end
% figure;for k=1:6;subplot(2,6,k);imagesc((kcomp{k}.e));subplot(2,6,6+k);imagesc(32+[1:length(kcomp{k}.h)],32+[1:length(kcomp{k}.h)],(kcomp{k}.h));title(num2str(kch(k)));end
% figure;for k=1:6;subplot(1,6,k);plot(kegv(k,:));end
% 
% dista=zeros(32,1);
% dista(1:22)=kcomp{2}.h(1:22);
% dista(24:end)=kcomp{2}.h(23:end,1);
% figure(7);
% subplot(121);imagesc(reshape(dista,[],4))
% subplot(122);imagesc(reshape(abs(dista),[],4))
%%
lbs={'k','b','g','r','y'};
for k=1:6
figure(30+k)
chi=repch(1:63)==kch(k);
e=repch((~chi)&ecs);
h=repch((~chi)&hps);
for m=2:4%1:llags
    [eex,eev,~]=svd(cov(kcomp{k,m}.e'));
    es=sign(eex(:,1)'*kcomp{k,m}.e);
    hs=sign(kcomp{k,1}.h(:,1)'*kcomp{k,m}.h);
    subplot(211);plot(e,bsxfun(@times,es,kcomp{k,m}.e),lbs{m});hold on;%1:size(kcomp{k,m}.e,1)
    legend(num2str(lagses(:,[1,end])))
    title(num2str(kch(k)))
    subplot(212);plot(h,bsxfun(@times,hs,kcomp{k,m}.h),lbs{m});hold on;%1:size(kcomp{k,m}.h,1)
end
end
%%
% then we try to compute the PC related to the bursts
load('g09_20120330.RUN3.Burst4Info.[14-250].all.mat')
lbs={'b:', 'b', 'c', 'g', 'r', 'm'};
lagses=[-[150:5:200];-[30:2:50]; -[8:2:28]; [8:2:28]; [30:2:50]; [150:5:200]];%-[160:10:200]; 
llages=size(lagses,1);
kch=[51;9;43;46;30;34];
nkch=length(kch);
bkcomp=cell(nkch,llages);
bkegv=zeros(nkch,62,llages);
cbkcomp=cell(nkch,llages);
cbkegv=zeros(nkch,62,llages);
% lags=-[160:10:200];%2:3010:20 30:40 3:2:30 20:30 -[10:20]20:30
ecs=repch(1:63)<33;
hps=repch(1:63)>32;
for n=1:llages
    lags=lagses(n,:);
for k=1:nkch
    nRes=AllBursts.BurstTime(AllBursts.BurstChan<=(kch(k)+1) & AllBursts.BurstChan>=(kch(k)-1) ...
   & AllBursts.BurstFreq>60); % & AllBursts.BurstFreq<125
    chi=repch(1:63)==kch(k);
    [bkcomp{k,n}.e,egv]=CovPC(lfp(:,chi),lfp(:,(~chi)&ecs),lags,nRes);
    legv=length(egv);
    bkegv(k,1:legv,n)=diag(egv);
    [bkcomp{k,n}.h,egv]=CovPC(lfp(:,chi),lfp(:,(~chi)&hps),lags,nRes);
    bkegv(k,(legv+1):end,n)=diag(egv);
end
for k=1:6
    figure(40+k)
    esigns=sign(bkcomp{k,n}.e(1:16,1)'*bkcomp{k,1}.e(1:16,1));
    hsigns=sign(bkcomp{k,n}.h(1:8,1)'*bkcomp{k,1}.h(1:8,1));
    subplot(211);plot(1:size(bkcomp{k,n}.e(:,1),1),esigns*bkcomp{k,n}.e(:,1),lbs{n});hold on
    subplot(212);plot(1:size(bkcomp{k,n}.h(:,1),1),hsigns*bkcomp{k,n}.h(:,1),lbs{n});hold on
    title(num2str(kch(k)))
end
end
%%
% low frequency using the kernel methods
% lags=-[160:10:200];%2:3010:20 30:40 3:2:30 20:30 -[10:20]20:30  [5:2:13]
for n=1:llages
    lags=lagses(n,1:2:end);
for k=1:nkch
    nRes=AllBursts.BurstTime(AllBursts.BurstChan<=(kch(k)+1) & AllBursts.BurstChan>=(kch(k)-1) ...
        & AllBursts.BurstFreq<60); % & AllBursts.BurstFreq<125
    if length(nRes)>800
        [dummy,order]=sort(rand(length(nRes),1));
        nRes=nRes(order(1:800));
    end
    chi=repch(1:63)==kch(k);
    [cbkcomp{k,n}.e,egv]=kCovPC(lfp(:,chi),lfp(:,(~chi)&ecs),lags,nRes);
    legv=length(egv);
    cbkegv(k,1:legv,n)=diag(egv);
    [cbkcomp{k,n}.h,egv]=kCovPC(lfp(:,chi),lfp(:,(~chi)&hps),lags,nRes);
    cbkegv(k,(legv+1):end,n)=diag(egv);
    fprintf('%d \n', kch(nkch))
    save('kCovPC','bkcomp','bkegv','kch')
end
for k=1:6
    figure(50+k)
    esigns=sign(cbkcomp{k,n}.e(:,1)'*cbkcomp{k,1}.e(:,1));
    hsigns=sign(cbkcomp{k,n}.h(:,1)'*cbkcomp{k,1}.h(:,1));
   subplot(211);plot(1:size(cbkcomp{k,n}.e(:,1),1),esigns*cbkcomp{k,n}.e(:,1),lbs{n}); hold on; 
    subplot(212);plot(1:size(cbkcomp{k,n}.h(:,1),1),hsigns*cbkcomp{k,n}.h(:,1),lbs{n}); hold on;
    title(num2str(kch(k)))
end
end
%%
% when i come back...
lags{1}=-[150:10:200];%2:3010:20 30:40 3:2:30 20:30 -[10:20]20:30
lags{2}=-[10:2:20];
lags{3}=-[22:2:42];
lags{4}=[150:10:200];%2:3010:20 30:40 3:2:30 20:30 -[10:20]20:30
lags{5}=[12:2:20];
lags{6}=[22:2:42];
ecs=repch(1:63)<33;
hps=repch(1:63)>32;
lkcomp=cell(nkch,6);
lkegv=zeros(nkch,62,6);
for n=1:6
for k=1:nkch
    nRes=AllBursts.BurstTime(AllBursts.BurstChan<=(kch(k)+1) & AllBursts.BurstChan>=(kch(k)-1) ...
   & AllBursts.BurstFreq<60); % & AllBursts.BurstFreq<125
    chi=repch(1:63)==kch(k);
    [lkcomp{k,n}.e,egv]=kCovPC(lfp(:,chi),lfp(:,(~chi)&ecs),lags{n},nRes);
    legv=length(egv);
    lkegv(k,1:legv,n)=diag(egv);
    [lkcomp{k,n}.h,egv]=kCovPC(lfp(:,chi),lfp(:,(~chi)&hps),lags{n},nRes);
    lkegv(k,(legv+1):end,n)=diag(egv);
end
end
for k=1:6
    figure(20+k)
    subplot(211);plot(1:size(bkcomp{k}.e(:,1),1),bkcomp{k}.e(:,1),'bx');
    subplot(212);plot(1:size(bkcomp{k}.h(:,1),1),bkcomp{k}.h(:,1),'bx');
    title(num2str(kch(k)))
end




figure
aRes=AllBursts.BurstChan( AllBursts.BurstFreq>60 & AllBursts.BurstChan<65); % & AllBursts.BurstFreq<125
c=histc(aRes,.5:1:65);
aRes=AllBursts.BurstChan( AllBursts.BurstFreq<60 & AllBursts.BurstChan<65); % & AllBursts.BurstFreq<125
d=histc(aRes,.5:1:65);
plot(1:65,[c,d])
legend('high','low')
hold on
plot(kch,zeros(nkch,1),'r+','LineWidth',3)

figure(21)
subplot(211);plot(1:size(bkcomp{1}.e(:,1),1),-bkcomp{1}.e(:,1),'g+-');
subplot(212);plot(1:size(bkcomp{1}.h(:,1),1),-bkcomp{1}.h(:,1),'g+-');



PCs=GetPC(kcomp,kegv);
adata=lfp*PCs;
% show activity VS original activity
time=1000+[1:2000];


%%
for k=1:np
    data=lfp(indt(k,1):4:indt(k,2),[rch(1),cch(1)]);
    data=bsxfun(@minus,data,mean(data,1));
    nt=size(data,1);
    reg(2*(k-1)+1)=cca_pwcausal_m(data',1,nt,3,1250/4, fpass,1);
    reg(2*(k-1)+2)=cca_pwcausal_m(data',1,nt,2,1250/4, fpass,1);
    reg_pmt(k)=cca_pwcausal_permute(data',1,nt,2,500,1,1250/4, fpass,0.01,1);
%     reg(4*(k-1)+4)=cca_pwcausal_bootstrap(data',1,nt,2,500,1,1250/4, fpass,0.01,1);
    data=zscore(data);
    regn(2*(k-1)+1)=cca_pwcausal_m(data',1,nt,3,1250/4, fpass,1);
    regn(2*(k-1)+2)=cca_pwcausal_m(data',1,nt,2,1250/4, fpass,1);
    regn_pmt(k)=cca_pwcausal_permute(data',1,nt,2,500,1,1250/4, fpass,0.01,1);
%     regn(4*(k-1)+4)=cca_pwcausal_bootstrap(data',1,nt,2,500,1,1250/4, fpass,0.01,1);
end
cd /data/data/weiwei/causal
save([FileBase, '_rad', num2str(rch(1)), '_ca3', num2str(cch(1))],'reg','regn','fpass','reg_pmt','regn_pmt','aic','bic')






































% check length of prds
figure
plot(indt(:,2)-indt(:,1))
% 
testch=[chanLoc.rad(rpch(chanLoc.rad)),chanLoc.lm(rpch(chanLoc.lm)),chanLoc.ca3Pyr(rpch(chanLoc.ca3Pyr))];
testlag=15:25;
nlag=length(testlag);
np=size(indt,1);
aic=zeros(np,nlag);
bic=zeros(np,nlag);
for k=1:np
    for n=1:nlag
data=lfp(indt(k,1):indt(k,2),:);
        [aic(k,n),bic(k,n)]=cca_find_model_order(data(1:4:end,:)',testlag(n),testlag(n));
    end
end

save('icsL4','aic','bic','testlag')
figure
subplot(2,1,1)
imagesc(bsxfun(@rdivide,aic,max(aic,[],2)))
title('AIC')
subplot(2,1,2)
imagesc(bsxfun(@rdivide,bic,max(bic,[],2)))
title('BIC')

figure
subplot(211)
plot(testlag,aic);
subplot(212)
plot(testlag,bic)
    




nch=length(repch);
chkch=repch(randi(length(repch),1,1));
ordertest=5:5:20;
nord=length(ordertest);
uroot=zeros(nch,nord);
H=zeros(nch,nord);
ks=zeros(nch,nord);
for k=2:nord
    uroot(:,k) = cca_check_cov_stat(lfp(:,repch)',ordertest(k));
    [H(:,k),ks(:,k)]= cca_kpss(lfp(:,repch)',ordertest(k),0.01);
end
[bic,aic] = cca_find_model_order(lfp(:,repch(1:10))',1,300);
result.bic = bic;
result.aic = aic;