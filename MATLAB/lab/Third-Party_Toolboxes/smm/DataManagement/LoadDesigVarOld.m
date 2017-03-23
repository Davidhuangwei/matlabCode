function desigVar = LoadDesigVar(fileBaseCell,dirName,depVar,trialDesig)
%function desigVar = LoadDesigVar(fileBaseCell,dirName,depVar,trialDesig)
% e.g.
%    trialDesig.alter.returnArm = {{{'taskType','alter'},...
%                                   {'trialType',[1 0 1 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
%                                   {'mazeLocation',[0 0 0 0 0 0 0 1 1],'>',0.6}}};
%    trialDesig.alter.centerArm = {{{'taskType','alter'},...
%                                   {'trialType',[1 0 1 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
%                                   {'mazeLocation',[0 0 0 0 1 0 0 0 0],'>',0.6}}};
%    trialDesig.circle.quad1 =    {...
%                                  {{'taskType','circle'},...
%                                   {'trialType',[1 0 0 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
%                                   {'mazeLocation',[0 0 0 0 0 0 0 0 1],'>',0.6}},...
%                                  {{'taskType','circle'},...
%                                   {'trialType',[0 0 1 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
%                                   {'mazeLocation',[0 0 0 0 0 0 0 1 0],'>',0.6}}...
%                                 };
%    trialDesig.circle.quad2 =    {...
%                                  {{'taskType','circle'},...
%                                   {'trialType',[1 0 0 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
%                                   {'mazeLocation',[0 0 0 0 0 0 1 0 0],'>',0.6}},...
%                                  {{'taskType','circle'},...
%                                   {'trialType',[0 0 1 0 0 0 0 0 0 0 0 0 0],'>',0.6},...
%                                   {'mazeLocation',[0 0 0 0 0 1 0 0 0],'>',0.6}}...
%                                 };
% 
% Note that:
% trial types specified by layer 1 of the cell array are inclusively combined by the | operator  
% trial types specified by layer 2 of the cell array are exclusively combined by the & operator
%----------default arguments for the wavelet transform-----------

if ~iscell(fileBaseCell) % support for legacy data types
    fileBaseCell = mat2cell(fileBaseCell,ones(size(fileBaseCell,1),1),size(fileBaseCell,2));
end
desigConditions = fieldnames(trialDesig);
desigVar = [];
%%% uses recursion to descend into desigVar %%%
if isstruct(eval(['trialDesig.',desigConditions{1}]))
    for i=1:length(desigConditions)
        desigVar = setfield(desigVar,desigConditions{i},...
            LoadDesigVar(fileBaseCell,dirName,depVar,getfield(trialDesig,desigConditions{i})));
    end
else

    for i=1:length(fileBaseCell)

        inDir = [fileBaseCell{i,:} '/' dirName '/'];
        measVar = LoadField([inDir depVar]);

        for m=1:length(desigConditions)
            condition = getfield(trialDesig,desigConditions{m});
            for n=1:length(condition)
                for p=1:length(condition{n})
                    condVar = [];
                    try
                        condVar = LoadField([inDir condition{n}{p}{1}]);
                    catch
                        fprintf('WARNING: %s not found... skipping\n',[inDir condition{n}{p}{1}]);
                    end
                    if ~isempty(condVar)
                       if ~exist('tempSelTrials','var')
                            tempSelTrials = ones(size(condVar,1),1);
                        end
                        if isnumeric(condition{n}{p}{2})
                            switch condition{n}{p}{3}
                                case '=='
                                    tempSelTrials = tempSelTrials & condVar*condition{n}{p}{2}' == condition{n}{p}{4};
                                case '~='
                                    tempSelTrials = tempSelTrials & condVar*condition{n}{p}{2}' ~= condition{n}{p}{4};
                                case '<'
                                    tempSelTrials = tempSelTrials & condVar*condition{n}{p}{2}' < condition{n}{p}{4};
                                case '<='
                                    tempSelTrials = tempSelTrials & condVar*condition{n}{p}{2}' <= condition{n}{p}{4};
                                case '>'
                                    tempSelTrials = tempSelTrials & condVar*condition{n}{p}{2}' > condition{n}{p}{4};
                                case '>='
                                    tempSelTrials = tempSelTrials & condVar*condition{n}{p}{2}' >= condition{n}{p}{4};
                                otherwise
                                    ERROR_IN_LoadDesigVar
                            end
                        else
                            tempSelTrials = tempSelTrials & strcmp(condVar,condition{n}{p}{2});
                        end
                    end
                end
                if exist('tempSelTrials','var') 
                    if exist('selectedTrials','var')
                        selectedTrials = selectedTrials | tempSelTrials;
                    else
                        selectedTrials = tempSelTrials;
                    end
                    clear tempSelTrials;
                end
            end
            if isfield(desigVar,desigConditions{m})
                nObs = size(getfield(desigVar,desigConditions{m}),1);
            else
                nObs=0;
            end
            %        desigConditions{m}
            %           fileBaseCell(i,:)
            %   find(selectedTrials)
            if ~exist('selectedTrials','var')
                selectedTrials = [];
            end
            desigVar = setfield(desigVar,desigConditions{m},...
                {nObs+1:nObs+length(find(selectedTrials)),1:size(measVar,2),1:size(measVar,3)},...
                measVar(selectedTrials,:,:));
            clear selectedTrials
            %desigVar.(desigConditions{m}) = cat(1,desigVar.(desigConditions{m}),measVar(selectedTrials,:,:,:,:,:,:,:,:,:,:,:,:,:,:,:));
        end

    end
end
return


%% testing %%%
fields1 = fieldnames(new)
for j=1:length(fields1)
    fields2 = fieldnames(new.(fields1{j}))
    for k=1:length(fields2)
        fprintf('%s,%s\n',fields1{j},fields2{k})
        size(new.(fields1{j}).(fields2{k}))
        size(old.(fields1{j}).(fields2{k}))
        if new.(fields1{j}).(fields2{k}) ~= old.(fields1{j}).(fields2{k})
            fprintf('BaD')
        end
    end
end
    
    
    
    
    
    