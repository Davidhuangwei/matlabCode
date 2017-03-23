% function 
clear all
close all
FileBase='ER02-20110906';
cd(['/gpfs01/sirota/home/evgeny/project/gamma/data/',FileBase]);
load([FileBase, '.thpar.mat'])
% FileBase= cdir;
PeriodTitle = 'RUN';
SignalType = 'lfpinterp';
Channels = 65:96;
nch=length(Channels)-4;
% Load group indices of bursts
par=LoadXml(FileBase);
repch=RepresentChan(par);
OutFileIndex=1;
if isempty(OutFileIndex)
    InputGroupFile = sprintf(['%s.%s.%s.%s.%d-%d'], FileBase, 'SortBurstsIntoGroups2', SignalType, PeriodTitle, Channels([1 end]) );
else
    InputGroupFile = sprintf(['%s.%s.%s.%s.%d-%d.%d'], FileBase, 'SortBurstsIntoGroups2', SignalType, PeriodTitle, Channels([1 end]), OutFileIndex );
end
fprintf(['Loading indices of bursts from different freq/phase groups from %s ...'], InputGroupFile)
load([InputGroupFile '.mat'],'BurstGroup');
% get all CA1 bursts
orBurst=zeros(length(BurstGroup),5);
for k=1:length(BurstGroup)
    orBurst(k,1)=k*strcmp(BurstGroup(k).AnatLayer(1:5),'CA1or');
    orBurst(k,2:3)=BurstGroup(k).ChanLim;
    orBurst(k,4:5)=BurstGroup(k).FreqLim;
end
orBurst(orBurst(:,1)<1,:)=[];
norB=size(orBurst,1);
% % so no idea now what is it used for ....
% %Load anatomical layers (needed only for marking layer boundaries on the figure!)
InputLayerFile = sprintf('%s.%s.%d-%d.txt', FileBase, 'AnatLayers', Channels([1 end]) );
fid = fopen(InputLayerFile);
out = textscan(fid, '%s%d%d%d');
AnatLayerTitle = out{1};
AnatLayerBorder = [out{2} out{3}];
AnatLayerChan = out{4};
fclose(fid); 
clear fid
%Remove empty fields (have no idea why they appear when i add CA1or as the first string)
id =AnatLayerBorder(:,1)==0;
AnatLayerTitle(id) = [];
AnatLayerBorder(id,:) = [];
AnatLayerChan(id) = [];
% fprintf('DONE\n')
% %TEMPORALLY: exclude second blade of the DG
% fprintf('WARNING: DGgran2 and DGmol2 are discarded for now !\n')
% id  = [find(strcmp(AnatLayerTitle, 'DGgran2'))  , find(strcmp(AnatLayerTitle, 'DGmol2')) ];
% AnatLayerTitle(id) = [];
% AnatLayerBorder(id,:) = [];
% AnatLayerChan(id) = [];

%Load coordinates of LFP bursts
InputBurstFile = sprintf(['%s.%s.%s.%s.%d-%d'], FileBase, 'SelectBursts3', SignalType, PeriodTitle, Channels([1 end])  );
fprintf(['Loading burst coordinates from %s.mat ...'], InputBurstFile)
load([InputBurstFile '.mat'], 'BurstFreq', 'BurstChan', 'Params');
fprintf('Burst input DONE\n')

%Load RAW timestamps of burst (refined)
% InputTimeFile = sprintf(['%s.%s.%s.%s.%d-%d'], FileBase, 'GammaBurstSpan3', SignalType, PeriodTitle, Channels([1 end]) );
% fprintf(['Loading refined burst timestamps from %s.mat ...'], InputTimeFile)
% load([InputTimeFile '.mat'], 'RefinedBurstTime');
% BurstTime0 = round(RefinedBurstTime*par.lfpSampleRate);
% clear RefinedBurstTime? of '... .GammaBurstSpan3.

InputTimeFile = sprintf(['%s.%s.%s.%s.%d-%d'], FileBase, 'GammaBurstSpan3', SignalType, PeriodTitle, Channels([1 end]) );
fprintf(['Loading refined burst timestamps from %s.mat ...'], InputTimeFile)
load([InputTimeFile '.mat'], 'RefinedBurstTime', 'BurstTimeSpan');
BTS=par.lfpSampleRate;%1000
BurstTime0 =round(RefinedBurstTime*BTS); clear RefinedBurstTime
BurstTimeSpan=round(BurstTimeSpan*BTS);
fprintf('DONE\n')


mfile=memmapfile([FileBase, '.csdsm5'], 'Format','int16');
csd=reshape(mfile.Data,96,[]);
% if i want to check later all channels
% chn=reshape(1:64,8,8);
% chn([1:2,7:8],:)=[];
% chn=[chn(:)',67:94]';
chn=67:94;
csd=cast(csd(chn,:),'double')';
out.file=mfile.Filename;
clear mfile 
% csd=load([FileBase, '.spec[20-200].csdsm5.65-96.smoothed.mat']);
[ch, lch]=GetLayer(AnatLayerBorder,AnatLayerTitle,{'CA1or','CA1rad','CA1lm'});%,'DGmol'
[~,ich]=getindex(chn,ch);
%% timelag detect
ncom=10;
% the causal stuff 
load([FileBase, '.spec[20-200].lfpdespikedinterp.65-96.smoothed.mat'])
[ch, lch]=GetLayer(AnatLayerBorder,AnatLayerTitle,{'CA1or','CA1rad','CA1lm'});%,'DGmol'
chn=65:96;
bt=floor(BurstTime0/16);
[~,ich]=getindex(chn,ch);
pars.pairwise=true;
tlag=0:5;
lt=length(t);
obt=[];
for k=1:size(orBurst,1)
    obt=[obt;bt(BurstGroup(orBurst(k,1)).Index)];
end
obt=unique(obt);
orrad=LagDetect(reshape(y(:,:,ich(lch==2)),lt,[]),reshape(y(:,:,ich(lch==3)),lt,[]),reshape(y(:,:,ich(lch==1)),lt,[]),pars,obt,tlag);
orlm=LagDetect(reshape(y(:,:,ich(lch==1)),lt,[]),reshape(y(:,:,ich(lch==3)),lt,[]),reshape(y(:,:,ich(lch==2)),lt,[]),pars,obt,tlag);
cd ~
save('lagD','orrad','orlm')



%% so i run ica here 
% weights=cell(norB,1);
% icasig=cell(norB,1);
% signs=cell(norB,1);
ncom=10;
% the causal stuff 
load([FileBase, '.spec[20-200].lfpdespikedinterp.65-96.smoothed.mat'])
% calc from PSDAcrossChannelsEC, out put is [y, f] by mtcsdfast and Params
% given the basic info
% here we use BurstTimeSpan
spec=y;
clear y
% to see the "most causal informative time" wrt refined burst time
cch=repch(repch>64)-64;
nch=length(cch);
nfr=length(f);
for k=1:size(orBurst,1)
    bi=BurstGroup(orBurst(k,1)).Index;
    itspan=ceil(max(floor((BurstTimeSpan(bi,2)-BurstTimeSpan(bi,1))/2))/16);% diff
    nt=2*itspan+1;
    y(k).s=zeros(nch,nfr,nt);
    y(k).u=zeros(nch,5,nfr,nt);
    for n=1:nt
        for jnm=1:nfr
        [u,s,~]=svd(cov(sq(spec(round(BurstTime0(bi)/16)-itspan+n,jnm,cch))));
        y(k).u(:,:,jnm,n)=u(:,1:5);
        y(k).s(:,jnm,n)=diag(s);
        end
    end
end
cd ~
save('infotime','y')       











































%%  csdica before
% sl=round(par.lfpSampleRate./7/4);% mean(orBurst(:,4:5),2) gamma(k)(k)
% jsn=cell(norB,1);
BT=[];% get all the bursts
iBT=[];
for k=1:norB
    BT=[BT;BurstGroup(orBurst(k,1)).Index];
    iBT=[iBT;k*ones(size(BurstGroup(orBurst(k,1)).Index))];
end
BT=BurstTime0(BT(BT>15 & BT<(length(csd)-7)));
data=csd(BT,ich);
data=bsxfun(@rdivide, data,max(data,[],2)-min(data,[],2));
figure; imagesc(sortrows(data,1))
letsee=[max(data(:,1:2),[],2),min(data(:,3:5),[],2),max(data(:,6:9),[],2)];
figure
tp=randi(size(data,1),[5000,1]);
% plot3(letsee(tp,1),letsee(tp,2),letsee(tp,3),'.')
% xlabel('CA1or')
% ylabel('CA1lm')
% zlabel('DGmol')
figure
subplot(311)
scatter(letsee(tp,1),letsee(tp,2),3,iBT(tp),'fill')
xlabel('CA1or')
ylabel('CA1lm')
subplot(312)
scatter(letsee(tp,2),letsee(tp,3),3,iBT(tp),'fill')
xlabel('CA1lm')
ylabel('DGmol')
subplot(313)
scatter(letsee(tp,1),letsee(tp,3),3,iBT(tp),'fill')
xlabel('CA1or')
ylabel('DGmol')
% so the bursts are bursts in the power, s.t. you can have this kind of p-t
[mu, Sigma, ~, mLP, assignments] = sortSpikes(letsee,0,2,2);
figure
subplot(311)
scatter(letsee(tp,1),letsee(tp,2),3,[assignments(tp)-1,zeros(length(tp),2)],'fill')
xlabel('CA1or')
ylabel('CA1lm')
subplot(312)
scatter(letsee(tp,2),letsee(tp,3),3,[assignments(tp)-1,zeros(length(tp),2)],'fill')
xlabel('CA1lm')
ylabel('DGmol')
subplot(313)
scatter(letsee(tp,1),letsee(tp,3),3,[assignments(tp)-1,zeros(length(tp),2)],'fill')
xlabel('CA1or') 
ylabel('DGmol')

% fuck!
% BT=BT(BT>15 & BT<(length(csd)-7));
% blatent=zeros(length(BT),length(ich));
% bvalu=zeros(length(BT),length(ich));
% for n=1:length(ich)
% data=csd(BT,ich(n));
% for k=1:7
%     data=[csd(BT-k,ich(n)), data, csd(BT+k,ich(n))];
% end
% ddata=max(sign(diff(data,1,2)),0);
% pdata=bsxfun(@times,min(sign([zeros(size(data,1),1),ddata]-[ddata,zeros(size(data,1),1)]),0),-7:7);%-1 is the trough
% [~,bl]=min(abs(pdata),[],2);
% data=data';
% 
% bvalu(:,n)=data(bl+15*(0 : length(BT)-1)');
% blatent(:,n)=bl;
% end
% [or, ior]=min(bvalu(:,1:2),[],2);
% [lm, ilm]=min(bvalu(:,3:5),[],2);
% [mol, imol]=min(bvalu(:,6:9),[],2);
% letsee=[or,lm,mol];
% letseel=letsee;
% for k=1:length(BT)
% letseel(k,:)=blatent(k,[ior(k), 2+ilm(k),5+imol(k)]);
% end
% figure;plot(1:length(BT),letseel,'.')
% figure;imagesc(letsee')
csd=ButFilter(csd,2,30/625,'high');

tlth=30;
iBT=iBT(BT>tlth & BT<(length(csd)-tlth));
BT=BT(BT>tlth & BT<(length(csd)-tlth));% BT=BT(BT>15 & BT<(length(csd)-7));
% thetaf=ThPh(BT);
% letsee=zeros(length(BT),3);
% letseel=letsee;
% mletsee=zeros(length(BT),3);
% mletseel=letsee;
% for k=1:length(BT)
%     or=csd(BT(k)+(-tlth :tlth),ich(1:2));
%     lm=csd(BT(k)+(-tlth :tlth),ich(3:5));
%     mol=csd(BT(k)+(-tlth :tlth),ich(6:9));
%     % or
%     
%     [letsee(k,1),letseel(k,1)]=clocalmin(or,tlth);
%     % lm
%     [letsee(k,2),letseel(k,2)]=clocalmin(lm,tlth);
%     % mol
%     [letsee(k,3),letseel(k,3)]=clocalmin(mol,tlth);
%     % find max
%     % or
%     [mletsee(k,1),mletseel(k,1)]=clocalmin(-or,tlth);
%     % lm
%     [mletsee(k,2),mletseel(k,2)]=clocalmin(-lm,tlth);
%     % mol
%     [mletsee(k,3),mletseel(k,3)]=clocalmin(-mol,tlth);
% end
% mletsee=-mletsee;
compsource=bsxfun(@minus,letseel(:,2:3),letseel(:,1));
compsink=bsxfun(@minus,mletseel(:,2:3),mletseel(:,1));
compsc=bsxfun(@rdivide,letsee(:,2:3),letsee(:,1));
compsk=bsxfun(@rdivide,mletsee(:,2:3),mletsee(:,1));
jnm=
for k=1:max(iBT)
sc=(iBT==k);
figure(k)
subplot(221)
scatter(compsource(sc,1),compsource(sc,2),5)%,iBT,iBT,iBT
subplot(222)
scatter(compsink(sc,1),compsink(sc,2),5)%,iBT
subplot(223)
scatter(compsc(sc,1),compsc(sc,2),5)
subplot(224)
scatter(compsk(sc,1),compsk(sc,2),5)
end





thefourth=[bsxfun(@rdivide, letsee,nm), thetaf,iBT];
jn=sortrows(thefourth,[5 4 1 2 3]);
figure; 
for k=1:9
jnm=jn(jn(:,5)==k,:);
[jj,inj]=histc(jnm(:,4),b);
inj=inj+1;
subplot(3,3,k)
imagesc([accumarray(inj,jnm(:,1))./jj,accumarray(inj,jnm(:,2))./jj,accumarray(inj,jnm(:,3))./jj])
title(['frquency: ', num2str(orBurst(k,4:5))])
end

jn(:,4)=jn(:,4)/pi;
jn(:,5)=jn(:,5)/9;
figure;imagesc(jn');
figure;plot(1:length(BT),letseel,'.')
title('min')
axis tight
figure;plot(1:length(BT),mletseel,'.')
title('max')
axis tight
figure;imagesc(letsee')

tp=randi(length(BT),[5000,1]);
% sink
figure
nm=max(mletsee,[],2)-min(letsee,[],2);
subplot(311)
scatter((mletsee(tp,1)-letsee(tp,1))./nm(tp),(mletsee(tp,2)-letsee(tp,2))./nm(tp),3,'fill')
% axis([-1 1 -1 1])
xlabel('CA1or')
ylabel('CA1lm')
subplot(312)
scatter((mletsee(tp,2)-letsee(tp,2))./nm(tp),(mletsee(tp,3)-letsee(tp,3))./nm(tp),3,'fill')
% axis([-1 1 -1 1])
xlabel('CA1lm')
ylabel('DGmol')
subplot(313)
scatter((mletsee(tp,1)-letsee(tp,1))./nm(tp),(mletsee(tp,3)-letsee(tp,3))./nm(tp),3,'fill')
% axis([-1 1 -1 1])
xlabel('CA1or') 
ylabel('DGmol')

subplot(311)
scatter((letsee(tp,1))./nm(tp),(letsee(tp,2))./nm(tp),3, [assignments(tp)-1,zeros(length(tp),2)],'fill')
% axis([-1 1 -1 1])
xlabel('CA1or')
ylabel('CA1lm')
subplot(312)
scatter((letsee(tp,2))./nm(tp),(letsee(tp,3))./nm(tp),3, [assignments(tp)-1,zeros(length(tp),2)],'fill')
% axis([-1 1 -1 1])
xlabel('CA1lm')
ylabel('DGmol')
subplot(313)
scatter((letsee(tp,1))./nm(tp),(letsee(tp,3))./nm(tp),3, [assignments(tp)-1,zeros(length(tp),2)],'fill')
% axis([-1 1 -1 1])
xlabel('CA1or') 
ylabel('DGmol')
figure
scatter3((letsee(tp,1))./nm(tp),(letsee(tp,2))./nm(tp),(letsee(tp,3))./nm(tp),3, [assignments(tp)-1,zeros(length(tp),2)],'fill')
figure
[In  Polygon]= ClusterPoints(bsxfun(@rdivide,letsee(:,2:3),nm), 1,2);
[mu, Sigma, ~, mLP, assignments] = sortSpikes(bsxfun(@rdivide,letsee,nm),0,2,2);
fr=2;
t1=find((assignments==1));%(iBT==fr)&(iBT==fr)&
t2=find((assignments==2));
y=zeros(max(BT)+tlth,3);
x=zeros(max(BT)+tlth,3);
for k=1:3
    y(BT(t1)+letseel(t1,k),k)=letseel(t1,k)./nm(t1);
    x(BT(t2)+letseel(t2,k),k)=letseel(t2,k)./nm(t2);
end
[y1, ff] = mtchd(y,2^7,par.lfpSampleRate,2^6,[],1,'linear');
[y2, ff] = mtchd(x,2^7,par.lfpSampleRate,2^6,[],1,'linear');
figure(21)
ll={'CA1or','CA1lm','DGmol'};
for k=1:3
    for n=1:3
    subplot2(3,3,k,n)
    plot(y1(:,k,n))
    hold on
    plot(y2(:,k,n),'r')
    legend('clust1','clust2')
    xlabel([ll(k), 'and ', ll(n)])
    end
end
% test ThetaPhase
figure
b=(-pi):.2:pi;
x1=histc(thetaf(t1),b);
x2=histc(thetaf(t2),b);
bar(b,[x1,x2])
figure
plot(b,[x1/sum(x1),x2/sum(x2)],'+-')
hold on
plot(b,[(x1+x2)/sum(x2+x1)],'r+-')
xlabel('theta phase')
ylabel('percentil')
legend('cluster1','cluster2')
jnm=zeros(length(BT),2);
jnm(BT(t1),1)=1;
jnm(BT(t2),2)=1;

[y ff]=mtchd(jnm,2^7,par.lfpSampleRate,2^6,[],1,'linear',[],[1 400]);
z=[y(:,1,1),y(:,2,1),y(:,2,2)];
figure
plot(ff,z)
imagesc(1:3, ff, z)
[ccg, t, pairs]=CCG(BT,assignments,1,30,1250);
z=[ccg(:,1,1),ccg(:,2,1),ccg(:,2,2)];
figure
plot(t,z)


figure
subplot(311)
hist2(letseel(:,1:2))
xlabel('CA1or')
ylabel('CA1lm')
subplot(312)
hist2(letseel(:,2:3))
xlabel('CA1lm')
ylabel('DGmol')
subplot(313)
hist2(letseel(:,1:3))
xlabel('CA1or') 
ylabel('DGmol')

figure
b=-20:20;
subplot(311)
a=histc(letseel(:,1),b);
bar(b,a)
xlabel('CA1or')
subplot(312)
a=histc(letseel(:,2),b);
bar(b,a)
xlabel('CA1lm')
subplot(313)
a=histc(letseel(:,3),b);
bar(b,a)
ylabel('DGmol')

figure
nm=max(mletsee,[],2)-min(letsee,[],2);
subplot(311)
scatter(letsee(tp,1)./nm(tp),letseel(tp,1),3,'fill')
xlabel('CA1or')
ylabel('CA1lm')
subplot(312)
scatter(letsee(tp,2)./nm(tp),letseel(tp,2),3,'fill')
xlabel('CA1lm')
ylabel('DGmol')
subplot(313)
scatter(letsee(tp,3)./nm(tp),letseel(tp,3),3,'fill')
xlabel('CA1or') 
ylabel('DGmol')

1
a=csd(BT(1)+(-tlth :tlth),ich);
figure;imagesc(a')
figure; plotm(a)
hold on
plot([tlth+1 tlth+1],[1 10],'r')

% so... in this case, we can only normalize it by max-min

figure
plot3(letsee(tp,1)./nm(tp),letsee(tp,2)./nm(tp),letseel(tp,2),'.')


























% see within the layer how many sink/sourse do you have
cor
clm=sign(diff(data(:,3:5),1,2));
nsinklm=find((clm(:,2)-clm(:,1))<-1);
dg=sign(diff(data(:,6:9),1,2));
figure; imagesc(dg)
ddg=diff(dg,1,2);
figure; imagesc(ddg')
mml=find(sign(ddg(:,2).*ddg(:,1))==0);
jnm=find(min(ddg(mml,:),[],2)<0);
dgp=mml(jnm);
sjnm=min(sign(data(dgp,6:9)),[],2);
tdgp=find(sjnm>0);
figure;imagesc(sortrows(data(dgp(tdgp),:),[1,2])',[-1 1])
title('orin trigger DG source pick csd')
ylabel('channels')

figure;imagesc(sortrows(data(setdiff(1:size(data,1),dgp(tdgp)),:),[1,2])',[-1 1])
title('orin trigger DG source pick csd')
ylabel('channels')




















    


BT=BT(BT>15 & BT<(length(csd)-7));
data=squeeze(csd(BT,ich));
for k=1:7
    data=[csd(BT-k,ich), data, csd(BT+k,ich)];
end
% data=squeeze([csd(max(BT-2*sl,1),:),csd(max(BT-sl,1),:),csd(BT,:)])';
[weights,~,icasig,~,signs,~,activation] = runica(data','extended',1,'sphering','off','verbose','off');%,'pca',6420);,'weights',weights{k-1}
% figure(358)
% scatter3(activation(1,:), ...
%     activation(2,:), ...
%     activation(3,:),'r.')
for k=1:20
    figure(210)
    subplot(2,10,k)
    imagesc(reshape(weights(k,:),15,[]))
    xlabel('components')
    ylabel('channel')
end
ww=cell2mat(weights);
figure(213)
for n=1:3
    subplot(3,1,n)
    w=bsxfun(@rdivide,bsxfun(@minus,ww(n:84:end,:),min(ww(n:84:end,:),[],2)),(max(ww(n:84:end,:),[],2)-min(ww(n:84:end,:),[],2)));
    imagesc(1:27,chn,reshape(w',nch,[])')
    hold on
    plot(repmat([3:3:27]',1,2)',[chn(1)*ones(9,1),chn(end)*ones(9,1)]','k','LineWidth',2)
end
U=cell(norB,1);
S=cell(norB,1);
for k=1:norB
    BT=BurstGroup(orBurst(k,1)).Index;
    data=squeeze(csd(max(BT-sl,1),[71,72,80:87]-64));
    [U{k},S{k},~]=svd(cov(data));
    figure(214)
    subplot(3,3,k)
    plot(data*U{k}(:,2),data*U{k}(:,5),'.')
%     hist(data*U{k}(:,6),100)(k)

end
S=cell2mat(S);
S=reshape(sum(S,2),28,[]);
imagesc(S)
plot(mean(S,2))
figure
k=9;
hold on
BT=BurstGroup(orBurst(k,1)).Index;
or0=squeeze([csd(max(BT,1),[71,72]-64),csd(BT,[71,72]-64)]);%(k)(k)(k)(k)-sl-sl-sl
lm0=squeeze([csd(max(BT,1),[80:83]-64),csd(BT,[80:83]-64)]);
dg0=squeeze([csd(max(BT,1),[84:87]-64),csd(BT,[84:87]-64)]);

scatter3(max(or0,[],2), ...
    max(lm0,[],2), ...
    max(dg0,[],2),'r.')
xlabel('orien')
ylabel('lm')
zlabel('DG')


% let me try csdsm5.65-96.smoothed <- shoud not be this... gamma burst
% shoud be generated by the lfp, instead of certain frequency, right?
sc=cell(norB,1);
scl=cell(norB,1);
sk=cell(norB,1);
skl=cell(norB,1);
for k=1:norB
    time=BurstGroup(orBurst(k,1)).Index;
    [sc{k}, scl{k}, sk{k}, skl{k}]=myloc_sksc(ButFilter(csd(:,ich),6,orBurst(k,4:5)/625,'bandpass'),time(time>15 & time<(length(csd)-7)), ceil(625/orBurst(k,4)),loc);
end
figure
for k=1:norB
    normt=sk{k}(:,1)-sc{k}(:,1);%
    subplot(5,norB,k)
    scatter(abs(sc{k}(:,1))./normt,abs(sc{k}(:,2))./normt,5,scl{k}(:,3)-scl{k}(:,2));
    hold on 
%     plot([-1 0],[-40 0],'r')
    axis([0,1,0,40])
    xlabel('CA1ori')
    ylabel('CA1rad')
    title(['frq' num2str(orBurst(k,4:5)), 'Hz'])
    subplot(5,norB,norB+k)
    scatter(abs(sc{k}(:,3))./normt,abs(sc{k}(:,2))./normt,5,scl{k}(:,3)-scl{k}(:,2));
    xlabel('DGmol')
    ylabel('CA1rad')
    hold on 
    plot([0 40], [0 40],'r')
    axis([0 40 0 40])
    subplot(5,norB,2*norB+k)
    scatter(sk{k}(:,3)./normt,sk{k}(:,2)./normt,5,scl{k}(:,3)-scl{k}(:,2));
    hold on
    plot([0 40], [0 40],'r')
    axis([0 40 0 40])
    subplot(5,norB,3*norB+k)
%     scatter(scl{k}(:,3)-scl{k}(:,1),scl{k}(:,2)-scl{k}(:,1),5);
 hist2([scl{k}(:,3)-scl{k}(:,1),scl{k}(:,2)-scl{k}(:,1)],9,9)
    subplot(5,norB,4*norB+k)
%     scatter(skl{k}(:,3)-scl{k}(:,1),skl{k}(:,2)-scl{k}(:,1),5);
hist2([skl{k}(:,3)-scl{k}(:,1),skl{k}(:,2)-scl{k}(:,1)],9,9)
    axis tight
end
thph=cell(norB,1);
for k=1:norB
    time=BurstGroup(orBurst(k,1)).Index;
    thph{k}=ThPh(time(time>15 & time<(length(csd)-7)));
end
figure
h = fspecial('average',[2,2]);
for k=1:norB
    [B, u, v]=hist2([atan(sc{k}(:,3)./sc{k}(:,2)),thph{k}],50,50);
    subplot(4,norB,k)
    imagesc(u, v,B')
    subplot(4,norB,norB+k)
    B=bsxfun(@rdivide,B,max(sum(B,2),1));
    B=bsxfun(@rdivide,B,max(max(B,[],2),.00001));
    imagesc(u, v,filter2(h,B,'same')')
    axis([0 pi/2 -pi pi])
    
    lnm=[scl{k}(:,3)-scl{k}(:,2),thph{k}];
    [B, u, v]=hist2(lnm,max(lnm(:,1))-min(lnm(:,1)),50);
    subplot(4,norB,2*norB+k)
    imagesc(u, v,B')
    subplot(4,norB,3*norB+k)
% 	B=bsxfun(@minus,B,min(B,[],2));
    B=bsxfun(@rdivide,B,max(sum(B,2),1));
    B=bsxfun(@rdivide,B,max(max(B,[],2),.00001));
    imagesc(u, v,filter2(h,B,'same')')
    axis([min(lnm(:,1)) max(lnm(:,1)) -pi pi])
end
figure
for k=1:norB
    normt=sk{k}(:,1)-sc{k}(:,1);%
    subplot(3,norB,k)
    scatter(abs(sc{k}(:,1))./normt,abs(sc{k}(:,2))./normt,5,scl{k}(:,2));
    hold on 
%     plot([-1 0],[-40 0],'r')
    axis([0,1,0,40])
    xlabel('CA1ori')
    ylabel('CA1lm')
    title(['frq' num2str(orBurst(k,4:5)), 'Hz'])
    subplot(3,norB,norB+k)
    hist(scl{k}(:,2),10)
    axis tight
    subplot(3,norB,norB*2+k)
    hist2([abs(sc{k}(:,1))./normt,abs(sc{k}(:,2))./normt],20,round(max(abs(sc{k}(:,2))./normt)))
    
end


for k=1:norB
    time=BurstGroup(orBurst(k,1)).Index;
    [sc{k}, scl{k}, sk{k}, skl{k}]=myloc_sksc(ButFilter(csd(:,ich),6,orBurst(k,4:5)/625,'bandpass'),time(time>15 & time<(length(csd)-7)), ceil(625/orBurst(k,4)),loc);
end



% to just check the gamma bursts performance regard to ca1rad and ca1lm,
% well probably for ca1rad and ca1lm and DGmol
% location 
[ch, lch]=GetLayer(AnatLayerBorder,AnatLayerTitle,{'CA1or','CA1rad','CA1lm','DGmol'});%
lch=max(lch)+1-lch;
[~,ich]=getindex(chn,ch);
loc=cell(max(lch),1);
for k=1:max(lch)
    loc{k}=ich(lch==k);
end
mch=length(ich);
u=cell(norB,1);
s=cell(norB,1);
weights=cell(norB,1);
icasig=cell(norB,1);
% run pca
for k=1:norB
    time=BurstGroup(orBurst(k,1)).Index;
    time=bsxfun(@plus, time(time>15 & time<(length(csd)-7)),-15:15)';
    data=ButFilter(csd(:,ich),6,orBurst(k,4:5)/625,'bandpass');
    data=reshape(data(time(:),:)',mch*31,[])';
    [u{k},s{k},~]=svd(cov(data));
end
% try ica
for k=1:norB
    time=BurstGroup(orBurst(k,1)).Index;
    time=bsxfun(@plus, time(time>15 & time<(length(csd)-7)),-15:15)';
    data=ButFilter(csd(:,ich),6,orBurst(k,4:5)/625,'bandpass');
    data=reshape(data(time(:),:)',mch*31,[])';
[weights{k},~,icasig{k},~,~,~,~] = runica(data','pca',14,'extended',1,'sphering','off','verbose','off');
end
for k=1:norB
    figure(k)
    for n=1:4
    subplot(3,5,n)
    imagesc(reshape(u{k}(:,n),mch,[]))
    subplot(3,5,5+n)
    imagesc(reshape(weights{k}(n,:),mch,[]))
    subplot(3,5,10+n)
    imagesc(reshape(weights{k}(n+4,:),mch,[]))
    end
    subplot(355)
    plot(diag(s{k}(1:10,1:10)))
    axis tight
    subplot(3,5,10)
    plot(icasig{k}(1:10))
    axis tight
    subplot(3,5,15)
    imagesc(reshape(weights{k}(9,:),mch,[]))
end
     
















    