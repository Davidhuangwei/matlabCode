function whldat = LoadMazeTrialTypes(fileBase,trialTypesBool,mazeLocationsBool,outputToScreen)
% function whldat = LoadMazeTrialTypes(fileBase,trialTypesBool,mazeLocationsBool,outputToScreen)
% Returns position data for those trials/locations specified by
% trialTypesBool and mazeLocationsBool. Positions for all other trials/locations
% are given a value of -1.
% - Default Values -
% trialTypesBool:
%   LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
%   [1  0  1  0   0   0   0   0   0   0   0   0  0]
% mazeLocationsBool:
% alter:  rwp lwp  da Tj ca rga lga rra lra
% z:      rwp lwp  da a1 c1 a2  c2  a3
%        [ 0   0   0  1  1   1   1   1   1]
% outputToScreen: 0

if ~exist('trialTypesBool','var') | isempty(trialTypesBool)
    trialTypesBool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                   % LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
end
if ~exist('mazeLocationsBool','var') | isempty(mazeLocationsBool)
    mazeLocationsBool = [0   0   0  1  1   1   1   1   1];
                      % rwp lwp  da Tj ca rga lga rra lra
end

if ~exist('outputToScreen','var') | isempty(outputToScreen)
    outputToScreen = 0;
end


numtrials = 0; % for counting trials
nXP = 0;
nLR = 0;
nRR = 0;
nRL = 0;
nLL = 0;
nLRP = 0;
nRRP = 0;
nRLP = 0;
nLLP = 0;
nLRB = 0;
nRRB = 0;
nRLB = 0;
nLLB = 0;

if outputToScreen
    fprintf('\nFile: %s,\n',fileBase);
end
whldat = load([fileBase '.whl']);
[whlm n]=size(whldat);
included = zeros(whlm,1);
if exist([fileBase '_whl_indexes.mat'],'file'),
    if outputToScreen
        fprintf('Including: ');
    end
    load([fileBase '_whl_indexes.mat']);
    if trialTypesBool(1),
        included(LeftRight & whldat(:,1)~=-1)=1;
        numtrials = numtrials + LR;
        nLR = nLR + LR;
        if outputToScreen
            fprintf('LR n=%i, ', nLR);
        end
    end
    if trialTypesBool(2),
        included(RightRight & whldat(:,1)~=-1)=1;
        numtrials = numtrials + RR;
        nRR = nRR + RR;
        if outputToScreen
            fprintf('RR n=%i, ', nRR);
        end
    end
    if trialTypesBool(3),
        included(RightLeft & whldat(:,1)~=-1)=1;
        numtrials = numtrials + RL;
        nRL = nRL + RL;
        if outputToScreen
            fprintf('RL n=%i, ', nRL);
        end
    end
    if trialTypesBool(4),
        included(LeftLeft & whldat(:,1)~=-1)=1;
        numtrials = numtrials + LL;
        nLL = nLL + LL;
        if outputToScreen
            fprintf('LL n=%i, ', nLL);
        end
    end
    if trialTypesBool(5),
        included(ponderLeftRight & whldat(:,1)~=-1)=1;
        numtrials = numtrials + LRP;
        nLRP = nLRP + LRP;
        if outputToScreen
            fprintf('LRP n=%i, ', nLRP);
        end
    end
    if trialTypesBool(6),
        included(ponderRightRight & whldat(:,1)~=-1)=1;
        numtrials = numtrials + RRP;
        nRRP = nRRP + RRP;
        if outputToScreen
            fprintf('RRP n=%i, ', nRRP);
        end
    end
    if trialTypesBool(7),
        included(ponderRightLeft & whldat(:,1)~=-1)=1;
        numtrials = numtrials + RLP;
        nRLP = nRLP + RLP;
        if outputToScreen
            fprintf('RLP n=%i, ', nRLP);
        end
    end
    if trialTypesBool(8),
        included(ponderLeftLeft & whldat(:,1)~=-1)=1;
        numtrials = numtrials + LLP;
        nLLP = nLLP + LLP;
        if outputToScreen
            fprintf('LLP n=%i, ', nLLP);
        end
    end
    if trialTypesBool(9),
        included(badLeftRight & whldat(:,1)~=-1)=1;
        numtrials = numtrials + LRB;
        nLRB = nLRB + LRB;
        if outputToScreen
            fprintf('LRB n=%i, ', nLRB);
        end
    end
    if trialTypesBool(10),
        included(badRightRight & whldat(:,1)~=-1)=1;
        numtrials = numtrials + RRB;
        nRRB = nRRB + RRB;
        if outputToScreen
            fprintf('RRB n=%i, ', nRRB);
        end
    end
    if trialTypesBool(11),
        included(badRightLeft & whldat(:,1)~=-1)=1;
        numtrials = numtrials + RLB;
        nRLB = nRLB + RLB;
        if outputToScreen
            fprintf('RLB n=%i, ', nRLB);
        end
    end
    if trialTypesBool(12),
        included(badLeftLeft & whldat(:,1)~=-1)=1;
        numtrials = numtrials + LLB;
        nLLB = nLLB + LLB;
        if outputToScreen
            fprintf('LLB n=%i, ', nLLB);
        end
    end
    if trialTypesBool(13),
        included(exploration & whldat(:,1)~=-1)=1;
        numtrials = numtrials + XP;
        nXP = nXP + XP;
        if outputToScreen
            fprintf('XP n=%i, ', nXP);
        end
    end
    if outputToScreen
        fprintf('Total n=%i ', numtrials);
    end
    if outputToScreen
        fprintf('\nRemoved:')
    end

% now remove maze locations not specified by mazeLocationsBool
%************* alternation *************%
    whldat(find(~included),:) = -1;
    if strcmp(taskType,'alter') | strcmp(taskType,'force')
        if mazeLocationsBool(1)==0,
            if exist('rWaterPort','var'),
                whldat(find(rWaterPort),:) = -1;
                if outputToScreen
                    fprintf(' rp,');
                end
            end
        end
        if mazeLocationsBool(2)==0,
            if exist('lWaterPort','var'),
                whldat(find(lWaterPort),:) = -1;
                if outputToScreen
                    fprintf(' lp,');
                end
            end
        end
        if mazeLocationsBool(3)==0,
            if exist('delayArea','var'),
                whldat(find(delayArea),:) = -1;
                if outputToScreen
                    fprintf(' da,');
                end
            end
        end
        if mazeLocationsBool(4)==0,
            if exist('Tjunction','var'),
                whldat(find(Tjunction),:) = -1;
                if outputToScreen
                    fprintf(' cp,');
                end
            end
        end
        if mazeLocationsBool(5)==0,
            if exist('centerArm','var'),
                whldat(find(centerArm),:) = -1;
                if outputToScreen
                    fprintf(' ca,');
                end
            end
        end
        if mazeLocationsBool(6)==0,
            if exist('rGoalArm','var'),
                whldat(find(rGoalArm),:) = -1;
                if outputToScreen
                    fprintf(' rca,');
                end
            end
        end
        if mazeLocationsBool(7)==0,
            if exist('lGoalArm','var'),
                whldat(find(lGoalArm),:) = -1;
                if outputToScreen
                    fprintf(' lca,');
                end
            end
        end
        if mazeLocationsBool(8)==0,
            if exist('rReturnArm','var'),
                whldat(find(rReturnArm),:) = -1;
                if outputToScreen
                    fprintf(' rra,');
                end
            end
        end
        if mazeLocationsBool(9)==0,
            if exist('lReturnArm','var'),
                whldat(find(lReturnArm),:) = -1;
                if outputToScreen
                    fprintf(' lra,');
                end
            end
        end
    %************* z maze *************%
    elseif strcmp(taskType, 'Z')
                if mazeLocationsBool(1)==0,
            if exist('rWaterPort','var'),
                whldat(find(rWaterPort),:) = -1;
                if outputToScreen
                    fprintf(' rp,');
                end
            end
        end
        if mazeLocationsBool(2)==0,
            if exist('lWaterPort','var'),
                whldat(find(lWaterPort),:) = -1;
                if outputToScreen
                    fprintf(' lp,');
                end
            end
        end
        if mazeLocationsBool(3)==0,
            if exist('delayArea','var'),
                whldat(find(delayArea),:) = -1;
                if outputToScreen
                    fprintf(' da,');
                end
            end
        end
        if mazeLocationsBool(4)==0,
            if exist('arm1','var'),
                whldat(find(arm1),:) = -1;
                if outputToScreen
                    fprintf(' a1,');
                end
            end
        end
        if mazeLocationsBool(5)==0,
            if exist('corner1','var'),
                whldat(find(corner1),:) = -1;
                if outputToScreen
                    fprintf(' c1,');
                end
            end
        end
        if mazeLocationsBool(6)==0,
            if exist('arm2','var'),
                whldat(find(arm2),:) = -1;
                if outputToScreen
                    fprintf(' a2,');
                end
            end
        end
        if mazeLocationsBool(7)==0,
            if exist('corner2','var'),
                whldat(find(corner2),:) = -1;
                if outputToScreen
                    fprintf(' c2,');
                end
            end
        end
        if mazeLocationsBool(8)==0,
            if exist('arm3','var'),
                whldat(find(arm3),:) = -1;
                if outputToScreen
                    fprintf(' a3,');
                end
            end
        end
        
        %%%%%%%%%%%% Circle Task %%%%%%%%%%%%%%
    elseif strcmp(taskType,'circle')
        if mazeLocationsBool(1)==0,
            if exist('rWaterPort','var'),
                whldat(find(rWaterPort),:) = -1;
                if outputToScreen
                    fprintf(' rp,');
                end
            end
        end
        if mazeLocationsBool(2)==0,
            if exist('lWaterPort','var'),
                whldat(find(lWaterPort),:) = -1;
                if outputToScreen
                    fprintf(' lp,');
                end
            end
        end
        if mazeLocationsBool(3)==0,
            if exist('delayArea','var'),
                whldat(find(delayArea),:) = -1;
                if outputToScreen
                    fprintf(' da,');
                end
            end
        end
        if mazeLocationsBool(4)==0,
            if exist('Tjunction','var'),
                whldat(find(Tjunction),:) = -1;
                if outputToScreen
                    fprintf(' cp,');
                end
            end
        end
        if mazeLocationsBool(5)==0,
            if exist('centerArm','var'),
                whldat(find(centerArm),:) = -1;
                if outputToScreen
                    fprintf(' ca,');
                end
            end
        end
        if mazeLocationsBool(6)==0,
            if exist('rGoalArm','var'),
                whldat(find(rGoalArm),:) = -1;
                if outputToScreen
                    fprintf(' rca,');
                end
            end
        end
        if mazeLocationsBool(7)==0,
            if exist('lGoalArm','var'),
                whldat(find(lGoalArm),:) = -1;
                if outputToScreen
                    fprintf(' lca,');
                end
            end
        end
        if mazeLocationsBool(8)==0,
            if exist('rReturnArm','var'),
                whldat(find(rReturnArm),:) = -1;
                if outputToScreen
                    fprintf(' rra,');
                end
            end
        end
        if mazeLocationsBool(9)==0,
            if exist('lReturnArm','var'),
                whldat(find(lReturnArm),:) = -1;
                if outputToScreen
                    fprintf(' lra,');
                end
            end
        end        
    end
    if outputToScreen
        fprintf('\n');
    end
else
    warning([mfilename ':whlIndexesNotFound'],...
        ['FILE NOT FOUND: ' fileBase '.whl_indexes.mat - All trial types included']);
end

whldat(whldat(:,1)==0,1) = 1; % zeros aren't good for the Accumulate function
whldat(whldat(:,2)==0,2) = 1;


return

save([filebase '_whl_indexes.mat'],'exploration','LeftRight','RightRight','RightLeft','LeftLeft',...
    'ponderLeftRight','ponderRightRight','ponderRightLeft','ponderLeftLeft',...
    'badLeftRight','badRightRight','badRightLeft','badLeftLeft','delayArea','rWaterPort',...
    'lWaterPort','Tjunction','centerArm','rGoalArm','lGoalArm','rReturnArm','lReturnArm',...
    'XP','LR', 'RR', 'RL', 'LL', 'LRP', 'RRP', 'RLP', 'LLP', 'LRB', 'RRB', 'RLB', 'LLB','taskType');
