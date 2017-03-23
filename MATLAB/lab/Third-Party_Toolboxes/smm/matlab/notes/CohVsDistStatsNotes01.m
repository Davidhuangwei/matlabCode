statCoh = [];
statDist = [];
groupNames = [];
for j=1:size(chanDist,1)
    for k=1:size(chanDist,2)
        statCoh = cat(1,statCoh,depCell{1,end}{j,k});
        statDist = cat(1,statDist,chanDist{j,k});
%        statCoh = cat(1,statCoh,depCell{1,end}{j,k});
%        statDist = cat(1,statDist,chanDist{j,k});
        if j==k
            groupNames = cat(1,groupNames,repmat({'within'},size(chanDist{j,k})));
        else
            groupNames = cat(1,groupNames,repmat({'between'},size(chanDist{j,k})));
        end
    end
end
       [P,T,STATS,TERMS]=anovan(UnATanCoh(statCoh),{groupNames statDist},'continuous',2,'model','full')     
            