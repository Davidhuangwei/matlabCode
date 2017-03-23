% ica_draftNI
clear all
FileBase='ni04-20110503';
storageF='/Volumes/YY/';
% cd ~/data/ni04-20110503/
% load ni04-20110503.SWS.workspace.mat
cd([storageF, FileBase])
tempga=load('tempGA.mat');
Period=load([FileBase, '.sts.SWS']);
FS = 1250;
% load('/home/weiwei/data/4_16_05_merged/ChanInfo/ChanLoc_Full.eeg.mat')
cd([storageF, FileBase])
load chanLoc.mat
Layers=fieldnames(chanLoc);
layer_show=zeros(18,1);
for n=1:length(Layers)
    
    layer_show(double(chanLoc.(Layers{n})))=n;
end
HP=1:54;
Period=Period(1:5,:);
% storage/evgeny/data/project/gammahome/weiwei/
nhp=length(HP);
cd([storageF, FileBase])
%
LFP= LoadBinary([FileBase '.lfpinterp'],HP,64,2,[],[],Period)';%
oPeriod=Period;
Period=ReshapePeriod(Period);
nPeriod=Period;
%
prd=10*12500;
Period=[nPeriod(1,1):prd:(nPeriod(end,2)-prd);(nPeriod(1,1)+prd):prd:nPeriod(end,2)]';
%
uPeriod=[Period(:,2)-Period(:,1)]>1250*2;
luP=sum(uPeriod);

%%
if 0
for k=1:luP
[tLFP, ARmodel] = WhitenSignal([mean(LFP(Period(k,1):Period(k,2),:),2),LFP(Period(k,1):Period(k,2),:)], [],[],[], 3);
LFP(Period(k,1):Period(k,2),:)=centersig(tLFP(:,2:end));
end
clear tLFP
end
% %%
FreqB=[30 100];
jdfr=[35:10:90];% [45 65 85];
[LFP,b,a]=ButFilter(LFP,4,FreqB/625,'bandpass');
%   %%
% for LFP
A=cell(luP,1);
W=cell(luP,1);
thr=6;%.985;%1:15;.982:11
% SpecICA=cell(luP,1);
nfcomp=zeros(luP,1);
% %%
for k=1:luP
    [icasig,A{k},W{k},nfcomp(k)]=wKDICA(LFP(Period(k,1):Period(k,2),:)',thr);%,'numOfIC', 5
    ncomp=size(icasig,1);

end
[icacomp,gA,gW]=wKDICA(LFP',thr);%,'numOfI
[od,mxD]=reorder(tempga,gA);
gA=gA(:,od);
gW=gW(od,:);
icacomp=icacomp(od,:);
[nm,lost,dists]=ClusterCompO(gA,A,.1);

%
[anm, mD, id]=ClusterComp(gA,cell2mat(A'),.1,0);

    lanm=size(anm,2);
if lanm<10
    [cu, clags]=xcorr(centersig(LFP)*pinv(anm)',30,'coeff');
    figure
    for row = 1:lanm
        for col = 1:lanm
            nm = lanm*(row-1)+col;
            subplot(lanm,lanm,nm)
            stem(clags,cu(:,nm),'.')
            title(sprintf('c_{%d%d}',row,col))
            axis tight
            ylim([-1 1])
        end
    end
else
    aw=pinv(anm)';
    figure
    cu=[];
    for row = 1:lanm
        for col = 1:lanm
            nm = lanm*(row-1)+col;
            [cuu, clags]=xcorr(centersig(LFP)*aw(:,row),centersig(LFP)*aw(:,col),30,'coeff');
            if isempty(cu)
                cu=zeros(length(cuu),lanm*lanm);
            end
            cu(:,nm)=cuu;
            nm = lanm*(row-1)+col;
            subplot(lanm,lanm,nm)
            stem(clags,cu(:,nm),'.')
            title(sprintf('c_{%d%d}',row,col))
            axis tight
            ylim([0 1])
        end
    end
end
%%
LSA=[gA,cell2mat(A')];
KLSA=LSA(:,~id);
lnm=size(anm,2);
nx=zscore(HP(:));
nxx=[nx(1):0.01:nx(end)]';
pod=0:8;
% nx=bsxfun(@power,nx,pod);%
% nxx=bsxfun(@power,nxx,pod);%
ny=zeros(size(nxx,1),lnm);
   nHP=HP(1):((HP(end)-HP(1))/(size(nxx,1)-1)):HP(end);
for k=1:lnm
    nmD=sum(mD==k);
    if nmD>0
       dt=bsxfun(@times,bsxfun(@rdivide,KLSA(:,mD==k),sqrt(sum(KLSA(:,mD==k).^2,1))),sign(anm(:,k)'*KLSA(:,mD==k)));
       ny(:,k)=GaussionProcessRegression(repmat(nx,nmD,1),dt(:),.8,.001,nxx(:));

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
   title(['comp.',num2str(k)])
%    title(['var', num2str(var(anm(:,k)))])
   xlabel(num2str(sum(mD==k)))
%    axis ij
   hold off
   n=n+1;
   end
end
ForAllSubplots('axis xy')
ForAllSubplots('axis ij')
%% Have a example of time-frequency method... use multitiper
% using frequency method
B=cell(luP,1);
sA=cell(luP,1);
c=cell(luP,1);
% chn=HP;%(1:2:end)HP;%[5:2:60];
%
for k=1:luP
%     [lambda,~,~,~,tlfp]=factoran(LFP(Period(k,1):Period(k,2),chn),nfcomp(k));
[B{k}, cc]=SSpecJAJD(LFP(Period(k,1):Period(k,2),:),400,400,1250,jdfr,100,1,nfcomp(k));
c{k}=zeros(nfcomp(k),length(jdfr),size(cc,4));
for n=1:nfcomp(k)
    c{k}(n,:,:)=cc(n,n,:,:);
end
sA{k}=pinv(B{k});% lambda/B{k}
fprintf('%d-',k)
end 
% for k=1:luP
%     sA{k}=pinv(B{k});
% end
[~,lp]=max(Period(:,2)-Period(:,1));
% [lambda,~,~,~,tlfp]=factoran(LFP(:,chn),size(gA,2));
[gB, gc]=SSpecJAJD(LFP,400,400,1250,jdfr,100,1,size(gA,2));
gsA=pinv(gB);%lambda/gB
%
[nm, mD, id]=ClusterComp(gsA,cell2mat(sA'),.1,0);
% figure(5)
% test
LSA=[gsA,cell2mat(sA')];
bl=1:size(LSA,2);
KLSA=LSA(:,~id);
bl=bl(~id);
lnm=size(nm,2);
nx=zscore(HP(:));
nxx=[nx(1):0.01:nx(end)]';
pod=0:8;
% nx=bsxfun(@power,nx,pod);%
% nxx=bsxfun(@power,nxx,pod);%
ny=zeros(size(nxx,1),lnm);
   nHP=HP(1):((HP(end)-HP(1))/(size(nxx,1)-1)):HP(end);
   blonging=cell(lnm,1);
   n=1;
for k=1:lnm
    nmD=sum(mD==k);
    
    if nmD>0
        blongi=bl(mD==k);
        blonging{k}=blongi(blongi>size(gsA,2));
       dt=bsxfun(@times,bsxfun(@rdivide,KLSA(:,mD==k),sqrt(sum(KLSA(:,mD==k).^2,1))),sign(nm(:,k)'*KLSA(:,mD==k)));
       ny(:,k)=GaussionProcessRegression(repmat(nx,nmD,1),dt(:),.8,.001,nxx(:));

% [ny(:,k),~]=BasicRegression(repmat(nx,nmD,1),dt(:),nxx);
       figure(24)
       subplot(1,lnm,k)
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
   end
end
ForAllSubplots('axis xy')
ForAllSubplots('axis ij')
%




%%
cd([storageF, FileBase])
Period=load([FileBase, '.sts.RUN']);%6729+[1,1.5*10^6];
FS = 1250;
% load('/home/weiwei/data/4_16_05_merged/ChanInfo/ChanLoc_Full.eeg.mat')
load chanLoc.mat
cd([storageF, FileBase])
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
    a=hilbert(filtfilt(b,a,LFP(Period(k,1):Period(k,2),1)));
    theta{k}.phase=angle(a);
    theta{k}.power=abs(a);
end
clear a
% save([FileBase, '.Theta.RUN.mat'],'theta')
% end
%

        gnm=anm;

        if iscell(theta)
            theta=theta{1}.phase;
        end
        llnm=max(size(gnm,2),size(gA,2));
    gnm=bsxfun(@rdivide,gnm,std(gnm));
    icasig=LFP*pinv(gnm)';
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
    figure(23)
    subplot(2,lnm,k+lnm)
    ny=GaussionProcessRegression(nx,gnm(:,k),.5,.001,nxx(:));
    imagesc((-pi):.01:pi,1:nHP,-diff(ny,2,1)*aveICAsig(k,:))% (ny(:,k))lfp2CSD,[.01]
%     hold on
%     plot((-pi):.01:pi,(2+sin((-pi):.01:pi)),'k','Linewidth',2)
    title(['comp', num2str(k)])
%     set(gca,'YTick',linspace(nHP(1),nHP(end),length(HP)),'YTicklabel',HP)
    grid on
    hold off
    title(num2str(FreqB))
end

cd ~/data/ni04-20110503/
fname=sprintf([FileBase, '.%d_%d.sp.w.mat'], FreqB);
save(fname,'nm','anm','mD','c','blonging','sA','A','B','gA','gsA','sA','cu','clags','jdfr')




%% show c

ncomps=length(blonging);
luP=length(c);
mapcells=cell(luP,1);
n=0;
for k=1:luP
    lc=size(c{k},1);
mapcells{k}=[ones(1,lc)*k;n+(1:lc);(1:lc)];
n=n+lc;
end
mapcells=cell2mat(mapcells');
compdis=cell(ncomps,1);
for k=1:ncomps
    compdis{k}=[];
for n=1:length(blonging{k})    
    if blonging{k}(n)>6
    id=find(mapcells(2,:)==(blonging{k}(n)-6));
    compdis{k}=[compdis{k},sq(c{mapcells(1,id)}(mapcells(3,id),:,:))];
    end
end
end

%% can't understand...
for k=1:ncomps
    figure(234)
    subplot(3,ncomps, k)
%     ncompdis=bsxfun(@rdivide,compdis{k},sqrt(sum(compdis{k}.*conj(compdis{k}),2)));
ip=setdiff([1:size(compdis{k},2)]-1,unique(mod(find(isnan(compdis{k}')),size(compdis{k},2))));
ip(~ip)=size(compdis{k},2);
fprintf('%d-%d\n',k,length(ip))
    ncompdis=compdis{k}(:,ip)/sqrt(sum(diag(compdis{k}(:,ip)*compdis{k}(:,ip)'/length(ip))));
    plot(real(ncompdis(1,:)),real(ncompdis(2,:)),'.')
    title(['comp.', num2str(k)])
%     ylim([-500 500])
    subplot(3,ncomps, k+ncomps)
    plot(real(ncompdis(1,:)),real(ncompdis(3,:)),'.')
    subplot(3,ncomps, k+ncomps*2)
    plot(real(ncompdis(2,:)),real(ncompdis(3,:)),'.')
end








































%%
for kk=1:2
    if kk==1
        gnm=nm;
        if iscell(theta)
theta=theta{1}.phase;
        end
llnm=max(size(nm,2),size(gA,2));
    else
        gnm=anm;
    end
%     if iscell(theta)
% theta=theta{1}.phase;
%         end
% llnm=max(size(gnm,2),size(gA,2));
    gnm=bsxfun(@rdivide,gnm,std(gnm));
    icasig=LFP*pinv(gnm)';
[bincounts,ind]=histc(theta,(-pi):.01:pi);
nbin=length(bincounts);
[nHP lnm]=size(gnm);
aveICAsig=zeros(lnm,nbin);
for k=1:nbin
    if bincounts(k)>0
aveICAsig(:,k)=sum(icasig(ind==(k-1),:),1)/bincounts(k);
    end
end
%%
for k=1:lnm
    figure(24)
    subplot(2,llnm,k+llnm*(kk-1))
    ny=GaussionProcessRegression(nx,gnm(:,k),.5,.001,nxx(:));
    imagesc((-pi):.01:pi,1:nHP,-diff(ny,2,1)*aveICAsig(k,:))% (ny(:,k))lfp2CSD,[.01]
    hold on
    plot((-pi):.01:pi,(2+sin((-pi):.01:pi)),'k','Linewidth',2)
    title(['comp', num2str(k)])
%     set(gca,'YTick',linspace(nHP(1),nHP(end),length(HP)),'YTicklabel',HP)
    grid on
    hold off
end
end





















%%

for k=1:luP
subplot(2,10,k)
        plot(HP,bsxfun(@plus,bsxfun(@rdivide,A{k},sqrt(sum(A{k}.^2,1))),1:size(A{k},2)),'Linewidth',2)
Acsd=diff(A{k},2,1);
hold on
        plot(HP(2:(end-1)),bsxfun(@plus,bsxfun(@rdivide,Acsd,sqrt(sum(A{k}.^2,1))),1:size(A{k},2)),':','Linewidth',2)
       
        grid on
        axis tight
        hold off
subplot(2,10,k+10)
       imagesc(ff,HP,SpecICA{k})
end
