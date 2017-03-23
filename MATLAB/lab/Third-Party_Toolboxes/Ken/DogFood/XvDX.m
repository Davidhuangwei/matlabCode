% [range mu sd] = XvDX(x);
%
% takes a time series and calculates the mean and standard deviation
% of the difference at any time for each value of the series.
%
% this definately works best if it is an integer valued series

function [range, mu, sd, n] = XvDX(x)

% make x a column vector
x = x(:);

% calculate differences
dx = diff(x);

% lose last x
x(end) = [];
Sizex = size(x, 1);

% now we want to lose the spikes
% first find them

HiPoints = find(x>1600);
b1 = x(HiPoints) >= x(HiPoints+1);
b2 = x(HiPoints) > x(HiPoints-1);
Spikes = HiPoints(b1 & b2);
nSpikes = size(Spikes, 1);

% mark all points within 40 samples (1ms) of a spike
rv = -40:40;
rvm = rv(ones(nSpikes, 1), :);
if (isempty(Spikes))
	Excluded = [];
else
	Excluded = Spikes(:, ones(1,81)) + rvm;
	Excluded = Excluded(:);
end;

Included = setdiff(1:Sizex, Excluded);

% find range of x
range = unique(x(Included));
nr = size(range, 1);

% initialize output arrays
mu = zeros(nr, 1);
sd = zeros(nr, 1);
n = zeros(nr, 1);

% for each value of x, find mean and sd.
for i = 1:nr
	pts = dx(find(x==range(i) & ~ismember(1:Sizex, Excluded)'));
	mu(i) = mean(pts);
	sd(i) = std(pts);
	n(i) = prod(size(pts));
end;

errorbar(200*(range/2048 - 1), mu, sd./sqrt(n));