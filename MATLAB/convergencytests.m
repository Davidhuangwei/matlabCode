clear all
close all
FileBase='4_16_05_merged';
a=40;
b=[12,15,20]';%8,3,5,:5:3012;%
nfr=length(b);
FreqBins=[a-b,a+b];
load('/gpfs01/sirota/data/bachdata/data/weiwei/m_sm/4_16_05_merged_par.mat');
repch=RepresentChan(Par);
load /gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/4_16_05_merged/ChanInfo/ChanLoc_Full.eeg.mat
States={'RUN','REM','SWS'};
stk=1;
State=States{stk};%'RUN';%'REM';'SWS'
cd(['/gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/', FileBase])
StatePeriod = load([FileBase '.sts.', State]);
nprd=size(StatePeriod,1);
Channels=[37,78];
lfp = LoadBinary([FileBase '.lfp'],Channels,Par.nChannels,2,[],[],StatePeriod)';% as loadinary don't take careof overlap of periods
FS = Par.lfpSampleRate;
cd /gpfs01/sirota/home/evgeny/project/gamma/data/4_16_05_merged
[FeatData, FeatName] = LoadBurst(FileBase, Par,'lfpinterp', State);
MyBursts = find(strcmp(FeatData{15},'CA1rad') & ( abs(FeatData{3}-37)<2 )  & abs(FeatData{2}-40)<20 & FeatData{9}>48);%FeatData{3}==54 |
nBursts = length(MyBursts);%54
kkn=0;
while nBursts<1000
    kkn=kkn+1;
    MyBursts = find(strcmp(FeatData{15},'CA1rad') & ( abs(FeatData{3}-37)<2 )  & abs(FeatData{2}-40)<20 & FeatData{9}>(48-kkn));%FeatData{3}==54 |
nBursts = length(MyBursts);%54(10*kkn)
end
Res = floor(FeatData{14}(MyBursts)*1250);
Clu= FeatData{2}(MyBursts);
[nRes,tClu]=getRes(Res,Clu,StatePeriod);
nBursts = length(nRes);
disp(['you have ', num2str(nBursts), ' bursts here'])
cd ~/data/sm/4_16_05_merged/
nlag=2;

cnames={'pl','pci','cci','cpap'};
sps=[400,800,1000,1200,1300,1350,1400];
nsps=length(sps);
[~,rod]=sort(rand(nBursts,1));
nte=zeros(nfr,2,nlag,nsps);
me=zeros(nfr,2,nlag,nsps);
ste=zeros(nfr,2,nlag,nsps);
pval=zeros(nfr,2,nlag,nsps);
h=cell(nfr,2,nlag,nsps);
pci=zeros(nfr,2,nlag,nsps);
pst=zeros(nfr,2,nlag,nsps);
cst=zeros(nfr,2,nlag,nsps);
cci=zeros(nfr,2,nlag,nsps);
cpap=zeros(nfr,2,nlag,nsps);
NI=zeros(nfr,2,nlag,nsps);
NIP=zeros(nfr,2,nlag,nsps);
A=zeros(nfr,2,nlag,nsps);
Noi_dist=cell(nfr,2,nlag,nsps);
par.width=0;
tRes=zeros(nBursts,4,nfr);
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
        % this is only for the two
        a=-filtLFP_temp(:,1);
        b=filtLFP_temp(:,2);
        tRes(:,1,k)=nRes-34+clocalmin1(a(bsxfun(@plus,nRes,(-33):6)),40);
        tRes(:,2,k)=nRes-41+clocalmin1(b(bsxfun(@plus,nRes,(-40):(-1))),40);
        tRes(:,3,k)=tRes(:,1,k)-71+clocalmin1(a(bsxfun(@plus,tRes(:,1,k),(-70):(-11))),60);
        tRes(:,4,k)=tRes(:,2,k)-71+clocalmin1(b(bsxfun(@plus,tRes(:,2,k),(-70):(-11))),60);
        
        for n=1:nlag
            %             pl(k,m,n)=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),2))'*fangle(filtLFP_temp(tRes,1))/nb;
%             if n<2
%                 ny=1;
%                 nx=2*n;
%             else
%                 ny=3;
%                 nx=4;
%             end
            ny=2*n-1;
            nx=2*n;
            for ksps=1:nsps
            X=zscore(abs(filtLFP_temp(tRes(rod(1:sps(ksps)),nx,k),2)));
            Y=zscore(abs(filtLFP_temp(tRes(rod(1:sps(ksps)),ny,k),1)));
            Z=zscore(abs(filtLFP_temp(tRes(rod(1:sps(ksps)),nx,k),1)));
            [oci, Noi_dist{k,m,n}]=...
                KCIcausal_new(X,Y,Z,par,0,0);%
            pci(k,m,n,ksps)=oci(1);
            pst(k,m,n,ksps)=oci(2);
            cst(k,m,n,ksps)=oci(3);
            cci(k,m,n,ksps)=oci(5);
            cpap(k,m,n,ksps)=oci(7);
            [nte(k,m,n,ksps), me(k,m,n,ksps), ste(k,m,n,ksps), pval(k,m,n,ksps), h{k,m,n,ksps}, ~, ~, ~, ~]=nTE(Y,X,Z,400);
            [Ress, A(k,m,n,ksps)]=BasicRegression(X,Y);
            [NIP(k,m,n,ksps),NI(k,m,n,ksps)]=UInd_KCItest(X, Ress);
            fprintf('*')
            end
            fprintf('%d',n)
        end
        fprintf('inv')
    end
    fprintf('\n')
    %     end
    clear filtLFP_temp
end
clear lfp
cd ~/data/sm/4_16_05_merged/
datat=sprintf('compLFP%d-%d.%s.convergencytests.amp.mat',Channels,State);
save(datat,'nte','me','ste','pval','cci','cst','pci','pst','cpap','A','NIP','NI','tRes','sps','FreqBins','rod')%['8_9nitry', labels{ln}])% 724all bursts 

figure
for sstk=1:3
    subplot(1,3,sstk);
    plot(sps,sq(cci(sstk,1,:,:)));
    legend('burst','before')
    hold on;
    plot(sps,sq(cci(sstk,2,:,:)),'+-')
    plot(sps([1 nsps]),[.05 .05],'k--');
    axis tight
    xlabel('Sample size')
    ylabel('p-value')
    title([num2str(FreqBins(sstk,:)), 'Hz'])
end

figure
for sstk=1:3
    subplot(1,3,sstk);
    plot(sps,abs(sq(nte(sstk,1,:,:))));%-abs(sq(me(sstk,1,:,:)))
    legend('burst','before')
    hold on;
    plot(sps,abs(sq(nte(sstk,2,:,:))),'+-')%-abs(sq(me(sstk,2,:,:)))
%     plot(sps([1 nsps]),[.05 .05],'k--');
    axis tight
    xlabel('Sample size')
    ylabel('nTE-mean(nTE)')
    title([num2str(FreqBins(sstk,:)), 'Hz'])
end