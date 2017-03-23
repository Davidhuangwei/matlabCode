function desigVar = LoadDesigVar(fileBaseMat,dirName,depVar,trialDesig)
%function desigVar = LoadDesigVar(fileBaseMat,dirName,depVar,trialDesig)
% e.g.
%    trialDesig.returnArm = {'alter',[0 0 0 0 0 1 0 1 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
%    trialDesig.centerArm = {'alter',[0 0 0 0 0 1 0 1 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
%    trialDesig.Tjunction = {'alter',[0 0 0 0 0 1 0 1 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
%    trialDesig.goalArm =   {'alter',[0 0 0 0 0 1 0 1 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};

desigConditions = fieldnames(trialDesig);

depVarCell = ParseStructName(depVar);

desigVar = [];
for i=1:size(fileBaseMat,1)

    inDir = [fileBaseMat(i,:) '/' dirName];

    taskType = LoadVar([inDir '/taskType.mat']);
    trialType = LoadVar([inDir '/trialType.mat']);
    mazeLocation = LoadVar([inDir '/mazeLocation.mat']);
    measVar = LoadVar([inDir '/' depVarCell{1} '.mat']);
    for j=2:length(depVarCell)
        measVar = getfield(measVar,depVarCell{j});
    end
    %selectedTrials = cell(size(trialDesig,1),1);
    %trialDesig = cell(cat(2,{taskType},{[1 0 1 0 0 0 0 0 0 0 0 0 0]},{[0 0 0 0 0 0 0 1 1]}));
    for m=1:length(desigConditions)
        selectedTrials = zeros(length(taskType),1);
        %keyboard
        condition = getfield(trialDesig,desigConditions{m});
        for n=1:size(condition,1)
            selectedTrials = selectedTrials | ...
                (strcmp(condition{n,1},taskType) & ...
                trialType*condition{n,2}'>condition{n,3} & ...
                mazeLocation*condition{n,4}'>condition{n,5});
        end
        if isfield(desigVar,desigConditions{m})
            nObs = size(getfield(desigVar,desigConditions{m}),1);
        else
            nObs=0;
        end
%        desigConditions{m}
 %           fileBaseMat(i,:)
 %   find(selectedTrials)

        desigVar = setfield(desigVar,desigConditions{m},...
            {nObs+1:nObs+length(find(selectedTrials)),1:size(measVar,2),1:size(measVar,3)},...
            measVar(selectedTrials,:,:));
    end

end
return

