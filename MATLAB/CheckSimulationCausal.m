% function CheckSimulationCausal
cd ~/data/
simuname=dir('PoissionInputMEC_CA3C*');
ARorder=1;
ncomp=2;
lambda=.01;
theta=[2,1,2];
for k=1:length(simuname)
    saveDir=['~/data/', simuname(k).name];
    cd(saveDir)
    Results = loadResults(saveDir);
    R=load([simuname(k).name, '.ICsC.mat']);
    lfp=Results.LFP(1:27,:);
    tmlfp=mkCSD(Results.tmLFP(1:27,:)',2,[1:27]',[1:27]',lambda,theta)';
    t=32000:64000;%1:32000;%
    titlen=['whole', simuname(k).name];
    [icasig3, gdA3, gdW3, ~]=wKDICA(WhitenSignal(lfp(:,t)',[],2,[], ARorder)',ncomp,0,0,0);
    [icasig4, gdA4, gdW4, ~]=wKDICA(lfp(:,t),ncomp,0,0,0);
    [icasig5, gdA5, gdW5, ~]=wKDICA(WhitenSignal(mkCSD(lfp(:,t)' ,2,[1:27]',[1:27]',lambda,theta),[],2,[], ARorder)'...
       ,ncomp,0,0,0);
    mamariRC=[mamari(gdW3,R.gdW3);mamari(gdW4,R.gdW4);mamari(gdW5,R.gdW5)];
    fprintf('\n Amari dist:gdW3-WLFP %d, gdW4-LFP%d. gdW5-WCSD %d\n ',mamariRC)
%     csdgdA4=mkCSD(gdA4',2,[1:27]',[1:27]',lambda,theta)';
    figure;plot(bsxfun(@plus,bsxfun(@rdivide,gdA4,sqrt(sum(gdA4.^2,1))),1:ncomp));
    hold on;plot(bsxfun(@plus,bsxfun(@rdivide,gdA5,sqrt(sum(gdA5.^2,1))),1:ncomp),'--');
    hold on;plot(bsxfun(@plus,bsxfun(@rdivide,gdA3,sqrt(sum(gdA3.^2,1))),1:ncomp),':');
    axis tight;grid on;
    set(gca,'Xtick',[27-27*[ 450, 290, 183, 143, 0]/650],'Xticklabel',{'lmo','lmi','rad','pyr','orin'});
    title(titlen)
    [inputsig, gdAi, gdWi, ~]=wKDICA(tmlfp(:,t),ncomp,0,0,0);
    %%
    infos=cell(3,1);
    for nnt=1:120
    for ki=1:2
        for ni=1:2
            infos{1}(ki,ni,nnt)=information(inputsig(ki,1:(end-nnt)),icasig3(ni,(nnt+1):end));%
            infos{2}(ki,ni,nnt)=information(inputsig(ki,1:(end-nnt)),icasig4(ni,(nnt+1):end));%
            infos{3}(ki,ni,nnt)=information(inputsig(ki,1:(end-nnt)),icasig5(ni,(nnt+1):end));%
        end
    end
    end
    Cinfos=cell(3,2);% WR to WC, WC to WR
    t2=1:32000;%32000:64000;
    for kk=1:2
        if kk==1
            [inputsig, ~, ~, ~]=wKDICA(tmlfp(:,t),ncomp,0,0,0);
            icasig3=R.gdW3*Zscore(WhitenSignal(lfp(:,t)',[],2,[], ARorder)',2);
            icasig4=R.gdW4*Zscore(lfp(:,t),2);
            icasig5=R.gdW5*Zscore(WhitenSignal(mkCSD(lfp(:,t)',2,[1:27]',[1:27]',lambda,theta),[],2,[], ARorder)'...
                ,2);
        else
            [inputsig, ~, ~, ~]=wKDICA(tmlfp(:,t2),ncomp,0,0,0);
            icasig3=gdW3*Zscore(WhitenSignal(lfp(:,t2)',[],2,[], ARorder)',2);
            icasig4=gdW4*Zscore(lfp(:,t2),2);
            icasig5=gdW5*Zscore(WhitenSignal(mkCSD(lfp(:,t2)',2,[1:27]',[1:27]',lambda,theta),[],2,[], ARorder)'...
                ,2);
        end
        for nnt=1:121
            for ki=1:2
                for ni=1:2
                    Cinfos{1,kk}(ki,ni,nnt)=information(inputsig(ki,1:(end-nnt+1)),icasig3(ni,(nnt):end));%
                    Cinfos{2,kk}(ki,ni,nnt)=information(inputsig(ki,1:(end-nnt+1)),icasig4(ni,(nnt):end));%
                    Cinfos{3,kk}(ki,ni,nnt)=information(inputsig(ki,1:(end-nnt+1)),icasig5(ni,(nnt):end));%
                end
            end
        end
        figure(520+k)
        for mi=1:3
            subplot(2,3,(kk-1)*3+mi);
            ccinfo=reshape(Cinfos{mi,kk},4,[]);
            [mcc,occ]=max(abs(ccinfo),[],2);
            [~,mocc]=sort(mcc);
            imagesc(0:120,1:4,ccinfo)
            hold on
            plot(occ-1,1:4,'k+')
            plot(occ(mocc(3:4))-1,mocc(3:4),'ko')
            hold off
        end
    end
    fprintf('%s:\n %d %d \n %d %d \n %d %d \n',simuname(k).name,max(max(infos{1},[],3),[],2)-max(min(infos{1},[],3),[],2),max(max(infos{2},[],3),[],2)-max(min(infos{1},[],3),[],2),max(max(infos{2},[],3),[],2)-max(min(infos{3},[],3),[],2))
    save([simuname(k).name, '.ICs.mat'],'gdA3','gdA4','gdA5','gdW3','gdW4','gdW5','gdWi','gdAi','infos','mamariRC','Cinfos')
end