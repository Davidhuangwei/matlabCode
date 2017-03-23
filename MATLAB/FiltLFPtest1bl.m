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
States={'RUN','REM','SWS'};
for stk=1:3
State=States{stk};%'RUN';%'REM';'SWS'
cd(['/gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/', FileBase])
StatePeriod = load([FileBase '.sts.', State]);
nprd=size(StatePeriod,1);
Channels=[37,78];
lfp = LoadBinary([FileBase '.lfp'],Channels,Par.nChannels,2,[],[],StatePeriod)';% as loadinary don't take careof overlap of periods
FS = Par.lfpSampleRate;
cd /gpfs01/sirota/home/evgeny/project/gamma/data/4_16_05_merged
[FeatData, FeatName] = LoadBurst(FileBase, Par,'lfpinterp', State);
MyBursts = find(strcmp(FeatData{15},'CA1rad') & ( abs(FeatData{3}-37)<2 )  & abs(FeatData{2}-40)<20 & FeatData{9}>51);%FeatData{3}==54 |
nBursts = length(MyBursts);%54
kkn=0;
while nBursts<500
    kkn=kkn+1;
    MyBursts = find(strcmp(FeatData{15},'CA1rad') & ( abs(FeatData{3}-37)<2 )  & abs(FeatData{2}-40)<20 & FeatData{9}>(51-kkn*2));%FeatData{3}==54 |
nBursts = length(MyBursts);%54(10*kkn)
end
disp(['you have ', num2str(nBursts), ' bursts here'])
Res = floor(FeatData{14}(MyBursts)*1250);
Clu= FeatData{2}(MyBursts);
[nRes,tClu]=getRes(Res,Clu,StatePeriod);
% nRes=bsxfun(@minus,nRes,0:10:30);
cl=ceil(FS/40);
nRes=repmat(nRes,2,1)-randi(cl,2*length(nRes),1);
% [~,id]=sort(rand(length(nRes),1));
% a=bsxfun(@plus,nRes(id(1:300)),[-10, 0, 10]);
% Clu=tClu(id(1:200));
% nRes=a(:);
cd ~/data/sm/4_16_05_merged/
% load('4_16_05_mergedthin.LFP.Channels37_78.Freq10_70.mat','nRes')
nlag=20;
% nt=size(lfp,1);
nb=length(nRes);
pl=zeros(nfr,2,nlag);

cnames={'pl','pci','cci','cpap'};
nte=zeros(nfr,2,nlag);
me=zeros(nfr,2,nlag);
ste=zeros(nfr,2,nlag);
pval=zeros(nfr,2,nlag);
h=cell(nfr,2,nlag);
pci=zeros(nfr,2,nlag);
pst=zeros(nfr,2,nlag);
cst=zeros(nfr,2,nlag);
cci=zeros(nfr,2,nlag);
cpap=zeros(nfr,2,nlag);
Noi_dist=cell(nfr,2,nlag);
par.width=.3;
t=1:nb;
stp=2;
ytick=1:size(FreqBins,1);

xlabels=(-nlag):(-1);%((-nlag+1):2:nlag+1)*stp;
xticks=1:2:(nlag);
ylabels=FreqBins(:,2)-40;
showr=false;%true;%false;%
tlfp=bsxfun(@plus,nRes,(-100):1);
tRes=nRes;%-102+vind;
for k=1:nfr
    wn = FreqBins(k,:)/(FS/2);
    [z, p, kk] = butter(4,wn,'bandpass');
    [b, a]=zp2sos(z,p,kk);
    filtLFP_temp = filtfilt(b, a, lfp);
    filtLFP_temp=hilbert(filtLFP_temp);
    for m=1:2
        if m==2            
            filtLFP_temp=filtLFP_temp(:,[2,1]);
        end
        for n=1:(nlag)
            pl(k,m,n)=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),2))'*fangle(filtLFP_temp(tRes,1))/nb;
            if n<nlag
                X=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),2));
                Y=fangle(filtLFP_temp(tRes,1));
                Z=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),1));
                [oci, Noi_dist{k,m,n}]=...
                    KCIcausal_new(X,Y,Z(:,end),par,0,0);%
                pci(k,m,n)=oci(1);
                pst(k,m,n)=oci(2);
                cst(k,m,n)=oci(3);
                cci(k,m,n)=oci(5);
                cpap(k,m,n)=oci(7);
                [nte(k,m,n), me(k,m,n), ste(k,m,n), pval(k,m,n), h{k,m,n}, ~, ~, ~, ~]=nTE(Y,X,Z(:,end),400);
            elseif n>nlag
                X=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),2));
                Y=fangle(filtLFP_temp(tRes,1));
                Z=fangle(filtLFP_temp(tRes,2));%-stp*(nlag-n+1)-floor(stp/2)
                 [oci, Noi_dist{k,m,n}]=...
                    KCIcausal_new(X,Y,Z(:,end),par,0,0);%[,fangle(filtLFP_temp(tRes-5*(nlag-n-1),1))]
                
                
%             if n==11
%                 disp('half done')
%             else
%                 oci=...
%                     KCIcausal_new(fangle(filtLFP_temp(tRes-2*(11-n),2)),fangle(filtLFP_temp(tRes,1)),[fangle(filtLFP_temp(tRes-2*(11-n)+1,2)),fangle(filtLFP_temp(tRes-2*(11-n)-1,2)),fangle(filtLFP_temp(tRes-2*(11-n),1))],par,0,0);%[,fangle(filtLFP_temp(tRes-5*(nlag-n-1),1))]
                
                pci(k,m,n)=oci(1);
                pst(k,m,n)=oci(2);
                cst(k,m,n)=oci(3);
                cci(k,m,n)=oci(5);
                cpap(k,m,n)=oci(7);
                [nte(k,m,n), me(k,m,n), ste(k,m,n), pval(k,m,n), h{k,m,n}, ~, ~, ~, ~]=nTE(Y,X,Z(:,end),400);
            end
        end
    end
    
    %     end
    clear filtLFP_temp
end
cd ~/data/sm/4_16_05_merged/
datat=sprintf('compLFP%d-%d.%s.basictests.bl.mat',Channels,State);
% dtl is time stp =2 nlag=40
% bl is bursts and other lag as final results.
save(datat)%['8_9nitry', labels{ln}])% 724all bursts 
end
title(datat)