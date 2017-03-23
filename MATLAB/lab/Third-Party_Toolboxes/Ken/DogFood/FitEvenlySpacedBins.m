% [Starts, Assignments] = FitEvenlySpacedBins(BinSize,Ranges,Points);
% 
% tiles a set of ranges with as many bins of specified size
% as it can, given that they must lie entirely in a range
%
% will also assign a set of points (e.g. spike times) into the bins
% if left bin<=point<right bin


function [Starts, Assignments] = FitEvenlySpacedBins(BinSize,Epochs,Points);

if nargin>=3
    Assignments = zeros(size(Points));
end

Starts = [];
for e=1:size(Epochs,1)
    FirstBin = length(Starts)+1;
    % find bin starts
    MyStarts = Epochs(e,1):BinSize:Epochs(e,2);
    
    % don't include last one, since it will overlap
    nEpochBins = length(MyStarts)-1;
    if (nEpochBins==0) continue; end;
    Starts = [Starts, MyStarts(1:nEpochBins)];
    
    if nargin>=3
        EpochPoints = find(Points>=MyStarts(1) & Points<MyStarts(nEpochBins)+BinSize);
        Assignments(EpochPoints) = FirstBin + floor((Points(EpochPoints)-Epochs(e,1))/BinSize);
    end
end    

% Stops = Starts + BinSize;