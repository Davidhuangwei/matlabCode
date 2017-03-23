function printClusters(x,c,j);
% PRINTCLUSTERS : print out j-component of the data in each cluster
% printClusters(x,c,j)
%	x - data
%	c - categories
%	j - which component

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

nc = max(c);
for i=1:nc,
  cl = cluster(x,c,i);
  fprintf(1,'cluster %d:\n', i );
  cl(j,:)
end

