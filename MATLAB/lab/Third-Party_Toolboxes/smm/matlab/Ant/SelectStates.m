% function [MySeg, AllStates] = SelectStates(FileBase, StateLabel, MinLen, Display)
% finds the segments that correspond to the staetes in StateLabel (cell array if>1)
% MinLen - in samples , Display - show the summary of each state
function [MySeg, AllStates] = SelectStates(FileBase, varargin)

[StateLabel, MinLen, Display] = DefaultArgs(varargin,{[], 2*1250, 0});
if isstr(StateLabel)
    StateLabel = {StateLabel };
end

Seg = load([FileBase '.states.res']);
SegLen =  load([FileBase '.states.len']);
SegClu =  load([FileBase '.states.clu']);

Seg2 = Seg(find(SegLen==2),:); Seg2=Seg2(1,:);
MinSeg = Seg2(2)-Seg2(1);
MinLen = MinLen ./ MinSeg; %now in windows
%Labels = {'SWS', 'IMM', 'REM', 'RUN' , 'AWK', 'HVS' , 'ART' ,'DES'};
load([FileBase '.statelabels.mat']);
MyLabels =[];
 for i=1:length(StateLabel)
    thislabel    = find(strcmp(Labels, StateLabel{i}));
    if ~isempty(thislabel)
        MyLabels(end+1) = thislabel;
    end
end
if isempty(MyLabels)
    error('state label is wrong');
    return
end
MySegInd = find(SegLen>MinLen & ismember(SegClu,MyLabels));
if isempty(MySegInd)
    fprintf('no some of the states in that file or too short\n');
    MySeg =[];
    return
end

MySeg = Seg(MySegInd,:);

Shift = round(MinSeg/2);
MySeg = [MySeg(:,1) - Shift MySeg(:,2) + Shift ];
AllStates = Labels(MyLabels);