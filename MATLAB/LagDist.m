addpath(genpath('/gpfs01/sirota/homes/weiwei/matlab/'))

load('/gpfs01/sirota/data/bachdata/data/weiwei/m_sm/4_16_05_merged_par.mat');
repch=RepresentChan(Par);
load /gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big/4_16_05_merged/ChanInfo/ChanLoc_Full.eeg.mat
% chanLoc
addpath /gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big%addpath
addpath(genpath('/gpfs01/sirota/homes/antsiro/matlab/draft/'))
addpath(genpath('/gpfs01/sirota/homes/share/matlab/Person-Specific_Matlab_Functions/ER'))


cd /gpfs01/sirota/home/evgeny/project/gamma/data/4_16_05_merged 
FileBase='4_16_05_merged';
State='RUN';
[FeatData, FeatName] = LoadBurst(FileBase, Par,'csdsm5', State);
Shk=3;
%%
isfcause=true;
MyBursts = find(strcmp(FeatData{15},'CA1rad')' & FeatData{7}==Shk & FeatData{9}>40);%
% if isfcause & abs(FeatData{2}-f0)<10 

nBursts = length(MyBursts);
disp(['you have ', num2str(nBursts), ' bursts here'])
Res = floor(FeatData{14}(MyBursts)*1250);
Clu= FeatData{2}(MyBursts);

cd /gpfs01/sirota/data/bachdata/data/weiwei/m_sm/
if exist([FileBase, '_SP_', State, '.mat'])
    load([FileBase, '_SP_', State, '.mat'], 'SP','FreqB')
else
    disp(['you do not have SP for ', State])
end
nprd=length(SP);
% clear SP
% %             in the new long frequency vision, I can use out.Periods which
% %             record the periods.
mLFP=[]; 
frc= unique(FeatData{2}(MyBursts));
frb=5*floor(frc([1 end])/5);
frbind=find((FreqB(:,1)>=frb(1))&(FreqB(:,1)<=frb(2)));
h = waitbar(0,'Spikes');
repch=RepresentChan(Par);
ChiShk=Par.AnatGrps(Shk).Channels+1;
ChiD=getindex(repch,ChiShk);
nCh=length(ChiD);
for sjn=1:nprd
    load([FileBase, '_LFPsig_', State, num2str(sjn)])
    if sjn==1
        Freq=out.FreqBins;
        nfr=size(Freq,1);
        nvar=size(out.LFPsig,2);
        nch=nvar/nfr;       
    end
    nt=size(out.LFPsig,1);
    out.LFPsig=reshape(double(out.LFPsig),nt,nch,nfr);
    %% get spike time
    SP=out.Periods;
    tClu=[];
    tRes=[];
    addb=0;
    for k=1:size(SP,1)
        temp=find((Res<SP(k,2))&(Res>SP(k,1)));
        tClu=[tClu;Clu(temp)];
        tRes=[tRes;Res(temp)-SP(k,1)+1+addb];
        addb=addb+SP(k,2)-SP(k,1)+1;
    end
    if isfcause
        ttake=tRes>80;
    else
        ttake=tRes<(size(out.LFPsig,1)-40);
    end
    clfp=zeros(length(ttake),nCh,nfr,40);
    for k=1:40
        clfp(:,:,:,k)=out.LFPsig(tRes(ttake)+2*k-81,ChiD,:);%nt*nfr*nlag
    end
    mLFP=[mLFP;clfp];
    waitbar(sjn/length(SP))
end
[spk, spklist]=spkcount(Clu);
% check basic phaselocking
% interesting band: 11:15, 18:21-> lock to the low frequency and high
% frequnecy bursts. 
bch=unique(FeatData{3}(MyBursts));
xl=mean(out.FreqBins,2);
for spki=1:9%3%1:length(spk)
    figure(224)
    pdata=sq(sum(fangle(mLFP(spklist==spki,:,:,:)),1)/spk(spki,2));
    for k=1:40
        subplot(4,10,k)
        imagesc(xl, ChiShk, sq(angle(pdata(:,:,k))),[0,.34]);
        hold on
        plot(xl([1 end]),[36 38;36 38],'k')
        title(['lag', num2str(k),', spk ', num2str(spk(spki,1))])        
    end
    pause
end
spk=round(spk);
for spki=1:length(spk)%32%1:3 
    figure(224)
    pdata=sq(sum(fangle(mLFP(spklist==spki,:,:,:)),1)/spk(spki,2));
    k=3;
        subplot(5,7,spki)
        imagesc(xl, ChiShk, sq(abs(pdata(:,:,k))),[0,.34]);
        hold on
        plot(xl([1 end]),[36 38;36 38],'k')
        title(['lag', num2str(k),', frq ', num2str(spk(spki,1)), ', spkn ', num2str(spk(spki,2))])        
end
% then, combin the same layer. and, i only care about those lower than 120
% Hz bursts/ signals. 
[loc, lnames]=getLoc(chanLoc,ChiShk);
loc(loc==0)=9;
frbins=[1,2;3,5;7,8;9,14;15,20;21,25];
nfr=size(frbins,1);
nlyr=9;
mb=abs(Clu-45)<15;
nb=sum(mb);
nlag=40;
nLFP=zeros(nb,nlyr,nfr,nlag);
% now, only low gamma
for k=1:nlyr
    for n=1:nfr
    nLFP(:,k,n,:)=sq(sum(sq(sum(mLFP(mb,loc==k,frbins(n,1):frbins(n,2),:),2)),2));
    end
end
    figure(224)
    pdata=sq(sum(fangle(nLFP),1)/nb);
    
for k=1:40;
        subplot(5,8,k)
        imagesc(1:nfr, 1:nlyr, sq(abs(pdata(:,:,k))),[0,.2]);
        hold on
%         plot(xl([1 end]),[36 38;36 38],'k')
        title(['lag', num2str(k)])        
end
% nTE at low gamma
mgamma=(spklist);
nte=zeros(nlyr,nfr,nlag-1);
me=zeros(nlyr,nfr,nlag-1);
ste=zeros(nlyr,nfr,nlag-1);
pval=zeros(nlyr,nfr,nlag-1);
h=cell(nlyr,nfr,nlag-1);
for k=1:nlyr
    for n=1:nfr
        for m=1:39
            [nte(k,n,m), me(k,n,m), ste(k,n,m), pval(k,n,m), h{k,n,m}, XBins, YBins, ZBins, ~]=...
                nTE(fangle(nLFP(:,3,n,40)),fangle(nLFP(:,k,n,m)),fangle(nLFP(:,3,n,m)),400);
        end
    end
end
for k=1:39
    figure(225)
    subplot(4,10,k)
    imagesc(1:nfr,1:nlyr,abs(.5-sq(pval(:,:,k))),[.45 .5])
end
% check the activity of nte
figure
sjn=abs(nte-me)-ste;
for k=1:9
    subplot(3,3,k)
    plot(1:39,sq(sjn(k,:,:)))
    xlabel(lnames{k})
end
legend('ltheta','htheta','beta','lgamma','hgamma','hfr')
% to check distribution
figure(2)
k=2;
n=4;
m=37;
plot3(angle(nLFP(:,3,n,40)),angle(nLFP(:,k,n,m)),angle(nLFP(:,3,n,m)),'.')
xlabel('effect')
ylabel('cause')
zlabel('condition')


t=1:nb;
pci=zeros(nlyr,nfr,nlag-1);



pst=zeros(nlyr,nfr,nlag-1);
cst=zeros(nlyr,nfr,nlag-1);
cci=zeros(nlyr,nfr,nlag-1);
cpap=zeros(nlyr,nfr,nlag-1);
par.width=.4;
% something delete before.... think of recode them.
for k=36:(nlag-1)%33
    for n=1:nlyr%2%5
        for m=1:nfr
            if (n~=3)&&(m~=4)
            oci=...
                KCIcausal_new(fangle(nLFP(:,3,m,40)),fangle(nLFP(:,n,m,k)),fangle(nLFP(:,3,m,k)),par,t,0);
            pci(n,m,k)=oci(1);
            pst(n,m,k)=oci(2);
            cst(n,m,k)=oci(3);
            cci(n,m,k)=oci(5);
            cpap(n,m,k)=oci(7);
            end
        end
    end
end
torad.pci=pci;
torad.pst=pst;
torad.cst=cst;
torad.cci=cci;
torad.cpap=cpap;
sjn=cci-pci;
bad=sum(sjn(:)<0 & pci(:)<.05)
for k=1:(nlag-1)
    figure(223)
    subplot(4,10,k)
    imagesc(1:nfr,1:nlyr,1-sq(pci(:,:,k)),[0.95 1]);
end
% inverse
for k=1:(nlag-1)%33
    for n=1:nlyr%2%5
        for m=1:nfr
            if (n~=3)&&(m~=4)
            oci=...
                KCIcausal_new(fangle(nLFP(:,n,m,40)),fangle(nLFP(:,3,m,k)),fangle(nLFP(:,n,m,k)),par,t,0);
            pci(n,m,k)=oci(1);
            pst(n,m,k)=oci(2);
            cst(n,m,k)=oci(3);
            cci(n,m,k)=oci(5);
            cpap(n,m,k)=oci(7);
            end
        end
    end
end
fmrad.pci=pci;
fmrad.pst=pst;
fmrad.cst=cst;
fmrad.cci=cci;
fmrad.cpap=cpap;
    

%% KCI tests
cd /gpfs01/sirota/data/bachdata/data/antsiro/blab/sm96_big
cd ~/data/sm/4_16_05_merged/
load 7_5.mat

fnames=dir('4_16_05_merged.phase.ch51*');
load(fnames.name)

for k=1:39
    figure(223)
    subplot(4,10,k)
    imagesc(sq(pci(:,:,k)),[0 .05])
end
for k=1:39
    figure(224)
    subplot(4,10,k)
    imagesc(sq(cci(:,:,k)),[0 .05])
end

t=1:size(mLFP,1);
cm=4;
pci=zeros(8,8,39);
pst=zeros(8,8,39);
cst=zeros(8,8,39);
cci=zeros(8,8,39);
cpap=zeros(8,8,39);
% something delete before.... think of recode them.
for k=1:15
    for n=1:8
        for m=1:8
            if (n~=3)&&(m~=4)
            oci=...
                KCIcausal_new(fangle(mLFP(:,shn,cm,40)),fangle(mLFP(:,n,m,k)),fangle(mLFP(:,shn,cm,k)),par,t,0);
            pci(n,m,k)=oci(1);
            pst(n,m,k)=oci(2);
            cst(n,m,k)=oci(3);
            cci(n,m,k)=oci(5);
            cpap(n,m,k)=oci(7);
            end
        end
    end
end