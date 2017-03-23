% clear all
% close all

sjn='/storage/evgeny/data/project/gamma/data/';
FileBase='ni04-20110503';%'g10-20130305';% 'g10-20130305'
cd(['/storage/weiwei/data/', FileBase])
load([FileBase, '.SICs.ch.1.32.fr.4.200.r4.0.mat'])
cd([sjn, FileBase])
FreqBins=Par.FreqBins;
nfr=size(FreqBins,1);
States={'RUN','REM'};% I need to think of what is the time window in ,'SWS'
Freq=Par.FreqB;
% load([FileBase, '.sts.RUN'])% AWK1
% Period=g09_20120330_sts;
Period=load([FileBase, '.sts.SWS']);
% Period2=load([FileBase, '.sts.REM']);
Period=Period([1 end]);
% Period2=load([FileBase, '.sts.RUN']);
% cPeriods=[Period2(Period2(:,1)>10^5,:);Period];
% Period=cPeriods;
%%
cd(['/storage/noriaki/data/processed/', FileBase])
Theta=GetThetaPhase(FileBase,Period);
FS = 1250;
nPeriod=ReshapePeriod(Period);
%%

r=Par.r;
theta=Par.theta;
A=Par.A;
W=Par.W;
tm=Par.tm;
cthr=Par.cthr;
HP=Par.HP;
gCh=Par.gCh;
lambda=Par.lambda;
cd([sjn, FileBase])
lfp=LoadBinary([FileBase '.lfpinterp'],gCh,64,2,[],[],Period)';
%%
[~, A, W, m]=wKDICA(lfp',10,0,0,0);% Here I want to get rid of the most prominate grobal components. 
figure;
subplot(131);
imagesc(A)
subplot(132);
imagesc(A(1:(end-2),:)+A(3:end,:)-2*A(2:(end-1),:))
subplot(133)
plot(bsxfun(@plus,bsxfun(@rdivide,A,sqrt(sum(A.^2,1))),1:size(A,2)))
%
 [~, A2, W2, m2]=wKDICA(diff(lfp',1,2),10,0,0,0);%,'W0
figure;
subplot(131);
imagesc(A2)
subplot(132);
imagesc(A2(1:(end-2),:)+A2(3:end,:)-2*A2(2:(end-1),:))
subplot(133)
plot(bsxfun(@plus,bsxfun(@rdivide,A2,sqrt(sum(A2.^2,1))),1:size(A2,2)))
%%
tm=1;%input('which component is Vol-Con?');%1;%
sname=sprintf([FileBase,'.rIC.Sleep.HP%d.%d.mat'],HP([1 end]));
save(sname,'A','W','tm','A2','W2')
lfp=lfp-lfp*W(tm,:)'*A(:,tm)';
%%
LFP=lfp;
% lfp=LFP(:,[5 15 25]);
%%
wn=12500;
t=1:wn:length(lfp);
nt=length(t);
ARmodel=cell(nt,1);
ARorder=1;% after this indeed I'm more or less forcusing in the "input and noise" now
for k=1:nt
[lfp(t(k):min((t(k)+wn-1),length(lfp)),:), ARmodel{k}] = WhitenSignal(LFP(t(k):min((t(k)+wn-1),length(lfp)),:), [],2,[], ARorder);
end
%%
nlfp=mkCSD(lfp,2,gCh,gCh,lambda,theta);
[~, nA, nW, m]=wKDICA(nlfp',8,0,0,0);%
[~, A, W, m]=wKDICA(lfp',8,0,0,0);%
%%
figure;
subplot(121)
plot(bsxfun(@plus,bsxfun(@rdivide,A,sqrt(sum(A.^2,1))),1:size(A,2)))
axis tight;grid on;
subplot(122)
plot(bsxfun(@plus,bsxfun(@rdivide,nA,sqrt(sum(nA.^2,1))),1:size(nA,2)))
axis tight;grid on
%%
[mnA,mnW,nAs,nWs,nnormAs,nnWs]=ICsRFbyBS(nlfp,nW,20,[]);
[mA,mW,As,Ws,normAs,nWs]=ICsRFbyBS(lfp,W,20,[]);
%%
figure;
subplot(121)
plot(bsxfun(@plus,bsxfun(@rdivide,mA,sqrt(sum(mA.^2,1))),1:size(mA,2)))
hold on;
mcsd=mkCSD(mA',2,gCh,gCh,lambda,theta)';
plot(bsxfun(@plus,bsxfun(@rdivide,mcsd,sqrt(sum(mcsd.^2,1))),1:size(mA,2)),'--')
for k=1:length(normAs)
    plot(bsxfun(@plus,normAs{k},1:size(mAcv,2)),':')
end
hold off
axis tight;grid on;
subplot(122)
plot(bsxfun(@plus,bsxfun(@rdivide,mnA,sqrt(sum(mnA.^2,1))),1:size(mnA,2)))
hold on;
for k=1:length(nnormAs)
    plot(bsxfun(@plus,nnormAs{k},1:size(mAcv,2)),':')
end
hold off
axis tight;grid on
title('ICsRFbyBS')
%%
[mnAcv,mnWcv,nAscv,nWscv,nnormAscv,nnWscv]=ICsRFbyCV(nlfp,nW,20);
[mAcv,mWcv,Ascv,Wscv,normAscv,nWscv]=ICsRFbyCV(lfp,W,20);
%%
figure;
subplot(121)
plot(bsxfun(@plus,bsxfun(@rdivide,mAcv,sqrt(sum(mAcv.^2,1))),1:size(mAcv,2)))
hold on;
for k=1:length(normAscv)
    plot(bsxfun(@plus,normAscv{k},1:size(mAcv,2)),':')
end
hold off
axis tight;grid on;
subplot(122)
plot(bsxfun(@plus,bsxfun(@rdivide,mnAcv,sqrt(sum(mnAcv.^2,1))),1:size(mnAcv,2)))
hold on;
for k=1:length(nnormAscv)
    plot(bsxfun(@plus,nnormAscv{k},1:size(mAcv,2)),':')
end
hold off
axis tight;grid on
title('ICsRFbyCV')
%% compute the pairwise information here!
mamari(mnWcv,mnW)
mamari(mWcv,mW)
mamari(pinv(mnAcv),pinv(mnA))
mamari(pinv(mAcv),pinv(mA))
%%
icasig=Zscore(lfp*mW',1);
nicasig=Zscore(nlfp*mnW',1);
ncomp=size(icasig,2);
infos=zeros(ncomp);
for k=1:(ncomp-1)
    for n=(k+1):ncomp
        infos(k,n)=information(icasig(:,k)',icasig(:,n)');
        infos(n,k)=information(nicasig(:,k)',nicasig(:,n)');
    end
end
figure;imagesc(abs(infos))
title('information zBS')
%% check the trace of variace 
vnicasig=icasig;
windowf=parzenwin(30);
for k=1:ncomp;
    vnicasig(:,k)=filter(windowf,1,icasig(:,k).^2);
end
CheckLFP([vnicasig, (Theta.ThAmp)/prctile(Theta.ThAmp,30).*cos(Theta.ThPh)])
%% first see the specturm for the whole sleeping periods 
% component6 looks like following component 4, 4 looks like indicating the
% activity of pyr layer. it sometimes preceed comp2, somethimes follow.
% the follow one seems at ~80 ms, the followed one is very fast, ~20 ms.
% comp 2 and 7 together says the boundry should be around ch20, but comp 6
% come across it, and it looks like some activity follows comp 4. so could
% it be some interneurons? then it would be interesting because it also
% send to DG. that would be an evidence how te CA1 directly modulate DG.
% However, I can't see the effect of CA3 components, which should be 3,
% don't know why... maybe it's always very large? so I should see during "
% REM" it becomes smaller...
 [yo,fo, phi]= mtchd(nicasig,[],1250,2^9,2^8,[],1,5,[2 140]);
%% see the spectrum in windows.


