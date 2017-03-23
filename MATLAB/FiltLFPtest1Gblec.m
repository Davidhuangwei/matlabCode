clear all
% close all
sjn='/gpfs01/sirota/data/bachdata/data/gerrit/analysis/';
FileBase='g09-20120330';
cd([sjn, FileBase])
load([FileBase, '.par.mat'])
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
% MECS1=load('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3..mat');41-48
% MECS2=load('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3.17-32.mat');
load('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3.1-16.mat')

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
nt=size(lfp,1);
FS = Par.lfpSampleRate;

% BURSTS SELECTION 
bsts=(BurstChan>5 & BurstChan<9)& (BurstFreq>60& BurstFreq<130);
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
nlag=30;
cl=ceil(FS/60);
tRes=nRes;%tRes=repmat(nRes,2,1)-randi(cl,2*length(nRes),1);
pl=zeros(nfr,2,nlag);

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

for k=1:nfr%2
    wn = FreqBins(k,:)/(FS/2);
    [z, p, kk] = butter(4,wn,'bandpass');
    [b, a]=zp2sos(z,p,kk);
    filtLFP_temp = filtfilt(b, a, lfp);
    filtLFP_temp=hilbert(filtLFP_temp);
    for m=1:2
        if m==2            
            filtLFP_temp=filtLFP_temp(:,[2,1]);
        end
        for n=1:nlag
            pl(k,m,n)=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),2))'*fangle(filtLFP_temp(tRes,1))/nb;
%             if n<nlag(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))
                X=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),2));
                Y=fangle(filtLFP_temp(tRes,1));
                Z=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),1));
                
            
                [oci, Noi_dist{k,m,n}]=...
                    KCIcausal_new(X,Y,Z,par,0,0);%
                pci(k,m,n)=oci(1);
                pst(k,m,n)=oci(2);
                cst(k,m,n)=oci(3);
                cci(k,m,n)=oci(5);
                cpap(k,m,n)=oci(7);
                [nte(k,m,n), me(k,m,n), ste(k,m,n), pval(k,m,n), h{k,m,n}, ~, ~, ~, ~]=nTE(Y,X,Z(:,end),400);
                fprintf('*')
%             elseif n>nlag
%                 X=fangle(filtLFP_temp(tRes(Clu<=FreqBins(k,2))-stp*(nlag-n+1),2));
%                 Y=fangle(filtLFP_temp(tRes(Clu<=FreqBins(k,2)),1));
%                 Z=fangle(filtLFP_temp(tRes(Clu<=FreqBins(k,2)),2));%-stp*(nlag-n+1)-floor(stp/2)
%                  [oci, Noi_dist{k,m,n}]=...
%                     KCIcausal_new(X,Y,Z,par,0,0);%[,fangle(filtLFP_temp(tRes(Clu<=FreqBins(k,2))-5*(nlag-n-1),1))]
%                
%                 pci(k,m,n)=oci(1);
%                 pst(k,m,n)=oci(2);
%                 cst(k,m,n)=oci(3);
%                 cci(k,m,n)=oci(5);
%                 cpap(k,m,n)=oci(7);
%                 [nte(k,m,n), me(k,m,n), ste(k,m,n), pval(k,m,n), h{k,m,n}, ~, ~, ~, ~]=nTE(Y,X,Z(:,end),400);
%             end
        end
        fprintf('inv')
    end
    fprintf('\n')
    clear filtLFP_temp
end

cd ~/data/g09_20120330/
datat=sprintf('compLFP%d-%d.%dHz.basictests.ephase.bl.mat',Channels,aa);
save(datat,'pci','pst','cst','cci','cpap','nte','me','ste','pval','h','Noi_dist','tRes','aa','nRes','Clu','FreqBins')%['8_9nitry', labels{ln}])% 724all bursts 
x=([1:nlag]-nlag)*stp;
y=1:nfr;
nc=3;
nl=2;
for m=1:2
    figure(225)
    subplot(nl,nc,(m-1)*nc+1)
    imagesc(x,y,sq(abs(pl(:,m,:))))%,[0,.26]
    set(gca,'Ytick',y,'Yticklabel',bb)
        title('pair independent')
    subplot(nl,nc,(m-1)*nc+2)
    imagesc(x,y,sq(pci(:,m,:)),[0, .05])
    set(gca,'Ytick',y,'Yticklabel',bb)
        title('pair independent')
    subplot(nl,nc,(m-1)*nc+3)
    imagesc(x,y,sq(cci(:,m,:)),[0, .05])
    set(gca,'Ytick',y,'Yticklabel',bb)
        title('c independent')
end
drawnow
