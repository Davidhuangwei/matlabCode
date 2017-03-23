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
for stk=1:3
State=States{stk};%'RUN';%'REM';'SWS'
cd(['/gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/', FileBase])
StatePeriod = load([FileBase '.sts.', State]);
nprd=size(StatePeriod,1);
Channels=[37,78];
lfp = LoadBinary([FileBase '.lfp'],Channels,Par.nChannels,2,[],[],StatePeriod)';% as loadinary don't take careof overlap of periods
FS = Par.lfpSampleRate;
cd /gpfs01/sirota/home/evgeny/project/gamma/data/4_16_05_merged
[FeatData, FeatName] = LoadBurst(FileBase, Par,'lfpinterp', State);
wholeB=find(strcmp(FeatData{15},'CA1rad') & ( abs(FeatData{3}-37)<2 )  & abs(FeatData{2}-40)<20 );
sB=prctile(FeatData{9}(wholeB),66);
MyBursts = find(strcmp(FeatData{15},'CA1rad') & ( abs(FeatData{3}-37)<2 )  & abs(FeatData{2}-40)<20 & FeatData{9}>46);%FeatData{3}==54 |
nBursts = length(MyBursts);%54
kkn=0;
while (nBursts<3000) && (min(FeatData{9}(MyBursts))>sB)
    kkn=kkn+1;
    MyBursts = find(strcmp(FeatData{15},'CA1rad') & ( abs(FeatData{3}-37)<2 )  & abs(FeatData{2}-40)<20 & FeatData{9}>(46-kkn));%FeatData{3}==54 |
nBursts = length(MyBursts);%54(10*kkn)
end
Res = floor(FeatData{14}(MyBursts)*1250);
Clu= FeatData{2}(MyBursts);
[nRes,tClu]=getRes(Res,Clu,StatePeriod);
nBursts = length(nRes);
fprintf(['you have ', num2str(nBursts), ' bursts here\n'])
cd ~/data/sm/4_16_05_merged/
nlag=3;
nktlag=floor(nBursts/250)-2;
cnames={'pl','pci','cci','cpap'};
nte=zeros(nfr,2,nlag,nktlag);
me=zeros(nfr,2,nlag,nktlag);
ste=zeros(nfr,2,nlag,nktlag);
pval=zeros(nfr,2,nlag,nktlag);
h=cell(nfr,2,nlag,nktlag);
pci=zeros(nfr,2,nlag,nktlag);
pst=zeros(nfr,2,nlag,nktlag);
cst=zeros(nfr,2,nlag,nktlag);
cci=zeros(nfr,2,nlag,nktlag);
cpap=zeros(nfr,2,nlag,nktlag);
NI=zeros(nfr,2,nlag,nktlag);
NIP=zeros(nfr,2,nlag,nktlag);
A=zeros(nfr,2,nlag,nktlag);
Noi_dist=cell(nfr,2,nlag,nktlag);
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
            for ktlag=1:nktlag
                btake=((ktlag-1)*250+1):((ktlag+2)*250);
            [oci, Noi_dist{k,m,n,ktlag}]=...
                KCIcausal_new(X(btake),Y(btake),Z(btake),par,0,0);%
            pci(k,m,n,ktlag)=oci(1);
            pst(k,m,n,ktlag)=oci(2);
            cst(k,m,n,ktlag)=oci(3);
            cci(k,m,n,ktlag)=oci(5);
            cpap(k,m,n,ktlag)=oci(7);
            [nte(k,m,n,ktlag), me(k,m,n,ktlag), ste(k,m,n,ktlag), pval(k,m,n,ktlag), h{k,m,n,ktlag}, ~, ~, ~, ~]=nTE(Y(btake),X(btake),Z(btake),400);
            [Ress, A(k,m,n,ktlag)]=BasicRegression(X(btake),Y(btake));
            [NIP(k,m,n,ktlag),NI(k,m,n,ktlag)]=UInd_KCItest(X(btake), Ress);
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
fprintf('done %s \n',State)
clear lfp
cd ~/data/sm/4_16_05_merged/
datat=sprintf('compLFP%d-%d.%s.basictests.amp.stationalrity.mat',Channels,State);
save(datat)%['8_9nitry', labels{ln}])% 724all bursts 
clear tRes
end
figure
for sstk=1:3
    datat=sprintf('compLFP%d-%d.%s.basictests.amp.stationalrity.mat',Channels,States{sstk});
    load(datat)
    subplot(1,3,sstk);
    plot(1:(3*nktlag),reshape(sq(cci(:,1,:,:)),3,3*nktlag));
    legend('12Hz','15Hz','20Hz')
    hold on;
    plot(1:(3*nktlag),reshape(sq(cci(:,2,:,:)),3,3*nktlag),'+-')
%     plot([1 3],[.05 .05],'k--');
    axis tight
    set(gca,'XTick',1:3,'XTicklabel',{'C(0)>E(0)','C(-1)>E(0)','C(-1)>E(-1)'})
    title(States{sstk})
end