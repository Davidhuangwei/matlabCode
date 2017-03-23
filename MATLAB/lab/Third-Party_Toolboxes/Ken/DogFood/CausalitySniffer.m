% CausalitySniffer(x,y,lag)
% or CausalitySniffer(x,lag) where x is a matrix of column vectors
%
% Tests for causality between two signals x and y by constructing
% causal filters between them.
%
% This is a wrapper function for CausalPredict.

function CausalitySniffer(x,y,lag)

x=x(:);
y=y(:);

fprintf('x->y: %f\n', CausalPredict(x,y,lag));
fprintf('y->x: %f\n', CausalPredict(y,x,lag));
fprintf('x->y (time reversed): %f\n', CausalPredict(flipud(x),flipud(y),lag));
fprintf('y->x (time reversed): %f\n', CausalPredict(flipud(y),flipud(x),lag));
