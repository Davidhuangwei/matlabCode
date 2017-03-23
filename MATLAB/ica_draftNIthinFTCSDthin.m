% function ica_darftNIthinFTCSDthin.m
clear all
FileBase='ni04-20110503';
Period=load(['/storage/noriaki/data/processed/', FileBase, '/', FileBase, '.sts.SWS']);
FS = 1250;
HP=1:32;%33:64Par.;1:32
ylbs=HP;
names=HP;
gCh=1:32;%1:3233:64
%%
if exist(['/storage/weiwei/data/ni11/', FileBase, '/chanLoc.mat'],'file')
    load(['/storage/weiwei/data/ni11/', FileBase, '/chanLoc.mat'])% chanLoc.mat
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
end
%%
nhp=length(HP);
if exist(['/storage/evgeny/data/project/gamma/data/', FileBase, '/', FileBase '.lfpinterp'],'file')
    cd(['/storage/evgeny/data/project/gamma/data/', FileBase])
    % cd([storageF, FileBase])
    %
    lfp= LoadBinary([FileBase '.lfpinterp'],gCh,64,2,[],[],Period)';%
    useinterp=1;
else
    cd(['/storage/noriaki/data/processed/', FileBase])
    % cd([storageF, FileBase])
    %
    Par=LoadPar(FileBase);
    badch=1+[setdiff(0:63,Par.AnatGrps.Channels),Par.AnatGrps.Channels(Par.AnatGrps.Skip>.5)];
    gCh=setdiff(gCh,badch);
    HP=setdiff(HP,badch);
    lfp= LoadBinary([FileBase '.lfp'],gCh,64,2,[],[],Period)';%
    useinterp=0;
end
FreqB=[3 150];%[40 100];%[5 20][60 120]
% jdfr=35:10:90;%45:10:100;%[35:10:130];% [45 65 85];[7:5:20][65:10:120]
[lfp,b,a]=ButFilter(lfp,4,FreqB/625,'bandpass');
[~, A, W, m]=wKDICA(lfp',.999,0,0,0);%,'W0
figure;
subplot(131);
imagesc(A)
subplot(132);
imagesc(A(1:(end-2),:)+A(3:end,:)-2*A(2:(end-1),:))
subplot(133)
plot(bsxfun(@plus,bsxfun(@rdivide,A,sqrt(sum(A.^2,1))),1:size(A,2)))
tm=input('which component is Vol-Con?');%1;%
lfp=lfp-lfp*W(tm,:)'*A(:,tm)';
%%
r=2.^[(-1):4];
lambda=.01;
theta=[3 1 3];%[215]
oPeriod=Period;
Period=ReshapePeriod(Period);
nPeriod=Period;
luP=size(Period,1);

thr=.985;%6;%1:15;.982:11
Par.freqB=bsxfun(@plus,[1:10:90]',[0 30]);
Par.FreqB=FreqB;
Par.thr=thr;
Par.r=r;
Par.theta=theta;
Par.lambda=lambda;
Par.W=W;
Par.A=A;
Par.tm=tm;
Par.FileBase=FileBase;
Par.ylbs=ylbs;
Par.names=names;
Par.HP=HP;
Par.gCh=gCh;
for nr=1:length(nr)
    rt=r(nr);
%     LFP=mkCSD(lfp,rt,HP,HP,lambda,theta);% compute CSD here.
    %%
    for nf=1:size(Par.freqB,1)
        FreqB=Par.freqB(nf,:);%[40 100];%[5 20][60 120]
        jdfr=(Par.freqB(nf,1)+3):6:Par.freqB(nf,2);%45:10:100;%[35:10:130];% [45 65 85];[7:5:20][65:10:120]
        
        LFP=mkCSD(lfp,rt,HP,HP,lambda,theta);% compute CSD here.
        [LFP,b,a]=ButFilter(LFP,4,FreqB/625,'bandpass');
        % LFP=diff(LFP,1,1);
        %% Have a example of time-frequency method... use multitiper
        
        % using frequency method
        B=cell(luP,1);
        sA=cell(luP,1);
        % chn=HP;%(1:2:end)HP;%[5:2:60];
        %%
        % jdfr=[35:10:90, 115:10:150];
        for k=1:luP
            %     nfcomp(k)=size(A{k},2);
            %     [lambda,~,~,~,tlfp]=factoran(LFP(Period(k,1):Period(k,2),chn),nfcomp(k));
            [B{k}, ~]=SSpecJAJD(LFP(Period(k,1):Period(k,2),:),1250,400,400,jdfr,100,.99,0);
            
            sA{k}=pinv(B{k});% lambda/B{k}
            fprintf('%d-',k)
        end
        [~,lp]=max(Period(:,2)-Period(:,1));
        % [lambda,~,~,~,tlfp]=factoran(LFP(:,chn),size(gA,2));(Period(2,1):Period(6,2),:)
        [gB, gc]=SSpecJAJD(LFP(Period(1,1):Period(luP,2),:),1250,400,400,jdfr,100,.99,0);
        gsA=pinv(gB);%lambda/gB
        S(nr,nfr).B=B;
        S(nr,nfr).A=sA;
        S(nr,nfr).gB=gB;
        S(nr,nfr).gsA=gsA;
        %%
        [nm,~,~]=ClusterCompO(gsA,sA,.1);
        lnm=length(nm);
        ny=zeros(length(HP),lnm);
        for k=1:lnm
            fd=sum(nm{k}.^2,1)>10^-8;
            nmD=sum(fd);
            if nmD>0
                dt=bsxfun(@times,bsxfun(@rdivide,nm{k}(:,fd),sqrt(sum(nm{k}(:,fd).^2,1))),sign(gsA(:,k)'*nm{k}(:,fd)));
                ny(:,k)=mean(dt,2);%GaussionProcessRegression(repmat(nx,nmD,1),dt(:),.8,.00001,nxx(:));
            end
        end
        gbsnm=bsxfun(@rdivide,ny,sum(ny.^2));%(fix(1:((length(nxx)-1)/(length(HP)-1)):length(nxx)),:);
        S(nr,nfr).gbsnm=gbsnm;
        icasig=pinv(gbsnm)*LFP';
        MI=zeros(lnm);
        nm=zeros(lnm,1);
        for k=1:lnm 
            nm(k)=information(icasig(k,:),icasig(k,:));
            for n=k:lnm
                if n==k
                    MI(k,n)=information(icasig(k,:),mean(icasig(setdiff(1:lnm,k),:),1));
                else
                    MI(k,n)=information(icasig(k,:),icasig(n,:));
                end
            end
        end
        
        S(nr,nfr).MI=MI;
        S(nr,nfr).nm=nm;
        clear icasig
        %%
        [snm, mD, id]=ClusterComp(gsA,cell2mat(sA'),.1,0);
        LSA=[gsA,cell2mat(sA')];
        LSW=[gB;cell2mat(B)]';
        KLSW=LSW(:,~id);
        bl=1:size(LSA,2);
        KLSA=LSA(:,~id);
        bl=bl(~id);
        lnm=size(snm,2);
        ny=zeros(length(HP),lnm);
        nyw=zeros(length(HP),lnm);
        blonging=cell(lnm,1);
        n=1;
        for k=1:lnm
            nmD=sum(mD==k);
            
            if nmD>0
                blongi=bl(mD==k);
                blonging{k}=blongi(blongi>size(gsA,2));
                dt=bsxfun(@times,bsxfun(@rdivide,KLSA(:,mD==k),sqrt(sum(KLSA(:,mD==k).^2,1))),sign(snm(:,k)'*KLSA(:,mD==k)));
                ny(:,k)=mean(dt,2);%GaussionProcessRegression(repmat(nx,nmD,1),dt(:),.8,.001,nxx(:));
                dtw=bsxfun(@times,bsxfun(@rdivide,KLSW(:,mD==k),sqrt(sum(KLSW(:,mD==k).^2,1))),sign(snm(:,k)'*KLSA(:,mD==k)));
                nyw(:,k)=mean(dtw,2);%GaussionProcessRegression(repmat(nx,nmD,1),dtw(:),.8,.00001,nxx(:));
            end
        end
        gsnm=bsxfun(@rdivide,ny,sum(ny.^2));
        gsnmw=bsxfun(@rdivide,nyw,sum(nyw.^2));
        S(nr,nfr).gsnm=gsnm;
        S(nr,nfr).gsnmw=gsnmw;
        %% use KDICA
        A=cell(luP,1);
        W=cell(luP,1);
        % %%
        for k=1:luP
            [~,A{k},W{k},~]=wKDICA(LFP(Period(k,1):Period(k,2),:)',thr);%,'numOfIC', 5
        end
        [~,gA,gW]=wKDICA(LFP',thr);%,'numOfI
        [nm,lost,dists]=ClusterCompO(gA,A,.1);
        S(nr,nfr).A=A;
        S(nr,nfr).W=W;
        S(nr,nfr).gA=gA;
        S(nr,nfr).gW=gW;
        lnm=length(nm);
        ny=zeros(length(HP),lnm);
        for k=1:lnm
            fd=sum(nm{k}.^2,1)>10^-8;
            nmD=sum(fd);
            if nmD>0
                dt=bsxfun(@times,bsxfun(@rdivide,nm{k}(:,fd),sqrt(sum(nm{k}(:,fd).^2,1))),sign(gA(:,k)'*nm{k}(:,fd)));
                ny(:,k)=mean(dt,2);%GaussionProcessRegression(repmat(nx,nmD,1),dt(:),.8,.00001,nxx(:));
            end
        end
        gnm=bsxfun(@rdivide,ny,sum(ny.^2));%(fix(1:((length(nxx)-1)/(length(HP)-1)):length(nxx)),:);
        S(nr,nfr).gbwnm=gnm;
        icasig=pinv(gnm)*LFP';
        MI=zeros(lnm);
        nm=zeros(lnm,1);
        for k=1:lnm 
            nm(k)=information(icasig(k,:),icasig(k,:));
            for n=k:lnm
                if n==k
                    MI(k,n)=information(icasig(k,:),mean(icasig(setdiff(1:lnm,k),:),1));
                else
                    MI(k,n)=information(icasig(k,:),icasig(n,:));
                end
            end
        end
        S(nr,nfr).wMI=MI;
        [snm, mD, id]=ClusterComp(gA,cell2mat(A'),.1,0);
        LSA=[gsA,cell2mat(sA')];
        LSW=[gB;cell2mat(B)]';
        KLSW=LSW(:,~id);
        bl=1:size(LSA,2);
        KLSA=LSA(:,~id);
        bl=bl(~id);
        lnm=size(snm,2);
        ny=zeros(length(HP),lnm);
        nyw=zeros(length(HP),lnm);
        blonging=cell(lnm,1);
        n=1;
        for k=1:lnm
            nmD=sum(mD==k);
            
            if nmD>0
                blongi=bl(mD==k);
                blonging{k}=blongi(blongi>size(gsA,2));
                dt=bsxfun(@times,bsxfun(@rdivide,KLSA(:,mD==k),sqrt(sum(KLSA(:,mD==k).^2,1))),sign(snm(:,k)'*KLSA(:,mD==k)));
                ny(:,k)=mean(dt,2);%GaussionProcessRegression(repmat(nx,nmD,1),dt(:),.8,.001,nxx(:));
                dtw=bsxfun(@times,bsxfun(@rdivide,KLSW(:,mD==k),sqrt(sum(KLSW(:,mD==k).^2,1))),sign(snm(:,k)'*KLSA(:,mD==k)));
                nyw(:,k)=mean(dtw,2);%GaussionProcessRegression(repmat(nx,nmD,1),dtw(:),.8,.00001,nxx(:));
            end
        end
        gsnm=bsxfun(@rdivide,ny,sum(ny.^2));
        gsnmw=bsxfun(@rdivide,nyw,sum(nyw.^2));
        S(nr,nfr).gbnm=gsnm;
        S(nr,nfr).gbnmw=gsnmw;
        fprintf('r%d-f%d.',nr,nf)
    end
    fprintf('\n')
end
cd /storage/weiwei/data/ni11/ni04-20110503/
sname=sprintf([FileBase, '.freqR.CSD.span.%d.%d.mat'],theta([1 3]));
save(sname,'S','Par')
return