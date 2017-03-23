sjn='/gpfs01/sirota/home/gerrit/data/';
FileBase='g09-20120330';
FreqBins=[60 120];%[30 120];
% BurstShanks=[41:48,63];% channels, burst cluseter
HP=[33:64]';%33:40
nhp=length(HP);
EC=20;%829
myfilename=mfilename;
cd ~/data/g09_20120330/
load('g09_20120330.RUN3.Burst4Info.[14-250].all.mat')
FS = Par.lfpSampleRate;

cd([sjn, FileBase])
lfp= LoadBinary([FileBase '.lfp'],[HP;EC],Par.nChannels,2,[],[],Period)';

cd ~/data/g09_20120330/
wn = FreqBins/(FS/2);
[z, p, kk] = butter(4,wn,'bandpass');
[b, a]=zp2sos(z,p,kk);
% sos=zp2sos(z,p,kk);
% fltLFP=sosfilt(sos,lfp);

% [rho,pval] = partialcorr(zscore(fltLFP(:,[2,3,5,7,9,10])));
% yy=fltLFP'*fltLFP;
% T=svd(yy);
lfp = filtfilt(b, a, lfp);
lfp=hilbert(lfp);

nlag=10;
cl=ceil(FS/60);
stp=2;


nRes=AllBursts.BurstTime(AllBursts.BurstChan<=21 & AllBursts.BurstChan>=17 ... % 8 5 29 28
    & AllBursts.BurstFreq>55 & AllBursts.BurstFreq<130);
nb=length(nRes);
fprintf('\n you have %d bursts',nb);

tRes=nRes;
att=5;
CIEHs=zeros(nhp,2);
CIHEs=zeros(nhp,2);
IEHs=zeros(nhp,2);
IHEs=zeros(nhp,2);
t1=1:30;
tn=1:20;
for k=1:nhp
filtLFP_temp = lfp(:,[k,1+nhp]);
fLFP=fangle(filtLFP_temp(2:end,:))-fangle(filtLFP_temp(1:(end-1),:));
f=abs(fLFP(:,2));tt1=bsxfun(@plus,tRes-stp*(nlag+att+1),t1);
 [a,na]=max(f(tt1),[],2);tt=bsxfun(@plus,tRes-stp*(nlag+att+1)+na,tn);f=abs(fLFP(:,1));
 b=max(f(tt),[],2);
 bb=median(f(tt),2);
[c,nc]=max(f(tt1),[],2);tt=bsxfun(@plus,tRes-stp*(nlag+att+1)+nc,tn);f=abs(fLFP(:,2));
d=max(f(tt),[],2);
dd=median(f(tt),2);
[d1,d2]=CInd_test_new_withGP(a,b,bb,.1,0);
CIEHs(k,:)=[d1,d2];
[d2,d1]=UInd_KCItest(a,b);
IEHs(k,:)=[d1,d2];
[d1,d2]=CInd_test_new_withGP(c,d,dd,.1,0);
CIHEs(k,:)=[d1,d2];
[d2,d1]=UInd_KCItest(c,d);
IHEs(k,:)=[d1,d2];
% figure(11);subplot(121);plot(a,b,'.');subplot(122);plot(c,d,'.')
fprintf('\n ch %d ec2hp: %d; hp2ec: %d;\n',HP(k),CIEHs(k,2),CIHEs(k,2));
end
save([FileBase, '.', myfilename, '.EC', num2str(EC), '.mat'], 'CIEHs','CIHEs','IEHs','IHEs','FreqBins')
figure(3)
subplot(222);imagesc(reshape(CIHEs(:,2),8,4),[0 .05])
colorbar
title(['HP to EC', num2str(EC), ' fr: ', num2str(FreqBins)])
subplot(221);imagesc(reshape(CIEHs(:,2),8,4),[0 .05])
colorbar
title(['EC', num2str(EC), 'to HP fr: ', num2str(FreqBins)])
ylabel('pval')
subplot(224);imagesc(reshape(CIHEs(:,1),8,4))
colorbar
subplot(223);imagesc(reshape(CIEHs(:,1),8,4))
colorbar
ylabel('stat')
