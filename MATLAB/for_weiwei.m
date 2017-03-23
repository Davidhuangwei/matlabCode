%Load gamma burst borders
InputBurstFile = sprintf(['%s.%s.%s.%s.%d-%d'], FileBase, 'SelectBursts3', SignalType, PeriodTitle, Channels([1 end])  );
fprintf(['Loading burst coordinates from %s.mat ...'], InputBurstFile)
load([InputBurstFile '.mat'], 'BurstChanIndex', 'Params');
fprintf('DONE\n')

%Load gamma burst refined timestamps (with LFP-refined burst times!)
InputTimeFile = sprintf(['%s.%s.%s.%s.%d-%d'], FileBase, 'GammaBurstSpan3', SignalType, PeriodTitle, Channels([1 end]) );
fprintf(['Loading refined burst timestamps from %s.mat ...'], InputTimeFile)
load([InputTimeFile '.mat'], 'RefinedBurstTime', 'BurstTimeSpan');
BurstTime = RefinedBurstTime; clear RefinedBurstTime
fprintf('DONE\n')


%Load boundaries of the frequency-phase groups
if isempty(OutFileIndex)
    InputGroupFile = sprintf(['%s.%s.%s.%s.%d-%d'], FileBase, 'SortBurstsIntoGroups2', SignalType, PeriodTitle, Channels([1 end]) );
else
    InputGroupFile = sprintf(['%s.%s.%s.%s.%d-%d.%d'], FileBase, 'SortBurstsIntoGroups2', SignalType, PeriodTitle, Channels([1 end]), OutFileIndex );
end
fprintf(['Loading indices of bursts from different freq/phase groups from %s ...'], InputGroupFile)
load([InputGroupFile '.mat'],'BurstGroup');
fprintf('DONE\n')

