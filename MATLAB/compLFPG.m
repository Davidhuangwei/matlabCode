clear all
% close all
sjn='/gpfs01/sirota/data/bachdata/data/gerrit/analysis/';
FileBase='g09-20120330';
cd([sjn, FileBase])
load([FileBase, '.par.mat'])
bfr=[60 90];%[60 130];[90 130]
aa=60;
bb=[20,40,60]';%8,3,5,:5:3012;%
FreqBins=[aa+zeros(3,1),aa+bb];
nfr=length(bb);

load([FileBase, '.sts.RUN3'])
Period=g09_20120330_sts;
nP=length(Period);
clear g09_20120330_sts
load([FileBase, '-LayerLabels.mat'])
load('g09-20120330.spec[14-250].lfpinterp.11.mat','t')
% mec3=cell2mat(Layers.Mec3);
% mec2=cell2mat(Layers.Mec2);
% mec1=cell2mat(Layers.Mec1);
% MECS1=load('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3.1-16.mat');
% MECS2=load('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3.17-32.mat');
load('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3.41-48.mat')

% MB.BurstTime=[MECS1.BurstTime;MECS2.BurstTime];
% MB.BurstFreq=[MECS1.BurstFreq;MECS2.BurstFreq];
% MB.BurstChan=[MECS1.BurstChan;MECS2.BurstChan];
% clear MECS1 MECS2
% mec3=mec3(2:3);%6
% mec2=10;
% mec1=13;
% lm=[43,44];%35,36,  
% DG=[37,38,46];%
% rad=42;

Channels=[6,43];%mec3,mec2,mec1,lm,DG,rad
nch=length(Channels);
lfp= LoadBinary([FileBase '.lfp'],Channels,Par.nChannels,2,[],[],Period)';
lfp=lfp(:,[2,1]);
FS = Par.lfpSampleRate;

% BURSTS SELECTION 
bsts=(BurstChan>41 & BurstChan<45)& (BurstFreq>bfr(1)& BurstFreq<bfr(2));
Bursts=BurstTime(bsts)*FS;
BF=BurstFreq(bsts);
myBursts=false(size(Bursts));%|(MB.BurstChan>24 & MB.BurstChan<28)  
n=0;
for k=1:nP
    kk=find(Bursts<(Period(k,2)-200) & Bursts>(Period(k,1)+200));
    myBursts(kk)=true;
    Bursts(kk)=Bursts(kk)-Period(k,1)+n;
    n=n+Period(k,2)-Period(k,1)+1;
end
nRes=floor(Bursts(myBursts));
Clu=BF(myBursts);
nBursts = length(nRes);
disp(['you have ', num2str(nBursts), ' bursts here'])
nb=length(nRes);
nlag=11;
nt=length(lfp);

% cause and effect are in the  same frequency range
nlfp=zeros(nt,nfr*2);
Res=zeros(nb,nfr);
for k=1:nfr
wn = FreqBins(k,:)/(FS/2);
[z, p, kk] = butter(4,wn,'bandpass');
[b, a]=zp2sos(z,p,kk);
filtLFP_temp = filtfilt(b, a, lfp);
filtLFP_temp=hilbert(filtLFP_temp);
nlfp(:,2*k+[-1 0])=filtLFP_temp;
end
LFP=zeros(nb,401,6);
tlfp=bsxfun(@plus,nRes,(-100):1);
for k=1:nfr
    x=nlfp(:,2*k);
    templfp=x(tlfp);
    tRes=nRes;%
    LFP(:,:,2*k)=x(bsxfun(@plus,tRes,-200 :200));
    x=nlfp(:,2*k-1);
    LFP(:,:,2*k-1)=x(bsxfun(@plus,tRes,-200 :200));
    Res(:,k)=tRes;
end
cd ~/data/g09_20120330/
datan=sprintf('compLFPch%d-ch%d.from%dHz.bf%d-%d.mat', Channels,aa,bfr);
% save(datan,'LFP','FreqBins','Res')
[ppLFP]=mean(abs(LFP(:,190:201,:)),2);
ppLFP=sq(ppLFP);
nip=zeros(3,2);ni=zeros(3,2);
for k=1:3
nc=2*k;ne=2*k-1;
[Ress,a]=BasicRegression([(ppLFP(:,nc)).^0,(ppLFP(:,nc)).^2,(ppLFP(:,nc))],(ppLFP(:,ne)));
[nip(k,1),ni(k,1)]=UInd_KCItest((ppLFP(:,nc)), Ress);
[Ress,a]=BasicRegression([(ppLFP(:,ne)).^0,(ppLFP(:,ne)).^2,(ppLFP(:,ne))],(ppLFP(:,nc)));
[nip(k,2),ni(k,2)]=UInd_KCItest((ppLFP(:,ne)), Ress);
end
figure(2)
subplot(121)
plot([1 2],nip,'o-')
hold on
plot([0.8 2.2], [.05 .05],'k')
set(gca,'XTick',1:2,'Xticklabel',{'mEC3 to CA1','CA1 to mEC3'})
legend([num2str(FreqBins(:,1)), repmat(' to ',3,1), num2str(FreqBins(:,2)), repmat('Hz',3,1)])
axis([.8 2.2 0 1])
xlabel('p-value')
title(sprintf('Gamma bursts at %d to %d Hz', bfr))