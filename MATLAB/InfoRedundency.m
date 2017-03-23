% function InfoRedundency(Channels)
Channels=[37, 78];
FileBase='4_16_05_merged';
a=40;
b=[12,15,20]';%8,3,5,:5:3012;%
nfr=length(b);
FreqBins=[a-b,a+b];
load('/gpfs01/sirota/data/bachdata/data/weiwei/m_sm/4_16_05_merged_par.mat');
load /gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/4_16_05_merged/ChanInfo/ChanLoc_Full.eeg.mat
cd(['/gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/', FileBase])
StatePeriod = load([FileBase '.sts.RUN']);
lfp = LoadBinary([FileBase '.lfp'],Channels,Par.nChannels,2,[],[],StatePeriod)';% as loadinary don't take careof overlap of periods
FS = Par.lfpSampleRate;
cd /gpfs01/sirota/home/evgeny/project/gamma/data/4_16_05_merged
par.State='RUN';
Shk=3;
cd ~/data/sm/4_16_05_merged/
load('4_16_05_mergedthin.LFP.Channels37_78.Freq10_70.mat','nRes')
nbs=400;
% nt=size(lfp,1);
nb=length(nRes);
timelags1=-100:4:100;
timelags2=-100:4:100;
t1=length(timelags1);
t2=length(timelags2);
pl=zeros(t1,t2,nfr,4);
npl=zeros(t1,t2,nfr,nbs,4);
mi=zeros(t1,t2,nfr,4);
nmi=zeros(t1,t2,nfr,nbs,4);
[~,y]=sort(rand(nb,nbs));
for m=1:nfr
    wn = FreqBins(m,:)/(FS/2);
    [z, p, kk] = butter(4,wn,'bandpass');
    [b, a]=zp2sos(z,p,kk);
    LFP = filtfilt(b, a, lfp);
    LFP=hilbert(LFP);
    for k=1:t1
        for n=1:t2
            tlg1=timelags1(k);
            tlg2=timelags2(n);
            Y=fangle(LFP(nRes+tlg1,1));
            X=fangle(LFP(nRes+tlg1+tlg2,1));
            % could use BasicCausalTesting.m 
            pl(k,n,m,3)=X'*Y/nb;
            mi(k,n,m,3)=MutualInformation(X,Y,4,4);
            for bs=1:nbs
                npl(k,n,m,bs,3)=X(y(:,bs),:)'*Y/nb;
                nmi(k,n,m,bs,3)=MutualInformation(X(y(:,bs),:),Y,4,4);
            end
            % 
            Y=fangle(LFP(nRes+tlg1,2));
            X=fangle(LFP(nRes+tlg1+tlg2,2));
            pl(k,n,m,4)=X'*Y/nb;
            mi(k,n,m,4)=MutualInformation(X,Y,4,4);
            for bs=1:nbs
                npl(k,n,m,bs,4)=X'*Y(y(:,bs),:)/nb;
                nmi(k,n,m,bs,4)=MutualInformation(X,Y(y(:,bs),:),4,4);
            end
            Y=fangle(LFP(nRes+tlg1,1));
            X=fangle(LFP(nRes+tlg1+tlg2,2));
            pl(k,n,m,1)=X'*Y/nb;
            mi(k,n,m,1)=MutualInformation(X,Y,4,4);
            for bs=1:nbs
                npl(k,n,m,bs,1)=X(y(:,bs),:)'*Y/nb;
                nmi(k,n,m,bs,1)=MutualInformation(X(y(:,bs),:),Y,4,4);
            end
            Y=fangle(LFP(nRes+tlg1,2));
            X=fangle(LFP(nRes+tlg1+tlg2,1));
            pl(k,n,m,2)=X'*Y/nb;
            mi(k,n,m,2)=MutualInformation(X,Y,4,4);
            for bs=1:nbs
                npl(k,n,m,bs,2)=X'*Y(y(:,bs),:)/nb;
                nmi(k,n,m,bs,2)=MutualInformation(X,Y(y(:,bs),:),4,4);
            end
        end
    end
end
datat=sprintf([FileBase, '.InfoRedundency.ch%d-%d.frequency12-20.mat'],Channels);
save(datat,'pl','npl','mi','nmi','FreqBins','timelags1','timelags2','y')

figure(223)
subplot(241)
imagesc(timelags2,timelags1,sq(abs(pl(:,:,2,1)-median(sq(npl(:,:,2,:,1)),3))))
ylabel('phase locking')
title('CA3 to CA1')
subplot(245)
imagesc(timelags2,timelags1,sq(mi(:,:,2,1))-median(sq(nmi(:,:,2,:,1)),3))
ylabel('mutual information')
subplot(242)
imagesc(timelags2,timelags1,sq(abs(pl(:,:,2,2)-median(sq(npl(:,:,2,:,2)),3))))
title('CA1 to CA3')
subplot(246)
imagesc(timelags2,timelags1,sq(mi(:,:,2,2))-median(sq(nmi(:,:,2,:,2)),3))
subplot(243)
imagesc(timelags2,timelags1,sq(abs(pl(:,:,2,3)-median(sq(npl(:,:,2,:,3)),3))))
title('CA3 to CA3')
subplot(247)
imagesc(timelags2,timelags1,sq(mi(:,:,2,3))-median(sq(nmi(:,:,2,:,3)),3))
subplot(244)
imagesc(timelags2,timelags1,sq(abs(pl(:,:,2,4)-median(sq(npl(:,:,2,:,4)),3))))
title('CA1 to CA1')
xlabel('timelags2(sampels)')
ylabel('timelags1(sampels)')
subplot(248)
imagesc(timelags2,timelags1,sq(mi(:,:,2,4))-median(sq(nmi(:,:,2,:,4)),3))

figure(227)
subplot(241)
imagesc(timelags2,timelags1,sq(abs(pl(:,:,2,1))))
ylabel('phase locking')
title('CA3 to CA1')
subplot(245)
imagesc(timelags2,timelags1,sq(mi(:,:,2,1)))
ylabel('mutual information')
subplot(242)
imagesc(timelags2,timelags1,sq(abs(pl(:,:,2,2))))
title('CA1 to CA3')
subplot(246)
imagesc(timelags2,timelags1,sq(mi(:,:,2,2)))
subplot(243)
imagesc(timelags2,timelags1,sq(abs(pl(:,:,2,3))))
title('CA3 to CA3')
subplot(247)
imagesc(timelags2,timelags1,sq(mi(:,:,2,3)))
subplot(244)
imagesc(timelags2,timelags1,sq(abs(pl(:,:,2,4))))
title('CA1 to CA1')
xlabel('timelags2(sampels)')
ylabel('timelags1(sampels)')
subplot(248)
imagesc(timelags2,timelags1,sq(mi(:,:,2,4)))


mim=(sq(mi(:,:,2,1))-mean(sq(nmi(:,:,2,:,1)),3))./median(sq(nmi(:,:,2,:,1)),3); 
mii=(sq(mi(:,:,2,2))-mean(sq(nmi(:,:,2,:,2)),3))./median(sq(nmi(:,:,2,:,2)),3);
mim2=sq(mi(:,:,2,1)); mii2=sq(mi(:,:,2,2));
figure(224);
subplot(121)
hist([mim2(:),mii2(:)],100)
xlabel('Mutual information between lags')
legend('CA3 to CA1','CA1 to CA3')
axis tight
subplot(122)
hist([mim(:),mii(:)],100)
xlabel('normalized Mutual information between lags')
axis tight
legend('CA3 to CA1','CA1 to CA3')

mim3=(sq(mi(:,:,2,3))-mean(sq(nmi(:,:,2,:,3)),3))./median(sq(nmi(:,:,2,:,3)),3); 
mii3=(sq(mi(:,:,2,4))-mean(sq(nmi(:,:,2,:,4)),3))./median(sq(nmi(:,:,2,:,4)),3);
mim23=sq(mi(:,:,2,3)); mii23=sq(mi(:,:,2,4));
figure(225);
subplot(121)
hist([mim23(:),mii23(:)],100)
xlabel('Mutual information between lags')
legend('CA3 to CA3','CA1 to CA1')
axis tight
subplot(122)
hist([mim3(:),mii3(:)],100)
xlabel('normalized Mutual information between lags')
axis tight
legend('CA3 to CA3','CA1 to CA1')

figure(226);
subplot(121)
hist([mim2(:),mii2(:),mim23(:),mii23(:)],100)
xlabel('Mutual information between lags')
legend('CA3 to CA1','CA1 to CA3','CA3 to CA3','CA1 to CA1')
axis tight
subplot(122)
hist([mim(:),mii(:),mim3(:),mii3(:)],100)
xlabel('normalized Mutual information between lags')
axis tight
legend('CA3 to CA1','CA1 to CA3','CA3 to CA3','CA1 to CA1')
