% 1. use wide band:
 nlfp=ButFilter(lfp,4,[30 300]/625,'bandpass');        
 nlfp=mkCSD(nlfp,r,gCh,HP,lambda,theta); 
 %%
 ncomp=8;
 Sep=cell(3,1);
 malpha=cell(3,1);
 W=cell(3,1);
 wA=cell(3,1);
 vMI=cell(3,1);
 rMI=cell(3,1);
 %% a. use original data. 
 rlfp=nlfp(:,1:32);
 [icasig,wA{1},W{1},m]=wKDICA(rlfp',ncomp,0,0,0);
[Sep{1},malpha{1},n]=ReliabilityICtest(W{1},rlfp);
figure;subplot(121);imagesc(Sep{1});subplot(122);imagesc(malpha{1},[-pi/4 pi/4]);title(num2str(n))

peaksic=cell(ncomp,1);
for k=1:ncomp;x=findpeaks(icasig(k,:)',prctile(icasig(k,:),85));peaksic{k}=x.loc;peaksic{k}(icasig(k,peaksic{k})>prctile(icasig(k,:),99))=[];
    peaksic{k}(peaksic{k}<21 |peaksic{k}>(size(rlfp,1)-50))=[];end
icsact=zeros(ncomp,71);
figure(250);for k=1:ncomp;subplot(2,ncomp,k);x=icasig(k,:);aaa=wA{1}(:,k)*mean(x(bsxfun(@plus,peaksic{k}(:),(-20):50)),1);imagesc((-20):50,[],aaa,max(abs(aaa(:)))*[-1 1]);
    for n=1:ncomp;x=icasig(n,:);icsact(n,:)=mean(x(bsxfun(@plus,peaksic{k}(:),(-20):50)),1)';end;
    subplot(2,ncomp,k+ncomp);imagesc((-20):50,[],icsact);end
%
[vMI{1}, R, rMI{1}]=UniqICtest(W{1},rlfp);
for k=1:ncomp
    for n=1:ncomp
        figure(253);
        subplot(ncomp,ncomp,(k-1)*ncomp+n);plot(1:240,sq(rMI{1}(k,n,:)));
        set(gca,'XTick',0:80:240,'XTicklabel',[0:30:90]-45);axis tight;
    end;
end
 %% b. use the first time dirivative. 
 rlfp=diff(nlfp(:,1:32),1,1);
 [icasig,wA{2},W{2},m]=wKDICA(rlfp',ncomp,0,0,0);
[Sep{2},malpha{2},n]=ReliabilityICtest(W{2},rlfp);
figure;subplot(121);imagesc(Sep{1});subplot(122);imagesc(malpha{1},[-pi/4 pi/4]);title(num2str(n))

peaksic=cell(ncomp,1);
for k=1:ncomp;x=findpeaks(icasig(k,:)',prctile(icasig(k,:),85));peaksic{k}=x.loc;peaksic{k}(icasig(k,peaksic{k})>prctile(icasig(k,:),99))=[];
    peaksic{k}(peaksic{k}<21 |peaksic{k}>(size(rlfp,1)-50))=[];end
icsact=zeros(ncomp,71);
figure(251);for k=1:ncomp;subplot(2,ncomp,k);x=icasig(k,:);aaa=wA{2}(:,k)*mean(x(bsxfun(@plus,peaksic{k}(:),(-20):50)),1);imagesc((-20):50,[],aaa,max(abs(aaa(:)))*[-1 1]);
    for n=1:ncomp;x=icasig(n,:);icsact(n,:)=mean(x(bsxfun(@plus,peaksic{k}(:),(-20):50)),1)';end;
    subplot(2,ncomp,k+ncomp);imagesc((-20):50,[],icsact);end
 kk=2;figure;plot(bsxfun(@plus,bsxfun(@rdivide,wA{kk},sqrt(sum(wA{kk}.^2,1))),1:size(wA{kk},2)));axis([1 32 0 ncomp+1]);grid on

%
[vMI{2}, R, rMI{2}]=UniqICtest(W{2},rlfp);
for k=1:ncomp
    for n=1:ncomp
        figure(254);
        subplot(ncomp,ncomp,(k-1)*ncomp+n);plot(1:240,sq(rMI{2}(k,n,:)));
        set(gca,'XTick',0:80:240,'XTicklabel',[0:30:90]-45);axis tight;
    end;
end
%% 
cd(['/storage/noriaki/data/processed/', FileBase])
Theta=GetThetaPhase(FileBase,Period);
%%
SEQ=1:10^6;
[x,activity]=ThetaPhaseTriggeredAve(Theta,Zscore(nlfp(SEQ,1:32),1)*W{2}',[50 30]);
 for k=1:8;figure(505);subplot(2,4,k);clim=max(max(abs(sq(activity(:,:,k)))));imagesc(x.Ph,x.Fr,sq(activity(:,:,k))',clim*[-1 1]);end
 %% check in every little periods
nPeriod=ReshapePeriod(Period);
 CheckICs(W{1}(1:5,:),nlfp(:,1:32),nPeriod(1:10:100,:))%(end-10):end