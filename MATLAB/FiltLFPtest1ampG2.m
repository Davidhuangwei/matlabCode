clear all
close all
sjn='/gpfs01/sirota/data/bachdata/data/gerrit/analysis/';
FileBase='g09-20120330';
cd([sjn, FileBase])
load([FileBase, '.par.mat'])
bb=[5,10,15,20]';%8,3,5,:5:3012;%
nfr=length(bb);

States={'RUN','REM','SWS'};

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
nt=size(lfp,1);
FS = Par.lfpSampleRate;

% BURSTS SELECTION 
bfr=[60 90;90 130;130 150];
for nbfr=1:length(bfr)
Bursts=BurstTime((BurstChan>41 & BurstChan<45)& BurstFreq>bfr(nbfr,1) & BurstFreq<bfr(nbfr,2))*FS;
myBursts=false(size(Bursts));%|(MB.BurstChan>24 & MB.BurstChan<28) 
n=0;
for k=1:nP
    kk=find(Bursts<(Period(k,2)-200) & Bursts>(Period(k,1)+200));
    myBursts(kk)=true;
    Bursts(kk)=Bursts(kk)-Period(k,1)+n;
    n=n+Period(k,2)-Period(k,1)+1;
end
nRes=floor(Bursts(myBursts));
nBursts = length(nRes);
disp(['you have ', num2str(nBursts), ' bursts here'])
nlag=3;

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
NI=zeros(nfr,2,nlag);
NIP=zeros(nfr,2,nlag);
A=zeros(nfr,2,nlag);
Noi_dist=cell(nfr,2,nlag);
par.width=0;
tRes=zeros(nBursts,4,nfr);

for aa=60:5:140%30:10:50
FreqBins=[aa-bb,aa+bb];
cfrequency=aa;
for k=1:nfr
    wn = FreqBins(k,:)/(FS/2);
    [z, p, kk] = butter(4,wn,'bandpass');
    [b, a]=zp2sos(z,p,kk);
    filtLFP_temp = filtfilt(b, a, lfp);
    filtLFP_temp=hilbert(filtLFP_temp);
    sl=ceil(FS/FreqBins(k,1));
    for m=1:2
        if m==2
            filtLFP_temp=filtLFP_temp(:,[2,1]);
        end
        % this is only for the two
        a=-filtLFP_temp(:,1);
        b=-filtLFP_temp(:,2);
        tRes(:,1,k)=nRes+7-sl+clocalmin1(a(bsxfun(@plus,nRes,(6-sl):(5))),sl);%5
        tRes(:,2,k)=tRes(:,1,k)+1-sl+clocalmin1(b(bsxfun(@plus,tRes(:,1,k),(-sl):(-1))),sl);
        tRes(:,3,k)=tRes(:,1,k)-3-sl+clocalmin1(a(bsxfun(@plus,tRes(:,1,k),(-4-sl):(-5))),sl);
        tRes(:,4,k)=tRes(:,2,k)-3-sl+clocalmin1(b(bsxfun(@plus,tRes(:,2,k),(-4-sl):(-5))),sl);
        
        for n=1:nlag
            %             pl(k,m,n)=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),2))'*fangle(filtLFP_temp(tRes,1))/nb;
            if n<2
                ny=1;
                nx=2*n;
            else
                ny=3;
                nx=4;
            end
            X=zscore(abs(filtLFP_temp(tRes(:,nx,k),2)));
            Y=zscore(abs(filtLFP_temp(tRes(:,ny,k),1)));
            Z=zscore(abs(filtLFP_temp(tRes(:,nx,k),1)));
            [oci, Noi_dist{k,m,n}]=...
                KCIcausal_new(X,Y,Z,par,0,0);%
            pci(k,m,n)=oci(1);
            pst(k,m,n)=oci(2);
            cst(k,m,n)=oci(3);
            cci(k,m,n)=oci(5);
            cpap(k,m,n)=oci(7);
            [nte(k,m,n), me(k,m,n), ste(k,m,n), pval(k,m,n), h{k,m,n}, ~, ~, ~, ~]=nTE(Y,X,Z,400);
            [Ress, A(k,m,n)]=BasicRegression(X,Y);
            [NIP(k,m,n),NI(k,m,n)]=UInd_KCItest(X, Ress);
            fprintf('*')
        end
        fprintf('inv')
    end
    fprintf('\n')
%     %     end
    clear filtLFP_temp
end
% clear lfp
cd ~/data/g09_20120330/
datat=sprintf('compLFP%d-%d.%dHz.bfr%d-%d.RUN3.basictests.amp.Hpp.mat',Channels,cfrequency,bfr(nbfr,:));
save(datat,'pci','pst','cst','cci','cpap','NIP','NI','A','nte','me','ste','pval','h','Noi_dist','tRes','cfrequency')%['8_9nitry', labels{ln}])% 724all bursts 

figure(nbfr)
% for aa=60:5:140
subplot(3,6,(aa-60)/5+1)
%     datat=sprintf('compLFP%d-%d.%dHz.RUN3.basictests.amp.mat',Channels,cfrequency);
%     load(datat)
%     subplot(1,3,sstk);
plot(1:3,sq(cci(:,1,:))');
legend('5Hz','10Hz','15Hz','20Hz')
hold on;
plot(1:3,sq(cci(:,2,:))','+-')
plot([1 3],[.05 .05],'k--');
axis tight
set(gca,'XTick',1:3,'XTicklabel',{'C(0)>E(0)','C(-1)>E(0)','C(-1)>E(-1)'})
title(['RUN Hpp center on ', num2str(cfrequency), 'Hz'])
drawnow
end
end
% to show
for kaa=60:5:140
    datat=sprintf('compLFP%d-%d.%dHz.bfr%d-%d.RUN3.basictests.amp.Hpp.mat',Channels,kaa,bfr(nbfr,:));
    load(datat)
    subplot(3,6,(kaa-60)/5+1)
    plot(1:3,sq(cci(:,1,:))');
    legend('5Hz','10Hz','15Hz','20Hz')
    hold on;
    plot(1:3,sq(cci(:,2,:))','+-')
    plot([1 3],[.05 .05],'k--');
    axis tight
    set(gca,'XTick',1:3,'XTicklabel',{'C(0)>E(0)','C(-1)>E(0)','C(-1)>E(-1)'})
    title(['RUN Hpp center on ', num2str(cfrequency), 'Hz'])
end