function c = agglom(x,nc,measure);
% AGGLOM : Basic Agglomerative Clustering
% c = agglom(x,nc,measure)
%	x       - d*n samples
%	nc      - number of clusters wanted
%	measure - distance measure used to group clusters
%	c       - calculated membership vector
% warning: AGGLOM is very computationally intensive and is not yet optimized
%          it was just implemented as a demonstration

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

[d,n] = size(x);

% initialize with singletons
c = linspace(1,n,n);
nk = n;

while nk>nc,
  %-----------------------------------------------------
  % find nearest pair of distinct clusters
  %-----------------------------------------------------
  dmin = feval(measure,cluster(x,c,1),cluster(x,c,2));
  imin = 1;
  jmin = 2;
  for i=1:nk-1,
    for j=i+1:nk,
      d = feval(measure,cluster(x,c,i),cluster(x,c,j));
      if d<dmin, dmin=d; imin=i; jmin=j; end
    end
  end
  %-----------------------------------------------------
  % Merge cluster imin and cluster jmin
  %-----------------------------------------------------
  for i=1:n,
    if c(i)==jmin, c(i)=imin; end
    if c(i)==nk, c(i)=jmin; end    % recover cluster index
  end
  %-----------------------------------------------------
  % Decrement count
  %-----------------------------------------------------
  nk = nk - 1
end

