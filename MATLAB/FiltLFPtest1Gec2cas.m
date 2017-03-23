% clear all
% close all
% first of all, I will try mEC3 to all HP layers during MEC bursts
sjn='/gpfs01/sirota/home/gerrit/data/';
FileBase='g09-20120330';
FreqBins=[60 120];%[30 120];
BurstShanks=[41:48,63];% channels, burst cluseter
HP=[41:48,63]';
nhp=length(HP);
EC=6;
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

pl=zeros(nhp,nlag,2);
nte=zeros(nhp,nlag,2);
me=zeros(nhp,nlag,2);
ste=zeros(nhp,nlag,2);
pval=zeros(nhp,nlag,2);
pci=zeros(nhp,nlag,4);
pst=zeros(nhp,nlag,4);
cst=zeros(nhp,nlag,4);
cci=zeros(nhp,nlag,4);
cpap=zeros(nhp,nlag,4);
par.width=.3;
Btitle={'EC to HP','HP to EC'};
t=([1:nlag]-nlag+1)*stp;
x=t;
y=1:nhp;
for k=1:nhp
    
    nRes=AllBursts.BurstTime(AllBursts.BurstChan<=8 & AllBursts.BurstChan>=5 ...
        & AllBursts.BurstFreq>55 & AllBursts.BurstFreq<130);
    nb=length(nRes);
    fprintf('\n you have %d bursts',nb);
    if k==1
    rRes=randi(cl,nb,1);
    tRes=nRes-rRes;%repmat(nRes,2,1)-randi(cl,2*length(nRes),1);
    end
    filtLFP_temp = lfp(:,[k,1+nhp]);% hp, ec
    for m=1:2
        if m==2
            filtLFP_temp=filtLFP_temp(:,[2,1]);
        end
        for n=1:nlag
%             pl(k,n,m)=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),2))'*fangle(filtLFP_temp(tRes,1))/nb;
            %             if n<nlag(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))
            X=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),2));
            Y=fangle(filtLFP_temp(tRes,1));
            Z=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),1));
            
            
%             [oci, ~]=...
%                 KCIcausal_new(X,Y,Z,par,0,0);%
%             pci(k,n,m)=oci(1);
%             pst(k,n,m)=oci(2);
%             cst(k,n,m)=oci(3);
%             cci(k,n,m)=oci(5);
%             cpap(k,n,m)=oci(7);
            % condition on time
            [oci, ~]=...
                KCIcausal_new(real(X),real(Y),[real(Z),-rRes],par,0,0);%[Z,-rRes]
            pci(k,n,m+2)=oci(1);
            pst(k,n,m+2)=oci(2);
            cst(k,n,m+2)=oci(3);
            cci(k,n,m+2)=oci(5);
            cpap(k,n,m+2)=oci(7);
            % TE
%             [nte(k,n,m), me(k,n,m), ste(k,n,m), pval(k,n,m),~, ~, ~, ~, ~]=nTE(Y,X,Z,400);
            fprintf('*')
        end
        fprintf('inv')
        figure(226)
        subplot(2,2,m)
        imagesc(x,y,sq(cci(:,:,m)),[0, .05])
        set(gca,'Ytick',y,'Yticklabel',HP)
        title(['HP channel: ', Btitle{m}])
        subplot(2,2,m+2)
        imagesc(x,y,sq(cci(:,:,m+2)),[0, .05])
        set(gca,'Ytick',y,'Yticklabel',HP)
        title(['HP channel | time: ', Btitle{m}])
        drawnow
    end
    clear filtLFP_temp
end


cd ~/data/g09_20120330/
datat=sprintf('compLFP%d-%dHz.ec-hp_allshank.phase.mat',FreqBins);

save(datat,'pci','pst','cst','cci','cpap','nte','me','ste','pval','nRes','FreqBins','BurstShanks','AllBursts','Btitle','t','myfilename')%['8_9nitry', labels{ln}])% 724all bursts

% for h=1:2
%     figure(225+h)
%     for m=1:2
%         for z=1:nhp
%             subplot(2,nhp,(m-1)*nhp+z)
%             imagesc(x,y,sq(cci(:,z,m,:,h)),[0, .05])
%             set(gca,'Ytick',y,'Yticklabel',EC(:,1))
%             title(['HP channel', num2str(HP(z,1))])
%         end
%     end
%     drawnow
% end
