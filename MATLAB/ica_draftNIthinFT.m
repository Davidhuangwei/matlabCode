% ica_draftNI
clear all
FileBase='ni04-20110503';
% storageF='/Volumes/YY/';
cd ~/data/ni04-20110503/
% % load ni04-20110503.SWS.workspace.mat
% % cd([storageF, FileBase])
load('tempGA.mat');
tempga=gA;
Period=load([FileBase, '.sts.REM']);
FS = 1250;
% load('/home/weiwei/data/4_16_05_merged/ChanInfo/ChanLoc_Full.eeg.mat')
cd(['/storage/weiwei/data/ni11/', FileBase])
% cd /storage/noriaki/data/processed/ni04-20110503/
HP=1:24;%Par.;
ylbs=HP;
names=HP;
% cd([storageF, FileBase])
%%
load chanLoc.mat
Layers=fieldnames(chanLoc);
layer_show=zeros(18,1);
for n=1:length(Layers)
    
    layer_show(double(chanLoc.(Layers{n})))=n;
end
ylbs=[find(diff(layer_show(HP),1));HP(end)];
names=cell(length(ylbs),1);
for k=1:length(ylbs)
names{k}=Layers{layer_show(ylbs(k))};
end
%%
% Period=Period(1:5,:);
% storage/evgeny/data/project/gammahome/weiwei/
nhp=length(HP);
cd(['/storage/evgeny/data/project/gamma/data/', FileBase])
% cd([storageF, FileBase])
%
LFP= LoadBinary([FileBase '.lfpinterp'],HP,64,2,[],[],Period)';%
r=.5;
theta=[.8 1];
lambda=.01;
LFP=mkCSD(LFP,r,HP,HP,lambda,theta);% compute CSD here.
oPeriod=Period;
Period=ReshapePeriod(Period);
nPeriod=Period;
luP=size(Period,1);
%
isw=0;
if isw
for k=1:luP
[tLFP, ARmodel] = WhitenSignal([mean(LFP(Period(k,1):Period(k,2),:),2),LFP(Period(k,1):Period(k,2),:)], [],[],[], 2);
LFP(Period(k,1):Period(k,2),:)=centersig(tLFP(:,2:end));
end
clear tLFP
end
% % Period=[1 (1250*6);(nPeriod(end)-(1250*6)) nPeriod(end)]
% % luP=size(Period,1);
% prd=1*12500;
% Period=[nPeriod(1,1):prd:(nPeriod(end,2)-prd);(nPeriod(1,1)+prd):prd:nPeriod(end,2)]';
% luP=size(Period,1);
% 
% uPeriod=[Period(:,2)-Period(:,1)]>1250*2;
% luP=20;%sum(uPeriod);
% 
% %
%%
FreqB=[30 90];%[40 100];%[5 20][60 120]
jdfr=35:10:90;%45:10:100;%[35:10:130];% [45 65 85];[7:5:20][65:10:120]
[LFP,b,a]=ButFilter(LFP,4,FreqB/625,'bandpass');
% LFP=diff(LFP,1,1);
%% Have a example of time-frequency method... use multitiper
usespec=1;
% jdfr=(FreqB(1)+5):20:FreqB(2);
if usespec 
% using frequency method
B=cell(luP,1);
sA=cell(luP,1);
c=cell(luP,1);
% chn=HP;%(1:2:end)HP;%[5:2:60];
%%
% jdfr=[35:10:90, 115:10:150];
for k=1:luP
%     nfcomp(k)=size(A{k},2);
%     [lambda,~,~,~,tlfp]=factoran(LFP(Period(k,1):Period(k,2),chn),nfcomp(k));
[B{k}, cc]=SSpecJAJD(LFP(Period(k,1):Period(k,2),:),1250,400,400,jdfr,100,.99,0);
c{k}=zeros(size(cc,1),length(jdfr),size(cc,4));
for n=1:size(cc,1)
    c{k}(n,:,:)=cc(n,n,:,:);
end
sA{k}=pinv(B{k});% lambda/B{k}
fprintf('%d-',k)
end 
% for k=1:luP
%     sA{k}=pinv(B{k});
% end
[~,lp]=max(Period(:,2)-Period(:,1));
% [lambda,~,~,~,tlfp]=factoran(LFP(:,chn),size(gA,2));(Period(2,1):Period(6,2),:)
[gB, gc]=SSpecJAJD(LFP(Period(1,1):Period(luP,2),:),1250,400,400,jdfr,100,.99,0);
gsA=pinv(gB);%lambda/gB
gcc=zeros(size(gc,1),length(jdfr),size(gc,4));
for n=1:size(gc,1)
    gcc(n,:,:)=gc(n,n,:,:);
end
%%
[nm,lost,dists]=ClusterCompO(gsA,sA,.1);
lnm=length(nm);
nx=zscore(HP(:));
nxx=[nx(1):0.01:nx(end)]';
pod=0:8;
% nx=bsxfun(@power,nx,pod);%
% nxx=bsxfun(@power,nxx,pod);%
ny=zeros(size(nxx,1),lnm);
   nHP=HP(1):((HP(end)-HP(1))/(size(nxx,1)-1)):HP(end);
for k=1:lnm
    fd=sum(nm{k}.^2,1)>10^-8;
    nmD=sum(fd);
    if nmD>0
       dt=bsxfun(@times,bsxfun(@rdivide,nm{k}(:,fd),sqrt(sum(nm{k}(:,fd).^2,1))),sign(gsA(:,k)'*nm{k}(:,fd)));
       ny(:,k)=GaussionProcessRegression(repmat(nx,nmD,1),dt(:),.8,.00001,nxx(:));

% [ny(:,k),~]=BasicRegression(repmat(nx,nmD,1),dt(:),nxx);
       figure(24)
       subplot(2,lnm,k)
       plot(dt,HP)
       set(gca,'YTick',ylbs,'YTicklabel',names)
   hold on
   plot(ny(:,k),nHP,'Linewidth',3)
%    dnm=lfp2CSD(ny(:,k),[.1 .001]);
%    plot(dnm/100,nHP,'g+-','Linewidth',2)% /sqrt(sum(ny(:,k).^2))/100
   grid on
   axis([-.5 .5 HP(1) HP(end)]) 
   title(['comp.',num2str(k)])
%    title(['var', num2str(var(anm(:,k)))])
   xlabel(num2str(sum(fd)))
%    axis ij
   hold off
   n=n+1;
   end
end
gbsnm=ny(fix(1:((length(nxx)-1)/(length(HP)-1)):length(nxx)),:);
ForAllSubplots('axis xy')
ForAllSubplots('axis ij')
%%
[snm, mD, id]=ClusterComp(gsA,cell2mat(sA'),.1,0);
% figure(5)
% test
LSA=[gsA,cell2mat(sA')];
LSW=[gB;cell2mat(B)]';
KLSW=LSW(:,~id);
bl=1:size(LSA,2);
KLSA=LSA(:,~id);
bl=bl(~id);
lnm=size(snm,2);
nx=zscore(HP(:));
nxx=[nx(1):0.01:nx(end)]';
pod=0:8;
% nx=bsxfun(@power,nx,pod);%
% nxx=bsxfun(@power,nxx,pod);%
ny=zeros(size(nxx,1),lnm);
nyw=zeros(size(nxx,1),lnm);
   nHP=HP(1):((HP(end)-HP(1))/(size(nxx,1)-1)):HP(end);
   blonging=cell(lnm,1);
   n=1;
for k=1:lnm
    nmD=sum(mD==k);
    
    if nmD>0
        blongi=bl(mD==k);
        blonging{k}=blongi(blongi>size(gsA,2));
       dt=bsxfun(@times,bsxfun(@rdivide,KLSA(:,mD==k),sqrt(sum(KLSA(:,mD==k).^2,1))),sign(snm(:,k)'*KLSA(:,mD==k)));
       ny(:,k)=GaussionProcessRegression(repmat(nx,nmD,1),dt(:),.8,.001,nxx(:));
       dtw=bsxfun(@times,bsxfun(@rdivide,KLSW(:,mD==k),sqrt(sum(KLSW(:,mD==k).^2,1))),sign(snm(:,k)'*KLSA(:,mD==k)));
       nyw(:,k)=GaussionProcessRegression(repmat(nx,nmD,1),dtw(:),.8,.00001,nxx(:));
% [ny(:,k),~]=BasicRegression(repmat(nx,nmD,1),dt(:),nxx);
       figure(23)
       subplot(2,lnm,k)
       plot(dt,HP)
   hold on
   plot(ny(:,k),nHP,'Linewidth',3)
%    dnm=lfp2CSD(ny(:,k),[.1 .001]);
%    plot(dnm/100,nHP,'g+-','Linewidth',2)% /sqrt(sum(ny(:,k).^2))/100
   grid on
   axis([-.5 .5 HP(1) HP(end)]) 
%    title(['var', num2str(var(nm(:,k)))])
   xlabel(num2str(sum(mD==k)))
%    axis ij
   hold off
   n=n+1;
   set(gca,'YTick',ylbs,'YTicklabel',names)
   end
end
gsnm=ny(fix(1:((length(nxx)-1)/(length(HP)-1)):length(nxx)),:);
gsnmw=nyw(fix(1:((length(nxx)-1)/(length(HP)-1)):length(nxx)),:);
ForAllSubplots('axis xy')
ForAllSubplots('axis ij')
%%
% gnm=gsnm;
% 
% llnm=size(gnm,2);
%     gnm=bsxfun(@rdivide,gnm,sum(gnm.^2));
% 
%     icasig=LFP*bsxfun(@rdivide,gsnmw,sum(gsnmw.^2));
% [bincounts,ind]=histc(theta,(-pi):.01:pi);
% nbin=length(bincounts);
% [nHP, lnm]=size(gnm);
% aveICAsig=zeros(lnm,nbin);
% for k=1:nbin
%     if bincounts(k)>0
% aveICAsig(:,k)=sum(icasig(ind==(k-1),:),1)/bincounts(k);
%     end
% end
% %
% for k=1:lnm
%     figure(25)
%     subplot(2,lnm,k+lnm)
%     ny=GaussionProcessRegression(nx,gnm(:,k),.5,.001,nxx(:));
%     ncsd=-diff(ny,2,1)*aveICAsig(k,:);
%     cscale=max(max(abs(ncsd)));
%     imagesc((-pi):.01:pi,1:nHP,ncsd,[-cscale,cscale])% (ny(:,k))lfp2CSD,[.01]
% %     hold on
% %     plot((-pi):.01:pi,(2+sin((-pi):.01:pi)),'k','Linewidth',2)
%     title(['comp', num2str(k)])
% %     set(gca,'YTick',linspace(nHP(1),nHP(end),length(HP)),'YTicklabel',HP)
%     grid on
%     hold off
%     title(num2str(FreqB))
% end
% %

end
% CheckCSD(LFP,gsnm,gsnmw,HP,st(1:(end-10)))
% CheckCSD(LFP,gbsnm,pinv(gbsnm)',HP,st(1:(end-10)))

%% check in the running period
cd(['/storage/noriaki/data/processed/', FileBase])

% cd([storageF, FileBase])
Period=load([FileBase, '.sts.RUN']);%6729+[1,1.5*10^6];
FS = 1250;
% load('/home/weiwei/data/4_16_05_merged/ChanInfo/ChanLoc_Full.eeg.mat')
load chanLoc.mat
cd(['/storage/evgeny/data/project/gamma/data/', FileBase])

% cd([storageF, FileBase])
LFP= LoadBinary([FileBase '.lfpinterp'],HP,64,2,[],[],Period)';
oPeriod=Period;
Period=ReshapePeriod(Period);
uPeriod=[Period(:,2)-Period(:,1)]>1250*2;
luP=sum(uPeriod);
if size(uPeriod,2)<2
    uPeriod=Period(uPeriod,:);
    [~,od]=sort(uPeriod(:,2)-uPeriod(:,1));
    uPeriod=uPeriod(od,:);
end
%
% cd /home/weiwei/data/ni04-20110503/
% if FileExists([FileBase, '.Theta.RUN.mat'])
%     load([FileBase, '.Theta.RUN.mat'])
% else
% % compute theta phase
[b,a]=butter(4,[4 10]/625, 'bandpass');
theta=cell(luP,1);
for k=1:luP
    a=hilbert(sum(filtfilt(b,a,LFP(Period(k,1):Period(k,2),13:16)),2));
    theta{k}.phase=angle(a);
    theta{k}.power=abs(a);
end
clear a
% save([FileBase, '.Theta.RUN.mat'],'theta')
% end

% %%
[LFP,b,a]=ButFilter(LFP,4,[30 140]/625,'bandpass');%FreqB
%
for kk=1:2
    if kk==1
        gnm=gsnm;%ganm;
    else
gnm=gbsnm;%gbnm;
    end
        if iscell(theta)
            theta=theta{1}.phase;
        end
        llnm=size(gnm,2);
    gnm=bsxfun(@rdivide,gnm,sum(gnm.^2));
if kk==2
    icasig=LFP*pinv(gnm)';
else
    icasig=LFP*bsxfun(@rdivide,gsnmw,sum(gsnmw.^2));% ganmw
end
[bincounts,ind]=histc(theta,(-pi):.01:pi);
nbin=length(bincounts);
[nHP, lnm]=size(gnm);
aveICAsig=zeros(lnm,nbin);
for k=1:nbin
    if bincounts(k)>0
aveICAsig(:,k)=sum(icasig(ind==(k-1),:),1)/bincounts(k);
    end
end
%
for k=1:lnm
    figure(22+kk)%
    subplot(2,lnm,k+lnm)
    ny=GaussionProcessRegression(nx,gnm(:,k),.7,.00001,nxx(:));
    nlfp=[ny(1);ny(1);ny(:);ny(end);ny(end)];
    ncsd=-diff(ny,2,1)*aveICAsig(k,:);
%     nlfp=[gnm(1,k);gnm(1,k);gnm(:,k);gnm(end,k);gnm(end,k)];
%     ncsd=-[nlfp(1:(end-2))-2*nlfp(2:(end-1))+nlfp(3:end)]*aveICAsig(k,:);
%     ncsd=interp2(ncsd,3,'linear');
    cscale=max(max(abs(ncsd(3:(end-20),:))));
    imagesc(linspace(-pi,pi,size(ncsd,2)),linspace(HP(1),HP(end),size(ncsd,1)),ncsd,[-cscale,cscale])% (ny(:,k))lfp2CSD,[.01]
%     hold on
%     plot((-pi):.01:pi,(2+sin((-pi):.01:pi)),'k','Linewidth',2)
    title(['comp', num2str(k)])
%     set(gca,'YTick',linspace(nHP(1),nHP(end),length(HP)),'YTicklabel',HP)
    grid on
    hold off
    title(num2str(FreqB))
    set(gca,'YTick',ylbs,'YTicklabel',names)
    
end
end
%%
cd ~/data/ni04-20110503/
fname=sprintf([FileBase, '.%d_%d.sp.w%d.mat'], FreqB,isw);
% save(fname,'nm','anm','mD','c','blonging','sA','A','B','gA','gsA','sA','cu','clags','jdfr','gbnm','ganm','ganmw')
save(fname,'nm','anm','mD','A','gA','gbnm','ganm','ganmw','lost','FreqB','sA','snm','gsA','gB','c','gsnm','gsnmw','jdfr')


return
