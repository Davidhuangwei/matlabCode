
clear all
close all
FileBase='4_16_05_merged';
a=40;
b=[8,12,15,20]';%3,5,:5:30
nfr=length(b);
FreqBins=[a-b,a+b];
% load('/gpfs01/sirota/data/bachdata/data/weiwei/m_sm/4_16_05_merged_par.mat');
% repch=RepresentChan(Par);
load /storage/antsiro/data/blab/sm96_big/4_16_05_merged/ChanInfo/ChanLoc_Full.eeg.mat
Layers=fieldnames(chanLoc);
layer_show=zeros(16,6);
for n=1:length(Layers)
    layer_show(chanLoc.(Layers{n}))=n;
end
Par.lfpSampleRate=1250;
Par.nChannels=97;
cd(['/storage/antsiro/data/blab/sm96_big/', FileBase])
StatePeriod = load([FileBase '.sts.SWS']);
nprd=size(StatePeriod,1);
% Channels=[37,78];
HP=[33:44];%find(layer_show(:,1));find(layer_show(:)==7)
lfp = LoadBinary([FileBase '.lfp'],HP,97,2,[],[],StatePeriod)';% Par.nChannelsas loadinary don't take careof overlap of periods
FS =1250;% Par.lfpSampleRate;

%%
nlfp=lfp;%(:,HP);
rlfp=ButFilter(nlfp,4,[140 220]/625,'bandpass');
ripple=abs(hilbert(rlfp(:,3)));
%%
nhp=length(HP);
xloc=findpeaks(ripple);
xloc=xloc.loc;
xloc=xloc(ripple(xloc)>prctile(ripple,70));
nrlfp=ButFilter(nlfp,4,[4 120]/625,'bandpass');
nrlfp(:,3)=rlfp(:,3);
cthr=6;
%
% B=cell(luP,1);
%         sA=cell(luP,1);
%         %
%         jdfr=[35:10:120];
%         for k=1:luP
%             [B{k}, cc]=SSpecJAJD(nrlfp(Period(k,1):Period(k,2),[1:2,4:nhp]),1250,400,400,jdfr,100,cthr,0);
%             sA{k}=pinv(B{k});% lambda/B{k}
%             fprintf('%d-',k)
%         end
% %         [~,lp]=max(Period(:,2)-Period(:,1));
%         [gB, gc]=SSpecJAJD(nrlfp(Period(5,1):Period(10,2),[1:2,4:nhp]),1250,400,400,jdfr,100,cthr,0);
%         gsA=pinv(gB);%lambda/gB
% [nm,lost,dists]=ClusterCompO(gsA,sA,.1);
% % 
%%
Period=ReshapePeriod(StatePeriod);
luP=size(StatePeriod,1);
FreqBins=[20 45;30 55;40 65; 50 90;90 120];
nhp=length(HP);
EC=HP;
r=2;%1.5
theta=[1 1 1.5];%[
lambda=.01;
% cthr=.97;%4
cthr=8;
Par.r=r;
Par.lambda=lambda;
Par.theta=theta;
Par.cthr=cthr;
for kfr=1:size(FreqBins,1)
    %% 
nlfp=ButFilter(lfp,4,[FreqBins(kfr,1),220]/625,'bandpass');
luP=size(Period,1);
%
% dlfp=diff(nlfp,1,1);
dlfp=mkCSD(nlfp,r,EC,EC,lambda,theta);
A=cell(luP,1);
W=cell(luP,1);
rW=cell(luP,1);
Sep=cell(luP+1,2);
vMI=cell(luP+1,2);
rMI=cell(luP+1,2);
for k=1:luP
    sigtmp=dlfp(Period(k,1):min(Period(k,2),size(dlfp,1)),:);
tsigtmp=Zscore(sigtmp,1);
takesig=sum(bsxfun(@ge,tsigtmp,prctile(abs(tsigtmp),10)),2)>0;
 
    [~, A{k}, W{k}, ~]=wKDICA(sigtmp(takesig,:)',cthr,0,0,0);%.999
% [W{k}, ~]=SSpecJAJD(sigtmp(takesig,:),1250,400,400,[45 70 90 140 180],100,cthr,0);%.999
[vMI{k,2},R,rW{k}, rMI{k,2}]=RefinICsRot(W{k},sigtmp(takesig,:),[],50);
 [Sep{k,1},~]=ReliabilityICtest(W{k},sigtmp(takesig,:),20,min(25000,sum(takesig)));
 [Sep{k,2},~]=ReliabilityICtest(rW{k},sigtmp(takesig,:),20,min(25000,sum(takesig)),3);
% A{k}=pinv(W{k});
figure(234)
 [vMI{k,1}, rR, rMI{k,1}]=UniqICtest(W{k},dlfp(Period(k,1):min(Period(k,2),size(dlfp,1)),:));%ButFilter(,4,[60 220]/625,'bandpass')
fprintf('%d-',k)
end
[~, gA, gW, ~]=wKDICA(dlfp(Period(5,1):Period(10,2),:)',cthr,0,0,0);%.999
[vMI{end,2},R,grW, rMI{end,2}]=RefinICsRot(gW,dlfp(Period(5,1):Period(10,2),:),[],50);
 [vMI{end,1}, rR, rMI{end,1}]=UniqICtest(gW,dlfp(Period(5,1):Period(10,2),:));
% [gW, ~]=SSpecJAJD(dlfp(Period(5,1):min(Period(10,2),size(dlfp,1)),:),1250,400,400,[30 50 70 90 140 180],100,cthr,0);%.999
[Sep{end,1},~]=ReliabilityICtest(gW,dlfp(Period(5,1):Period(10,2),:),20,25000);
 [Sep{end,2},~]=ReliabilityICtest(grW,dlfp(Period(5,1):Period(10,2),:),20,25000,3);
grA=pinv(grW);

S(kfr).A=A;
S(kfr).W=W;
S(kfr).rW=rW;
S(kfr).vMI=vMI;
S(kfr).rMI=rMI;
S(kfr).Sep=Sep;
S(kfr).cthr=cthr;
S(kfr).grW=grW;
S(kfr).gW=gW;
S(kfr).grA=grA;
S(kfr).gA=gA;

cd /storage/weiwei/data/4_16_05_merged/
save('4_16_05_merged.highP.rot.SWS.mat','S','FreqBins','HP','Layers','layer_show','Par')

if 0

% old things... 
%%
nrlfp=ButFilter(nlfp,4,[FreqBins(kfr,1),220]/625,'bandpass');
% clfp=[];
A=cell(luP,1);
W=cell(luP,1);
nhp=length(HP);
cthr=.99;
for k=1:luP
    [~, A{k}, W{k}, ~]=wKDICA(nrlfp(Period(k,1):Period(k,2),[1:2,4:nhp])',cthr,0,0,0);%.999
end
[~, gA, gW, ~]=wKDICA(nrlfp(Period(5,1):Period(10,2),[1:2,4:nhp])',cthr,0,0,0);%.999
% 
%         %
        [nm,lost,dists]=ClusterCompO(gA,A,.1);
        lnm=length(nm);
        ny=zeros(length(HP)-1,lnm);
%         muny=zeros(length(HP),lnm);
%%
for k=1:lnm
    fd=sum(nm{k}.^2,1)>10^-8;
    nmD=sum(fd);
    if nmD>0
        dt=bsxfun(@times,bsxfun(@rdivide,nm{k}(:,fd),sqrt(sum(nm{k}(:,fd).^2,1))),sign(gA(:,k)'*nm{k}(:,fd)));
        ny(:,k)=mean(dt,2);%GaussionProcessRegression(repmat(nx,nmD,1),dt(:),.8,.00001,nxx(:));
        %                 thetav=sqrt(var(dt,2));
        %                 muny(:,k)=thetam*ny(:,k)*nmD./(thetam*nmD+thetav);
        if 1
            figure(25+kfr)
            subplot(1,lnm, k)%length(r),lnm,k+(nr-1)*lnm
            plot(dt,1:(nhp-1))%HP([1:2,4:nhp]
            %                 set(gca,'YTick',ylbs,'YTicklabel',names)
            hold on
            plot(ny(:,k),1:(nhp-1),'b','Linewidth',3)%HP([1:2,4:nhp]
            %                 plot(muny(:,k),HP,'g--','Linewidth',3)
            grid on
            axis([-.5 .5 1 nhp-1])%HP(1) HP(end)
            title(['comp.',num2str(k)])
            xlabel(num2str(sum(fd)))
            set(gca,'Ytick',1:nhp,'YtickLabel',HP([1:2,4:nhp]))
            %    axis ij
            hold off
            n=n+1;
        end
    end
end
ForAllSubplots('axis xy')
ForAllSubplots('axis ij')
clfp=nrlfp(:,[1:2,4:nhp])*pinv(ny)';%ButFilter(,4,FreqBins(kfr,:)/625,'bandpass')
CheckLFP(clfp,[],[],xloc);
end
end
%%
dlfp=diff(ButFilter(nlfp,4,[30 300]/625,'bandpass'),1,1);
r=8;%1.5
theta=[1 1 1.5];%[
lambda=.01;
dlfp=mkCSD(dlfp(:,[1:2,4:nhp]),r,HP([1:2,4:nhp]),HP,lambda,theta);
A=cell(luP,1);
W=cell(luP,1);
nhp=length(HP);
cthr=.998;
for k=1:luP
    [~, A{k}, W{k}, ~]=wKDICA(dlfp(Period(k,1):min(Period(k,2),size(dlfp,1)),[1:2,4:nhp])',cthr,0,0,0);%.999
end
[~, gA, gW, ~]=wKDICA(dlfp(Period(5,1):Period(10,2),[1:2,4:nhp])',cthr,0,0,0);%.999
% 
%         %
        [nm,lost,dists]=ClusterCompO(gA,A,.1);
        lnm=length(nm);
        ny=zeros(length(HP)-1,lnm);
%         muny=zeros(length(HP),lnm);
%
for k=1:lnm
    fd=sum(nm{k}.^2,1)>10^-8;
    nmD=sum(fd);
    if nmD>0
        dt=bsxfun(@times,bsxfun(@rdivide,nm{k}(:,fd),sqrt(sum(nm{k}(:,fd).^2,1))),sign(gA(:,k)'*nm{k}(:,fd)));
        ny(:,k)=mean(dt,2);%GaussionProcessRegression(repmat(nx,nmD,1),dt(:),.8,.00001,nxx(:));
        %                 thetav=sqrt(var(dt,2));
        %                 muny(:,k)=thetam*ny(:,k)*nmD./(thetam*nmD+thetav);
        if 1
            figure(25+kfr)
            subplot(1,lnm, k)%length(r),lnm,k+(nr-1)*lnm
            plot(dt,1:(nhp-1))%HP([1:2,4:nhp]
            %                 set(gca,'YTick',ylbs,'YTicklabel',names)
            hold on
            plot(ny(:,k),1:(nhp-1),'b','Linewidth',3)%HP([1:2,4:nhp]
            %                 plot(muny(:,k),HP,'g--','Linewidth',3)
            grid on
            axis([-.5 .5 1 nhp-1])%HP(1) HP(end)
            title(['comp.',num2str(k)])
            xlabel(num2str(sum(fd)))
            set(gca,'Ytick',1:nhp,'YtickLabel',HP([1:2,4:nhp]))
            %    axis ij
            hold off
            n=n+1;
        end
    end
end
ForAllSubplots('axis xy')
ForAllSubplots('axis ij')
ncomp=size(ny,2);
%
[ygch f phgch] = mtchd(mkCSD(ButFilter(nlfp(:,[1:2,4:nhp]),4,[14 300]/625,'bandpass'),r,HP([1:2,4:nhp]),HP([1:2,4:nhp]),lambda,theta)*pinv(ny)',2^9,1250,2^8,2^7,[],0,[],[20 230]);  
%
powers=zeros(ncomp,length(f));
for k=1:ncomp
figure(256);
subplot(2,5,k)
imagesc(f,[],bsxfun(@times,f'.^2,sq(ygch(:,k,:))'))
powers(k,:)=sq(ygch(:,k,k))'.*(f'.^2);
hold on
plot(f',ncomp- ncomp*powers(k,:)/max(powers(k,:)),'w')
set(gca,'XTick',20:10:220)
grid on
hold off
end
csd=diff(ny,2,1);
figure;imagesc(csd,max(abs(csd(:)))*[-1 1])
set(gca,'Ytick',1:nhp,'YtickLabel',HP([1:2,4:nhp]))
figure;imagesc(layer_show)

%%
icasig=mkCSD(nlfp(:,[1:2,4:nhp]),r,HP([1:2,4:nhp]),HP([1:2,4:nhp]),lambda,theta)*pinv(ny)';
%%
CheckLFP(icasig)
load 4_16_05_merged.thpar.mat
theta=false(size(ThPh));
for k=1:luP
    theta(StatePeriod(k,1):StatePeriod(k,2))=true;
end
%%
myTh=ThPh(theta);
FreqBins=bsxfun(@plus,[30:5:250]',[-1 6]);
nfr=size(FreqBins,1);
PhaseAmpLoc=zeros(nfr,size(icasig,2));
for k=1:nfr
    tmp=abs(hilbert(ButFilter(icasig,4,FreqBins(k,:)/625,'bandpass')));
    PhaseAmpLoc(k,:)=sum(bsxfun(@times,tmp,exp(i*myTh)),1)./sum(tmp,1);%;%
end
figure
imagesc([],mean(FreqBins,2),abs(PhaseAmpLoc),[0 .015])
figure
imagesc([],mean(FreqBins,2),angle(PhaseAmpLoc),[-pi pi])