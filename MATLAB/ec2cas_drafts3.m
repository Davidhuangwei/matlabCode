sjn='/gpfs01/sirota/home/gerrit/data/';
FileBase='g09-20120330';
FreqBins=[55 120];%[30 120];
% BurstShanks=[41:48,63];% channels, burst cluseter
HP=[41:48,63]';%33:40
nhp=length(HP);
EC=[6,8]';
myfilename=mfilename;
cd ~/data/g09_20120330/
load('g09_20120330.RUN3.Burst4Info.[14-250].all.mat')
FS = Par.lfpSampleRate;

cd([sjn, FileBase])
lfp= LoadBinary([FileBase '.lfp'],[HP;EC],Par.nChannels,2,[],[],Period)';

cd ~/data/g09_20120330/
wn = FreqBins/(FS/2);
[z, p, kk] = butter(4,wn,'bandpass');
[b, a]=zp2sos(z,p,kk);
% sos=zp2sos(z,p,kk);
% fltLFP=sosfilt(sos,lfp);

% [rho,pval] = partialcorr(zscore(fltLFP(:,[2,3,5,7,9,10])));
% yy=fltLFP'*fltLFP;
% T=svd(yy);
lfp = filtfilt(b, a, lfp);
lfp=hilbert(lfp);

nlag=10;
cl=ceil(FS/60);
stp=2;

par.width=.3;
Btitle={'EC to HP','HP to EC'};
t=([1:nlag]-nlag+1)*stp;
x=t;
y=1:nhp;

nRes=AllBursts.BurstTime(AllBursts.BurstChan<=8 & AllBursts.BurstChan>=5 ...
    & AllBursts.BurstFreq>55 & AllBursts.BurstFreq<120);
nb=length(nRes);
nb=min(2000,nb);
fprintf('\n you have %d bursts',nb);
nRes=nRes(1:nb);
%%

% tt=[1:2:40]-40;
tRes=nRes-randi(round(1250/65));
% tRes=bsxfun(@plus,nRes(nRes>=2.00*10^5 & nRes<=2.24*10^5),tt);
nbs=size(tRes,1);
% time=bsxfun(@plus,[1:nbs]'*100,tt);
% time=time(:);
% tRes=tRes(:);
% figure;hist(tRes,500)
nlag=10;
oci=zeros(nlag,4,4,9);
bss=zeros(nbs,200);
for k=1:200
[~,bss(:,k)]=sort(rand(nbs,1));
end
bss=bss-1;
for k=1:9
filtLFP_temp = lfp(:,[k,1+nhp]);
fLFP=fangle(filtLFP_temp(2:end,:))-fangle(filtLFP_temp(1:(end-1),:));
if k<7
    dch=k+2;
else
    dch=k-2;
end
dd=fangle(lfp(2:end,[dch,end]))-fangle(lfp(1:(end-1),[dch,end]));
for n=1:nlag
    %             pl(k,n,m)=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),2))'*fangle(filtLFP_temp(tRes,1))/nb;
    %             if n<nlag(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))
    tz=2;%(nlag-3);
    tx=(nlag-n+tz);
    X=filtLFP_temp(tRes-stp*tx,2);
    Y=filtLFP_temp(tRes,1);
    Z=filtLFP_temp(tRes-stp*tz,1);
    a=abs(fLFP(tRes-stp*tx,2));
    b=abs(fLFP(tRes,1));
    c=abs(fLFP(tRes-stp*tz,1));
                oci(n,:,1,k)=...
                    mKCIcausal_new(a,b,[c,abs(dd(tRes-stp*tz-1,1)),abs(dd(tRes-stp*tx,2)),real(Z)],par,bss,0);%abs(X),abs(Y),abs(Z)
                oci(n,:,2,k)=...
                    mKCIcausal_new(a,b,[c,abs(dd(tRes-stp*tx,2)),real(Z)],par,bss,0);%abs(X),abs(Y),abs(Z)
                oci(n,:,3,k)=...
                    mKCIcausal_new(a,b,[c,real(Z)],par,bss,0);%
                oci(n,:,4,k)=...
                    mKCIcausal_new(fangle(X),fangle(Y),[fangle(Z),abs(dd(tRes-stp*tz-1)),real(Z)-real(filtLFP_temp(tRes-stp*(nlag-n+1)-1,1))],par,bss,0);%
    fprintf('*')
end
end
figure(3)
for m=1:4
    subplot(1,4,m)
plot(sq(oci(:,4,m,:)))
title('Cind pval')
end
figure(4)
for m=1:4
    subplot(1,4,m)
plot(sq(oci(:,1,m,:)))
title('UCind pval')
end
legend
figure(13)
for m=1:4
    subplot(1,4,m)
plot(sq(oci(:,3,m,:)))
title('Cind sta')
end
figure(14)
for m=1:4
    subplot(1,4,m)
plot(sq(oci(:,2,m,:)))
title('UCind sta')
end
save([myfilename, num2str(EC(1)), 'con', num2str(EC(2)), 'Shank', num2str((HP(1)-25)/8), 'r.mat'],'oci','FreqBins','bss','HP','EC','nRes','tRes')
