% function ShankBasedCausalDiscover(FileBase, FreqBins)
clear all
close all
FileBase='4_16_05_merged';
a=40;
b=12;%3,5,
FreqBins=[a-b,a+b];
load('/gpfs01/sirota/data/bachdata/data/weiwei/m_sm/4_16_05_merged_par.mat');
repch=RepresentChan(Par);
load /gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/4_16_05_merged/ChanInfo/ChanLoc_Full.eeg.mat

cd(['/gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/', FileBase])
StatePeriod = load([FileBase '.sts.RUN']);
nprd=size(StatePeriod,1);
Shk=3;
effchannel=getindex(repch,Par.AnatGrps(Shk).Channels+1);
Channels=[78;effchannel];
[chindx,lnames]=LayerInShank(Channels,chanLoc);
onlyu=[];
israd=false(length(lnames),1);
for k=1:length(lnames)
    chindx{k}=chindx{k}(chindx{k}>1);
    if isempty(chindx{k})
        onlyu=k;
    end
    israd(k)=strcmp('rad',lnames{k});
end
chindx(onlyu)=[];
lnames(onlyu)=[];
israd(onlyu)=[];
israd=find(israd);

nch=length(Channels);
lfp = LoadBinary([FileBase '.lfp'],Channels,Par.nChannels,2,[],[],StatePeriod)';% as loadinary don't take careof overlap of periods

FS = Par.lfpSampleRate;
wn = FreqBins/(FS/2);
[z, p, kk] = butter(4,wn,'bandpass');
[b, a]=zp2sos(z,p,kk);
wn = [4 10]/(FS/2);
[z, p, kk] = butter(4,wn,'bandpass');
[be, ae]=zp2sos(z,p,kk);
filtLFP_temp = [filtfilt(be, ae, lfp(:,1)),filtfilt(b, a, lfp(:,2:end))];
filtLFP_temp=hilbert(filtLFP_temp);
cd /gpfs01/sirota/home/evgeny/project/gamma/data/4_16_05_merged
State='RUN';
[FeatData, FeatName] = LoadBurst(FileBase, Par,'csdsm5', State);
MyBursts = find((find(strcmp(FeatData{15},'CA1rad') & FeatData{3}<=max(effchannel) & FeatData{3}>=min(effchannel) & FeatData{9}>40 & abs(FeatData{2}-40)<20 )));%
nBursts = length(MyBursts);%54length
disp(['you have ', num2str(nBursts), ' bursts here'])
Res = floor(FeatData{14}(MyBursts)*1250);
Clu= FeatData{2}(MyBursts);
[nRes,tClu]=getRes(Res,Clu,StatePeriod);

tClu=tClu(nRes>200);
nRes=nRes(nRes>200);

% [~,id]=sort(rand(length(nRes),1));
% 
% a=bsxfun(@plus,nRes(id(1:200)),[-10, 0, 10]);
% Clu=tClu(id(1:200));
% nRes=a(:);

cd ~/data/sm/4_16_05_merged/
nlag=41;
nb=length(nRes);
disp(['we use ', num2str(nb), ' bursts here'])

pl=zeros(2,nch-1,nlag,2);
nlayer=length(lnames);
cnames={'pl','pci','cci','cpap'};
h=cell(2,nlayer,nlag,2);
pci=zeros(2,nlayer,nlag,2);
pst=zeros(2,nlayer,nlag,2);
cst=zeros(2,nlayer,nlag,2);
cci=zeros(2,nlayer,nlag,2);
cpap=zeros(2,nlayer,nlag,2);
plce=zeros(nch,nlag);
par.width=.3;
t=1:nb;

showr=false;%true;
tlfp=bsxfun(@plus,nRes,(-100):1);
% cause and effect are in the  same frequency range
% clr={'r','g','b','c','y','k'};
setch=floor(length(chindx{1})+length(chindx{2})+length(chindx{3})/2);
dsp=3;
for kk=1:2
    if kk==2
        % inverse
        cset=2:nch;
        eset=1;
        ct=setch+1;
        et=1;
    else
        cset=1;
        eset=2:nch;        
        ct=1;
        et=setch+1;
    end
    % get tRes and ttRes
%     x=filtLFP_temp(:,ct);
%     templfp=x(tlfp);
%     vind=clocalmin1(templfp,102);
    tRes=nRes;%-102+vind;
%     mtime=bsxfun(@plus,tRes,-197 :202)';
%     nlfp=reshape(filtLFP_temp(mtime(:),:),400,nb,nch);
%     x=filtLFP_temp(:,et);
%     ttlfp=bsxfun(@plus,tRes,0:100);
%     templfp=x(ttlfp);
%     vind=clocalmin1(templfp,1);
%     ttRes=tRes+vind-1;
%     if kk==1
%     save([FileBase, 'thin.try.Shank.', num2str(Shk),'.ch.', num2str(Channels(1)),'.mat'],'nlfp','tRes','Clu', 'FreqBins')
%     end
%     figure(222)
%     plot(tRes-ttRes)

    clear x nlfp mtime
    for k=1:length(lnames)
        for n=1:nlag
            if k==11
                disp('half done')
            else
            if k==1
%             pl(kk,:,n,1)=fangle(filtLFP_temp(ttRes+5*n,eset))'*fangle(filtLFP_temp(tRes,cset))/nb;
            pl(kk,:,n,2)=fangle(filtLFP_temp(tRes+dsp*(n-21),eset))'*fangle(filtLFP_temp(tRes,cset))/nb;
            if kk==1
            plce(:,n)=mean(fangle(filtLFP_temp(tRes,:).*conj(filtLFP_temp(tRes+dsp*(n-21),:))),1);
            end
             end
           % KCI
           if kk==1
               chindx{k}=setdiff(chindx{k},1);
           end
           if kk==1
           cset_tmp=cset;
           eset_tmp=getindex(eset,chindx{k});
           else
               cset_tmp=getindex(cset,chindx{k});
           eset_tmp=eset;
           end
%            conset=setdiff(eset,eset_temp);
           csq=mean(filtLFP_temp(tRes+dsp*(n-21),cset_tmp),2);
%            esq=mean(filtLFP_temp(ttRes+5*n,eset_tmp),2);
%             oci=...
%                 KCIcausal_new(fangle(csq),fangle(esq),fangle(mean(filtLFP_temp(ttRes,eset_tmp),2)),par,t,0);
% %             figure;
% %             subplot(211);
% %             plot(real(fangle(esq*exp(1i*pi/3))),real(fangle(mean(filtLFP_temp(ttRes,eset_tmp),2))),'.')
% %             subplot(212);
% %             plot(imag(fangle(esq*exp(1i*pi/3))),imag(fangle(mean(filtLFP_temp(ttRes,eset_tmp),2))),'.')
%             pci(kk,k,n,1)=oci(1);
%             pst(kk,k,n,1)=oci(2);
%             cst(kk,k,n,1)=oci(3);
%             cci(kk,k,n,1)=oci(5);
%             cpap(kk,k,n,1)=oci(7);   
            
            esq=mean(filtLFP_temp(tRes,eset_tmp),2);
            oci=...
                KCIcausal_new(fangle(csq),fangle(esq),[fangle(mean(filtLFP_temp(tRes+dsp*(n-21)-1,cset_tmp),2)),fangle(mean(filtLFP_temp(tRes+dsp*(n-21)+1,cset_tmp),2)),fangle(mean(filtLFP_temp(tRes,eset_tmp),2))],par,t,0);
            pci(kk,k,n,2)=oci(1);
            pst(kk,k,n,2)=oci(2);
            cst(kk,k,n,2)=oci(3);
            cci(kk,k,n,2)=oci(5);
            cpap(kk,k,n,2)=oci(7);      
            end
        end
    end
   
    %     end
end
clear filtLFP_temp
cd ~/data/sm/4_16_05_merged/
save(['8_4stry', num2str(Shk)])% 724all bursts
ytick=1:length(lnames);
xlabels=(1:nlag)*dsp;
xticks=1:2:(nlag);
ylabels=lnames;
for nm=1:2
    figure(225)
    subplot(2,6,1+(nm-1)*6)
    imagesc(sq(abs(pl(1,:,:,nm))))%,[0,.26]
    set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',1:(nch-1),'Yticklabel',effchannel)
    title('pl')
    subplot(2,6,2+(nm-1)*6)
    imagesc(sq(pci(1,:,:,nm)),[0, .05])
    set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
    title('pair independent of thetaG')
    subplot(2,6,3+(nm-1)*6)
    imagesc(sq(cci(1,:,:,nm)),[0, .05])
    set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
    title('c independent')
    
    subplot(2,6,4+(nm-1)*6)
    imagesc(sq(abs(pl(2,:,:,nm))))%,[0,.26]
    set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',1:(nch-1),'Yticklabel',effchannel)
    title('inv pl')
    subplot(2,6,5+(nm-1)*6)
    imagesc(sq(pci(2,:,:,nm)),[0, .05])
    set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
    title('inv pair independent')
    subplot(2,6,6+(nm-1)*6)
    imagesc(sq(cci(2,:,:,nm)),[0, .05])
    set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
    title('inv c independent')
    
    
end