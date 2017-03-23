function [Je,J] = critsse(x,c);
% CRITSSE : computes Sum-of-Squared-Error Criterion for a given clustering
% [Je,J] = critsse(x,c)
%	x  - d*n matrix of samples
%		d - dimension of samples
%		n - number of samples
%	c  - the 1*n cluster identity for each sample x(:,i)
%	Je    - the result
%	J     - the result, per cluster (1*nc matrix)

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

% get dimensions of data
[d,n] = size(x);

% get number of clusters
nc = max(c);

% calculate statistics for each cluster, in particular m, the means
[nr,m,v] = clusterstats(x,c);

% the sum squared error for each cluster is the sum of the variances
% times the number of samples in the cluster
J = zeros(1,nc);
for j = 1:nc,
  J(j) = sum(v(:,j))*nr(j);
end

Je = sum(J);


