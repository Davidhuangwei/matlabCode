sjn='/gpfs01/sirota/home/gerrit/data/';
FileBase='g09-20120330';
FreqBins=[55 120];%[30 120];
% BurstShanks=[41:48,63];% channels, burst cluseter
HP=[43 45]';
nhp=length(HP);
EC=[17:32]';
nec=length(EC);
BG=[17 22; 21 24; 25 29; 28 32];
myfilename=mfilename;
cd ~/data/g09_20120330/
load('g09_20120330.RUN3.Burst4Info.[14-250].all.mat')
FS = Par.lfpSampleRate;
cl=ceil(1250/65);
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

stp=2;

par.width=.3;

nsbs=2000;
aRes=zeros(nsbs,4);
obgn=0;

%% 
nlag=10;
oci=zeros(nlag,4,4,nec);

for k=1:nec
    if k<12
        bgn=ceil(k/4);
    else
        bgn=4;
    end
    if bgn~=obgn
    nRes=AllBursts.BurstTime(AllBursts.BurstChan<=BG(bgn,2) & AllBursts.BurstChan>=BG(bgn,1) ...
        & AllBursts.BurstFreq>55 & AllBursts.BurstFreq<125);
    nb=length(nRes);
    fprintf('\n you have %d bursts',nb);
    [dummy,tpm]=sort(rand(nb,1));
    tpm=tpm(1:nsbs);
    nRes=nRes(tpm);
    aRes(:,bgn)=nRes;
    bss=zeros(nsbs,200);
    for kk=1:200
    [dummy,tpm]=sort(rand(nsbs,1));
    tpm=tpm(1:nsbs);
    bss(:,kk)=tpm;
    end
    obgn=bgn;
    bss=bss-1;
    end
    rRes=randi(cl,nsbs,1);
    tRes=nRes+ceil(cl/2)-rRes;
    
    filtLFP_temp = lfp(:,[1,k+nhp]);
fLFP=fangle(filtLFP_temp(2:end,:))-fangle(filtLFP_temp(1:(end-1),:));
if k<(nec-2)
    dch=k+2+nhp;
else
    dch=k-2+nhp;
end
dd=fangle(lfp(2:end,[dch,2]))-fangle(lfp(1:(end-1),[dch,2]));
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
save([myfilename, num2str(HP(1)), 'con', num2str(HP(2)), 'Shank', num2str(ceil(EC(1)/16)), 'r.mat'],'oci','FreqBins','bss','HP','EC','nRes','tRes')
figure(3)
Remarks=['HER','ER','R','\phi']
for m=1:4
    subplot(2,4,m)
imagesc(sq(oci(:,4,m,:))',[0 .05])
title([])
xlabel('Cind pval')
colorbar
subplot(2,4,m+4)
imagesc(sq(oci(:,3,m,:))')
xlabel('Cind sta')
colorbar
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