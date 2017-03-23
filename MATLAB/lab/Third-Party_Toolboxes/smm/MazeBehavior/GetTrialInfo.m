function [taskType, trialType, mazeLocation, mazeLocName] = GetTrialInfo(fileBase,samples)


%   LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
%   [1  0  1  0   0   0   0   0   0   0   0   0  0]
% mazeLocationsBool:
% alter:  rwp lwp  da Tj ca rga lga rra lra
% z:      rwp lwp  da a1 c1 a2  c2  a3
%        [ 0   0   0  1  1   1   1   1   1]


load([fileBase '_whl_indexes.mat']);
if strcmp(taskType,'rem')
    trialType = [1 1 1 1 1 1 1 1 1 1 1 1 1];
    mazeLocation = [1 1 1 1 1 1 1 1 1];
    return
end

trialType = [sum(LeftRight(samples)) sum(RightRight(samples)) sum(RightLeft(samples)) sum(LeftLeft(samples)) ...
    sum(ponderLeftRight(samples)) sum(ponderRightRight(samples)) sum(ponderRightLeft(samples)) sum(ponderLeftLeft(samples)) ...
    sum(badLeftRight(samples)) sum(badRightRight(samples)) sum(badRightLeft(samples)) sum(badLeftLeft(samples)) ...
    sum(exploration(samples))];

if sum(trialType) ~= 0
    trialType = trialType./sum(trialType); % whichever trialTypes are most encountered during window
else
    trialType = zeros(size(trialType));
end

if strcmp(taskType,'alter') | strcmp(taskType,'force') | strcmp(taskType,'circle')
    mazeLocation = [sum(rWaterPort(samples)) sum(lWaterPort(samples)) sum(delayArea(samples)) ...
        sum(Tjunction(samples)) sum(centerArm(samples)) sum(rGoalArm(samples)) ...
        sum(lGoalArm(samples)) sum(rReturnArm(samples)) sum(lReturnArm(samples))];
end

if strcmp(taskType,'circle')
    quad1 = LoadCircleQuads(fileBase,[1 1 1 1 1 1 1 1 1 1 1 1 1],[1 0 0 0]) > 0;
    quad2 = LoadCircleQuads(fileBase,[1 1 1 1 1 1 1 1 1 1 1 1 1],[0 1 0 0]) > 0;
    quad3 = LoadCircleQuads(fileBase,[1 1 1 1 1 1 1 1 1 1 1 1 1],[0 0 1 0]) > 0;
    quad4 = LoadCircleQuads(fileBase,[1 1 1 1 1 1 1 1 1 1 1 1 1],[0 0 0 1]) > 0;
    circleQuads = [sum(quad1(samples,1)) sum(quad2(samples,1)) sum(quad3(samples,1)) sum(quad4(samples,1))];
    if sum(circleQuads) ~= 0
        circleQuads = circleQuads/sum(circleQuads);
    else
        circleQuads = zeros(size(circleQuads));
    end
end

if strcmp(taskType,'Z')
        mazeLocation = [sum(rWaterPort(samples)) sum(lWaterPort(samples)) sum(delayArea(samples)) ...
        sum(arm1(samples)) sum(corner1(samples)) sum(arm2(samples)) ...
        sum(corner2(samples)) sum(arm3(samples)) 0];
end

if sum(mazeLocation) ~= 0
    mazeLocation = mazeLocation./sum(mazeLocation); % whichever mazeLocations are most encountered during window
else 
    mazeLocation = zeros(size(mazeLocation));
end

% calculate mazeLocName
if strcmp(taskType,'alter') | strcmp(taskType,'force')
    if     sum(mazeLocation.*[0 0 0 1 0 0 0 0 0]) > 0.3
        mazeLocName = 'Tjunction';
    elseif sum(mazeLocation.*[0 0 0 0 0 0 0 1 1]) > 0.5
        mazeLocName = 'returnArm';
    elseif sum(mazeLocation.*[0 0 1 0 0 0 0 0 0]) > 0.5
        mazeLocName = 'delayArea';
    elseif sum(mazeLocation.*[0 0 0 0 1 0 0 0 0]) > 0.5
        mazeLocName = 'centerArm';
    elseif sum(mazeLocation.*[0 0 0 0 0 1 1 0 0]) > 0.5
        mazeLocName = 'goalArm';
    elseif sum(mazeLocation.*[1 1 0 0 0 0 0 0 0]) > 0.5
        mazeLocName = 'waterPort';
    else
        mazeLocName = 'undefined';
    end
end

if strcmp(taskType,'Zmaze') | strcmp(taskType,'Z')
    if     sum(mazeLocation.*[0 0 0 0 1 0 0 0 0]) > 0.3
        mazeLocName = 'corner1';
    elseif sum(mazeLocation.*[0 0 0 0 0 0 1 0 0]) > 0.3
        mazeLocName = 'corner2';
    elseif sum(mazeLocation.*[0 0 1 0 0 0 0 0 0]) > 0.5
        mazeLocName = 'delayArea';
    elseif sum(mazeLocation.*[0 0 0 1 0 0 0 0 0]) > 0.5
        mazeLocName = 'arm1';
    elseif sum(mazeLocation.*[0 0 0 0 0 1 0 0 0]) > 0.5
        mazeLocName = 'arm2';
    elseif sum(mazeLocation.*[0 0 0 0 0 0 0 1 0]) > 0.5
        mazeLocName = 'arm3';
    elseif sum(mazeLocation.*[1 1 0 0 0 0 0 0 0]) > 0.5
        mazeLocName = 'waterPort';
    else
        mazeLocName = 'undefined';
    end
end

if strcmp(taskType,'circle')
    if sum(mazeLocation.*[0 0 1 0 0 0 0 0 0]) > 0.5
        mazeLocName = 'delayArea';
    elseif sum(mazeLocation.*[1 1 0 0 0 0 0 0 0]) > 0.5
        mazeLocName = 'waterPort';
    elseif sum(circleQuads.*[1 0 0 0]) > 0.5
        mazeLocName = 'quad1';
    elseif sum(circleQuads.*[0 1 0 0]) > 0.5
        mazeLocName = 'quad2';
    elseif sum(circleQuads.*[0 0 1 0]) > 0.5
        mazeLocName = 'quad3';
    elseif sum(circleQuads.*[0 0 0 1]) > 0.5
        mazeLocName = 'quad4';
    else
        mazeLocName = 'undefined';
    end
end


return