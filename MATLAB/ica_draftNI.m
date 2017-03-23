% ica_draftNI
clear all
FileBase='ni04-20110503';
cd ~/data/ni04-20110503/
Period=load('ni04-20110503.sts.SWS');
FS = 1250;
% load('/home/weiwei/data/4_16_05_merged/ChanInfo/ChanLoc_Full.eeg.mat')
load ChanLoc.mat
Layers=fieldnames(ChanLoc);
layer_show=zeros(18,1);
for n=1:length(Layers)
    layer_show(ChanLoc.(Layers{n})-70)=n;
end
HP=[71:82]';%84,86:88
%%
% nhp=length(HP);
nhp=length(HP);
LFP= LoadBinary([FileBase '.lfp'],HP,96,2,[],[],Period)';
oPeriod=Period;
Period=ReshapePeriod(Period);
uPeriod=[Period(:,2)-Period(:,1)]>1250*2;
luP=sum(uPeriod);
if size(uPeriod,2)<2
uPeriod=Period(uPeriod,:);
[~,od]=sort(uPeriod(:,2)-uPeriod(:,1));
uPeriod=uPeriod(od,:);
end
%%
% mLFP=mean(LFP,1);
% varLFP=var(LFP,1);
% cLFP=zscore(LFP);
% csd=cell(luP,1); % TOO LARGE 
% WELL... WE CAN PROBABLY RHPORD A LONG ONE
% for LFP
LFPica.fA=cell(luP,20);
LFPica.fW=cell(luP,20);
LFPica.rW=cell(luP,20);
LFPica.KDW=cell(luP,20);
% for CSD
CSDica.fA=cell(luP,20);
CSDica.fW=cell(luP,20);
CSDica.rW=cell(luP,20);
CSDica.KDW=cell(luP,20);
[b,a]=butter(4,[30 200]/625,'bandpass');


    %%
    oLFP=LFP;
%%
    [z, p, kk] = butter(4,[4 400]/625,'bandpass');
sos=zp2sos(z,p,kk);
    LFP=sosfilt(sos,oLFP);
%%
for k=1:luP
    %%
    close all
    k=400;%randi(luP,1,1)
    cth=.98;
    lcompn=0;
    t=uPeriod(k,1):uPeriod(k,2);
%     t=t(1:40300);%:end
    nt=length(t)
    
a=[-2*LFP(t,[2,end-1])+LFP(t,[1,end-2])+LFP(t,[3,end]),sum(LFP(t,[2,end-1])-LFP(t,[1,end]),2)];
C=cov(a);
Uz=C\a'*LFP(t,:)/nt;
exactivity=a*Uz;
inactivity=LFP(t,:)-exactivity;

csd{k}=((inactivity(:,1:(end-2))-2*inactivity(:,2:(end-1))+inactivity(:,3:end)));
% csd{k}=LFP(t,2:(end-1));
% csd{k}=filtfilt(b,a,csd{k});

[u,v,~]=svd(cov(csd{k}));
tracev=trace(v);
if lcompn
    temp_d=1:6;
else
temp_d=diag(v)'/tracev*triu(ones(nhp-2))<cth ;%| [true(1,size(wo,1)),false(1,14-size(wo,1))];
end
activity_new=csd{k}*u(:,temp_d);
tic
% for kk=1:10
figure;
W=KDICA(activity_new');%,'W0',wo
% wo=W;
W_in=u(:,temp_d)*W';
icasig1=W*activity_new';
subplot(133);plot(HP(2:(end-1)),bsxfun(@plus,W_in*500,2*[1:size(W_in,2)]),'o-')
axis tight
grid on
set(gca,'XTick',HP(2:(end-1)),'XTickLabel',layer_show(HP(2:(end-1))-70))
[weights,~,~,~,~,~,~] = runica(activity_new','sphering','off','stop',1e-4,'verbose','off','weights',W);%20);,'weights',weights{k-1}
W_in=u(:,temp_d)*weights';
subplot(132);plot(HP(2:(end-1)),bsxfun(@plus,W_in*500,2*[1:size(W_in,2)]),'o-')
set(gca,'XTick',HP(2:(end-1)),'XTickLabel',layer_show(HP(2:(end-1))-70))
grid on
axis tight
[icasig, A, W] = fastica(activity_new','initGuess',inv(W));
W_in=u(:,temp_d)*W';
subplot(131)
plot(HP(2:(end-1)),bsxfun(@plus,W_in*500,2*[1:size(W_in,2)]),'o-')
axis tight
grid on
set(gca,'XTick',HP(2:(end-1)),'XTickLabel',layer_show(HP(2:(end-1))-70))
axis tight
ncomp=size(icasig,1);

for kk=1:ncomp
    [coh,ff] = mtchd(zscore(inactivity(:,kk))',2^8,1250,2^7,[],1,'linear',[],[20 200]);
    if kk==1
        co=repmat(reshape(sq(coh),1,[]),ncomp,1);
    else 
        co(kk,:)=sq(coh);
    end
end
figure;

subplot(211);plot(ff,co)
axis tight
ffticasig=fft(icasig');
subplot(212);plot((1:ceil(200*length(ffticasig)/1250))*1250/length(ffticasig),abs(ffticasig(1:ceil(200*length(ffticasig)/1250),:)))
axis tight

icacorr=zeros(41,ncomp,ncomp);
for kk=1:ncomp
    for n=kk:ncomp
    icacorr(:,kk,n)=xcorr(icasig(kk,:)',icasig(n,:)',20);
    figure(33)
    subplot(ncomp,ncomp,(kk-1)*ncomp+n)
    plot(-20:20,sq(icacorr(:,kk,n)))
    axis tight
    end
end
icacorr1=zeros(41,ncomp,ncomp);
for kk=1:ncomp
    for n=kk:ncomp
    icacorr1(:,kk,n)=xcorr(icasig1(kk,:)',icasig1(n,:)',20);
    figure(43)
    subplot(ncomp,ncomp,(kk-1)*ncomp+n)
    plot(-20:20,sq(icacorr1(:,kk,n)))
    axis tight
    end
end
% %%
% figure;plot(t-t(1),bsxfun(@plus,inactivity/10000,HP'))
% %% here I try the time-special ICA
% figure;
%%
lgn=[3 1];%1;
[u,v,~]=svd(cov(STmatrix(csd{k},lgn)));
tracev=trace(v);
activity_new=STmatrix(csd{k},lgn)*u(:,diag(v)'/tracev*triu(ones(3*(nhp-2)))<cth);
W=KDICA(activity_new');
W_in=u(:,diag(v)'/tracev*triu(ones(3*(nhp-2)))<cth)*W';
% figure
% for kcomp=1:size(W,1)
%     subplot(1,size(W,1),kcomp)
%     imagesc(1:3,HP(2:(end-1)),reshape(u(:,kcomp),14,[]))%W_in
%     set(gca, 'YTick',HP(2:(end-1)),'YTicklabel',layer_show(HP(2:(end-1))))
% end

figure
ls={'o-','+-',':'};
for k=1:3
    subplot(121)
plot(HP(2:(end-1)),bsxfun(@plus,W_in(((k-1)*14+1):(k*14),:)*3000,2*[1:size(W_in,2)]),ls{k})
hold on
axis tight
set(gca, 'XTick',HP(2:(end-1)),'XTicklabel',layer_show(HP(2:(end-1))-70))
subplot(122)
plot(HP(2:(end-1)),bsxfun(@plus,u(((k-1)*14+1):(k*14),1:size(W,1))*3,2*[1:size(W_in,2)]),ls{k})
hold on
axis tight 
set(gca, 'XTick',HP(2:(end-1)),'XTicklabel',layer_show(HP(2:(end-1))-70))
end
%%
icasig1=W*activity_new';
subplot(122);plot(HP(2:(end-1)),bsxfun(@plus,W_in*1000,2*[1:size(W_in,2)]),'o-')
axis tight
grid on
set(gca,'XTick',HP(2:(end-1)),'XTickLabel',layer_show(HP(2:(end-1))))
[icasig, A, W] = fastica(activity_new','initGuess',inv(W));
W_in=u(:,diag(v)'/tracev*triu(ones(nhp-2))<cth)*W';
subplot(121)
plot(HP(2:(end-1)),bsxfun(@plus,W_in*1000,2*[1:size(W_in,2)]),'o-')
axis tight
grid on
set(gca,'XTick',HP(2:(end-1)),'XTickLabel',layer_show(HP(2:(end-1))))
% [weights,~,~,~,~,~,~] = runica(activity_new','sphering','off','stop',1e-4,'verbose','off','weights',W);%20);,'weights',weights{k-1}
% W_

%%
% [coh,ff] = mtchd(icasig,2^8,1250,2^7,[],1,'linear',[],[55 200]);
% toc
% end

    csd{k}=(LFP(t,1:(end-2))-2*LFP(t,2:(end-1))+LFP(t,3:end));
if showsignal
figure(1);
    subplot(211)
    imagesc(t, HP, cLFP(t,:)')
    subplot(212)
    imagesc(t, HP, csd{k}')
    pause
end
end
% weights=cell();
% icasig=cell(13,1);signs,~,activations
% for k=1:13
t=uPeriod(end,1):uPeriod(end,2);

var(icasig')
figure;imagesc(1:8,HP(2:(end-1)),W_in)
figure(15);plot(HP(2:(end-1)),bsxfun(@plus,W_in*1000,[1:8]),'o-')
hold on;plot([18 31],repmat(1:8,2,1))
end
[weights,~,icasig,~,signs,~,activations] = runica(activity_new','sphering','off','stop',1e-4,'verbose','off');%20);,'weights',weights{k-1}

set(gca,'XTick',1:14,'XTickLabel',diag(v)'/tracev)
figure;plot(1:14,diag(v)'/tracev*triu(ones(nhp-2)))