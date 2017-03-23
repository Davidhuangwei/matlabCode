clear all
cd /storage/antsiro/data/blab/sm96_big/4_16_05_merged/
icStates='SWS';
Period=load(['4_16_05_merged.sts.', icStates]);
FS = 1250;
FileBase='4_16_05_merged';
load('/storage/antsiro/data/blab/sm96_big/4_16_05_merged/ChanInfo/ChanLoc_Full.eeg.mat')
Layers=fieldnames(chanLoc);
layer_show=zeros(16,6);
for n=1:length(Layers)
    layer_show(chanLoc.(Layers{n}))=n;
end
Par.layer_show=layer_show;
Par.Layers=Layers;
% Par=LoadXml(FileBase);
%%
r=9;
theta=[1.5 1 1];
lambda=.0001;
FreqBins=[4 100;30 55;50 90; 80, 120;140 200];%[4 30; 30 60;35 90; 55 120;130 200];
nfr=size(FreqBins,1);
FreqB=[3 300];%



oPeriod=Period;
Period=ReshapePeriod(Period);
nt=Period(end);
% uPeriod=[Period(:,2)-Period(:,1)]>1250*2;
% luP=sum(uPeriod);
% if size(uPeriod,2)<2
% uPeriod=Period(uPeriod,:);
% [~,od]=sort(uPeriod(:,2)-uPeriod(:,1));
% uPeriod=uPeriod(od,:);
% end
nPeriod=Period;
Period=bsxfun(@plus, 1:12500:(nt-25000),[0 25000]')';
cthr=.996;
Par.r=r;
Par.cthr=cthr;
Par.FreqB=FreqB;
Par.FreqBins=FreqBins;
Par.theta=theta;
Par.lambda=lambda;
% Period=[nPeriod(1:(end-1),1), ceil((nPeriod(1:(end-1),2)+nPeriod(2:end,2))/2)];
luP=size(Period,1);
Par.jdfr=cell(nfr,1);
ifplot=1;
usespec=1;
useica=1;
%%
% nhp=length(HP);
for sk=2:6
HP=16*(sk-1)+[1:16]';
gCh=HP;
Par.gCh=gCh;
Par.HP=HP;
nhp=length(HP);
cd /storage/antsiro/data/blab/sm96_big/4_16_05_merged/
lfp= LoadBinary([FileBase '.lfp'],HP,96,2,[],[],oPeriod)';
ripple=abs(hilbert(ButFilter(lfp(:,chanLoc.ca1Pyr(sk)-HP(1)+1),4,[140 200]/625,'bandpass')));
xloc=findpeaks(ripple);
xloc=xloc.loc;
xloc=xloc((ripple(xloc)>prctile(ripple,80))&(ripple(xloc)<prctile(ripple,99)));
Par.ripple=xloc;
arlfp=ripple(xloc);
Par.arlfp=arlfp;
%% resample the ripples to make a flat distribution. 
[N,edges,bin]=histcount(ripple(xloc),100); bin=max(bin-1,1);
xloc=xloc.*(rand(size(bin))<(6*log(N(bin)')./N(bin)')); 
xloc=xloc(xloc>0);
arlfp=ripple(xloc);
rlfp=zeros(length(xloc),16,nfr);
rw=[];
sw=[];
gw=[];
for kfr=1:nfr
jdfr=(FreqBins(kfr,1)+3):fix(diff(FreqBins(kfr,:))/6):FreqBins(kfr,2);%35:10:9045:10:100;%[35:10:130];% [45 65 85];[7:5:20][65:10:120]
Par.jdfr{kfr}=jdfr;
%% LFP=diff(LFP,1,1);
    LFP=ButFilter(lfp,4,FreqBins(kfr,:)/625,'bandpass');
    LFP=mkCSD(LFP,r,gCh,HP,lambda,theta);% compute CSD here.(nr)
    rlfp(:,:,kfr)=LFP(xloc,:);
    %
    % no whithen considered.
    % Have a example of time-frequency method... 
    % jdfr=(FreqB(1)+5):20:FreqB(2);
    if usespec
        % using frequency method
        B=cell(luP,1);
        sA=cell(luP,1);
        %%
        % jdfr=[35:10:90, 115:10:150];
        for k=1:luP
            [B{k}, cc]=SSpecJAJD(LFP(Period(k,1):Period(k,2),:),1250,400,400,jdfr,100,cthr,0);
            sA{k}=pinv(B{k});% lambda/B{k}
            fprintf('%d-',k)
        end
        [~,lp]=max(Period(:,2)-Period(:,1));
        [gB, gc]=SSpecJAJD(LFP(Period(5,1):Period(10,2),:),1250,400,400,jdfr,100,cthr,0);
        gsA=pinv(gB);%lambda/gB
        gcc=zeros(size(gc,1),length(jdfr),size(gc,4));
        for n=1:size(gc,1)
            gcc(n,:,:)=gc(n,n,:,:);
        end
        %%
        [nm,lost,dists]=ClusterCompO(gsA,sA,.1);
        lnm=length(nm);
        %%
        thetam=.0001;
        ny=zeros(length(HP),lnm);
%         muny=zeros(length(HP),lnm);
        for k=1:lnm
            fd=sum(nm{k}.^2,1)>10^-8;
            nmD=sum(fd);
            if nmD>0
                dt=bsxfun(@times,bsxfun(@rdivide,nm{k}(:,fd),sqrt(sum(nm{k}(:,fd).^2,1))),sign(gsA(:,k)'*nm{k}(:,fd)));
                ny(:,k)=mean(dt,2);%GaussionProcessRegression(repmat(nx,nmD,1),dt(:),.8,.00001,nxx(:));
%                 thetav=sqrt(var(dt,2));
%                 muny(:,k)=thetam*ny(:,k)*nmD./(thetam*nmD+thetav);
if ifplot
                figure(24)
                subplot(1,lnm, k)%length(r),lnm,k+(nr-1)*lnm
                plot(dt,HP)
%                 set(gca,'YTick',ylbs,'YTicklabel',names)
                hold on
                plot(ny(:,k),HP,'b','Linewidth',3)
%                 plot(muny(:,k),HP,'g--','Linewidth',3)
                grid on
                axis([-.5 .5 HP(1) HP(end)])
                title(['comp.',num2str(k)])
                xlabel(num2str(sum(fd)))
                %    axis ij
                hold off
                n=n+1;
end
            end
        end
        gbsnm=ny;%(fix(1:((length(nxx)-1)/(length(HP)-1)):length(nxx)),:);
        ForAllSubplots('axis xy')
        ForAllSubplots('axis ij')
        S(kfr).snm=nm;
      S(kfr).gbsnm=gbsnm;
      S(kfr).B=B;
      S(kfr).sA=sA;
      S(kfr).gsA=gsA;
      S(kfr).gB=gB;
      [rfw,rfA]=RefineICsFrIC(LFP,pinv(gbsnm)',cthr);
      S(kfr).rfw=rfw;
      S(kfr).rfA=rfA;
      [S(kfr).MI,S(kfr).smi]=PairwiseInformation(LFP,pinv(gbsnm)');
      [S(kfr).nMI,S(kfr).snmi]=PairwiseInformation(LFP,rfw);
    end
    if useica
        % using frequency method
        A=cell(luP,1);
        W=cell(luP,1);
        %%
        % jdfr=[35:10:90, 115:10:150];
        for k=1:luP
            try
            [~, A{k}, W{k}, m]=wKDICA(LFP(Period(k,1):Period(k,2),:)',cthr,0,0,0);%.999
            catch 
                A{k}=[];
                W{k}=[];
            end
            fprintf('%d-',k)
        end
        [~, gA, gW, m]=wKDICA(LFP(Period(5,1):Period(10,2),:)',cthr,0,0,0);%.999
        %%
        [nm,lost,dists]=ClusterCompO(gA,A,.1);
        lnm=length(nm);
        %%
        thetam=.0001;
        ny=zeros(length(HP),lnm);
%         muny=zeros(length(HP),lnm);
for k=1:lnm
    fd=sum(nm{k}.^2,1)>10^-8;
    nmD=sum(fd);
    if nmD>0
        dt=bsxfun(@times,bsxfun(@rdivide,nm{k}(:,fd),sqrt(sum(nm{k}(:,fd).^2,1))),sign(gA(:,k)'*nm{k}(:,fd)));
        ny(:,k)=mean(dt,2);%GaussionProcessRegression(repmat(nx,nmD,1),dt(:),.8,.00001,nxx(:));
        %                 thetav=sqrt(var(dt,2));
        %                 muny(:,k)=thetam*ny(:,k)*nmD./(thetam*nmD+thetav);
        if ifplot
            figure(25)
            subplot(1,lnm, k)%length(r),lnm,k+(nr-1)*lnm
            plot(dt,HP)
            %                 set(gca,'YTick',ylbs,'YTicklabel',names)
            hold on
            plot(ny(:,k),HP,'b','Linewidth',3)
            %                 plot(muny(:,k),HP,'g--','Linewidth',3)
            grid on
            axis([-.5 .5 HP(1) HP(end)])
            title(['comp.',num2str(k)])
            xlabel(num2str(sum(fd)))
            %    axis ij
            hold off
            n=n+1;
        end
    end
end
        gbsnm=ny;%(fix(1:((length(nxx)-1)/(length(HP)-1)):length(nxx)),:);
        ForAllSubplots('axis xy')
        ForAllSubplots('axis ij')
        S(kfr).wnm=nm;
      S(kfr).gbwnm=gbsnm;
      S(kfr).A=A;
      S(kfr).W=W;
      S(kfr).gA=gA;
      S(kfr).gW=gW;
%       [rfw,rfA]=RefineICsFrIC(LFP,pinv(gbsnm)',.983);
%       S(kfr).rfw=rfw;
%       S(kfr).rfA=rfA;
      [S(kfr).wMI,S(kfr).smi]=PairwiseInformation(LFP,pinv(gbsnm)');
%       [S(kfr).nMI,S(kfr).snmi]=PairwiseInformation(LFP,rfw);
    end
    % CheckCSD(LFP,gsnm,gsnmw,HP,st(1:(end-10)))
    % CheckCSD(LFP,gbsnm,pinv(gbsnm)',HP,st(1:(end-10)))
    % return
% end
      rw=[rw,S(kfr).rfw'];
      sw=[sw,pinv(S(kfr).gbsnm)'];
      gw=[gw,pinv(S(kfr).gbwnm)'];
end
%%
nrlfp=[];
for kfr=1:nfr
    nrlfp=[nrlfp,sq(rlfp(:,:,kfr))*S(kfr).rfw'];
end
[Par.rStat, Par.rpval]=GroupUIndtest(arlfp,nrlfp,eye(size(rw,2)));
fprintf('end refine')
nrlfp=[];
for kfr=1:nfr
    nrlfp=[nrlfp,sq(rlfp(:,:,kfr))*pinv(S(kfr).gbsnm)'];
end
[Par.sStat, Par.spval]=GroupUIndtest(arlfp,nrlfp,eye(size(sw,2)));
fprintf('end s')
nrlfp=[];
for kfr=1:nfr
    nrlfp=[nrlfp,sq(rlfp(:,:,kfr))*pinv(S(kfr).gbwnm)'];
end
[Par.gStat, Par.gpval]=GroupUIndtest(arlfp,nrlfp,eye(size(gw,2)));
% Par.ylbs=ylbs;
% Par.names=names;
Par.icStates=icStates;
cd(['/storage/weiwei/data/', FileBase])
sname=sprintf([FileBase,'.SICs.', icStates, 'n.sk%d.r%.1f.mat'],sk,r);
save(sname,'Par','S')
% out=CheckResInStatesNI(FileBase,'RUN',Par,S);

fprintf('finish shank %d\n', sk)
end


return












































%%
%%
% lfp=ButFilter(LFP,4,[4 300]/625,'bandpass');
% CheckLFP(nlfp)

% [~, A, W, m]=wKDICA(nlfp',.9999,0,0,0);%
%% 
% nlfp=lfp(Period(1,1):Period(5,1),1:16);
% [~, A, W, m]=wKDICA(nlfp',16,0,0,0);%
% for k=1:6
% nlfp(:,(k-1)*16+[1:16])=mkCSD(nlfp(:,(k-1)*16+[1:16]),r,1:16,1:16,lambda,theta);
% end
% [u,s,~]=svd(cov(nlfp));
% s=diag(s);
% logl=-2*log(s);
% s=sum(A.^2,1)/sum(s)*length(s);
% bic=size(nlfp,1)*log(s*(ones(length(s))-triu(ones(length(s))))/size(nlfp,1))+[1:length(s)]*log(size(nlfp,1));
% [u, k, L]=PCAmodelSelection(nlfp);
% [u,s,~]=svd(cov(nlfp));
% s=diag(s);
% nlfp=nlfp*(u(:,1:30));
% m=7;
% [lambda,psi,T,stats]=factoran(nlfp',m);
%     bic=-2*stats.loglike+m*log(N);
%     obic=bic+10^-4;
%     while (bic<obic)&&(m<mm)
%         m=m+1;
%         obic=bic;
%         [~,~,~,stats]=factoran(nlfp',m);
%         bic=-2*stats.loglike+m*log(N);
%     end
%     m=m-1;
%     [lambda,psi,T,stats,xc]=factoran(nlfp',m);
%%
nlfp=mkCSD(lfp(:,1:16),r,1:16,1:16,lambda,theta);
luP=size(Period,1);
A=cell(luP,1);
W=cell(luP,1);
for k=1:luP
    [~, A{k}, W{k}, m]=wKDICA(nlfp(Period(k,1):Period(k,2),:)',.996,0,0,0);%.999
    fprintf('%d-',k)
end
[~, gA, gW, m]=wKDICA(nlfp(Period(1,1):Period(5,2),:)',.996,0,0,0);%.999
%%
[nm,lost,dists]=ClusterCompO(gA,A,.1);
% [snm, mD, id]=ClusterComp(A{16},cell2mat(A'),.1,0);
[~,xloc]=SinkLoc(nm);
[~,aaa]=sort(xloc);
%%
r=9;
theta=[1.5 1 1];
lambda=.0001;
nsnm=mkCSD(bsxfun(@rdivide,snm,sqrt(sum(snm.^2,1)))',r,1:16,1:16,lambda,theta)';

for k=1:size(snm,2)
    figure(3)
    subplot(3,20,k)
    plot(nsnm(:,aaa(k)),1:16);
    hold on
    plot([0 0], [1 16],'r:')
    title(num2str(sum(mD==aaa(k))))
    axis tight
    hold off
end
ForAllSubplots('axis xy')
        ForAllSubplots('axis ij')
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

%%
for k=1:luP
    %%
    close all
    k=luP-2%randi(luP,1,1)
    cth=.96;
%     t=uPeriod(k,1):uPeriod(k,2);
%     t=t(1:40300);%:end
    nt=length(t);
    
a=[-2*LFP(t,[2,end-1])+LFP(t,[1,end-2])+LFP(t,[3,end]),sum(LFP(t,[2,end-1])-LFP(t,[1,end]),2)];
C=cov(a);
Uz=C\a'*LFP(t,:)/nt;
exactivity=a*Uz;
inactivity=LFP(t,:)-exactivity;

csd{k}=((inactivity(:,1:(end-2))-2*inactivity(:,2:(end-1))+inactivity(:,3:end)));
% csd{k}=filtfilt(b,a,csd{k});inactivity;%1:3;%

[u,v,~]=svd(cov(csd{k}));
tracev=trace(v);
temp_d=diag(v)'/tracev*triu(ones(size(csd{k},2)))<cth ;%| [true(1,size(wo,1)),false(1,14-size(wo,1))];
mcsd=mean(csd{k},1);
activity_new=bsxfun(@minus, csd{k},mcsd)*u(:,temp_d);%1:4;%
tic
% for kk=1:10
figure(8);
W=KDICA(activity_new');%,'W0',wo
% wo=W;
W_in=u(:,temp_d)/W;
[~,order]=sort(max(abs(W_in),[],1));
W_in=W_in(:,order);
icasig1=W*activity_new';
icasig1=icasig1(order,:);
subplot(133);plot(HP(2:(end-1)),bsxfun(@plus,bsxfun(@rdivide, W_in,std(W_in,[],1)),2*[1:size(W_in,2)]),'o-')%W_inbsxfun(@plus,bsxfun(@rdivide, W_in,std(W_in,[],1)),2*[1:size(W_in,2)])
axis tight
grid on
set(gca,'XTick',HP(2:(end-1)),'XTickLabel',layer_show(HP(2:(end-1))))
[icasig, A, W] = fastica(activity_new','initGuess',inv(W));
W_in=u(:,temp_d)/W;
[~,order]=sort(max(abs(W_in),[],1));
W_in=W_in(:,order);
icasig=icasig(order,:);
subplot(131)
plot(HP(2:(end-1)),bsxfun(@plus,bsxfun(@rdivide, W_in,std(W_in,[],1)),2*[1:size(W_in,2)]),'o-')%bsxfun(@plus,bsxfun(@rdivide, W_in,std(W_in,[],1)),2*[1:size(W_in,2)])
axis tight
grid on
set(gca,'XTick',HP(2:(end-1)),'XTickLabel',layer_show(HP(2:(end-1))))
[weights,~,~,~,~,~,~] = runica(activity_new','sphering','off','stop',1e-4,'verbose','off','weights',W);%20);,'weights',weights{k-1}
W_in=u(:,temp_d)/weights;
[~,order]=sort(max(abs(W_in),[],1));
W_in=W_in(:,order);
subplot(132);plot(HP(2:(end-1)),bsxfun(@plus,bsxfun(@rdivide, W_in,std(W_in,[],1)),2*[1:size(W_in,2)]),'o-')%bsxfun(@plus,bsxfun(@rdivide, W_in,std(W_in,[],1)),2*[1:size(W_in,2)])
grid on
axis tight
set(gca,'XTick',HP(2:(end-1)),'XTickLabel',layer_show(HP(2:(end-1))))
ncomp=size(icasig,1);

for kk=1:ncomp
    [coh,ff] = mtchd(zscore(inactivity(:,kk))',2^8,1250,2^7,[],1,'linear',[],[20 200]);
    if kk==1
        co=repmat(reshape(sq(coh),1,[]),ncomp,1);
    else 
        co(kk,:)=sq(coh);
    end
end
figure(9);

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
%%
% figure;plot(t-t(1),bsxfun(@plus,inactivity/10000,HP'))
% %% here I try the time-special ICA
% figure;
lgn=[3 1];%1;
[u,v,~]=svd(cov(STmatrix(csd{k},lgn)));
tracev=trace(v);
activity_new=STmatrix(csd{k},lgn)*u(:,diag(v)'/tracev*triu(ones(3*(nhp-2)))<cth);
W=KDICA(activity_new');
W_in=u(:,diag(v)'/tracev*triu(ones(3*(nhp-2)))<cth)/W;
% figure
% for kcomp=1:size(W,1)
%     subplot(1,size(W,1),kcomp)
%     imagesc(1:3,HP,reshape(u(:,kcomp),14,[]))%W_in
%     set(gca, 'YTick',HP,'YTicklabel',layer_show(HP(2:(end-1))))
% end
figure
ls={'o-','+-',':'};
for k=1:3
    subplot(121)
plot(HP(2:(end-1)),bsxfun(@plus,W_in(((k-1)*14+1):(k*14),:)/500,2*[1:size(W_in,2)]),ls{k})
hold on
axis tight
set(gca, 'XTick',HP(2:(end-1)),'XTicklabel',layer_show(HP(2:(end-1))))
subplot(122)
plot(HP(2:(end-1)),bsxfun(@plus,u(((k-1)*14+1):(k*14),1:size(W,1))*3,2*[1:size(W_in,2)]),ls{k})
hold on
axis tight 
set(gca, 'XTick',HP(2:(end-1)),'XTicklabel',layer_show(HP(2:(end-1))))
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
    imagesc(t, HP(2:(end-1)), cLFP(t,:)')
    subplot(212)
    imagesc(t, HP(2:(end-1)), csd{k}')
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
% end
[weights,~,icasig,~,signs,~,activations] = runica(activity_new','sphering','off','stop',1e-4,'verbose','off');%20);,'weights',weights{k-1}

set(gca,'XTick',1:14,'XTickLabel',diag(v)'/tracev)
figure;plot(1:14,diag(v)'/tracev*triu(ones(nhp-2)))