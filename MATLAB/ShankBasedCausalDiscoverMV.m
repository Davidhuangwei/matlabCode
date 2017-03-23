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

nch=length(Channels);
lfp = LoadBinary([FileBase '.lfp'],Channels,Par.nChannels,2,[],[],StatePeriod)';% as loadinary don't take careof overlap of periods

FS = Par.lfpSampleRate;
wn = FreqBins/(FS/2);
[z, p, kk] = butter(4,wn,'bandpass');
[b, a]=zp2sos(z,p,kk);
filtLFP_temp = filtfilt(b, a, lfp);
filtLFP_temp=hilbert(filtLFP_temp);
cd /gpfs01/sirota/home/evgeny/project/gamma/data/4_16_05_merged
State='RUN';
[FeatData, FeatName] = LoadBurst(FileBase, Par,'csdsm5', State);
MyBursts = find(strcmp(FeatData{15},'CA1rad') & (FeatData{3}==54 | abs(FeatData{3}-37)<2 ) & FeatData{9}>40 & abs(FeatData{2}-40)<20);%
nBursts = length(MyBursts);%54
disp(['you have ', num2str(nBursts), ' bursts here'])
Res = floor(FeatData{14}(MyBursts)*1250);
Clu= FeatData{2}(MyBursts);
[nRes,tClu]=getRes(Res,Clu,StatePeriod);
tdiff=10;
a=bsxfun(@plus,nRes,[-tdiff,0,tdiff]);
nRes=a(:);
cd ~/data/sm/4_16_05_merged/
nlag=20;
nb=length(nRes);
pl=zeros(2,nch-1,nlag,2);
nlayer=length(lnames);
cnames={'pl','pci','cci','cpap'};
h=cell(2,nlayer,nlag,2);
pci=zeros(2,nlayer,nlag,2);
pst=zeros(2,nlayer,nlag,2);
cst=zeros(2,nlayer,nlag,2);
cci=zeros(2,nlayer,nlag,2);
cpap=zeros(2,nlayer,nlag,2);
par.width=.3;
t=1:nb;
ytick=1:size(FreqBins,1);
xlabels=(1:nlag)*5;
xticks=1:2:(nlag);
ylabels=FreqBins(:,2)-40;
showr=false;true;
tlfp=bsxfun(@plus,nRes,(-100):1);
% cause and effect are in the  same frequency range
% clr={'r','g','b','c','y','k'};
setch=floor(length(chindx{1})+length(chindx{2})+length(chindx{3})/2);
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
%     x=fangle(filtLFP_temp(:,ct));
%     templfp=x(tlfp);
%     vind=clocalmin1(templfp,102);
%     tRes=nRes-102+vind;
tRes=nRes;
    mtime=bsxfun(@plus,tRes,-100 :300)';
    nlfp=reshape(filtLFP_temp(mtime(:),:),401,nb,nch);
    x=fangle(filtLFP_temp(:,et));
    ttlfp=bsxfun(@plus,tRes,0:100);
    templfp=x(ttlfp);
    vind=clocalmin1(templfp,1);
    ttRes=tRes+vind-1;
    if kk==1
    save([FileBase, 'thin.Shank.', num2str(Shk),'.ch.', num2str(Channels(1)),'.mat'],'nlfp','tRes','ttRes','Clu','nRes', 'FreqBins')
    end
    figure(222)
    plot(tRes-ttRes)
    clear x nlfp mtime
    for k=3;%1:length(lnames)
        for n=5%1:nlag
            if k==1
            pl(kk,:,n,1)=fangle(filtLFP_temp(ttRes+5*n,eset))'*fangle(filtLFP_temp(tRes,cset))/nb;
            pl(kk,:,n,2)=fangle(filtLFP_temp(tRes+5*n,eset))'*fangle(filtLFP_temp(tRes,cset))/nb;
            end
           % KCI
           if kk==1
               chindx{k}=setdiff(chindx{k},1);
           end
           if kk==1
           cset_tmp=cset;
           eset_tmp=getindex(eset,chindx{k});
           if k==1
           oe=chindx{2};
           elseif k==length(chindx)
               oe=chindx{k-1};
           else
               oe=[chindx{k-1};chindx{k+1};];
           end
           else
               cset_tmp=getindex(cset,chindx{k});
           eset_tmp=eset;
           oe=[];
           end
%            conset=setdiff(eset,eset_temp);
           csq=mean(filtLFP_temp(tRes,cset_tmp),2);
           esq=mean(filtLFP_temp(ttRes+5*n,eset_tmp),2);
            oci=...
                KCIcausal_new(fangle(csq),fangle(esq),[fangle(mean(filtLFP_temp(ttRes,eset_tmp),2)),filtLFP_temp(ttRes,oe)],par,t,0);
%             figure;
%             subplot(211);
%             plot(real(fangle(esq*exp(1i*pi/3))),real(fangle(mean(filtLFP_temp(ttRes,eset_tmp),2))),'.')
%             subplot(212);
%             plot(imag(fangle(esq*exp(1i*pi/3))),imag(fangle(mean(filtLFP_temp(ttRes,eset_tmp),2))),'.')
            pci(kk,k,n,1)=oci(1);
            pst(kk,k,n,1)=oci(2);
            cst(kk,k,n,1)=oci(3);
            cci(kk,k,n,1)=oci(5);
            cpap(kk,k,n,1)=oci(7);   
            
            esq=mean(filtLFP_temp(tRes+5*n,eset_tmp),2);
            oci=...
                KCIcausal_new(fangle(csq),fangle(esq),[fangle(mean(filtLFP_temp(tRes,eset_tmp),2)),filtLFP_temp(tRes,oe)],par,t,0);
            pci(kk,k,n,2)=oci(1);
            pst(kk,k,n,2)=oci(2);
            cst(kk,k,n,2)=oci(3);
            cci(kk,k,n,2)=oci(5);
            cpap(kk,k,n,2)=oci(7);      
        end
    end
    if showr
        
        for m=1:2
            figure(225)
            subplot(2,4,1+(m-1)*4)
            imagesc(sq(abs(pl(:,m,:))))%,[0,.26]
            set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
            title(cnames{1})
            subplot(2,4,2+(m-1)*4)
            imagesc(sq(abs(nte(:,m,:)-me(:,m,:))-ste(:,m,:)))
            set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
            if m==1
                title('nTE')
            else
                title('inv nTE')
            end
            subplot(2,4,3+(m-1)*4)
            imagesc(sq(pci(:,m,:)),[0, .05])
            set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
            if m==1
                title('pair independent')
            else
                title('inv pair independent')
            end
            subplot(2,4,4+(m-1)*4)
            imagesc(sq(cci(:,m,:)),[0, .05])
            set(gca,'Xtick', xticks ,'Xticklabel',xlabels,'Ytick',ytick,'Yticklabel',ylabels)
            if m==1
                title('c independent')
            else
                title('inv c independent')
            end
        end
    end
    %     end
end
clear filtLFP_temp
cd ~/data/sm/4_16_05_merged/
save 8_4mv% 724all bursts
ytick=1:length(lnames);
xlabels=(1:nlag)*5;
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
    title('pair independent')
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