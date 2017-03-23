function S = scatter(x);
% SCATTER : scatter matrix for samples x
% S = scatter(x)
%	x - data
%	S - scatter matrix

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

% get dimensions of data
[d,n] = size(x);

% within-class scatter matrix is proportional to covariance matrix
S = cov(x')*(n-1);



