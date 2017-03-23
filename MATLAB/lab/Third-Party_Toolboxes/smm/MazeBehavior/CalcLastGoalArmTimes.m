function goalArmTimes = CalcLastGoalArmTimes(fileBaseCell,winLen,trialTypesBool,varargin)
outFileName = DefaultArgs(varargin,{''});

whlSamp = 39.065;
eegSamp = 1250;
bps = 2;
whlWinLen = whlSamp*winLen/eegSamp;

cwd = pwd;
for k=1:length(fileBaseCell)
    fileBase = fileBaseCell{k};
    cd([SC(cwd) fileBase])
    taskType = GetTaskType(fileBase);
    
    trialMidsStruct = CalcFileMidPoints02(fileBase,0,trialTypesBool);
    if strcmp(taskType,'alter') | strcmp(taskType,'force')
        goalArmInd = find(LoadMazeTrialTypes(fileBase,trialTypesBool,[0 0 0 0 0 1 1 0 0],0) > 0);
    elseif strcmp(taskType,'Zmaze') | strcmp(taskType,'Z')
        goalArmInd = find(LoadMazeTrialTypes(fileBase,trialTypesBool,[0 0 0 0 0 0 0 1 0],0) > 0);
    elseif strcmp(taskType,'circle')
        goalArmInd = find(LoadCircleQuads(fileBase,trialTypesBool,[0 0 0 1],0) > 0);
    else
        error([mfilename ':taskTypeNotFound'],['taskType - ' taskType ' Not recognized'])
    end
    
    goalArmTimes = [];
    for j=1:length(trialMidsStruct.(fileBase).waterPort)
        lastGoalArm = goalArmInd(find(goalArmInd < trialMidsStruct.(fileBase).waterPort(j),1,'last'));
        goalArmTimes(j,1) = goalArmInd(find(goalArmInd < lastGoalArm-whlWinLen/2,1,'last')) / whlSamp;
%         goalArmTimes(j,1) = goalArmInd(find(goalArmInd < lastGoalArm-whlWinLen/2,1,'last'));
    end

    if ~isempty(outFileName)
        fprintf(['Saving: ' outFileName '\n'])
        save(outFileName,'-ascii','goalArmTimes');        
    end
end
cd(cwd)

return


%%%%%%%% testing %%%%%%%%%%%
saveName = 'lastGoalArmTimes_goodCorr_Win626.txt'
close all
winLen = 626;
cwd = pwd;
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};
    cd(cwd)
    goalArmTimes = CalcLastGoalArmTimes({fileBase},winLen,trialTypesBool,saveName)*39.065;
%     goalArmTimes = CalcLastGoalArmTimes({fileBase},winLen,trialTypesBool)
    cd(fileBase)
    trialMidsStruct = CalcFileMidPoints02(fileBase,0,trialTypesBool);
    allMaze = LoadMazeTrialTypes(fileBase,trialTypesBool,[1 1 1 1 1 1 1 1 1],0);
    figure
    hold on
    plot(allMaze(:,1),allMaze(:,2),'.k')
    if strcmp(GetTaskType(fileBase),'alter') | strcmp(GetTaskType(fileBase),'force')
        plot(allMaze(trialMidsStruct.(fileBase).goalArm,1),allMaze(trialMidsStruct.(fileBase).goalArm,2),'c.')
        trialMidsStruct.(fileBase).goalArm;
    elseif strcmp(GetTaskType(fileBase),'circle')
        plot(allMaze(trialMidsStruct.(fileBase).quad4,1),allMaze(trialMidsStruct.(fileBase).quad4,2),'c.')
        trialMidsStruct.(fileBase).quad4;
    elseif strcmp(GetTaskType(fileBase),'Zmaze') | strcmp(GetTaskType(fileBase),'Z')
        plot(allMaze(trialMidsStruct.(fileBase).arm3,1),allMaze(trialMidsStruct.(fileBase).arm3,2),'c.')
    end
    plot(allMaze(round(goalArmTimes),1),allMaze(round(goalArmTimes),2),'ro')
%     plot(allMaze(goalArmTimes,1),allMaze(goalArmTimes,2),'ro')
end
cd(cwd)


