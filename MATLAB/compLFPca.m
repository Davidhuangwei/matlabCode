function [LFP, datan]=compLFPca(Channels)
% clear all
% close all
FileBase='4_16_05_merged';
a=40;
b=[12,15,20]';%8,3,5,:5:3012;%
nfr=length(b);
FreqBins=[a-b,a+b];
load('/gpfs01/sirota/data/bachdata/data/weiwei/m_sm/4_16_05_merged_par.mat');
repch=RepresentChan(Par);
load /gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/4_16_05_merged/ChanInfo/ChanLoc_Full.eeg.mat

cd(['/gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/', FileBase])
StatePeriod = load([FileBase '.sts.RUN']);
nprd=size(StatePeriod,1);
% Channels=[71,78];
datan=sprintf('compLFP%d%d.mat',Channels);
lfp = LoadBinary([FileBase '.lfp'],Channels,Par.nChannels,2,[],[],StatePeriod)';% as loadinary don't take careof overlap of periods
FS = Par.lfpSampleRate;
cd /gpfs01/sirota/home/evgeny/project/gamma/data/4_16_05_merged
State='RUN';Shk=3;
cd ~/data/sm/4_16_05_merged/
load('4_16_05_mergedthin.LFP.Channels37_78.Freq10_70.mat','nRes')
nlag=11;
nb=length(nRes);
pl=zeros(nfr,2,2*nlag-1);

cnames={'pl','pci','cci','cpap'};
par.width=.3;
t=1:nb;
stp=5;
showr=true;%false;%
% cause and effect are in the  same frequency range
nt=size(lfp,1);
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
save(datan,'LFP','FreqBins','Res')