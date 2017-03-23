function trialMidRegionsStruct = CalcFileMidPoints02(fileBaseMat,plotFig,trialtypesbool)
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
plotWindow = 0.25;
timeOffset = 0.3;

trialMidRegionsStruct = [];

for i=1:size(fileBaseMat,1)
    allMazeRegions = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[1 1 1 1 1 1 1 1 1]);
    taskType = GetTaskType(fileBaseMat(i,:));
    
    if strcmp(taskType,'alter') | strcmp(taskType,'force')
        waterPorts = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[1 1 0 0 0 0 0 0 0]);
        startArm = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 0 0 1 1]);
        endArm = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 1 1 0 0]);
        
        mazeRegionsStruct = [];
        mazeRegionsStruct = setfield(mazeRegionsStruct,'returnArm','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 0 0 1 1]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'returnArm','locationCalc','nearestAbsDist');
        mazeRegionsStruct = setfield(mazeRegionsStruct,'returnArm','timeOffset',0);

        mazeRegionsStruct = setfield(mazeRegionsStruct,'delayArea','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 1 0 0 0 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'delayArea','locationCalc','start');
        mazeRegionsStruct = setfield(mazeRegionsStruct,'delayArea','timeOffset',-0.3);

        mazeRegionsStruct = setfield(mazeRegionsStruct,'centerArm','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 1 0 0 0 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'centerArm','locationCalc',2/3);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'centerArm','timeOffset',0);

        mazeRegionsStruct = setfield(mazeRegionsStruct,'Tjunction','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 1 0 0 0 0 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'Tjunction','locationCalc','nearestAbsDist');
        mazeRegionsStruct = setfield(mazeRegionsStruct,'Tjunction','timeOffset',0.025);

        mazeRegionsStruct = setfield(mazeRegionsStruct,'goalArm','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 1 1 0 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'goalArm','locationCalc','nearestAbsDist');
        mazeRegionsStruct = setfield(mazeRegionsStruct,'goalArm','timeOffset',0);

        mazeRegionsStruct = setfield(mazeRegionsStruct,'waterPort','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 1 1 0 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'waterPort','locationCalc','end');
        mazeRegionsStruct = setfield(mazeRegionsStruct,'waterPort','timeOffset',0.4);
        %trialMidRegionsStruct = setfield(trialMidRegionsStruct,fileBaseMat(i,:),CalcFig8TrialMidPoints02(allMazeRegions,waterPorts,startArm,mazeRegionsStruct,plotFig,plotWindow));
    end
    if strcmp(taskType,'Zmaze') | strcmp(taskType,'Z')
        waterPorts = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[1 1 1 0 0 0 0 0 0]);
        startArm = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 1 0 0 0 0 0]);
        endArm = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 0 0 1 0]);

        mazeRegionsStruct = [];

        mazeRegionsStruct = setfield(mazeRegionsStruct,'delayArea','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,   [0 0 0 1 0 0 0 0 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'delayArea','locationCalc','start');
        mazeRegionsStruct = setfield(mazeRegionsStruct,'delayArea','timeOffset',-0.3);
        
        mazeRegionsStruct = setfield(mazeRegionsStruct,'arm1','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,   [0 0 0 1 0 0 0 0 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'arm1','locationCalc','nearestAbsDist');
        mazeRegionsStruct = setfield(mazeRegionsStruct,'arm1','timeOffset',0);
        
        mazeRegionsStruct = setfield(mazeRegionsStruct,'corner1','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 1 0 0 0 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'corner1','locationCalc','farestXdist');
        mazeRegionsStruct = setfield(mazeRegionsStruct,'corner1','timeOffset',0);
        
        mazeRegionsStruct = setfield(mazeRegionsStruct,'arm2','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,   [0 0 0 0 0 1 0 0 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'arm2','locationCalc','nearestAbsDist');
        mazeRegionsStruct = setfield(mazeRegionsStruct,'arm2','timeOffset',0);
       
        mazeRegionsStruct = setfield(mazeRegionsStruct,'corner2','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 0 1 0 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'corner2','locationCalc','farestXdist');
        mazeRegionsStruct = setfield(mazeRegionsStruct,'corner2','timeOffset',0);
       
        mazeRegionsStruct = setfield(mazeRegionsStruct,'arm3','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,   [0 0 0 0 0 0 0 1 0]));     
        mazeRegionsStruct = setfield(mazeRegionsStruct,'arm3','locationCalc','nearestAbsDist');
        mazeRegionsStruct = setfield(mazeRegionsStruct,'arm3','timeOffset',0);
        
        mazeRegionsStruct = setfield(mazeRegionsStruct,'waterPort','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,   [0 0 0 0 0 0 0 1 0]));
        mazeRegionsStruct = setfield(mazeRegionsStruct,'waterPort','locationCalc','end');
        mazeRegionsStruct = setfield(mazeRegionsStruct,'waterPort','timeOffset',1);
        
        %trialMidRegionsStruct = setfield(trialMidRegionsStruct,fileBaseMat(i,:),CalcTrialMidPoints02(allMazeRegions,waterPorts,startArm,mazeRegionsStruct,plotFig,plotWindow));
        
%         mazeRegionsStruct = setfield(mazeRegionsStruct,'waterPort','data',LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,   [1 1 1 0 0 0 0 0 0]));
%         mazeRegionsStruct = setfield(mazeRegionsStruct,'waterPort','locationCalc','start');
%         mazeRegionsStruct = setfield(mazeRegionsStruct,'waterPort','timeOffset',timeOffset);
    end

    if strcmp(taskType,'circle')
        
        waterPorts = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[1 1 1 0 0 0 0 0 0]);
        startArm = LoadCircleQuads(fileBaseMat(i,:),trialtypesbool,[1 0 0 0]);
        endArm = LoadCircleQuads(fileBaseMat(i,:),trialtypesbool,[0 0 0 1]);
        
        mazeRegionsStruct = [];
        
        da = LoadCircleQuads(fileBaseMat(i,:),trialtypesbool,[1 0 0 0]);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'delayArea','data',da);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'delayArea','locationCalc','start');
        mazeRegionsStruct = setfield(mazeRegionsStruct,'delayArea','timeOffset',-0.3);

        quad1 = LoadCircleQuads(fileBaseMat(i,:),trialtypesbool,[1 0 0 0]);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad1','data',quad1);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad1','locationCalc','nearestAbsDist');
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad1','timeOffset',0);

        quad2 = LoadCircleQuads(fileBaseMat(i,:),trialtypesbool,[0 1 0 0]);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad2','data',quad2);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad2','locationCalc','nearestAbsDist');
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad2','timeOffset',0);

        quad3 = LoadCircleQuads(fileBaseMat(i,:),trialtypesbool,[0 0 1 0]);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad3','data',quad3);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad3','locationCalc','nearestAbsDist');
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad3','timeOffset',0);

        quad4 = LoadCircleQuads(fileBaseMat(i,:),trialtypesbool,[0 0 0 1]);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad4','data',quad4);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad4','locationCalc','nearestAbsDist');
        mazeRegionsStruct = setfield(mazeRegionsStruct,'quad4','timeOffset',0);
        
        wp = LoadCircleQuads(fileBaseMat(i,:),trialtypesbool,[0 0 0 1]);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'waterPort','data',wp);
        mazeRegionsStruct = setfield(mazeRegionsStruct,'waterPort','locationCalc','end');
        mazeRegionsStruct = setfield(mazeRegionsStruct,'waterPort','timeOffset',0.8);
%         trialMidRegionsStruct = setfield(trialMidRegionsStruct,fileBaseMat(i,:),CalcCircleZTrialMidPoints02(allMazeRegions,waterPorts,startArm,mazeRegionsStruct,plotFig,plotWindow));
    end
        trialMidRegionsStruct = setfield(trialMidRegionsStruct,fileBaseMat(i,:),CalcTrialMidPoints03(allMazeRegions,waterPorts,startArm,endArm,mazeRegionsStruct,plotFig,plotWindow));

    %trialMidRegionsStruct = CalcTrialMidPoints(allMazeRegions,waterPorts,mazeRegionsStruct,plotFig)
end
