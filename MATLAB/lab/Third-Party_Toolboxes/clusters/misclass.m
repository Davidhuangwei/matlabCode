function [e,p,nr,n,best] = misclass(c,t);
% MISCLASS : calculates percent of misclassified samples in clusters
% [e,p,nr,n,best] = misclass(c,t)
%	c    - cluster categories
%	t    - correct category
%	e    - total percentage
%	p    - percentage/cluster
%	nr   - absolute number of misclassified/cluster
%	n    - size of clusters
%       best - majority vote/cluster

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

nc=max(c);
[q,nt] = size(t);

p = zeros(1,nc);
nr = zeros(1,nc);
n = zeros(1,nc);
best = zeros(1,nc);
for j=1:nc,
  [p(j),nr(j),n(j),best(j)] = misclass1(c,t,j);
end
e = sum(nr)/nt;