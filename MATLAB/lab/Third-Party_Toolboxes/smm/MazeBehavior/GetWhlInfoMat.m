function [trialTypes mazeLoc] = GetWhlInfoMat(fileBase,samples)

whlIndexes = load([fileBase '_whl_indexes.mat']);


%   LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
%   [1  0  1  0   0   0   0   0   0   0   0   0  0]
% mazeLocationsBool:
% alter:  rwp lwp  da Tj ca rga lga rra lra
% z:      rwp lwp  da a1 c1 a2  c2  a3
%        [ 0   0   0  1  1   1   1   1   1]
if strcmp(whlIndexes.taskType,'alter')
    trialTypes = cat(2,...
        whlIndexes.LeftRight ,...
        whlIndexes.RightRight ,...
        whlIndexes.RightLeft ,...
        whlIndexes.LeftLeft ,...
        whlIndexes.ponderLeftRight ,...
        whlIndexes.ponderRightRight ,...
        whlIndexes.ponderRightLeft ,...
        whlIndexes.ponderLeftLeft ,...
        whlIndexes.badLeftRight ,...
        whlIndexes.badRightRight ,...
        whlIndexes.badRightLeft ,...
        whlIndexes.badLeftLeft ,...
        whlIndexes.exploration ...
        );

    mazeLoc = cat(2,...
        whlIndexes.rWaterPort ,...
        whlIndexes.lWaterPort ,...
        whlIndexes.delayArea ,...
        whlIndexes.Tjunction ,...
        whlIndexes.centerArm ,...
        whlIndexes.rGoalArm ,...
        whlIndexes.lGoalArm ,...
        whlIndexes.rReturnArm ,...
        whlIndexes.lReturnArm ...
        );
    if exist('samples','var') & ~isempty(samples)
        trialTypes = trialTypes(samples,:);
        mazeLoc = mazeLoc(samples,:);
    end
else
    other_task_types_not_yet_programed
end
return