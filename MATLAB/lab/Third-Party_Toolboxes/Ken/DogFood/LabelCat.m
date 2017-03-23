% [Out Labels] = LabelCat(V1, V2, V3, ...)
%
% concatenates inputs to produce Out, and returns an array
% Labels the same length as Out indicating which element of
% Out comes from which input vector. The inputs must be
% row or column vectors, and Out will be a column vector.

function [Out, Labels] = LabelCat(varargin)

nIn = length(varargin);

Out = [];
Labels = [];

for i=1:nIn
	x = varargin{i};
	if min(size(x))>1
		error('all inputs should be vectors');
    end

	Out = [Out;x(:)];
	Labels = [Labels; i*ones(length(x),1)];
end