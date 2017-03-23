% function FiltLFPy(FileBase, FreqBins)
clear all
close all
FileBase='4_16_05_merged';
a=40;
b=[8,12,15:5:30]';%3,5,
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
[FeatData, FeatName] = LoadBurst(FileBase, Par,'csdsm5', State);
Shk=2;
MyBursts = find(strcmp(FeatData{15},'CA1rad') & (FeatData{3}==54 | abs(FeatData{3}-37)<2 ) & FeatData{9}>40 & abs(FeatData{2}-40)<20);%
nBursts = length(MyBursts);%54
disp(['you have ', num2str(nBursts), ' bursts here'])
Res = floor(FeatData{14}(MyBursts)*1250);
Clu= FeatData{2}(MyBursts);
[tRes,tClu]=getRes(Res,Clu,StatePeriod);
nfr=size(FreqBins,1);
nlag=11;
nt=size(lfp,1);
nb=length(tRes);
pl=zeros(nfr,2,2*nlag-1);

cnames={'pl','nte','me','ste','pci','cci','cpap'};
nte=zeros(nfr,2,2*nlag-1);
me=zeros(nfr,2,2*nlag-1);
ste=zeros(nfr,2,2*nlag-1);
pval=zeros(nfr,2,2*nlag-1);
h=cell(nfr,2,2*nlag-1);
pci=zeros(nfr,2,2*nlag-1);
pst=zeros(nfr,2,2*nlag-1);
cst=zeros(nfr,2,2*nlag-1);
cci=zeros(nfr,2,2*nlag-1);
cpap=zeros(nfr,2,2*nlag-1);
par.width=.3;
t=1:nb;
ytick=1:size(FreqBins,1);
xlabels=(-nlag+1):2:(nlag-1);
xticks=1:2:(2*nlag-1);
ylabels=FreqBins(:,2)-40;
showr=true;
% cause and effect are in the  same frequency range
for k=1:nfr
wn = (FreqBins(k,:))/(FS/2);
wn(1)=max(wn(1),4/(FS/2));
[z, p, kk] = butter(4,wn,'bandpass');
[b, a]=zp2sos(z,p,kk);
filtLFP_temp = filtfilt(b, a, lfp);
filtLFP_temp=hilbert(filtLFP_temp);

for n=1:(2*nlag-1)
    pl(k,1,n)=fangle(filtLFP_temp((5*n+1):(end-10*nlag+5*n+1),2))'*fangle(filtLFP_temp((5*nlag+1):(end-5*nlag+1),1))/nt;
    % filtLFP_temp=filtLFP_temp(tRes,:);
    pl(k,2,n)=fangle(filtLFP_temp(tRes-5*(nlag-n),2))'*fangle(filtLFP_temp(tRes,1))/nb;
    % nTE
    if n~=nlag
        [nte(k,1,n), me(k,1,n), ste(k,1,n), pval(k,1,n), h{k,1,n}, XBins, YBins, ZBins, ~]=...
            nTE(fangle(filtLFP_temp(tRes,1)),fangle(filtLFP_temp(tRes-5*(nlag-n),2)),fangle(filtLFP_temp(tRes-5*(nlag-n),1)),400);
        [nte(k,2,n), me(k,2,n), ste(k,2,n), pval(k,2,n), h{k,2,n}, XBins, YBins, ZBins, ~]=...
            nTE(fangle(filtLFP_temp(tRes,2)),fangle(filtLFP_temp(tRes-5*(nlag-n),1)),fangle(filtLFP_temp(tRes-5*(nlag-n),2)),400);
        if n<nlag
            oci=...
                KCIcausal_new(fangle(filtLFP_temp(tRes,1)),fangle(filtLFP_temp(tRes-5*(nlag-n),2)),[fangle(filtLFP_temp(tRes-5*(nlag-n),1)),fangle(filtLFP_temp(tRes-5*(nlag-n-1),2))],par,t,0);
        else
            oci=...
                KCIcausal_new(fangle(filtLFP_temp(tRes,1)),fangle(filtLFP_temp(tRes-5*(nlag-n),2)),[fangle(filtLFP_temp(tRes-5*(nlag-n),1)),fangle(filtLFP_temp(tRes-5*(nlag-n+1),2))],par,t,0);
        end
        pci(k,1,n)=oci(1);
        pst(k,1,n)=oci(2);
        cst(k,1,n)=oci(3);
        cci(k,1,n)=oci(5);
        cpap(k,1,n)=oci(7);
        % inverse
        if n<nlag
            oci=...
                KCIcausal_new(fangle(filtLFP_temp(tRes,2)),fangle(filtLFP_temp(tRes-5*(nlag-n),1)),[fangle(filtLFP_temp(tRes-5*(nlag-n),2)),fangle(filtLFP_temp(tRes-5*(nlag-n-1),1))],par,t,0);
        else
            oci=...
                KCIcausal_new(fangle(filtLFP_temp(tRes,2)),fangle(filtLFP_temp(tRes-5*(nlag-n),1)),[fangle(filtLFP_temp(tRes-5*(nlag-n),2)),fangle(filtLFP_temp(tRes-5*(nlag-n+1),1))],par,t,0);
        end
        pci(k,2,n)=oci(1);
        pst(k,2,n)=oci(2);
        cst(k,2,n)=oci(3);
        cci(k,2,n)=oci(5);
        cpap(k,2,n)=oci(7);
        
    end
    if showr
        
        for m=1:2
            figure(225)
            subplot(2,4,1+(m-1)*4)
            imagesc(sq(abs(pl(:,m,:))))%,[0,.26]
            set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
            title(cnames{1})
            subplot(2,4,2+(m-1)*4)
            imagesc(sq(abs(nte(:,m,:)-me(:,m,:))-ste(:,m,:)))
            set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
            if m==1
                title('nTE')
            else
                title('inv nTE')
            end
            subplot(2,4,3+(m-1)*4)
            imagesc(sq(pci(:,m,:)),[0, .05])
            set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
            if m==1
                title('pair independent')
            else
                title('inv pair independent')
            end
            subplot(2,4,4+(m-1)*4)
            imagesc(sq(cci(:,m,:)),[0, .05])
            set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
            if m==1
                title('c independent')
            else
                title('inv c independent')
            end
        end
    end
end
clear filtLFP_temp
end
cd ~/data/sm/4_16_05_merged/
save 7_29% 724all bursts