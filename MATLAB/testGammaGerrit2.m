% DG and mec3
clear all
close all
sjn='/gpfs01/sirota/data/bachdata/data/gerrit/analysis/';
% cd(sjn)
FileBase='g09-20120330';
cd([sjn, FileBase])
load([FileBase, '.par.mat'])
% HP=load('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3.33-40.mat');
MECS1=load('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3.1-16.mat');
MECS2=load('g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3.17-32.mat');
load('g09-20120330.spec[14-250].lfpinterp.11.mat','t')
load([FileBase, '.sts.RUN3'])
Period=g09_20120330_sts;
nP=length(Period);
clear g09_20120330_sts
load([FileBase, '-LayerLabels.mat'])
mec3=cell2mat(Layers.Mec3);
mec2=[];%cell2mat(Layers.Mec2);
mec1=[];%cell2mat(Layers.Mec1);
% lm=[35,36,43,44];
mol=[37,38,45,46,54,56];
Channels=[mec3,mol];%,radmec1,mec2,
chbelong=[length(mec3),length(mol)];%length(mec1),length(mec2),,length(rad)
lfp= LoadBinary([FileBase '.lfp'],Channels,Par.nChannels,2,[],[],Period)';
FreqBins=[60 100];%; 80 100; 30 60
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
BCH=false(size(HP.BurstTime));
for k=1:chbelong(1)
    BCH(HP.BurstChan==mec3(k))=true;
end
Bursts=HP.BurstTime(BCH & HP.BurstFreq<100 & HP.BurstFreq>60)*FS;
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
tb=400;
mt=bsxfun(@plus,nRes,-tb :tb);
lfp=reshape(LFP(mt(:),:,:),nt,2*tb+1,nfr,nch);
clear LFP
cd ~/data/g09_20120330
save([FileBase,'.HPGB30-60Hz.fHighGamma.MECtoDGmol.mat'])
clear all
close all
FileBase='g09-20120330';
load([FileBase,'.HPGB30-60Hz.fHighGamma.MECtoDGmol.mat'])
% phase locking analysis:fangle()
rlfp=sq(sum(lfp(:,tb+1,:,(end-chbelong(2)+1):end),4));
pl=zeros(2*tb+1,nfr,nch);
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
[kk,ikk]=max(reshape(abs(pl),2*tb+1,nfr*nch),[],1);
figure(1);
subplot(211)
imagesc(1:nch, FreqBins(:,1),reshape(ikk,nfr,nch),[180 220])
set(gca,'XTick', 1:nch,'XTicklabel', Channels)
subplot(212);
imagesc(1:nch, FreqBins(:,1),reshape(kk,nfr,nch),[0 .2])
set(gca,'XTick', 1:nch,'XTicklabel', Channels)
colorbar
rlfp=sq(sum(lfp(:,:,:,(end-chbelong(2)+1):end),4));% fangle()
timelags=-100:4:100;
timelag2s=-200:4:200;
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
                    pn(m,h,n,k)=UInd_KCItest(sq(fangle(lfp(:,tb+1+timelag+timelag2,n,k))), sq(fangle(lfp(:,tb+1+timelag+timelag2,n,k))).*sq(conj(rlfp(:,tb+1+timelag,n))));
                else
                    pn(m,h,n,k)=UInd_KCItest(sq(conj(rlfp(:,tb+1+timelag,n))), sq(fangle(lfp(:,tb+1+timelag+timelag2,n,k))).*sq(conj(rlfp(:,tb+1+timelag,n))));
                end
                
            end
        end
        figure(224)
        subplot(nfr,nch,k+(n-1)*nch)
        imagesc(sq(pn(:,:,n,k)))
        drawnow
    end
    end
end

pa=zeros(size(pn));
A=zeros(size(pn));
for k=1:nch
    if k~=21 && k~=19
    for n=1:nfr
        for m=1:t1
            for h=1:t2
                timelag=timelags(m);
                timelag2=timelag2s(h);
                ms=zscore(sq(abs(lfp(:,tb+1+timelag+timelag2,n,k))));
                cs=zscore(sq(abs(rlfp(:,tb+1+timelag,n))));
                if timelag2<0
                    [Ress, A(m,h,n,k)]=BasicRegression(ms,cs);
                    pa(m,h,n,k)=UInd_KCItest(ms, Ress);
                else
                    [Ress, A(m,h,n,k)]=BasicRegression(cs,ms);
                    pa(m,h,n,k)=UInd_KCItest(cs, Ress);
                end
                
            end
        end
        figure(226)
        subplot(nfr,nch,k+(n-1)*nch)
        imagesc(sq(pa(:,:,n,k)))
        drawnow
    end
    end
end
title('.1')

pac=zeros(size(pn));
for k=1:nch
    if k~=21 && k~=19
    for n=1:nfr
        for m=1:t1
            for h=1:t2
                timelag=timelags(m);
                timelag2=timelag2s(h);
                ms=zscore(sq(abs(lfp(:,tb+1+timelag+timelag2,n,k))));
                cs=zscore(sq(abs(rlfp(:,tb+1+timelag,n))));
                if timelag2<0
%                     [Ress, A(m,h,n,k)]=BasicRegression(ms,cs);
                    pac(m,h,n,k)=UInd_KCItest(ms, cs);
                else
%                     [Ress, A(m,h,n,k)]=BasicRegression(cs,ms);
                    pac(m,h,n,k)=UInd_KCItest(cs, ms);
                end
                
            end
        end
        figure(226)
        subplot(nfr,nch,k+(n-1)*nch)
        imagesc(sq(pac(:,:,n,k)))
        drawnow
    end
    end
end