% RankOrder(v)
%
% a very quick script that computes rank ordering of a vector
% so [1 3 5.5 -6 0] would give [3 4 5 1 2].
%
% NaN's remain NaN's

function Out = RankOrder(v);

% check for vector input
if prod(size(v))~=max(size(v))
	error('v should be a vector');
end

[sorted order] = sort(v);

Out(order) = 1:length(v);

Out(find(isnan(v))) = NaN;