% no future cross frequency band
% function FiltLFPtest(FileBase, FreqBins)
clear all
close all
FileBase='4_16_05_merged';
a=40;
b=12;%[12,15,20]';%8,3,5,:5:3012;%
nfr=length(b);
FreqBins=[a-b,a+b];
load('/gpfs01/sirota/data/bachdata/data/weiwei/m_sm/4_16_05_merged_par.mat');
repch=RepresentChan(Par);
load /gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/4_16_05_merged/ChanInfo/ChanLoc_Full.eeg.mat

cd(['/gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/', FileBase])
StatePeriod = load([FileBase '.sts.RUN']);
nprd=size(StatePeriod,1);
Channels=[37,78];
lfp = LoadBinary([FileBase '.lfp'],Channels,Par.nChannels,2,[],[],StatePeriod)';% as loadinary don't take careof overlap of periods
FS = Par.lfpSampleRate;
cd /gpfs01/sirota/home/evgeny/project/gamma/data/4_16_05_merged
State='RUN';
Shk=3;
cd ~/data/sm/4_16_05_merged/
load('4_16_05_mergedthin.LFP.Channels37_78.Freq10_70.mat','nRes')
nlag=11;
nb=length(nRes);
pl=zeros(nfr,2,2*nlag-1);
nfr=4;
nm=4;
cnames={'pl','pci','cci','cpap'};
h=cell(nfr,nm,2*nlag-1);
pci=zeros(nfr,nm,2*nlag-1);
pst=zeros(nfr,nm,2*nlag-1);
cst=zeros(nfr,nm,2*nlag-1);
cci=zeros(nfr,nm,2*nlag-1);
cpap=zeros(nfr,nm,2*nlag-1);
par.width=.3;
t=1:nb;
stp=5;
ytick=1:size(FreqBins,1);

xlabels=((-nlag+1):2:nlag+1)*stp;
xticks=1:2:(2*nlag-1);
ylabels=FreqBins(:,2)-40;
showr=true;%false;%
tlfp=bsxfun(@plus,nRes,(-100):1);
% cause and effect are in the  different frequency range
wn = [4 20]/(FS/2);
[z, p, kk] = butter(4,wn,'bandpass');
[b, a]=zp2sos(z,p,kk);
conlfp = filtfilt(b, a, lfp);
conlfp=hilbert(conlfp);
labels={'conlf'};
wn = FreqBins/(FS/2);
[z, p, kk] = butter(4,wn,'bandpass');
[b, a]=zp2sos(z,p,kk);
filtLFP_temp = filtfilt(b, a, lfp);
filtLFP_temp=[hilbert(filtLFP_temp),conlfp];
clear lfp conlfp
for k=1:4
    for m=1:4
        tRes=nRes;%-102+vind;
        for n=1:(2*nlag-1)
            pl(k,m,n)=fangle(filtLFP_temp(tRes-stp*(11-n),m))'*fangle(filtLFP_temp(tRes,k))/nb;
            if k~=m% k effect,m cause
                if n<nlag
                    oci=...
                        KCIcausal_new(fangle(filtLFP_temp(tRes-stp*(nlag-n),m)),fangle(filtLFP_temp(tRes,k)),[fangle(filtLFP_temp(tRes-stp*(nlag-n)-floor(stp/2),m)),fangle(filtLFP_temp(tRes-stp*(nlag-n),setdiff(1:4,m)))],par,0,0);%
                    pci(k,m,n)=oci(1);
                    pst(k,m,n)=oci(2);
                    cst(k,m,n)=oci(3);
                    cci(k,m,n)=oci(5);
                    cpap(k,m,n)=oci(7);
                elseif n>nlag
                    oci=...
                        KCIcausal_new(fangle(filtLFP_temp(tRes-stp*(nlag-n),m)),fangle(filtLFP_temp(tRes,k)),[fangle(filtLFP_temp(tRes-stp*(nlag-n)-floor(stp/2),m)),fangle(filtLFP_temp(tRes+floor(stp/2),setdiff(1:4,m)))],par,0,0);%[,fangle(filtLFP_temp(tRes-5*(nlag-n-1),1))]
                    pci(k,m,n)=oci(1);
                    pst(k,m,n)=oci(2);
                    cst(k,m,n)=oci(3);
                    cci(k,m,n)=oci(5);
                    cpap(k,m,n)=oci(7);
                end
            end
        end
    end
end
clear filtLFP_temp
cd ~/data/sm/4_16_05_merged/
save(['8_9nitry2freb', labels{ln}])% 724all bursts

if showr
    nc=3;
    nl=2;
    k=1:nl;
    for m=1:2
        figure(225+ln)
        subplot(nl,nc,(m-1)*nc+1)
        imagesc(sq(abs(pl(:,m,:))))%,[0,.26]
        set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
        if m==1
            title(['pair independent', labels{ln}])
        else
            title('inv pair independent')
        end
        subplot(nl,nc,(m-1)*nc+2)
        imagesc(sq(pci(:,m,:)),[0, .05])
        set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
        if m==1
            title('pair independent')
        else
            title('inv pair independent')
        end
        subplot(nl,nc,(m-1)*nc+3)
        imagesc(sq(cci(:,m,:)),[0, .05])
        set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
        if m==1
            title('c independent')
        else
            title('inv c independent')
        end
    end
end