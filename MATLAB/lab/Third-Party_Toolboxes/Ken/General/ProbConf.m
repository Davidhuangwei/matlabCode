% [p ci] = ProbConf(x, alpha)
%
% estimates probability and confidence intervals the probability out of
% binary vector x.  All this function does is call binofit.

function [p, ci] = ProbConf(x, alpha)

if nargin<2
	alpha = .05;
end

[p ci] = binofit(sum(x), length(x), alpha);