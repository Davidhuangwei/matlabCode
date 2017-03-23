function xj = cluster(x,c,j);
% CLUSTER : return the matrix of samples in cluster j according to c
% xj = cluster(x,c,j)
%	x - data
%	c - categories
%	j - cluster identity

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

[d,n] = size(x);
xj = x(:,find(c==j));
