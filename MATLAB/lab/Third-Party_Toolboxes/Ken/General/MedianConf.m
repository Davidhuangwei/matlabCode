% [m, range] = MedianConf(x, alpha)
%
% calculates the median and a two-sided confidence interval
% for a data vector x.
%
% alpha gives confidence level (default .95)
%

function [m, range] = MedianConf(x, alpha)

if nargin<2
	alpha = 0.95;
end

% turn row vector to column vector
if min(size(x))==1
	x = x(:);
end

m = median(x);
sorted = sort(x);
n = size(x,1);

% find position of c.i.
tmp = binocdf(0:n, n, .5);
cc = max(find(tmp<(1-alpha)/2)) -1;

if isempty(cc)
	range = [NaN NaN];
else	
	range(1,:) = sorted(cc+1,:);
	range(2,:) = sorted(n-cc,:);
end