function out=CheckResInStatesNI(FileBase,States,Par,S)
cd(['/storage/noriaki/data/processed/', FileBase])
if exist([FileBase, '.sts.', States],'file')
    Period=load([FileBase, '.sts.', States]);
else
    allstates={'REM','RUN','SWS'};
    resstates=setdiff(allstates,States);
    Period1=load([FileBase, '.sts.', resstates{1}]);%6729+[1,1.5*10^6];
    Period2=load([FileBase, '.sts.', resstates{2}]);%6729+[
    Period=interPeriod(Period1,Period2);
    clear Period1 Period2
end
FS = 1250;
% load('/home/weiwei/data/4_16_05_merged/ChanInfo/ChanLoc_Full.eeg.mat')
% load chanLoc.mat
if Par.useinterp
    cd(['/storage/evgeny/data/project/gamma/data/', FileBase])
    % cd([storageF, FileBase])
    %
    LFP= LoadBinary([FileBase '.lfpinterp'],Par.gCh,64,2,[],[],Period)';%
else
    cd(['/storage/noriaki/data/processed/', FileBase])
    LFP= LoadBinary([FileBase '.lfp'],Par.gCh,64,2,[],[],Period)';%
end

Period=ReshapePeriod(Period);
for k=1:size(Period,1)
    LFP(Period(k,1):Period(k,2),:)=bsxfun(@minus, LFP(Period(k,1):Period(k,2),:),mean(LFP(Period(k,1):Period(k,2),:),1));
end
ssname=sprintf([FileBase,'.rIC.', States, '.HP%d.%d.mat'],Par.HP([1 end]));
if exist(ssname,'file')
    load(ssname)
else 
[~, A, W, m]=wKDICA(LFP',.9999,0,0,0);%,'W0
figure;
subplot(131);
imagesc(A)
subplot(132);
imagesc(A(1:(end-2),:)+A(3:end,:)-2*A(2:(end-1),:))
subplot(133)
plot(bsxfun(@plus,bsxfun(@rdivide,A,sqrt(sum(A.^2,1))),1:size(A,2)))
tm=input('which component is Vol-Con?');
save(ssname,'A','W','tm')
end
LFP=LFP-LFP*W(tm,:)'*A(:,tm)';
%% get theta
[b,a]=butter(4,[4 10]/625, 'bandpass');
luP=size(Period,1);
if exist(['/storage/noriaki/data/processed/', FileBase, '/', FileBase, '.thpar.mat'])
    load(['/storage/noriaki/data/processed/', FileBase, '/', FileBase, '.thpar.mat'])
    thetatime=false(size(ThAmp));
    for k=1:luP
        thetatime(Period(k,1):Period(k,2))=true;
    end
    theta=ThPh(thetatime);
    ThAmp=ThAmp(thetatime);
    ThFr=ThFr(thetatime);
else
    Period=ReshapePeriod(Period);
    theta=cell(luP,1);
    for k=1:luP
        aaa=hilbert(-sum(filtfilt(b,a,LFP(Period(k,1):Period(k,2),15:19)),2));
        theta{k}.phase=angle(aaa);
        theta{k}.power=abs(aaa);
    end
    clear a
end
% %%ncsd
[lfp,b,a]=ButFilter(LFP,4,Par.FreqB/625,'bandpass');%[30 140]
lfp=mkCSD(lfp,Par.r,Par.gCh,Par.HP,Par.lambda,Par.theta);% compute CSD her

%%
for kfr=1:length(S)
    out(kfr).ncsd=cell(2,Par.cthr);
    LFP=ButFilter(lfp,4,Par.FreqBins(kfr,:)/625,'bandpass');
    for kk=1:2
        if kk==1
            gnm=S(kfr).gbsnm;%gbnm;
        else
            gnm=bsxfun(@rdivide,S(kfr).muny,sqrt(sum(S(kfr).muny.^2)));
        end
    if iscell(theta)
        theta=cell2mat(theta.phase);
    end
    gnm=bsxfun(@rdivide,gnm,sqrt(sum(gnm.^2)));
%     if kk==1
        icasig=LFP*pinv(gnm)';
        
%     else
%         icasig=LFP*bsxfun(@rdivide,gsnmw,sum(gsnmw.^2));% ganmw
%     end
    [bincounts,ind]=histc(theta,(-pi):.01:pi);
    nbin=length(bincounts);
    lnm=Par.cthr;
    aveICAsig=zeros(lnm,nbin);
    for k=1:nbin
        if bincounts(k)>0
            aveICAsig(:,k)=sum(icasig(ind==(k-1),:),1)/bincounts(k);
        end
    end
    out(kfr).aveICAsig{kk}=aveICAsig;
    out(kfr).MI=cell(2*10,1);
    out(kfr).sMI=cell(2*10,1);
    mis=zeros(Par.cthr,10);
    for k=1:10
        [out(kfr).MI{k+10*(kk-1)}, out(kfr).sMI{k+10*(kk-1)}]=PairwiseInformation(icasig,eye(Par.cthr),-2*(k-1));
        mis(:,11-k)=diag(out(kfr).MI{k+10*(kk-1)});
    end
    %
    for k=1:Par.cthr
        figure(kfr)%
        subplot(2,Par.cthr+1,k+(Par.cthr+1)*(kk-1))
        ncsd=gnm(:,k)*aveICAsig(k,:);
        out(kfr).ncsd{kk,k}=ncsd;
        cscale=max(max(abs(ncsd)));
        imagesc([linspace(-pi,pi,size(ncsd,2)),2*pi+linspace(-pi,pi,size(ncsd,2))],linspace(Par.HP(1),Par.HP(end),size(ncsd,1)),repmat(ncsd,1,2),[-cscale,cscale])% (ny(:,k))lfp2CSD,[.01]
        title(['comp', num2str(k)])
        %     set(gca,'YTick',linspace(nHP(1),nHP(end),length(HP)),'YTicklabel',HP)
        grid on
        hold off
        set(gca,'YTick',Par.ylbs,'YTicklabel',Par.names)
        title(['comp', num2str(k)])
        
    end
    figure(kfr)%
        subplot(2,Par.cthr+1,(Par.cthr+1)*kk)
        imagesc(2*[10:(-1):0],1:Par.cthr,baxfun(@rdivide,mis,max(abs(mis),[],2)))
        title(num2str(Par.FreqBins(kfr,:)))
    end
end
%%
cd /storage/weiwei/data/ni04-20110503/ 
fname=sprintf([FileBase, '.Check.SICs.ch.%d.%d.fr.%d.%d.r%.1f.mat'],Par.HP([1 end]),Par.FreqBins([1 end]),Par.r);
% save(fname,'nm','anm','mD','c','blonging','sA','A','B','gA','gsA','sA','cu','clags','jdfr','gbnm','ganm','ganmw')
save(fname,'out')
