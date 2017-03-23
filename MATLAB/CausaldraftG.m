clear all
close all
sjn='/storage/gerrit/data/project/GammaBursts/';
FileBase='g09-20120330';%'g10-20130305';% 'g10-20130305'
cd([sjn, FileBase])
load([FileBase, '.par.mat'])

FreqBins=[20 60;35 90; 55 120;130 160];
nfr=size(FreqBins,1);
States={'RUN','REM'};% I need to think of what is the time window in ,'SWS'
Freq=[4 14];
% load([FileBase, '.sts.RUN'])% AWK1
% Period=g09_20120330_sts;
Period=load([FileBase, '.sts.RUN']);
Period=Period(diff(Period,1,2)>5000,:);
nP=size(Period,1);
% clear g09_20120330_sts
load([FileBase, '-LayerLabels.mat'])
FS = Par.lfpSampleRate;
nPeriod=ReshapePeriod(Period);
EC=1:15;
HP=EC;
lfp=LoadBinary([FileBase '.lfpinterp'],EC,96,2,[],[],Period)';
Period=nPeriod;
% CheckLFP(lfp)
%% 
nlfp=ButFilter(lfp,4,[30 220]/625,'bandpass');
luP=size(Period,1);
%
dlfp=diff(nlfp,1,1);
r=8;%1.5
theta=[1 1 1.5];%[
lambda=.01;
dlfp=mkCSD(dlfp,r,EC,EC,lambda,theta);
A=cell(luP,1);
W=cell(luP,1);
rW=cell(luP,1);
nhp=length(HP);
% cthr=.97;%4
cthr=8;
Sep=cell(luP+1,2);
vMI=cell(luP+1,2);
for k=1:luP
    sigtmp=dlfp(Period(k,1):min(Period(k,2),size(dlfp,1)),:);
tsigtmp=Zscore(sigtmp,1);
takesig=sum(bsxfun(@ge,tsigtmp,prctile(abs(tsigtmp),10)),2)>0;
 
    [~, A{k}, W{k}, ~]=wKDICA(sigtmp(takesig,:)',cthr,0,0,0);%.999
% [W{k}, ~]=SSpecJAJD(sigtmp(takesig,:),1250,400,400,[45 70 90 140 180],100,cthr,0);%.999
[vMI{k,2},R,rW{k}]=RefinICsRot(W{k},sigtmp(takesig,:));
 Sep{k,1}=ReliabilityICtest(W{k},sigtmp(takesig,:));
 Sep{k,2}=ReliabilityICtest(rW{k},sigtmp(takesig,:));
% A{k}=pinv(W{k});
figure(234)
 [vMI{k,1}, rR, rMI]=UniqICtest(W{k},dlfp(Period(k,1):min(Period(k,2),size(dlfp,1)),:));%ButFilter(,4,[60 220]/625,'bandpass')
fprintf('%d-',k)
end
[~, gA, gW, ~]=wKDICA(dlfp(Period(5,1):Period(10,2),:)',cthr,0,0,0);%.999
[vMI{end,2},R,grW]=RefinICsRot(gW,dlfp(Period(5,1):Period(10,2),:));
 [vMI{end,1}, rR, rMI]=UniqICtest(gW,dlfp(Period(5,1):Period(10,2),:));
% [gW, ~]=SSpecJAJD(dlfp(Period(5,1):min(Period(10,2),size(dlfp,1)),:),1250,400,400,[30 50 70 90 140 180],100,cthr,0);%.999
Sep{end,1}=ReliabilityICtest(gW,dlfp(Period(5,1):Period(10,2),:));
 Sep{end,2}=ReliabilityICtest(grW,dlfp(Period(5,1):Period(10,2),:));
grA=pinv(grW);
%%
%         %
        [nm,lost,dists]=ClusterCompO(gA,A,.1);
        lnm=length(nm);
        ny=zeros(length(HP),lnm);
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
            figure(25)
            subplot(1,lnm, k)%length(r),lnm,k+(nr-1)*lnm
            plot(dt,1:nhp)%HP([1:2,4:nhp]
            %                 set(gca,'YTick',ylbs,'YTicklabel',names)
            hold on
            plot(ny(:,k),1:nhp,'b','Linewidth',3)%HP([1:2,4:nhp]
            %                 plot(muny(:,k),HP,'g--','Linewidth',3)
            grid on
            axis([-.5 .5 1 nhp])%HP(1) HP(end)
            title(['comp.',num2str(k)])
            xlabel(num2str(sum(fd)))
            set(gca,'Ytick',1:nhp,'YtickLabel',HP)
            %    axis ij
            hold off
        end
    end
end
ForAllSubplots('axis xy')
ForAllSubplots('axis ij')
ncomp=size(ny,2);
%%
[ygch f phgch] = mtchd(mkCSD(nlfp,r,HP,HP,lambda,theta)*pinv(ny)',2^9,1250,2^8,2^7,[],0,[],[30 230]);  
%
powers=zeros(ncomp,length(f));
for k=1:ncomp
figure(256);
subplot(2,7,k)
imagesc(f,[],bsxfun(@times,f'.^2,sq(ygch(:,k,:))'))%bsxfun(@times,f'.^2,).*(f'.^2)
powers(k,:)=sq(ygch(:,k,k))'.*f'.^2;
hold on
plot(f',ncomp- ncomp*powers(k,:)/max(powers(k,:)),'w')
set(gca,'XTick',30:10:220)
grid on
hold off
end
csd=diff(ny,2,1);
figure;imagesc(csd,max(abs(csd(:)))*[-1 1])
set(gca,'Ytick',1:nhp,'YtickLabel',HP)
figure;imagesc(layer_show)
%% factor analysis
m=5;
k=1;
% ndlfp=Zscore(dlfp(Period(k,1):Period(k,2),:),1);%
[lambda,psi,T,stats]=factoran(ndlfp,m);
mm=size(dlfp,2);
N=diff(Period(k,:));
mm=mm-2;
n=[];
    bic=-2*stats.loglike+m*log(N)/2;%
    obic=bic+10^-4;
        n(m)=bic;
    while (bic<obic)&&(m<mm)
        m=m+1;
        obic=bic;
        [~,~,~,stats]=factoran(ndlfp,m);
        bic=-2*stats.loglike+m*log(N)/2;%
        n(m)=bic;
    end
    m=m-1;
 [lambda,psi,T,stats,xc]=factoran(ndlfp,m);
  figure;plot(1:15,pinv(lambda)')