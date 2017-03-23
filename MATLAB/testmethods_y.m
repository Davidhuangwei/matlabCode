clear all
close all
FileBase='4_16_05_merged';
a=40;
b=[8,12,15,20]';%3,5,:5:30
nfr=length(b);
FreqBins=[a-b,a+b];
load('/gpfs01/sirota/data/bachdata/data/weiwei/m_sm/4_16_05_merged_par.mat');
repch=RepresentChan(Par);
load /gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/4_16_05_merged/ChanInfo/ChanLoc_Full.eeg.mat

cd(['/gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/', FileBase])
StatePeriod = load([FileBase '.sts.RUN']);
nprd=size(StatePeriod,1);
Channels=[37,78];
lfp = LoadBinary([FileBase '.lfp'],Channels,Par.nChannels,2,[],[],StatePeriod)';% as loadinary don't take careof overlap of periods
FS = Par.lfpSampleRate;
cd /gpfs01/sirota/home/evgeny/project/gamma/data/4_16_05_merged
State='RUN';
[FeatData, FeatName] = LoadBurst(FileBase, Par,'csdsm5', State);
Shk=3;
MyBursts = find(strcmp(FeatData{15},'CA1rad') & (FeatData{3}==54 | abs(FeatData{3}-37)<2 ) & FeatData{9}>40 & abs(FeatData{2}-40)<20);%
nBursts = length(MyBursts);%54
disp(['you have ', num2str(nBursts), ' bursts here'])
Res = floor(FeatData{14}(MyBursts)*1250);
Clu= FeatData{2}(MyBursts);
[nRes,tClu]=getRes(Res,Clu,StatePeriod);
% [~,id]=sort(rand(length(nRes),1));
% % a=bsxfun(@plus,nRes(id(1:200)),[-10, 0, 10]);
% % Clu=tClu(id(1:200));
% % nRes=a(:);

% tlfp=bsxfun(@plus,nRes,(-100):100);
fb=2;
wn = FreqBins(fb,:)/(FS/2);
[z, p, kk] = butter(4,wn,'bandpass');
[b, a]=zp2sos(z,p,kk);
filtLFP_temp = filtfilt(b, a, lfp);
filtLFP_temp=hilbert(filtLFP_temp);
bn=15;
bc=floor(bn/2);
xbins=linspace(-pi,pi,bn);
nlags=21;
m=11;
sn=2;
md=zeros(nlags,bn,2);
sbpn=6;
for k=1:nlags
    figure(225+fb)
    subplot(sbpn,nlags,k)
    md(k,:,1)=histc(angle(filtLFP_temp(nRes-sn*(m-k),1)),xbins);
    [~,id]=sort(md(k,:,1));
    md(k,end,1)=xbins(id(end));
    bar(xbins(2:end),circshift(sq(md(k,1:(end-1),1))',bc-id(end)))
    axis([-pi, pi, 0, 180])
    title(['time lag', num2str(-sn*(m-k))])
    subplot(sbpn,nlags,k+nlags)
    md(k,:,2)=histc(angle(filtLFP_temp(nRes-sn*(m-k),2)),xbins);
    [~,id]=sort(md(k,:,2));
    md(k,end,2)=xbins(id(end));
    bar(xbins(2:end),circshift(sq(md(k,1:(end-1),2))',bc-id(end)))
    axis([-pi, pi, 0, 180])
    subplot(sbpn,nlags,k+2*nlags)
    plot(mod(angle(filtLFP_temp(nRes-sn*(m-k),2))-md(k,end,2)+pi,2*pi)-pi,mod(angle(filtLFP_temp(nRes-sn*(m-k),1))-md(k,end,1)+pi,2*pi)-pi,'.')
    axis([-pi pi -pi pi])
    subplot(sbpn,nlags,k+3*nlags)
    plot(mod(angle(filtLFP_temp(nRes-sn*(m-k),2))-md(k,end,2)+pi,2*pi)-pi,mod(angle(filtLFP_temp(nRes,1))-md(m,end,1)+pi,2*pi)-pi,'.')
    axis([-pi pi -pi pi])
    
    subplot(sbpn,nlags,k+4*nlags)
    plot(abs(fangle(filtLFP_temp(nRes-sn*(m-k),2))-fangle(filtLFP_temp(nRes-sn*(m-k)-1,2))),mod(angle(filtLFP_temp(nRes,1))-md(m,end,1)+pi,2*pi)-pi,'.')
    axis([0 .4 -pi pi])
    subplot(sbpn,nlags,k+5*nlags)
    plot(abs(filtLFP_temp(nRes-sn*(m-k),2))-abs(filtLFP_temp(nRes-sn*(m-k)-1,2)),mod(angle(filtLFP_temp(nRes,1))-md(m,end,1)+pi,2*pi)-pi,'.')
    axis tight
end








cd ~/data/sm/4_16_05_merged/
nlag=11;
% nt=size(lfp,1);
nb=length(nRes);
pl=zeros(nfr,2,2*nlag-1);

cnames={'pl','pci','cci','cpap'};
h=cell(nfr,2,2*nlag-1);
pci=zeros(nfr,2,2*nlag-1);
pst=zeros(nfr,2,2*nlag-1);
cst=zeros(nfr,2,2*nlag-1);
cci=zeros(nfr,2,2*nlag-1);
cpap=zeros(nfr,2,2*nlag-1);
par.width=.3;
t=1:nb;
ytick=1:size(FreqBins,1);
xlabels=(1:(2*nlag+1))*5;
xticks=1:2:(2*nlag-1);
ylabels=FreqBins(:,2)-40;
showr=false;%true;
% cause and effect are in the  same frequency range
clr={'r','g','b','c','y','k'};
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
        tRes=nRes;%-102+vind;
        for n=1:(2*nlag-1)
            pl(k,m,n)=fangle(filtLFP_temp(tRes-5*(11-n),2))'*fangle(filtLFP_temp(tRes,1))/nb;
            if n==11
                disp('half done')
            else
                oci=...
                    KCIcausal_new(fangle(filtLFP_temp(tRes-5*(11-n),2)),fangle(filtLFP_temp(tRes,1)),[fangle(filtLFP_temp(tRes-5*(11-n)+1,2)),fangle(filtLFP_temp(tRes-5*(11-n)-1,2)),fangle(filtLFP_temp(tRes-5*(11-n),1))],par,0,0);%[,fangle(filtLFP_temp(tRes-5*(nlag-n-1),1))]
                
                pci(k,m,n)=oci(1);
                pst(k,m,n)=oci(2);
                cst(k,m,n)=oci(3);
                cci(k,m,n)=oci(5);
                cpap(k,m,n)=oci(7);
            end
        end
    end
    
    %     end
    clear filtLFP_temp
end
cd ~/data/sm/4_16_05_merged/
save 8_9nitry% 724all bursts 