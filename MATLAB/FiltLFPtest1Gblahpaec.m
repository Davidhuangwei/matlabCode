% clear all
% close all
sjn='/gpfs01/sirota/home/gerrit/data/';
FileBase='g09-20120330';
FreqBins=[60 120];%[30 120];
BurstShanks=[52  53; 43 44; 35 36; 5 8;25 27];% channels, burst cluseter
HP=[52 1;53 1; 43 2; 44 2; 35 3; 36 3];
nhp=size(HP,1);
EC=[[5:8,25:27]',[4*ones(4,1);5*ones(3,1)]];
nec=size(EC,1);

cd ~/data/g09_20120330/
load('g09_20120330.RUN3.Burst4Info.[14-250].all.mat')
FS = Par.lfpSampleRate;

cd([sjn, FileBase])
lfp= LoadBinary([FileBase '.lfp'],[HP(:,1);EC(:,1)],Par.nChannels,2,[],[],Period)';

cd ~/data/g09_20120330/
wn = FreqBins/(FS/2);
[z, p, kk] = butter(4,wn,'bandpass');
[b, a]=zp2sos(z,p,kk);
lfp = filtfilt(b, a, lfp);
lfp=hilbert(lfp);

nlag=20;
cl=ceil(FS/60);
stp=2;

pl=zeros(nec,nhp,2,nlag,2);
nte=zeros(nec,nhp,2,nlag,2);
me=zeros(nec,nhp,2,nlag,2);
ste=zeros(nec,nhp,2,nlag,2);
pval=zeros(nec,nhp,2,nlag,2);
pci=zeros(nec,nhp,2,nlag,2);
pst=zeros(nec,nhp,2,nlag,2);
cst=zeros(nec,nhp,2,nlag,2);
cci=zeros(nec,nhp,2,nlag,2);
cpap=zeros(nec,nhp,2,nlag,2);
par.width=.3;
Btitle={'HP','EC'};
t=([1:nlag]-nlag+1)*stp;
x=t;
y=1:nec;
for k=1:nec
    for z=1:nhp
        for h=1:2
            if h==1
                nsh=HP(z,2);
            else
                nsh=EC(k,2);
            end
            nRes=AllBursts.BurstTime(AllBursts.BurstChan<=BurstShanks(nsh,2)&AllBursts.BurstChan>=BurstShanks(nsh,1)...
                & AllBursts.BurstFreq>55 & AllBursts.BurstFreq<130);
            nb=length(nRes);
            fprintf('\n you have %d %s bursts in hp %d ec %d:',nb,Btitle{h},z,k);
            tRes=nRes-randi(cl,nb,1);%repmat(nRes,2,1)-randi(cl,2*length(nRes),1);
            filtLFP_temp = lfp(:,[z,k+nhp]);
            for m=1:2
                if m==2
                    filtLFP_temp=filtLFP_temp(:,[2,1]);
                end
                for n=1:nlag
                    pl(k,z,m,n,h)=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),2))'*fangle(filtLFP_temp(tRes,1))/nb;
                    %             if n<nlag(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))
                    X=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),2));
                    Y=fangle(filtLFP_temp(tRes,1));
                    Z=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),1));
                    
                    
                    [oci, ~]=...
                        KCIcausal_new(X,Y,Z,par,0,0);%
                    pci(k,z,m,n,h)=oci(1);
                    pst(k,z,m,n,h)=oci(2);
                    cst(k,z,m,n,h)=oci(3);
                    cci(k,z,m,n,h)=oci(5);
                    cpap(k,z,m,n,h)=oci(7);
                    [nte(k,z,m,n,h), me(k,z,m,n,h), ste(k,z,m,n,h), pval(k,z,m,n,h),~, ~, ~, ~, ~]=nTE(Y,X,Z,400);
                    fprintf('*')
                end
                fprintf('inv')
        figure(225+h)
    subplot(2,nhp,(m-1)*nhp+z)    
    imagesc(x,y,sq(cci(:,z,m,:,h)),[0, .05])
    set(gca,'Ytick',y,'Yticklabel',EC(:,1))
    title(['HP channel', num2str(HP(z,1))])
    drawnow
            end
        end
        clear filtLFP_temp
    end
end

cd ~/data/g09_20120330/
datat=sprintf('compLFP%d-%dHz.ec-hp.phase.mat',FreqBins,aa);

save(datat,'pci','pst','cst','cci','cpap','nte','me','ste','pval','nRes','Clu','FreqBins','BurstShanks','AllBursts','Btitle','t')%['8_9nitry', labels{ln}])% 724all bursts 

for h=1:2
    figure(225+h)
for m=1:2
    for z=1:nhp
    subplot(2,nhp,(m-1)*nhp+z)    
    imagesc(x,y,sq(cci(:,z,m,:,h)),[0, .05])
    set(gca,'Ytick',y,'Yticklabel',EC(:,1))
    title(['HP channel', num2str(HP(z,1))])
    end
end
drawnow
end
