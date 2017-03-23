function [tRes,tClu]=getRes(Res,Clu,Periods)
% [tRes,tClu]=getRes(Res,Clu,Periods)
nprd=size(Periods);
    tClu=[];
    tRes=[];
    addb=0;
for k=1:nprd
    
    %% get spike time
        temp=find((Res<(Periods(k,2)-50))&(Res>(Periods(k,1)+50)));
        tClu=[tClu;Clu(temp)];
        tRes=[tRes;Res(temp)-Periods(k,1)+1+addb];
        addb=addb+Periods(k,2)-Periods(k,1)+1;
end