% if I use SSpecJAJD in G10 stimulate data, it should work much better than
% ICA methods. 

%% %%%%%%% gerrit stimulation session
clear all
cd /home/weiwei/data/g10-20130528/
FileBase = 'g10-20130528';
Par = LoadXml([FileBase '.xml']);

% let me try 10 and 14
% now training on stimulation data
%   load('g10-20130528-StimulationResults-2.mat');
load('g10-20130528-StimulationResults-2.mat');% 
filen=2;
load chanLoc.mat
[~,~,bsn,nst]=size(StimSegsLfp);
nst=16;

Layers=fieldnames(chanLoc);
layer_show=zeros(nst,1);
for n=1:length(Layers)
    layer_show(chanLoc.(Layers{n}))=n;
end
% %% here I try to check whether we can see the "consistent pattern" they get.
t=[432:814];%648;%432:;326:650;%[10:20]*32.552;326488    1:1955;
thr=.98;
rtrail=1:bsn;    %randi(bsn,bstn,1);% I need to keep this the same for all the conditions.
% spectrumo=fft(reshape(permute(StimSegsLfp(401:900,:,:,:),[1,3,4 2]),[],64),51);
% mspec=zeros(64,64,25);
% for k=1:25
%     mspec(:,:,k)=spectrumo(k,:)'*spectrumo(k,:);
% end
%
% for k=1:25
%     figure(1);
%     subplot(5,5,k)
%     imagesc(abs(mspec(:,:,k))/600,[0 8000])
% end
% %% compute for far-away signals.
% so that means, I need to first compute which frequency band is better to
% see the difference, then use the frequency band. 
% kA=cell(nst,4);
% kW=cell(nst,4);
% t=[432:814];%648;%432:;326:650;%[10:20]*32.552;326488    1:1955;
% thr=.99;
% for k=1:nst
% sec=k;%[k,k+4,k+8,k+12];%1:16;%[10,14];[9 12];;[9 12]
% for n=1:4;
% HP=(24+8*n+[1:8])';%64
% lfp = reshape(permute(StimSegsLfp(t,HP,:,sec),[1 3 4 2]),[],length(HP));%
% % here I still emplore fastICA and KDICA
% % [~,A{k,n},W{k,n}]=fastica(lfp','g','skew');%,'numOfIC', 4,'numOfIC', 5
% [~,kA{k,n},kW{k,n}]=wKDICA(lfp',thr);%,'numOfIC', 5
% end
% end
% %%
% for k=1:nst
%     figure(k)
%     for n=1:4
%         if ~isempty(kA{k,n})
%         nco=size(kA{k,n},2);
%         subplot(1,4,n)
%     plot(bsxfun(@plus, kA{k,n}/1000,1:nco),HP)
%     hold on
%     plot([1:nco;1:nco],HP([1,end]),':')
%     hold off
%     axis tight
%         end
%     end
%     ForAllSubplots('axis xy')
% ForAllSubplots('axis ij')
% end
% TRY optimizing at the same time.
hkA=cell(nst,1);
hkW=cell(nst,1);
t=[432:814];%648;%432:;326:650;%[10:20]*32.552;326488    1:1955;
thr=.99;
for k=1:nst
sec=k;%[k,k+4,k+8,k+12];%1:16;%[10,14];[9 12];;[9 12]

HP=33:48;%64
lfp = reshape(permute(StimSegsLfp(t,HP,:,sec),[1 3 4 2]),[],length(HP));%
% here I still emplore fastICA and KDICA
% [~,A{k,n},W{k,n}]=fastica(lfp','g','skew');%,'numOfIC', 4,'numOfIC', 5
[~,hkA{k},hkW{k}]=wKDICA(lfp',[],[],[],1);%,'numOfIC', 5

end

lfp = reshape(permute(StimSegsLfp(t,HP,:,1:sec),[1 3 4 2]),[],length(HP));%
[~,gkA,gkW]=wKDICA(lfp',thr);%,'nu
%%
[anm, mD, id]=ClusterComp(gkA,cell2mat(hkA'),1,1);
%%
lanm=size(anm,2);
for k=1:lanm
    figure(223)
    subplot(1,lanm,k)
    imagesc(reshape(anm(:,k),8,[]),[-.4 .4])
    colorbar('northoutside')
    xlabel([num2str(sum(mD==k)), '|', num2str(nst)])
    title(['comp.', num2str(k)])
end
lfp = reshape(permute(StimSegsLfp(:,HP,:,1:nst),[1 3 4 2]),[],length(HP));%
w=pinv(anm)';
nmsig=centersig(lfp)*bsxfun(@rdivide,w,std(w));
nmsig=reshape(nmsig,[1955,50,nst,lanm]);
figure;
for k=1:nst
    subplot(2,8,k)
%     imagesc(sq(mean(nmsig(:,:,k,:),2))')
%     colorbar('southoutside')
plot([1:1955]/32.552,sq(mean(nmsig(:,:,k,:),2)))
title(['stim.', num2str(k)])
axis tight
end
legend('comp.1','comp.2','comp.3','comp.4','comp.5','comp.6','comp.7', 'comp.8')
%% special example
figure
k=5;
lfp = reshape(permute(StimSegsLfp(:,HP,:,1:nst),[1 3 4 2]),[],length(HP));%
w=pinv(anm)';
nmsig=centersig(lfp)*bsxfun(@rdivide,w,std(w));
nmsig=reshape(nmsig,[1955,50,nst,lanm]);
plot([1:1955]/32.552,sq(mean(nmsig(:,:,k,:),2)))
title(['stim.', num2str(k)])
axis tight
legend('comp.1','comp.2','comp.3','comp.4','comp.5','comp.6','comp.7', 'comp.8')
figure
lLanm=size(hkA{k},2);
lfp = reshape(permute(StimSegsLfp(:,HP,:,k),[1 3 4 2]),[],length(HP));%
w=hkW{k}';
nmsig=centersig(lfp)*bsxfun(@rdivide,w,std(w));
nmsig=reshape(nmsig,[1955,50,1,lLanm]);
plot([1:1955]/32.552,sq(mean(nmsig(:,:,:,:),2)))
title(['stim.', num2str(k)])
axis tight
legend('comp.1','comp.2','comp.3','comp.4','comp.5','comp.6','comp.7', 'comp.8')
figure;
for n=1:lLanm
    subplot(1,lLanm,n)
     imagesc(reshape(hkA{k}(:,n),8,[]))
     colorbar('northoutside')
title(['comp.', num2str(n)])
end

fname=sprintf([FileBase, '.Stim.%d.mat'], 2);
save(fname,'anm','mD','hkA','hkW','gkA','gkW')


%% use factoranalysis to find "factors" make ics
KLA=[gkA,cell2mat(hkA')];
[nN, N]=size(KLA);
mm=nN-2;
m=size(gkA,2);
[lambda,psi,T,stats]=factoran(KLA',m);
bic=-2*stats.loglike+m*log(N);
obic=bic+10^-4;
while (bic<obic)&&(m<mm)
    m=m+1;
    obic=bic;
    [~,~,~,stats]=factoran(KLA',m);
    bic=-2*stats.loglike+m*log(N);
    fprintf('%d-',m)
end
m=m-1;

[lambda,psi,T,stats]=factoran(KLA',m);
for k=1:m
    figure(224)
    subplot(1,m,k)
    imagesc(reshape(lambda(:,k),8,[]))
end
lfp = reshape(permute(StimSegsLfp(:,HP,:,:),[1 3 4 2]),[],length(HP));%
% [corrs]=xcorr(resample(centersig(lfp),1,30)*pinv(lambda),20);
% figure(225)
% for k=1:6
%     for n=k:6
%         subplot(6,6,6*(k-1)+n)
%         plot((-10:10)*30,sq(corrs(k,n,:)))
%         axis tight
%         grid on
%     end
% end
nmsig=centersig(lfp)*pinv(lambda)';
nmsig=reshape(nmsig,[1955,50,33,m]);

figure;
for k=1:32
    subplot(2,16,k)
%     imagesc(sq(mean(nmsig(:,:,k,:),2))')
%     colorbar('southoutside')
plot([1:1955]/32.552,sq(mean(nmsig(:,:,k,:),2)))
axis tight
end

%% try pure factor analysis 
lfp = reshape(permute(StimSegsLfp(t,HP,:,:),[1 3 4 2]),[],length(HP));%
[N, hp]=size(lfp);
mm=hp-2;
m=1;%size(gkA,2);
[~,~,~,stats]=factoran(lfp,m);
bic=-2*stats.loglike+m*log(N);%
obic=bic+10^-4;
while (bic<obic)&&(m<mm)
    m=m+1;
    obic=bic;
    [~,~,~,stats]=factoran(lfp,m);
    bic=-2*stats.loglike+m*log(N);%
    fprintf('%d-',m)
end
m=m-1;
[flambda,fpsi,fT,stats]=factoran(lfp,m);
figure;
for k=1:m
    subplot(1,m,k)
    imagesc(reshape(lambda(:,k),[],4))
end
%%
ncomp=size(anm,2);
compcount=accumarray(mD(:),ones(length(mD),1));
[~,icomp]=sort(compcount,'descend');
figure
for k=1:size(anm,2)
    subplot(3,9,k)
    imagesc(reshape(anm(:,icomp(k)),[],4))
    title(num2str(compcount(icomp(k))));% sum(mD==k)
end
figure
for k=1:size(gkA,2)
   subplot(1,size(gkA,2),k) 
   imagesc(reshape(gkA(:,k),[],4))
end
%%
for k=1:nst
    figure(k)
    ncomp=size(hkA{k},2);
    for n=1:ncomp
        subplot(1,ncomp,n)
        imagesc(reshape(hkA{k}(:,n),[],4))
    end
end
%% get groble one.
sec=[1:nst];
% gA=cell(1,4);
gkA=cell(1,4);
% gW=cell(1,4);
gkW=cell(1,4);
% gicasig=cell(1,4);
gkicasig=cell(1,4);
for n=1:4
HP=(24+8*n+[1:8])';%64
lfp = reshape(permute(StimSegsLfp(t,HP,:,sec),[1 3 4 2]),[],length(HP));%
% here I still emplore fastICA and KDICA
% [gicasig{n},gA{n},gW{n}]=fastica(lfp');%,'numOfIC', 5
[~,gkA{n},gkW{n}]=wKDICA(lfp',thr);%,'numOfIC', 5
end
nm=cell(1,4);
for n=1:4
    [nm{n}, ~, ~]=ClusterComp(gkA{n},cell2mat({kA{:,n}}),.1,0);
end

nmW=cell(1,4);
for n=1:4
    nmW{n}=pinv(nm{n});
end
lfp = reshape(permute(StimSegsLfp(t,33:64,:,sec),[1 3 4 2]),[],32);%
corrs=CorrComps(lfp,gkW,10,1,30);
% [nB,c]=jadiag(reshape(corrs,19,[]));
% [nB,c] = bgwedge(reshape(corrs,19,[]),50,10);
[u,s,~]=svd(cov(reshape(corrs,5,[])'));
for k=1:4
    subplot(1,4,k)
    plot(gkA{k},1:8)
end
ForAllSubplots('axis xy')
ForAllSubplots('axis ij')
mgA=cell2mat(gkA);
figure;imagesc(mgA)
%%
ngkA=cell(10,1);
for k=1:10
    figure(2)
    subplot(2,5,k)
    ngkA{k}=[gkA{1}*u{1}(:,k),gkA{2}*u{2}(:,k),gkA{3}*u{3}(:,k),gkA{4}*u{4}(:,k)];
    imagesc(ngkA{k})
    colorbar
end

%% check the stimulate responds of each component.
% I need to think of the meaning of "orthognal combination of sources"
nt=size(StimSegsLfp,1);
lfp=reshape(permute(StimSegsLfp(:,33:64,:,sec),[1 3 4 2]),[],32);%

for k=1:10
    figure(20)
    subplot(2,5,k)
    imagesc(reshape(lfp*ngkA{k}(:),nt,[])')  
end

%%
% [nu,or]=sort(rtrail);
lt=length(t);
% tt=or([1;find(diff(nu))+1]);
tt=rtrail';
tt=bsxfun(@plus,(tt+1100)*lt,1:lt);%;(tt-1)+200;(tt-1)+300;(tt-1)+900

%%
% sigA=CorrComp(gicasig,[200 25],tt(:));
sigkA=CorrComp(gkicasig,[200 25],tt(:));
figure
for k=1:4
    subplot(4,1,k)
    imagesc(gkicasig{k})
end
%%
% for k=1:nst
%         figure(k)
%     for n=k:4
%         [nx, ny, nz]=size(sigA{k,n});
%         for cx=1:nx
%         subplot(nx, 4,(cx-1)*4+n)
%         imagesc(-200:25:200,1:ny,abs(sq(sigA{k,n}(cx,:,:))),[0 1]);
%         title(['fast', num2str([k -cx -n])])
%         end
%     end
% end
for k=1:4
        figure(20+k)
    for n=k:4
        [nx, ny, nz]=size(sigkA{k,n});
        for cx=1:nx
        subplot(nx, 4,(cx-1)*4+n)
        imagesc(-200:25:200,1:ny,abs(sq(sigkA{k,n}(cx,:,:))),[0 1]);
        title(['fast', num2str([k -cx -n])])
        end
    end
end
%%
figure(227+filen)
% imagesc(sortrows(zscore(cell2mat(reshape(kA,1,nst)))',8))
for k=1:4
subplot(2,4,k)
        HP=(24+8*k+[1:8])';%64
        plot(HP,bsxfun(@plus,bsxfun(@rdivide,gkA{k},sqrt(sum(gkA{k}.^2,1))),1:size(gkA{k},2)),'Linewidth',2)
        grid on
        axis tight
subplot(2,4,k+4)
        HP=(24+8*k+[2:7])';%64
gkAcsd=diff(gkA{k},2,1);
        plot(HP,bsxfun(@plus,bsxfun(@rdivide,gkAcsd,sqrt(sum(gkA{k}.^2,1))),1:size(gkA{k},2)),'Linewidth',2)
        grid on
        axis tight
end
% %% fastica
% figure(226)
% % imagesc(sortrows(zscore(cell2mat(reshape(kA,1,nst)))',8))
% for k=1:4
% subplot(2,4,k)
%         HP=(24+8*k+[1:8])';%64
%         plot(HP,bsxfun(@plus,bsxfun(@rdivide,gA{k},sqrt(sum(gA{k}.^2,1))),1:size(gA{k},2)),'Linewidth',2)
%         grid on
%         axis tight
% subplot(2,4,4+k)
%         HP=(24+8*k+[2:7])';%64
% gAcsd=diff(gA{k},2,1);
%         plot(HP,bsxfun(@plus,bsxfun(@rdivide,gAcsd,sqrt(sum(gA{k}.^2,1))),1:size(gA{k},2)),'Linewidth',2)
%         grid on
%         axis tight
% end


%% check
% figure(224)
% % imagesc(sortrows(zscore(cell2mat(reshape(kA,1,nst)))',8))
% for k=1:nst
%     for n=1:4
%         HP=(24+8*n+[1:8])';%64
%         subplot(nst,4,(k-1)*4+n)
%         [~,order]=sort(var(A{k,n}),'descend');
%         plot(HP,bsxfun(@plus,bsxfun(@rdivide,A{k,n}(:,order),sqrt(sum(A{k,n}(:,order).^2,1))),1:size(A{k,n},2)),'Linewidth',2)
%         grid on
%         axis tight
%     end
% end
figure(224)
% imagesc(sortrows(zscore(cell2mat(reshape(kA,1,nst)))',8))
for k=1:nst
    for n=1:4
        HP=(24+8*n+[1:8])';%64
        subplot(4,nst,(n-1)*nst+k)
        [~,order]=sort(var(kA{k,n}),'descend');
        plot(HP,bsxfun(@plus,bsxfun(@rdivide,kA{k,n}(:,order),sqrt(sum(kA{k,n}(:,order).^2,1))),1:size(kA{k,n},2)),'Linewidth',2)
        grid on
        axis tight
    end
end
%%
subplot(212)
CSKA
plot(HP(2:(end-1)),bsxfun(@plus,bsxfun(@rdivide,CSKA{k}(:,order),sqrt(sum(CSKA{k}(:,order).^2,1))),1:size(CSKA{k},2)),'Linewidth',2)
grid on
axis tight



