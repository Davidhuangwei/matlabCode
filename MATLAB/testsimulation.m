% test for the simulations 
conum=2;
FileBase=sprintf('PoissionInputMEC_CA3CO%d',conum);% 'PoissionInputMEC_CA3'-> RANDOM
cd(['/home/weiwei/data/', FileBase]);
sig1=load('spikeTimesGroup1.mat');
sig2=load('spikeTimesGroup2.mat');
mat=(cell2mat(sig1.spikeTimes')); % input from MEC3
mat2=(cell2mat(sig2.spikeTimes')); % input from CA3
%%
Results = loadResults(['/home/weiwei/data/', FileBase]);
lfp=Results.LFP(1:27,:);
tmlfp=Results.tmLFP(1:27,:);
ncomp=2;
for k=1:3
    if k==1
        t=1:32000;
        titlen=['co',num2str(conum)];
    elseif k==2
        t=32001:64000;
        titlen=['ran',num2str(conum)];
    else
        t=1:64000;
        titlen=['whole',num2str(conum)];
    end
[icasig3, gdA3, gdW3, ~]=wKDICA(diff(lfp(:,t),1,2),ncomp,0,0,0);  [~, gdA4, gdW4, ~]=wKDICA(lfp(:,t),ncomp,0,0,0);
lambda=.01;theta=[2,1,2];csdgdA4=mkCSD(gdA4',2,[1:27]',[1:27]',lambda,theta)';
figure;plot(bsxfun(@plus,bsxfun(@rdivide,gdA4,sqrt(sum(gdA4.^2,1))),1:ncomp));
hold on;plot(bsxfun(@plus,bsxfun(@rdivide,csdgdA4,sqrt(sum(csdgdA4.^2,1))),1:ncomp),'--');
hold on;plot(bsxfun(@plus,bsxfun(@rdivide,gdA3,sqrt(sum(gdA3.^2,1))),1:ncomp),':');axis tight;grid on;
set(gca,'Xtick',[27-27*[ 450, 290, 183, 143, 0]/650],'Xticklabel',{'lmo','lmi','rad','pyr','orin'});
title(titlen)
end
%%
for k=31:64;
    figure(164);subplot(211);
    imagesc(Results.LFP(1:27,((k-1)*1000+1):(k*1000)),max(abs(Results.LFP(:)))*[-1 1]);
    set(gca,'Ytick',[27-27*[ 450, 290, 183, 143, 0]/650],'Yticklabel',{'lmo','lmi','rad','pyr','orin'});
    subplot(212);
    imagesc(Results.tmLFP(1:27,((k-1)*1000+1):(k*1000)),max(abs(Results.tmLFP(:)))*[-1 1]);
    set(gca,'Ytick',[27-27*[ 450, 290, 183, 143, 0]/650],'Yticklabel',{'lmo','lmi','rad','pyr','orin'});
    pause;
end