bl=1250*5;
for k=96:98%nblock
    figure(213)
    subplot(2,1,1)
    timep=((k-1)*bl+1):(k*bl);
    PlotTraces(flfp(timep,:),[],1250,5);
    title('origin')
    subplot(2,1,2)
    PlotTraces(dnlfp(timep,:),[],1250,5);
    title('dn')
%     figure(214)
%     subplot(2,1,1)
%     plotm(sq(jsn(:,:,k)),fstage{end},[],[],[],[],[],[],1)
%     hold off
%     title('10 first')
%     subplot(2,2,3)
%     plotm(fstage{k}(:,2:end)',fstage{end},[],[],[],[],[],[],1)
%     hold off
%     if fstage{k}(1)>0
%     title(['comp', num2str(fstage{k}(:,1)')])
%     subplot(2,2,4)
%     MapSilicon(weights{k}(fstage{k}(1),:),par.GoodCh,par,[],1);
%     title(['comp', num2str(fstage{k}(:,1)')])
%     end
    pause(1)
end
llnm=find(inds>exp(mean(log(inds(:)))+3*std(log(inds(:)))));
[~,jlnm]=sort(inds(llnm),'descend');
llnm=llnm(jlnm);
sllnm=[floor((llnm-1)/80+1),mod(llnm-1,80)+1];
m=1;
for k=1:ceil(length(llnm)/40)
    m=m-40;
    figure
    for n=m:min(m+39,length(llnm))
        subplot(5,8,n-m+1)
        MapSilicon(abs(weights3{sllnm(n,1)}(sllnm(n,2),:)),par.GoodCh,par,[],1);
        title(['inds', num2str(inds(llnm(n)))])
    end
    m=n+1;
end
length(find(checkspace>0))
figure
sjnm=find(checkspace>0);
for k=1:144
    subplot(6,24,k)
    MapSilicon(abs(weights3{sllnm(sjnm(k),1)}(sllnm(sjnm(k),2),:)),par.GoodCh,par,[],1);
    title(['inds', num2str(inds(llnm(sjnm(k))))])
end
jnm=cell2mat(weights3);
figure
for k=1:2
    subplot(1,2,k)
    MapSilicon(abs(jnm(dg(k),:)),par.GoodCh,par,[],1);
end
FileBase='g10-20130305';
cd ~/data/g10
mdata=memmapfile('g10-20130305.lfp','Format','int16');
dnlfp=cast(reshape(mdata.Data,96,[])','double');
cd /gpfs01/sirota/bach/data/gerrit/processed-data/g10/g10-20130305
mmdata=memmapfile('g10-20130305.lfp','Format','int16');
lfp=cast(reshape(cast(mmdata.Data,'double'),96,[])','double');

par=LoadXml(FileBase);
repch=RepresentChan(par);
lfp=lfp(:,repch);
dnlfp=dnlfp(:,repch);
rt=dir('*sts.RUN');
run=load(rt(1).name);

lfp=lfp(run(6,1):run(6,2),:);
for pn=5:length(run)
rtime=run(pn,1):run(pn,2);
tlfp=lfp(rtime,:);
tdnlfp=dnlfp(rtime,:);
% lfp=ButFilter(lfp,2,1/625,'high');
% flfp=ButFilter(lfp,2,[80 400]/625,'bandpass');
% bl=1250*5;
% nblock=floor(size(dnlfp,1)/bl);
figure
subplot(211)
PlotTraces(tlfp,rtime,[],5);
subplot(212)
PlotTraces(tdnlfp,rtime,[],5);
drawnow
pause
end
figure
subplot(211)
PlotTraces(lfp,rtime,[],5);
subplot(212)
PlotTraces(lfp*U(:,1:20),rtime,[],5);
figure
plot(diag(S))
figure
imagesc(U(:,1:20))
figure
plot(rtime,[mean(lfp,2),lfp*U(:,1)])
plotm(lfp*U(:,1:20),rtime)
for k=1:100%110:nblock
    figure(215)
    subplot(211)
    PlotTraces(lfp(((k-1)*bl+1):(k*bl),:),((k-1)*bl+1):(k*bl),[],5);
    
    subplot(212)
    PlotTraces(dnlfp(((k-1)*bl+1):(k*bl),:),((k-1)*bl+1):(k*bl),[],5);
    figure(216)
    plotm(fstage{k}(:,2:end)',fstage{end})
    pause(1)
end
for k=1%22:nblock
    data = flfp((bl*(k-1)+1):end,:)';
    
    ndch=icaview(data,weights{k},1,icasig{k},par,[100 400],10,['time block ', num2str(k),'comp', num2str(fstage{k}(:,1)')]);% CDPC((bl*(k-1)+1):(bl*k),:)
    
end
%% let's try short term pca
flfp=ButFilter(lfp,2,[1 300]/625,'bandpass');
wl=1;
bl=round(par.lfpSampleRate*wl);
nt=round(length(flfp)/bl);
tch=find((repch<65)&(repch>32));
tnch=nch-length(tch);
U=zeros(tnch,tnch*nt);
Uf=zeros(nch,nt);
S=zeros(tnch,nt);
fsig=zeros(size(flfp));
for k=1:nt
    if k<nt
        tp=((k-1)*bl+1):(k*bl);
    else
        tp=((k-1)*bl+1):length(flfp);
    end
    tlfp=flfp(tp,[1:(tch(1)-1),(tch(end)+1):end]);
    [tU, tS, ~]=svd(cov(tlfp));
    tlfp=bsxfun(@minus,tlfp,mean(tlfp,1));
    tV=tlfp*tU(:,1)/tS(1);% activity
    ld=tV'*bsxfun(@minus,flfp(tp,:),mean(flfp(tp,:),1));
    nn=tV*ld;% weight
    U(:,((k-1)*tnch+1):(k*tnch))=tU;
    S(:,k)=diag(tS);
    Uf(:,k)=ld;
    fsig(tp,:)=lfp(tp,:)-nn;
end
figure
subplot(211)
PlotTraces(flfp,[],[],5);
subplot(212)
PlotTraces(dnlfp,[],[],5);
mml=bsxfun(@minus,lfp,mean(lfp,1));
dlfp=bsxfun(@plus,mml-(mml*mean(Uf(:,randi(size(Uf,2),1,400)),2))*mean(Uf(:,randi(size(Uf,2),1,400)),2)',mean(lfp,1));
%%
% new.... method...
% as probably it will work better if i separate the probs, then let's try
% first: MEC!
FileBase='g10-20130326';
cd(['/gpfs01/sirota/bach/data/gerrit/processed-data/g10/', FileBase])
if exist([FileBase, '.raw.lfp'])
    mmdata=memmapfile([FileBase, '.raw.lfp'],'Format','int16');
else
    mmdata=memmapfile([FileBase, '.lfp'],'Format','int16');
end
lfp=cast(reshape(cast(mmdata.Data,'double'),96,[])','double');
par=LoadXml(FileBase);
repch=RepresentChan(par);
nch=length(repch);
fp=lfp(:,repch);
rt=dir('*sts.RUN');
run=load(rt(1).name);
nlfp=[];
for pn=1:size(run,1)
lfp=fp(run(pn,1):run(pn,2),:);

ljn=reshape(lfp,[],1);
[~, locn]=findpeaks(ljn);
[~, jjn]=findpeaks(-ljn);
sjn=zeros(size(ljn));
sjn(locn)=1;sjn(jjn)=-1;
sjn=reshape(sjn,[],nch);
lm{1}=find(repch<33);% mec
lm{2}=find(repch>64);% lec
lm{3}=setdiff(1:length(repch),[lm{1},lm{2}]);% hip
% figure(32);
% subplot(211)
% hold on
% m{1}=mean(sjn(:,lm{1}),2);% mecm
% plot(1:length(sjn),m{1},'r.')
% m{2}=mean(sjn(:,lm{2}),2);% lecm
% plot(1:length(sjn),m{2},'go')
% m{3}=mean(sjn(:,lm{3}),2);% hipm
% plot(1:length(sjn),m{3},'b+')
% axis tight
% subplot(212)
% hold on
% cf=sum([lm{1},lm{2},lm{3}],2);
% cf(abs(cf)<2.4)=0;
% plot(repmat(find(cf>0),1,2)',(ones(sum(cf>0),1)*[0 1])','g')
% plot(repmat(find(cf<0),1,2)',(ones(sum(cf<0),1)*[0 1])','y')
% PlotTraces(lfp,1:length(sjn),[],5);
% axis tight

%% so... try the pca clean...
flfp=ButFilter(lfp,2,100/625,'high');
dnlfp=lfp;
% art=struct;
for jnm=1:3
mm=m{jnm};
mm(abs(mm)<.8)=0;
mm=conv(mm,ones(1,25),'same');
mm=sign(abs(mm));prd=mm-[0;mm(1:(end-1))];
onset=find(prd>0);offset=find(prd<0);% well, it will always begin with onset~ you just need to check whether there is an offset...
% btw, the offset indeed is offset+1 here...
% get the periods that have peak-groups.
if length(onset)==length(offset)
    prd=[onset,offset];
else 
    prd=[onset,[offset;length(prd)]];
end
nprd=size(prd,1);
% art(jnm).a=cell(nprd,1);
for k=1:nprd
    tp=prd(k,1):prd(k,2);
    [dnlfp(tp,lm{jnm}), ~]=oldclean(lfp(tp,lm{jnm}),flfp(tp,lm{jnm}),1,'itpca');% art(jnm).a{k}
end
end
nlfp=[nlfp;dnlfp];
end
cd ~/data/g10
sdata=zeros(size(nlfp,1),par.nChannels);
sdata(:,repch)=nlfp;
fileID = fopen([FileBase, '.run'],'w');
fwrite(fileID, sdata','int16');
fclose(fileID);
clear all

%%
FileBase='g10-20130423';
cd ~/data/g10
mdata=memmapfile([FileBase,'.run'],'Format','int16');
lfp=cast(reshape(mdata.Data,96,[])','double');
% cd(['/gpfs01/sirota/bach/data/gerrit/processed-data/g10/', FileBase])
% if exist([FileBase,'.raw.lfp'])
%     lfp=LoadBinary([FileBase,'.raw.lfp'],1:96,96,[],[],[],'RUN')';
% else
%     lfp=LoadBinary([FileBase,'.lfp'],1:96,96,[],[],[],'RUN')';
% end
figure
sl=1250*1;
for k=1:floor(length(lfp)/sl)
    tp=((k-1)*sl+1):(k*sl);
%     ot=onset(find((onset>=min(tp))&(onset<=max(tp))));
%     op=onset(find((offset>=min(tp))&(offset<=max(tp))));

%     subplot(211)
%     PlotTraces(dnlfp(tp,:),[],[],5);
%     subplot(212)
subplot(211)
PlotTraces(fp(tp,:),[],[],5);% tp
subplot(212)
PlotTraces(nlfp(tp,:),[],[],5);% tp
% hold on
% plot([ot,ot]',[zeros(1,length(ot)); ones(1,length(ot))],'g')
% plot([op,op]',[zeros(1,length(op)); ones(1,length(op))],'y')
title(num2str(k))
pause
end
% icam=0;
% if icam
% %% ica methods: (indeed the ica still perform not too good...)
% mm=mecm;
% mm(abs(mm)<.8)=0;
% mms=mm;
% mm=abs(sign(mm));% well, as it's just the way to calculate the good periods. i can improve here
% 
% mm=conv(mm,ones(1,60),'same');
% figure;plot(mm);
% mm=sign(mm);prd=mm-[0;mm(1:(end-1))];
% onset=find(prd>0);offset=find(prd<0);% well, it will always begin with onset~ you just need to check whether there is an offset...
% % get the periods that have peak-groups.
% if length(onset)==length(offset)
%     prd=[onset,offset];
% else 
%     prd=[onset,[offset;length(prd)]];
% end
% prd=prd(diff(prd,1,2)>150,:);
% hold on
% plot(prd',ones(size(prd'))*4,'r+-','Linewidth',2)
% tp=prd(end-6,1):prd(end-6,2);
% data=lfp(tp,hip)';
% [weights,~,icasig,~,signs,~,activations] = runica(data,'extended',1,'sphering','off','stop',1e-6,'verbose','off');
% tjsn=[];
% fb=[10 80];
% for k=1:length(weights)
%     [tjsn(:,k),~] = mtchd(activations(k,:)',2^7,par.lfpSampleRate,2^6,[],1,'linear',[],fb);
% end
% [tjsn(:,k+1),ff] = mtchd(mms,2^7,par.lfpSampleRate,2^6,[],1,'linear',[],fb);
% figure
% imagesc(1:(k+1),ff,bsxfun(@rdivide,tjsn,max(tjsn,[],1)))
% figure
% imagesc(weights)
% nv=[22];%13 19,6,7,22,13,27
% dnlfp=icaproj(data,weights,setdiff(1:k,nv),mean(data,2))'; 
% figure
% subplot(211)
% PlotTraces(data',tp,[],5);
% % hold on
% % plot(tp,mms(tp),'g','Linewidth',.5)
% subplot(212)
% PlotTraces(dnlfp,tp,[],5);
% % hold on
% % plot(tp,mms(tp),'g','Linewidth',.5)
% end