clear all
% close all
sjn='/gpfs01/sirota/data/bachdata/data/gerrit/analysis/';
FileBase='g09-20120330';
cd([sjn, FileBase])
load([FileBase, '.par.mat'])

FS = Par.lfpSampleRate;
bfr=[60 120];%[30 60];[90 130]
% aa=90;
% bb=[30,60,90]';%8,3,5,:5:3012;%

FreqBins=[30 60;30 90; 30 150; 60 90; 60 120;90 120];%[aa+zeros(3,1),aa+bb];
nfr=size(FreqBins,1);

load([FileBase, '.sts.RUN3'])
Period=g09_20120330_sts;
nP=length(Period);
clear g09_20120330_sts
load([FileBase, '-LayerLabels.mat'])
load('g09-20120330.spec[14-250].lfpinterp.11.mat','t')
% mec3=cell2mat(Layers.Mec3);
% mec2=cell2mat(Layers.Mec2);
% mec1=cell2mat(Layers.Mec1);
% MECS1=load('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3..mat');1-16
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
selectchannels=[37, 50,10, 6, 18, 20, 22];
nsch=length(selectchannels);
channelname={'DG','rad','mec2','mec3','mecdeep','mecdeep','mecdeep'};
nip=zeros(3,2,nsch);ni=zeros(3,2,nsch);
lmch=43;

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

for ksch=1:nsch%4;%
Channels=[selectchannels(ksch),lmch];%mec3,mec2,mec1,lm,DG,rad
nch=length(Channels);
cd([sjn, FileBase])
lfp= LoadBinary([FileBase '.lfp'],Channels,Par.nChannels,2,[],[],Period)';
lfp=lfp(:,[2,1]);
nt=length(lfp);

% cause and effect are in the  same frequency range
nlfp=zeros(nt,nfr*2);
Res=zeros(nb,nfr);
for k=1:nfr
wn = FreqBins(k,:)/(FS/2);
[z, p, kk] = butter(4,wn,'bandpass');
[b, a]=zp2sos(z,p,kk);
filtLFP_temp = filtfilt(b, a, lfp);%filt
filtLFP_temp=hilbert(filtLFP_temp);
nlfp(:,2*k+[-1 0])=filtLFP_temp;
end
LFP=zeros(nb,401,2*nfr);
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
% cd ~/data/g09_20120330/
% datan=sprintf('compLFPch%d-ch%d.from%dHz.bf%d-%d.mat', Channels,aa,bfr);
% save(datan,'LFP','FreqBins','Res')
[ppLFP]=mean((abs(LFP(:,190:201,:))),2);
% ppLFP=zscore((sq(ppLFP)));
for k=1:nfr
nc=2*k;ne=2*k-1;
[Ress,a]=BasicRegression([(ppLFP(:,nc)).^0,(ppLFP(:,nc)).^2,(ppLFP(:,nc))],(ppLFP(:,ne)));
[nip(k,1,ksch),ni(k,1,ksch)]=UInd_KCItest((ppLFP(:,nc)), Ress);
[Ress,a]=BasicRegression([(ppLFP(:,ne)).^0,(ppLFP(:,ne)).^2,(ppLFP(:,ne))],(ppLFP(:,nc)));
[nip(k,2,ksch),ni(k,2,ksch)]=UInd_KCItest((ppLFP(:,ne)), Ress);
end
end
datat=sprintf('compLFPch%d.NoiseIndependentT.bf%d-%d.mat',lmch,bfr);
save(datat, 'nip','ni','selectchannels','FreqBins','Res','channelname','datat')
figure(227)
for ksch=1:nsch
subplot(1,nsch,ksch)
plot([1 2],sq(nip(:,:,ksch)),'o-')
hold on
plot([0.8 2.2], [.05 .05],'k')
set(gca,'XTick',1:2,'Xticklabel',{[channelname{ksch}, ' to lm'],['lm to ', channelname{ksch}]})
legend([num2str(FreqBins(:,1)), repmat(' to ',nfr,1), num2str(FreqBins(:,2)), repmat('Hz',nfr,1)])
axis([.8 2.2 0 1])
xlabel('p-value')
% title(sprintf('Gamma bursts at %d to %d Hz', bfr))
end