function UpdateWhlIndexes(filebase,taskType)
load([filebase '_whl_indexes.mat']);
fprintf('\n%s\n',filebase);

if ~exist('lGoalArm','var')
    lGoalArm = Lchoicearm;%         11883x1                     95064  double array
end
if ~exist('lReturnArm','var')
    lReturnArm = Lreturnarm ;%        11883x1                     95064  double array
end
if ~exist('lWaterPort','var')
    lWaterPort = Lwaterport ;%        11883x1                     11883  logical array
end
if ~exist('rGoalArm','var')
    rGoalArm = Rchoicearm   ;%      11883x1                     95064  double array
end
if ~exist('rReturnArm','var')
    rReturnArm = Rreturnarm  ;%       11883x1                     95064  double array
end
if ~exist('rWaterPort','var')
    rWaterPort = Rwaterport  ;%       11883x1                     11883  logical array
end
if ~exist('centerArm','var')
    centerArm = centerarm   ;%       11883x1                     95064  double array
end
if ~exist('Tjunction','var')
    Tjunction = choicepoint ;%       11883x1                     11883  logical array
end
if ~exist('delayArea','var')
    delayArea = delayarea   ;%       11883x1                     11883  logical array
end
if ~exist('LL','var')
    LL = ll                 ;%    1x1                         8  double array
end
if ~exist('LLB','var')
    LLB = llb               ;%     1x1                         8  double array
end
if ~exist('LLP','var')
    LLP = llp               ;%     1x1                         8  double array
end
if ~exist('LR','var')
    LR = lr                 ;%    1x1                         8  double array
end
if ~exist('LRB','var')
    LRB = lrb               ;%     1x1                         8  double array
end
if ~exist('LRP','var')
    LRP = lrp               ;%     1x1                         8  double array
end
if ~exist('RL','var')
    RL = rl                 ;%    1x1                         8  double array
end
if ~exist('RLB','var')
    RLB = rlb               ;%     1x1                         8  double array
end
if ~exist('RLP','var')
    RLP = rlp               ;%     1x1                         8  double array
end
if ~exist('RR','var')
    RR = rr                 ;%    1x1                         8  double array
end
if ~exist('RRB','var')
    RRB = rrb               ;%    1x1                         8  double array
end
if ~exist('RRP','var')
    RRP = rrp               ;%     1x1                         8  double array
end
if ~exist('XP','var')
    XP =  xp ;%
end



matlabVersion = version;
if str2num(matlabVersion(1)) > 6
    fprintf([filebase '_whl_indexes.mat']);
    save([filebase '_whl_indexes.mat'],'-V6','exploration','LeftRight','RightRight','RightLeft','LeftLeft',...
        'ponderLeftRight','ponderRightRight','ponderRightLeft','ponderLeftLeft',...
        'badLeftRight','badRightRight','badRightLeft','badLeftLeft','delayArea','rWaterPort',...
        'lWaterPort','Tjunction','centerArm','rGoalArm','lGoalArm','rReturnArm','lReturnArm',...
        'XP','LR', 'RR', 'RL', 'LL', 'LRP', 'RRP', 'RLP', 'LLP', 'LRB', 'RRB', 'RLB', 'LLB','taskType');
else
    fprintf([filebase '_whl_indexes.mat']);
    save([filebase '_whl_indexes.mat'],'exploration','LeftRight','RightRight','RightLeft','LeftLeft',...
        'ponderLeftRight','ponderRightRight','ponderRightLeft','ponderLeftLeft',...
        'badLeftRight','badRightRight','badRightLeft','badLeftLeft','delayArea','rWaterPort',...
        'lWaterPort','Tjunction','centerArm','rGoalArm','lGoalArm','rReturnArm','lReturnArm',...
        'XP','LR', 'RR', 'RL', 'LL', 'LRP', 'RRP', 'RLP', 'LLP', 'LRB', 'RRB', 'RLB', 'LLB','taskType');
end