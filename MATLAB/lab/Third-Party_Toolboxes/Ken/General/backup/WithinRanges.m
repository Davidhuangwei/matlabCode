function out = WithinRanges(x, Ranges, RangeLabel)

% WithinRanges(x, Ranges, RangeLabel)
% detects which points of the input vector lie within
% one of the ranges specified in the nx2 array ranges
% returns an array the size of x with a 1 if the corresponding
% point is in the ranges.
%
% ranges are (start1 stop1 ; start2 stop2 ; etc.)
% The ranges may be optionally labeled 1..nLabels
% in which case out is a matrix with one column per
% range label
%
% endpoint behaviour is inclusive
% (if i am right that sort() leaves equal in the order they
% were given in).

% reshape x to a vector
x = x(:);

% get size info
nPoints = length(x);
nRanges = size(Ranges,1);

if nRanges==0
    out=zeros(size(x));
    return;
end

% check if RangeLabel is there
if nargin<3
	RangeLabel = ones(nRanges, 1);
end
nLabels = max(RangeLabel);

% check End comes after Start in each case
if any(Ranges(:,2)<Ranges(:,1))
    error('End should come after Start!');
end

% make array containing points, starts and finishes

%ToSort = [x ; Ranges(:,1) ; Ranges(:,2)];
ToSort = [Ranges(:,1) ; x ; Ranges(:,2)]; % this order means it will be inclusive
% sort it
[Sorted Index] = sort(ToSort);

% Make delta array containing 1 for every start and -1 for every stop
% with one column for each range label
Delta = zeros(nPoints+2*nRanges,nLabels);
for l=1:nLabels
	MyRanges = find(RangeLabel==l);
%	Delta(nPoints+MyRanges, l) = 1;
%	Delta(nPoints+nRanges+MyRanges, l) = -1;
	Delta(MyRanges, l) = 1;
	Delta(nPoints+nRanges+MyRanges, l) = -1;
end

%Arrange it in order
DeltaSorted = Delta(Index,:);

% take cumulative sums
Summed = cumsum(DeltaSorted);

% and reorder back to the original order
ReOrdered = zeros(nPoints+2*nRanges,nLabels);
ReOrdered(Index,:) = Summed;

out = ReOrdered(nRanges+1:nPoints+nRanges,:);




return
% OLD MEMORY HOG CODE BELOW

vSize = size(v);
v = v(:);
nPoints = length(v);
nRanges = size(ranges, 1);

% set up arrays to do vectorised comparisons
% first dimension indexes v, second indexes ranges
vMat = repmat(v, [1 nRanges]);
MinMat = repmat(min(ranges,[],2)', [nPoints, 1]);
MaxMat = repmat(max(ranges,[],2)', [nPoints, 1]);

% Now do comparisons
WithinMat = vMat>=MinMat & vMat<=MaxMat;

% Now make final array - which is 1 if a point lies
% in any of the ranges

out = any(WithinMat, 2);

% finally reshape to be the correct size
out = reshape(out, vSize);