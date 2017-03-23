function [n,m,v] = clustertest(nr);
% CLUSTERTEST : test clusterstats with really simple distribution
% [n,m,v] = clustertest(n)
%	nr - number of samles

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

data = zeros(3,nr);
data(1,:) = randn(1,nr);
data(2,:) = randn(1,nr)*2+1;
data(3,:) = randn(1,nr)*3+2;

datac = ones(1,nr);

[n,m,v] = clusterstats(data,datac);
