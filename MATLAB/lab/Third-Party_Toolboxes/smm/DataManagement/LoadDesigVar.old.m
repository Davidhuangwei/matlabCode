function desigVar = LoadDesigVar(fileBaseMat,dirName,depVar,trialDesig)
%function desigVar = LoadDesigVar(fileBaseMat,dirName,depVar,trialDesig)
% e.g.
%    trialDesig.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
%    trialDesig.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
%    trialDesig.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
%    trialDesig.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};

desigConditions = fieldnames(trialDesig);
desigVar = [];
if isstruct(eval(['trialDesig.',desigConditions{1}]))
    for i=1:length(desigConditions)
        desigVar = setfield(desigVar,desigConditions{i},...
            LoadDesigVar(fileBaseMat,dirName,depVar,getfield(trialDesig,desigConditions{i})));
    end
else
    depVarCell = ParseStructName(depVar);

    for i=1:size(fileBaseMat,1)

        inDir = [fileBaseMat(i,:) '/' dirName];

        taskType = LoadVar([inDir '/taskType.mat']);
        if exist([inDir '/trialType.mat'],'file')
            trialType = LoadVar([inDir '/trialType.mat']);
        else
            trialType = repmat([1 1 1 1 1 1 1 1 1 1 1 1 1],size(taskType));
        end
        if exist([inDir '/mazeLocation.mat'],'file')
            mazeLocation = LoadVar([inDir '/mazeLocation.mat']);
        else
            mazeLocation = repmat([1 1 1 1 1 1 1 1 1],size(taskType));
        end
        measVar = LoadVar([inDir '/' depVarCell{1} '.mat']);
        for j=2:length(depVarCell)
            measVar = getfield(measVar,depVarCell{j});
        end
        %selectedTrials = cell(size(trialDesig,1),1);
        %trialDesig = cell(cat(2,{taskType},{[1 0 1 0 0 0 0 0 0 0 0 0 0]},{[0 0 0 0 0 0 0 1 1]}));
        for m=1:length(desigConditions)
            selectedTrials = zeros(length(taskType),1);
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
            %desigVar.(desigConditions{m}) = cat(1,desigVar.(desigConditions{m}),measVar(selectedTrials,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:));
        end

    end
end
return

