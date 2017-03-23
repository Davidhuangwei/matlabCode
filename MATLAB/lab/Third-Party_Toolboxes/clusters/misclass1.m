function [p,nr,n,best] = misclass1(c,t,j);
% MISCLASS1 : calculates % misclassified samples in a cluster with respect to maj. vote
% [p,nr,n,best] = misclass1(c,t,j)
%	c    - cluster categories
%	t    - correct category
%	j    - which cluster
%	p    - percentage
%	nr   - absolute number of misclassified
%	n    - size of cluster j
%       best - majority vote for this cluster

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

t1 = cluster(t,c,j);
[d,n] = size(t1);

%determine majority vote in t1
[best,bestvote] = majority(t1);

%now determine how many were wrong
nr = n-bestvote;
p = nr/n;