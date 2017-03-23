% [Ph TotPh] = PhaseFromCycles(t, Start, End)
%
% computes the phase of a set of spikes (at times t) from a set of
% cycle beginning and ends.  
%
% Phases are in the range 0 to 2*pi.  If a spike is not in a cycle, 
% you get NaN.
%
% This means if you are using josef's .the.1 or .gam.1 files, 0 is now
% the NEGATIVE phase.
%
% Optional output TotPh attempts to make an "unwrapped" phase.  Where 
% there is a gap between cycles (i.e. the start of the next cycle does 
% not coincide with the end of the previous one), 100 is added to the 
% cycle count.

function [Ph, TotPh] = PhaseFromCycles(t, Start, End)

% make all inputs column vectors
t = t(:);
Start = Start(:);
End = End(:);


% remove duplicate rows
Dupes = (diff(Start)==0);
if ~isequal(Dupes, diff(End)==0)
    error('duplicate start entries don''t match duplicate end entries');
end
Start(Dupes)=[];
End(Dupes)= [];

% get number of cycles
nCycles = length(Start);
if length(End)~=nCycles
    error('Start and End are not same length');
end

if ~isequal(Start, sort(Start)) | ~isequal(End, sort(End)) | ~isequal(t, sort(t))
    error('Start, End, and t need to be sorted');
end

nPoints = length(t);

ToSort = [t; End; Start]; % if we have equaliy we want spk; end; start
% sort it
[Sorted Index] = sort(ToSort); % Sorted = ToSort(Index)
SortPos(Index) = 1:2*nCycles+nPoints; % ToSort = Sorted(SortPos)
SpkSortPos = SortPos(1:nPoints); % position of spikes in the sorted array.

% Label arrays
StartMarkUnsrt = [zeros(nPoints+nCycles,1) ; ones(nCycles,1)];
EndMarkUnsrt = [zeros(nPoints,1); ones(nCycles,1) ; zeros(nCycles,1)];
StartMark = StartMarkUnsrt(Index);
EndMark = EndMarkUnsrt(Index);

WhichCycle = cumsum(StartMark);
InCycle = WhichCycle - cumsum(EndMark);

if any(InCycle(SpkSortPos)~=0 & InCycle(SpkSortPos)~=1)
    error('cycles should not overlap');
end

% find which cycle each spike belongs to
SpkCyc = WhichCycle(SpkSortPos).*InCycle(SpkSortPos); %0 if not in a cycle

% make output array
Ph = NaN*ones(nPoints,1); % NaN if not in any cycle
Good = find(SpkCyc>0);
Ph(Good) = 2*pi*(t(Good)-Start(SpkCyc(Good)))./(End(SpkCyc(Good)) - Start(SpkCyc(Good)));

% now make re-heated cycle number arrays

Gap = [0; Start(2:nCycles)~=End(1:nCycles-1)];
BigCycNo = (1:nCycles)' + cumsum(Gap)*100;

TotPh = Ph;
TotPh(Good) = TotPh(Good) + 2*pi*BigCycNo(SpkCyc(Good));
