clear all
close all
sjn='/gpfs01/sirota/data/bachdata/data/gerrit/analysis/';
% cd(sjn)
FileBase='g09-20120330';
cd([sjn, FileBase])
load([FileBase, '.par.mat'])
HP=load('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3.33-40.mat');
MECS1=load('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3.1-16.mat');
MECS2=load('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3.17-32.mat');
load('g09-20120330.spec[14-250].lfpinterp.11.mat','t')
load([FileBase, '.sts.RUN3'])
Period=g09_20120330_sts;
nP=length(Period);
clear g09_20120330_sts
load([FileBase, '-LayerLabels.mat'])
mec3=cell2mat(Layers.Mec3);
mec2=cell2mat(Layers.Mec2);
mec1=cell2mat(Layers.Mec1);
lm=[35,36,43,44];
rad=[33,41,42];

Channels=[mec1,mec2,mec3,rad,lm];
chbelong=[length(mec1),length(mec2),length(mec3),length(rad),length(lm)];
lfp= LoadBinary([FileBase '.lfp'],Channels,Par.nChannels,2,[],[],Period)';
FreqBins=[60 100; 80 100; 30 60];
[nt, nch]=size(lfp);
nfr=size(FreqBins,1);
LFP=zeros(nt,nfr,nch);
FS = Par.lfpSampleRate;
for k=1:nfr
    wn = FreqBins(k,:)/(FS/2);
    [z, p, kk] = butter(4,wn,'bandpass');
    [b, a]=zp2sos(z,p,kk);
    filtLFP_temp = filtfilt(b, a, lfp);
    filtLFP_temp=hilbert(filtLFP_temp);
    LFP(:,k,:)=filtLFP_temp;
end
Bursts=HP.BurstTime(HP.BurstChan>32 & HP.BurstChan<37 & HP.BurstFreq>30 & HP.BurstFreq<60)*FS;
myBursts=false(size(Bursts));
n=0;
for k=1:nP
    kk=find(Bursts<(Period(k,2)-200) & Bursts>(Period(k,1)+200));
    myBursts(kk)=true;
    Bursts(kk)=Bursts(kk)-Period(k,1)+n;
    n=n+Period(k,2)-Period(k,1)+1;
end
nRes=floor(Bursts(myBursts));
nt=length(nRes);
mt=bsxfun(@plus,nRes,-200:200);
lfp=reshape(LFP(mt(:),:,:),nt,401,nfr,nch);
clear LFP
cd ~/data/g09_20120330
save([FileBase,'.HPGB30-60Hz.fGamma.mat'])
% phase locking analysis:
rlfp=fangle(sq(sum(lfp(:,201,:,end-[4,6]),4)));
pl=zeros(401,nfr,nch);
for k=1:nch
    for n=1:nfr
            pl(:,n,k)=fangle(lfp(:,:,n,k))'*rlfp(:,n)/nt;
    end
end
figure(331)
for k=1:nfr
    subplot(3,3,k)
    imagesc(sq(abs(pl(:,k,:))))
end
[kk,ikk]=max(reshape(abs(pl),401,nfr*nch),[],1);
figure(1);
subplot(211)
imagesc(1:nch, FreqBins(:,1),reshape(ikk,nfr,nch),[180 220])
set(gca,'XTick', 1:nch,'XTicklabel', Channels)
subplot(212);
imagesc(1:nch, FreqBins(:,1),reshape(kk,nfr,nch),[0 .2])
set(gca,'XTick', 1:nch,'XTicklabel', Channels)
colorbar
rlfp=fangle(sq(sum(lfp(:,:,:,end-[4,6]),4)));
timelags=-100:4:100;
timelag2s=-50:4:50;
t1=length(timelags);
t2=length(timelag2s);
pn=zeros(t1,t2,nfr,nch);
for k=1:nch
    if k~=21 && k~=19
    for n=1:nfr
        for m=1:t1
            for h=1:t2
                timelag=timelags(m);
                timelag2=timelag2s(h);
                if timelag2<0
                    pn(m,h,n,k)=UInd_KCItest(sq(fangle(lfp(:,201+timelag+timelag2,n,k))), sq(fangle(lfp(:,201+timelag+timelag2,n,k))).*sq(conj(rlfp(:,201+timelag,n))));
                else
                    pn(m,h,n,k)=UInd_KCItest(sq(conj(rlfp(:,201+timelag,n))), sq(fangle(lfp(:,201+timelag+timelag2,n,k))).*sq(conj(rlfp(:,201+timelag,n))));
                end
            end
        end
    end
    end
end
