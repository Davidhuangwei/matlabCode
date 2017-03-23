function [nr,m,v] = clusterstats(x,c,nc);
% CLUSTERSTATS(x,c) computes the statistics for each cluster
% [nr,m,v] = clusterstats(x,c[,nc])
%	x  - d*n matrix of samples
%		d - dimension of samples
%		n - number of samples
%	c  - 1*n matrix with the cluster identity for each sample x(:,i)
%		should contain numbers between 1 and nc
%	nc - the number of different clusters (max(c) if omitted)
%	nr - 1*nc matrix with the number of samples in each cluster
%	m  - d*nc matrix with the mean for each cluster
%	v  - d*nc matrix with the variance for each component

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

if (nargin<3) nc=max(c);end

% get dimensions of data
[d,n] = size(x);

% calculate sum and number of members in each cluster
nr = zeros(1,nc);
sum = zeros(d,nc);
sumsq = zeros(d,nc);
for i = 1:n,
  xi = x(:,i);
  sum(:,c(i)) = sum(:,c(i)) + xi;
  sumsq(:,c(i)) = sumsq(:,c(i)) + xi .* xi;
  nr(c(i)) = nr(c(i)) + 1;
end

% calculate mean and variance for each cluster
m = zeros(d,nc);
v = zeros(d,nc);
for j = 1:nc,
  m(:,j) = sum(:,j)/nr(j);
  v(:,j) = sumsq(:,j)/nr(j) - m(:,j) .* m(:,j);
end



