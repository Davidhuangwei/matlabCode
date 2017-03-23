function trialMidRegionsStruct = CalcFileMidPoints(fileBaseMat,plotFig,trialtypesbool)
% function trialMidRegionsStruct = CalcFileMidPoints(fileBaseMat,taskType,trialtypesbool,plotFig)

if ~exist('plotFig','var') | isempty(plotFig)
    plotFig = 0;
end

if ~exist('trialtypesbool','var') | isempty(trialtypesbool)
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp
end
% [1 0 1 0 0 0 0 0 0 0 0 0 0]
% [0 0 0 1 1 1 1 1 1]

trialMidRegionsStruct = [];

for i=1:size(fileBaseMat,1)
    allMazeRegions = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 1 1 1 1 1 1]);
    taskType = GetTaskType(fileBaseMat(i,:));
    
    if strcmp(taskType,'alter') | strcmp(taskType,'force')
        waterPorts = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[1 1 0 0 0 0 0 0 0]);
        mazeRegionsStruct = [];
        mazeRegionsStruct = setfield(mazeRegionsStruct,'returnArm','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 0 0 1 1]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'centerArm','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 1 0 0 0 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'Tjunction','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 1 0 0 0 0 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'goalArm','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 1 1 0 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'returnArm','midCalc',0);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'centerArm','midCalc',2/3);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'Tjunction','midCalc',0);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'goalArm','midCalc',0);
    end
    if strcmp(taskType,'Zmaze') | strcmp(taskType,'Z')
        waterPorts = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[1 1 1 0 0 0 0 0 0]);

        mazeRegionsStruct = [];
        mazeRegionsStruct = setfield(mazeRegionsStruct,'arm1','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,   [0 0 0 1 0 0 0 0 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'corner1','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 1 0 0 0 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'arm2','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,   [0 0 0 0 0 1 0 0 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'corner2','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 0 1 0 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'arm3','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,   [0 0 0 0 0 0 0 1 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'arm1','midCalc',0);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'corner1','midCalc',-1);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'arm2','midCalc',0);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'corner2','midCalc',-1);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'arm3','midCalc',0);
    end

    if strcmp(taskType,'circle')
        
        waterPorts = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[1 1 1 0 0 0 0 0 0]);

        mazeRegionsStruct = [];
        
        quad1 = LoadCircleQuads(fileBaseMat(i,:),trialtypesbool,[1 0 0 0]);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad1','data',quad1);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad1','midCalc',0);

        quad2 = LoadCircleQuads(fileBaseMat(i,:),trialtypesbool,[0 1 0 0]);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad2','data',quad2);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad2','midCalc',0);

        quad3 = LoadCircleQuads(fileBaseMat(i,:),trialtypesbool,[0 0 1 0]);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad3','data',quad3);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad3','midCalc',0);

        quad4 = LoadCircleQuads(fileBaseMat(i,:),trialtypesbool,[0 0 0 1]);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad4','data',quad4);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad4','midCalc',0);
    end

    trialMidRegionsStruct = setfield(trialMidRegionsStruct,fileBaseMat(i,:),CalcTrialMidPoints(allMazeRegions,waterPorts,mazeRegionsStruct,plotFig));
    %trialMidRegionsStruct = CalcTrialMidPoints(allMazeRegions,waterPorts,mazeRegionsStruct,plotFig)
end
