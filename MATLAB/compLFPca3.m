
clear all
close all
FileBase='4_16_05_merged';
a=40;
b=[12,15,20]';%8,3,5,:5:3012;%
nfr=length(b);
FreqBins=[a-b,a+b];
load('/gpfs01/sirota/data/bachdata/data/weiwei/m_sm/4_16_05_merged_par.mat');
repch=RepresentChan(Par);
load /gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/4_16_05_merged/ChanInfo/ChanLoc_Full.eeg.mat

States={'REM', 'RUN','SWS'};
for zr=1:3
    State=States{zr};
cd(['/gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/', FileBase])
StatePeriod = load([FileBase '.sts.', State]);
nprd=size(StatePeriod,1);
Channels=[37,78];
lfp = LoadBinary([FileBase '.lfp'],Channels,Par.nChannels,2,[],[],StatePeriod)';% as loadinary don't take careof overlap of periods
FS = Par.lfpSampleRate;
cd /gpfs01/sirota/home/evgeny/project/gamma/data/4_16_05_merged
cd ~/data/sm/4_16_05_merged/
% load('4_16_05_mergedthin.LFP.Channels37_78.Freq10_70.mat','nRes')
cd /gpfs01/sirota/home/evgeny/project/gamma/data/4_16_05_merged
[FeatData, FeatName] = LoadBurst(FileBase, Par,'lfpinterp', State);
nBursts=0;
k=-1;
while nBursts<500
    k=k+1;
MyBursts = find(strcmp(FeatData{15},'CA1rad') & ( abs(FeatData{3}-37)<2 )  & abs(FeatData{2}-40)<20 & FeatData{9}>51-k*2);%FeatData{3}==54 |
nBursts = length(MyBursts);%54
end
disp(['you have ', num2str(nBursts), ' bursts here'])
Res = floor(FeatData{14}(MyBursts)*1250);
Clu= FeatData{2}(MyBursts);
[nRes,tClu]=getRes(Res,Clu,StatePeriod);
nb=length(nRes);
istrough=false;
for k=1:nfr
wn = FreqBins(k,:)/(FS/2);
[z, p, kk] = butter(4,wn,'bandpass');
[b, a]=zp2sos(z,p,kk);
filtLFP_temp = filtfilt(b, a, lfp);
filtLFP_temp=hilbert(filtLFP_temp);
nlfp(:,2*k+[-1 0])=filtLFP_temp;
end
LFP=zeros(nb,401,6);
if istrough
tlfp=bsxfun(@plus,nRes,(-100):1);
end
for k=1:nfr
    x=nlfp(:,2*k);
    if istrough
    templfp=x(tlfp);
    vind=clocalmin1(templfp,102);
    tRes=nRes-102+vind;
    Res(:,k)=tRes;
    else
        tRes=nRes;
        Res=nRes;
    end
    LFP(:,:,2*k)=x(bsxfun(@plus,tRes,-200 :200));
    x=nlfp(:,2*k-1);
    LFP(:,:,2*k-1)=x(bsxfun(@plus,tRes,-200 :200));
end
if istrough
    datat=sprintf('compLFPtrough%d-%d.%s.mat',Channels,State);
else
datat=sprintf('compLFP%d-%d.%s.mat',Channels,State);
end
cd ~/data/sm/4_16_05_merged
save(datat,'LFP','FreqBins','Res')
clear LFP lfp tlfp nlfp nRes
end