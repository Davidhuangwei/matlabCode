clear all
close all
sjn='/storage/gerrit/data/project/GammaBursts/';
FileBase='g09-20120330';%'g10-20130305';% 'g10-20130305'
cd([sjn, FileBase])
load([FileBase, '.par.mat'])

FreqBins=[4 30;35 60; 55 120;130 160];
nfr=size(FreqBins,1);
States={'RUN','REM'};% I need to think of what is the time window in ,'SWS'
Freq=[4 14];
% load([FileBase, '.sts.RUN'])% AWK1
% Period=g09_20120330_sts;
Period=load([FileBase, '.sts.RUN']);
nP=size(Period,1);
% clear g09_20120330_sts
load([FileBase, '-LayerLabels.mat'])
% load('g09-20120330.spec[14-250].lfpinterp.11.mat','t')'g09-20120330.SelectBursts4.[14-250].lfpinterp.RUN3.1-16.mat'
MECS1=load([FileBase, '.SelectBursts3.[14-250].lfpinterp.RUN.1-16.mat']);% .SelectBursts.lfpinterp.AWK1.
MECS2=load([FileBase, '.SelectBursts3.[14-250].lfpinterp.RUN.17-32.mat']);
cthr=6;
MB.BurstTime=[MECS1.BurstTime;MECS2.BurstTime];
MB.BurstFreq=[MECS1.BurstFreq;MECS2.BurstFreq];
MB.BurstChan=[MECS1.BurstChan;MECS2.BurstChan];
clear MECS1 MECS2
% mec3=mec3(2:3);%6
% mec2=10;
% mec1=13;
% lm=[43,44];%35,36,  
% DG=[37,38,46];%
% rad=42;

% Channels=[6,43];%mec3,mec2,mec1,lm,DG,rad
% nch=length(Channels);
% lfp= LoadBinary([FileBase '.lfp'],Channels,Par.nChannels,2,[],[],Period)';
% lfp=lfp(:,[2,1]);
% nt=size(lfp,1);
FS = Par.lfpSampleRate;
nPeriod=ReshapePeriod(Period);
%% BURSTS SELECTION 
Bfr=[140 220];
Par.Bfr=Bfr;
Par.Chan=[25 26 12 13 14];%cell2mat(Layers.Mec2)
% Par.Chan=;%Par.Chan((Par.Chan)<17);
Bursts1=MB.BurstTime(((MB.BurstChan<12 & MB.BurstChan>8)  ) & MB.BurstFreq>60 & MB.BurstFreq<130)*FS;
myBursts=false(size(Bursts1));%| (MB.BurstChan<25 & MB.BurstChan>22)|(MB.BurstChan>24 & MB.BurstChan<28) | (MB.BurstChan<31 & MB.BurstChan>27)
n=0;
for k=1:nP
    kk=find(Bursts1<(Period(k,2)-200) & Bursts1>(Period(k,1)+200));
    myBursts(kk)=true;
    Bursts1(kk)=Bursts1(kk)-Period(k,1)+n;
    n=n+Period(k,2)-Period(k,1)+1;
end
nRes1=floor(Bursts1(myBursts));

Bursts=MB.BurstTime(((MB.BurstChan<15 & MB.BurstChan>11) | (MB.BurstChan<31 & MB.BurstChan>27) ) & MB.BurstFreq>Bfr(1) & MB.BurstFreq<Bfr(2))*FS;
myBursts=false(size(Bursts));%|(MB.BurstChan>24 & MB.BurstChan<28) | (MB.BurstChan<31 & MB.BurstChan>27)
n=0;
for k=1:nP
    kk=find(Bursts<(Period(k,2)-200) & Bursts>(Period(k,1)+200));
    myBursts(kk)=true;
    Bursts(kk)=Bursts(kk)-Period(k,1)+n;
    n=n+Period(k,2)-Period(k,1)+1;
end
nRes=floor(Bursts(myBursts));
nBursts = length(nRes);


disp(['you have ', num2str(nBursts+length(nRes1)), ' bursts here'])
%% theta phase of the whole time span.
% EC2C=cell2mat(Layers.Mec2);
% EC2= sum(LoadBinary([FileBase '.lfpinterp'],EC2C,96,2,[],[],Period)',2);%
% [b,a]=butter(4,Freq/625, 'bandpass');%[4 15]Freq[4 20][4 14]Freq
% for k=1:size(nPeriod,1)
% EC2(nPeriod(k,1):nPeriod(k,2),:)=hilbert(filtfilt(b,a,EC2(nPeriod(k,1):nPeriod(k,2),:)));
% end
% load theta phase 
load([FileBase,'.thpar.mat'])
EC2=zeros(nPeriod(end),1);
for k=1:nP
EC2(nPeriod(k,1):nPeriod(k,2))=ThPh(Period(k,1):Period(k,2));
end
btime=zeros(nBursts,2);
bt=find(abs(EC2)<=(pi/180));
for k=1:nBursts
    btime(k,1)=find(bt<nRes(k),1,'last');
    btime(k,2)=find(bt>nRes(k),1,'first');
end
%%
r=8;%1.5
theta=[1 1 1];%[
HP=33:40;%41:4833:40;
lambda=.01;
lfp=LoadBinary([FileBase '.lfpinterp'],HP,96,2,[],[],Period)';
cd(['/storage/weiwei/data/', FileBase])
sname=sprintf([FileBase,'.rIC.RUN.HP%d.%d.mat'],HP([1 end]));
if exist(sname,'file')
    load(sname);
else
[~, A, W, m]=wKDICA(lfp',.9999,0,0,0);%,'W0
figure;
subplot(131);
imagesc(A)
subplot(132);
imagesc(A(1:(end-2),:)+A(3:end,:)-2*A(2:(end-1),:))
subplot(133)
plot(bsxfun(@plus,bsxfun(@rdivide,A,sqrt(sum(A.^2,1))),1:size(A,2)))
tm=input('which component is Vol-Con?');%1;%
save(sname,'A','W','tm')
end
lfp=lfp-lfp*W(tm,:)'*A(:,tm)';
%%
usetime=zeros(size(lfp,1),1);
usetime([fix(Bursts(myBursts));nRes1])=1;
usetime=conv(usetime',ones(1,614),'same');sum(usetime>0)
Par.Burst=Bursts(myBursts);
Par.MEC3B=nRes1;
Par.sts='RUN';% AWK1
Par.r=r;
Par.theta=theta;
Par.lambda=lambda;
Par.A=A;
Par.W=W;
Par.tm=tm;
if isreal(EC2)
    Par.thetaphase=EC2(fix(Bursts(myBursts)));
else
    Par.thetaphase=angle(EC2(fix(Bursts(myBursts))));
end
Par.Freq=Freq;
Par.FreqBins=FreqBins;
Par.cthr=cthr;
%%
nHP=HP(1):.5:HP(end);
Par.HP=nHP;
Periods=1:12500:(sum(usetime>0)-25000);
nP=length(Periods);
for kfr=1:nfr
    clclength=fix(1250/FreqBins(kfr,1)*1.5);
    fB=fix(Bursts(myBursts));
taketime=bsxfun(@plus,fB((fB>clclength)&(fB<(length(lfp)-clclength-10))),(-clclength):(clclength+10));
nlfp=ButFilter(lfp,4,FreqBins(kfr,:)/625,'bandpass');
nlfp=mkCSD(nlfp(usetime>0,:),r,HP,nHP,lambda,theta);
tA=cell(nP,1);
tW=cell(nP,1);
B=cell(nP,1);
sA=cell(nP,1);
jdfr=(FreqBins(kfr,1)+3):6:FreqBins(kfr,2);
for k=1:nP
    [~, tA{k}, tW{k}, ~]=wKDICA(nlfp(Periods(k)+[1:25000],:)',cthr,0,0,0);%,'W0
    try
        [B{k}, ~]=SSpecJAJD(nlfp(Periods(k)+[1:25000],:),1250,400,400,jdfr,100,cthr,0);
        
    catch
        errorterm.S=[errorterm.S;nr,nf,k];
        fprintf('\n error: r%d-f%d-k%d-\n',nr,nf,k)
        continue
    end
    sA{k}=pinv(B{k});% lambda/B{k}
    fprintf('%d-',k)
end
[gB, gc]=SSpecJAJD(nlfp,1250,400,400,jdfr,100,cthr,0);
gsA=pinv(gB);
[~, gA, gW, ~]=wKDICA(nlfp(Periods(k)+[1:25000],:)',cthr,0,0,0);%,'W0
[nm,~,~]=ClusterCompO(gsA,sA,.1);
[nmA,~,~]=ClusterCompO(gA,tA,.1);
lnm=length(nm);
ny=zeros(length(nHP),lnm);
for k=1:lnm
    fd=sum(nm{k}.^2,1)>10^-8;
    nmD=sum(fd);
    if nmD>0
        dt=bsxfun(@times,bsxfun(@rdivide,nm{k}(:,fd),sqrt(sum(nm{k}(:,fd).^2,1))),sign(gsA(:,k)'*nm{k}(:,fd)));
        ny(:,k)=mean(dt,2);%GaussionProcessRegression(repmat(nx,nmD,1),dt(:),.8,.00001,nxx(:));
    end
end
gbsnm=bsxfun(@rdivide,ny,sum(ny.^2));%(fix(1:((length(nxx)-1)/(length(HP)-1)):length(nxx)),:);
S(kfr).gbsnm=gbsnm;
lnm=length(nmA);
ny=zeros(length(nHP),lnm);
muny=zeros(length(nHP),lnm);
thetam=.0001;
for k=1:lnm
    fd=sum(nmA{k}.^2,1)>10^-8;
    nmD=sum(fd);
    if nmD>0
        dt=bsxfun(@times,bsxfun(@rdivide,nmA{k}(:,fd),sqrt(sum(nmA{k}(:,fd).^2,1))),sign(gsA(:,k)'*nmA{k}(:,fd)));
        ny(:,k)=mean(dt,2);%GaussionProcessRegression(repmat(nx,nmD,1),dt(:),.8,.00001,nxx(:));
        thetav=sqrt(var(dt,2));
        muny(:,k)=thetam*ny(:,k)*nmD./(thetam*nmD+thetav);
    end
end
gbwnm=bsxfun(@rdivide,ny,sqrt(sum(ny.^2)));%(fix(1:((length(nxx)-1)/(length(HP)-1)):length(nxx)),:);
muny=bsxfun(@rdivide,muny,sqrt(sum(muny.^2)));
S(kfr).gbwnm=gbwnm;
S(kfr).nm=nm;
S(kfr).nmA=nmA;
S(kfr).sA=sA;
S(kfr).B=B;
S(kfr).tA=tA;
S(kfr).tW=tW;
S(kfr).muny=muny;
icatrough=zeros(sum(myBursts),2*cthr);
%%
close all
[rfw, rfA]=RefineICsFrIC(nlfp,pinv(gbsnm)');
nlfp=ButFilter(lfp,4,FreqBins(kfr,:)/625,'bandpass');
S(kfr).rfw=rfw;
S(kfr).rfA=rfA;
nlfp=mkCSD(nlfp,r,HP,nHP,lambda,theta);
nn=1;
msig=[];
thetaP=cell(3,1);
t=(-30):2:50;
ct=length(t);
Par.t=t;
for kk=1:3
    if kk==1;
        icasig=pinv(gbsnm)*nlfp';
        [msign,locs]=SinkLoc(gbsnm);
        ncomps=size(icasig,1);
        [S(kfr).sMI,dummy]=PairwiseInformation(nlfp,pinv(gbsnm)');
    elseif kk==2
        icasig=pinv(gbwnm)*nlfp';
        [msign,locs]=SinkLoc(gbwnm);
        ncomps=size(icasig,1);
        [S(kfr).wMI,dummy]=PairwiseInformation(nlfp,pinv(gbwnm)');
    else
        icasig=rfw*nlfp';
        [msign,locs]=SinkLoc(rfA);
        ncomps=size(icasig,1);
        [S(kfr).rMI,dummy]=PairwiseInformation(nlfp,rfw');
    end
    thetaP{kk}=zero(nBursts,ncomps);
    for kt=1:nBursts
        [~,tlocs]=SinkLoc(icasig(:,btime(kt,1):btime(kt,2))');
        thetaP{kk}(kt,:)=btime(kt,1)-1+tlocs;
    end
    for kc=1:size(icasig,1)
        sig=icasig(kc,:)';
        icatrough(:,nn)=LocMin(sig(taketime'),clclength);
        icatrough(:,nn)=icatrough(:,kc+(kk-1)*cthr)-clclength-1+fix(Bursts(myBursts));
        nn=nn+1;
    end
    msig(kk).peak=findpeaks(-bsxfun(@times,icasig',msign));
    msig(kk).mact=cell(ncomps,1);
    for kc=1:ncomps
        msig(kk).mact{kc}=zeros(ncomps,ct);%
        taketime2=bsxfun(@plus,msig(kk).peak(kc).loc((msig(kk).peak(kc).loc>30)& (msig(kk).peak(kc).loc<size(icasig,2)-50)),t);
        for nkc=1:ncomps
            tmp=icasig(nkc,:)';
            msig(kk).mact{kc}(nkc,:)= mean(tmp(taketime2),1);
        end
    end
    
end
S(kfr).msig=msig;
%
if isreal(EC2)
    S(kfr).thetaphase=EC2(icatrough);
    S(kfr).bigGthetaphase=EC2(cell2mat(thetaP{kk}));
else
S(kfr).thetaphase=angle(EC2(icatrough));
S(kfr).bigGthetaphase=angle(EC2(cell2mat(thetaP{kk})));
end
S(kfr).icatrough=icatrough;
S(kfr).thetaP=thetaP;

phasediff=angle(exp(i*bsxfun(@minus,S(kfr).thetaphase,Par.thetaphase)));
ncomps=size(gbsnm,2)+size(gbwnm,2)+size(rfA,2);
ui=zeros(2,ncomps);
up=zeros(2,ncomps);
for k=1:ncomps; [ui(1,k), up(1,k)]=UInd_KCItestnb(S(kfr).thetaphase(:,k),phasediff(:,k),.2);[ui(2,k),up(2,k)]=UInd_KCItestnb(Par.thetaphase,phasediff(:,k),.2);end;

phasediff=angle(exp(i*bsxfun(@minus,S(kfr).bigGthetaphase,Par.thetaphase)));
uiw=zeros(2,ncomps);
upw=zeros(2,ncomps);
for k=1:ncomps; [uiw(1,k), upw(1,k)]=UInd_KCItestnb(S(kfr).bigGthetaphase(:,k),phasediff(:,k),.2);[ui(2,k),up(2,k)]=UInd_KCItestnb(Par.thetaphase,phasediff(:,k),.2);end;


S(kfr).ui=ui;
S(kfr).up=up;
S(kfr).uiw=uiw;
S(kfr).upw=upw;
fprintf('%.3f-',up(1,:))
fprintf('\n')
fprintf('%.3f-',up(2,:))
fprintf('\n')
end
cd(['/storage/weiwei/data/',FileBase])
sname=sprintf([FileBase, '.freqR.thetaPhase.CSD.span.%d.%d.Ch.%d.%d.r%.1f.Causal.Bfr%d.%d.MEC23.comp%d.n.mat'],theta([1 3]),HP([1 end]),r,Bfr,cthr);
save(sname,'S','Par')
return
cd ~/data/sm/4_16_05_merged/
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
        a=filtLFP_temp(:,1);
        b=filtLFP_temp(:,2);
        tRes(:,1,k)=nRes+7-sl+clocalmin1(a(bsxfun(@plus,nRes,(6-sl):5)),sl-4);
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
    %     end
    clear filtLFP_temp
end
clear lfp
cd ~/data/g09_20120330/
% datat=sprintf('compLFP%d-%d.%dHz.RUN3.basictests.amp.mat',Channels,cfrequency);
save(datat)%['8_9nitry', labels{ln}])% 724all bursts 


figure
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
    title('RUN')