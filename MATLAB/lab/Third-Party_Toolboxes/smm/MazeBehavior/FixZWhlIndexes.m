function FixZWhlIndexes(fileBaseMat)
for i=1:size(fileBaseMat,1)
    filebase = fileBaseMat(i,:);
    load([filebase '_whl_indexes.mat']);
    
    tempLeftRight = LeftRight;
    LeftRight = RightLeft;
    RightLeft = tempLeftRight;


    tempBadLeftRight = badLeftRight;
    badLeftRight = badRightLeft;
    badRightLeft = tempBadLeftRight;

    tempLR = LR;
    LR = RL;
    RL = tempLR;

    tempLRB = LRB;
    LRB = RLB;
    RLB = tempLRB;

    matlabVersion = version;
    if str2num(matlabVersion(1)) > 6
        save([filebase '_whl_indexes.mat'],'-V6','exploration','LeftRight','RightRight','RightLeft','LeftLeft',...
            'ponderLeftRight','ponderRightRight','ponderRightLeft','ponderLeftLeft',...
            'badLeftRight','badRightRight','badRightLeft','badLeftLeft','delayArea','rWaterPort',...
            'lWaterPort','arm1','arm2','arm3','corner1','corner2',...
            'XP','LR', 'RR', 'RL', 'LL', 'LRP', 'RRP', 'RLP', 'LLP', 'LRB', 'RRB', 'RLB', 'LLB','taskType');
        donewithfile = 1;
    else
        save([filebase '_whl_indexes.mat'],'exploration','LeftRight','RightRight','RightLeft','LeftLeft',...
            'ponderLeftRight','ponderRightRight','ponderRightLeft','ponderLeftLeft',...
            'badLeftRight','badRightRight','badRightLeft','badLeftLeft','delayArea','rWaterPort',...
            'lWaterPort','arm1','arm2','arm3','corner1','corner2',...
            'XP','LR', 'RR', 'RL', 'LL', 'LRP', 'RRP', 'RLP', 'LLP', 'LRB', 'RRB', 'RLB', 'LLB','taskType');
        donewithfile = 1;
    end
end
