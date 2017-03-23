function trialEdges = GetTrialEdges(fileBase,trialTypesBool)
%returns a nx2 matrix with the whl index for the beginning and end of each trial 

notPortsOrDelay = LoadMazeTrialTypes(fileBase,trialTypesBool,[0 0 0 1 1 1 1 1 1]);

whlIndexInfo = load([fileBase '_whl_indexes.mat']);
if strcmp(getfield(whlIndexInfo,'taskType'),'alter') | strcmp(getfield(whlIndexInfo,'taskType'),'force')
    atPorts = LoadMazeTrialTypes(fileBase,trialTypesBool,[1 1 0 0 0 0 0 0 0]);
end
if strcmp(getfield(whlIndexInfo,'taskType'),'circle') | strcmp(getfield(whlIndexInfo,'taskType'),'Z')
    atPorts = LoadMazeTrialTypes(fileBase,trialTypesBool,[1 1 1 0 0 0 0 0 0]);
end

trialEdges = [];

trialbegin = find(notPortsOrDelay(:,1)~=-1);
while ~isempty(trialbegin),

    trialend = trialbegin(1) + find(atPorts((trialbegin(1)+1):end,1)~=-1);
    if isempty(trialend),
        fprintf('\nbad trial... skipping!!\n');
        break;
    end
    trialEdges = [trialEdges; trialbegin(1) trialend(1)];
    
    trialbegin = trialend(1)-1+find(notPortsOrDelay(trialend(1):end,1)~=-1);
end
