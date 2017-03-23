clear all
% close all
sjn='/gpfs01/sirota/data/bachdata/data/gerrit/analysis/';
FileBase='g09-20120330';
cd([sjn, FileBase])
load([FileBase, '.par.mat'])
load([FileBase, '.sts.RUN3'])
Period=g09_20120330_sts;
nP=length(Period);
clear g09_20120330_sts
load([FileBase, '-LayerLabels.mat'])
load('g09-20120330.spec[14-250].lfpinterp.11.mat','t')
mec3=cell2mat(Layers.Mec3);
mec2=cell2mat(Layers.Mec2);
mec1=cell2mat(Layers.Mec1);
HP=load('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3.33-40.mat');
MECS1=load('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3.1-16.mat');
MECS2=load('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3.17-32.mat');

MB.BurstTime=[MECS1.BurstTime;MECS2.BurstTime];
MB.BurstFreq=[MECS1.BurstFreq;MECS2.BurstFreq];
MB.BurstChan=[MECS1.BurstChan;MECS2.BurstChan];
clear MECS1 MECS2
mec3=mec3(2:3);
mec2=10;
mec1=13;
lm=[43,44];%35,36,
DG=[37,38,46];%
rad=42;

Channels=[mec3,mec2,mec1,lm,DG,rad];
nch=length(Channels);
lfp= LoadBinary([FileBase '.lfp'],Channels,Par.nChannels,2,[],[],Period)';
FreqBins=[70 100];%;%; 70 100; 90 120];[50 70]
nt=size(lfp,1);
nfr=size(FreqBins,1);
% LFP=zeros(nt,nfr,nch);
FS = Par.lfpSampleRate;

% BURSTS SELECTION 
Bursts=MB.BurstTime((MB.BurstChan>4 & MB.BurstChan<9)|(MB.BurstChan>24 & MB.BurstChan<28) & MB.BurstFreq>60 & MB.BurstFreq<120)*FS;
myBursts=false(size(Bursts));
n=0;
for k=1:nP
    kk=find(Bursts<(Period(k,2)-200) & Bursts>(Period(k,1)+200));
    myBursts(kk)=true;
    Bursts(kk)=Bursts(kk)-Period(k,1)+n;
    n=n+Period(k,2)-Period(k,1)+1;
end
nRes=floor(Bursts(myBursts));
nb=length(nRes);
if nb>1000
    nRes=nRes(1:700);
    nb=length(nRes);
end
nbs=400;
[~,y]=sort(rand(nb,nbs));
lfp=lfp(1:(nRes(end)+1250*3),:);
timelags1=-50:4:50;
timelags2=-60:4:60;
t1=length(timelags1);
t2=length(timelags2);
pl=zeros(t1,t2,nfr,nch,nch);
npl=zeros(t1,t2,nfr,nbs,nch,nch);
mi=zeros(t1,t2,nfr,nch,nch);
nmi=zeros(t1,t2,nfr,nbs,nch,nch);
for kk=1:nfr
    wn = FreqBins(kk,:)/(FS/2);
    [z, p, kkk] = butter(4,wn,'bandpass');
    [b, a]=zp2sos(z,p,kkk);
    LFP = filtfilt(b, a, lfp);
    LFP=hilbert(LFP);
    for n1=1:nch
        for n2=1:nch
            for k=1:t1
                for n=1:t2
                    tlg1=timelags1(k);
                    tlg2=timelags2(n);
                    Y=fangle(LFP(nRes+tlg1,n2));
                    X=fangle(LFP(nRes+tlg1+tlg2,n1));
                    % could use BasicCausalTesting.m
                    [pl(k,n,kk,n1,n2),mi(k,n,kk,n1,n2),npl(k,n,kk,:,n1,n2),nmi(k,n,kk,:,n1,n2)]=...
                        BasicCausalTesting(X,Y,y,nbs,nb);
                    
                end
            end
            
        end
    end
    for n1=1:nch
        for n2=1:nch
            figure(2)
            subplot(nch,nch,n2+(n1-1)*nch)
            imagesc(timelags2,timelags1,sq(abs(pl(:,:,kk,n1,n2))))
            figure(3)
            subplot(nch,nch,n2+(n1-1)*nch)
            imagesc(timelags2,timelags1,sq(mi(:,:,kk,n1,n2)))
        end
    end
    drawnow
    disp(['done frequency bins', num2str(kk)])
end
close all
cd ~/data/g09_20120330/
datat=sprintf([FileBase, '.InfoRedundency.mec2H.frequency%d-%d.thin.mat'],FreqBins);
save(datat,'pl','npl','mi','nmi','FreqBins','timelags1','timelags2','y','Channels')
zr=reshape(sq(abs(pl)),size(pl,1),size(pl,2),nch,nch);
zri=reshape(sq(mi),size(pl,1),size(pl,2),nch,nch);
h=disp_patchesY(zr,[],0);
hi=disp_patchesY(zri,[],0);
figure
subplot(121)
imagesc(h) 
subplot(122)
imagesc(hi)
for k=1:2
   figure(k)
   subplot(121)
   hold on
   plot(repmat(16:31:341,2,1),repmat([1 286],11,1)','k')
   set(gca,'XTick',16:31:341,'XTicklabel',Channels,'YTick',16:31:341,'YTicklabel',Channels)
   subplot(122)
   hold on
   plot(repmat(16:31:341,2,1),repmat([1 286],11,1)','k')
   set(gca,'XTick',16:31:341,'XTicklabel',Channels,'YTick',16:31:341,'YTicklabel',Channels)
end
% for kk=1:nfr
% figure(222+kk)
% for n1=1:nch
%     for n2=1:nch
%         subplot(nch,nch,n2+(n1-1)*nch)
%         imagesc(timelags2,timelags1,sq(abs(pl(:,:,kk,n1,n2))))
%     end
% end
% end


















% rlfp=fangle(sq(sum(lfp(:,201,:,end-[4,6]),4)));
% pl=zeros(401,nfr,nch);
% for k=1:nch
%     for n=1:nfr
%             pl(:,n,k)=fangle(lfp(:,:,n,k))'*rlfp(:,n)/nt;
%     end
% end
% figure(331)
% for k=1:nfr
%     subplot(3,3,k)
%     imagesc(sq(abs(pl(:,k,:))))
% end
% [kk,ikk]=max(reshape(abs(pl),401,nfr*nch),[],1);
% figure(1);
% subplot(211)
% imagesc(1:nch, FreqBins(:,1),reshape(ikk,nfr,nch),[180 220])
% set(gca,'XTick', 1:nch,'XTicklabel', Channels)
% subplot(212);
% imagesc(1:nch, FreqBins(:,1),reshape(kk,nfr,nch),[0 .2])
% set(gca,'XTick', 1:nch,'XTicklabel', Channels)
% colorbar
% rlfp=fangle(sq(sum(lfp(:,:,:,end-[4,6]),4)));
% timelags=-100:4:100;
% timelag2s=-50:4:50;
% t1=length(timelags);
% t2=length(timelag2s);
% pn=zeros(t1,t2,nfr,nch);
% for k=1:nch
%     if k~=21 && k~=19
%     for n=1:nfr
%         for m=1:t1
%             for h=1:t2
%                 timelag=timelags(m);
%                 timelag2=timelag2s(h);
%                 if timelag2<0
%                     pn(m,h,n,k)=UInd_KCItest(sq(fangle(lfp(:,201+timelag+timelag2,n,k))), sq(fangle(lfp(:,201+timelag+timelag2,n,k))).*sq(conj(rlfp(:,201+timelag,n))));
%                 else
%                     pn(m,h,n,k)=UInd_KCItest(sq(conj(rlfp(:,201+timelag,n))), sq(fangle(lfp(:,201+timelag+timelag2,n,k))).*sq(conj(rlfp(:,201+timelag,n))));
%                 end
%             end
%         end
%     end
%     end
% end
