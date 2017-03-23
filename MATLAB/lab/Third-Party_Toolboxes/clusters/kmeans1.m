function c = kmeans1(x,nc);
% KMEANS1 : k-means clustering
% c = kmeans(x,nc)
%	x       - d*n samples
%	nc      - number of clusters wanted
%	c       - calculated membership vector
% algorithm taken from Sing-Tze Bow, 'Pattern Recognition'

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

[d,n] = size(x);

%------------------------------------------------------------------------
% step 1: Arbitrarily choose nc samples as the initial cluster centers
%------------------------------------------------------------------------
z= Inf*ones(d,nc);
oldz = z;
for i=1:nc,
  % find a random sample not yet in z
  distance = 0;
  while (distance==0)
    j = fix(rand*n)+1;
    candidate = x(:,j);
    [dummy,dummy,distance] = nearest(z,candidate);
  end
  % assign it as the center of cluster i
  z(:,i) = candidate;
end
c = zeros(1,n);
D = zeros(nc,n);

while(1),
%------------------------------------------------------------------------
% step 2: distribute the patterns samples x to the chosen cluster domains
%         based on which cluster center is nearest
%------------------------------------------------------------------------
for j=1:nc,			% for every cluster
  center = z(:,j);		% get cluster center
  if (center ~= oldz(:,j)),	% has it moved ? 
    D(j,:) = sqrDist(x,center);	% calculate the sqr distances from x to center
  end
end
oldz = z;

% find minimum
[Dmin,index] = min(D);
moved = sum(index~=c);
fprintf(2,'moved = %d\n',moved);
c = index;

%------------------------------------------------------------------------
% step 3: Update the cluster centers
%         i.e. calculate the mean and minimize critsse for each cluster
%------------------------------------------------------------------------
[nr,z,v] = clusterstats(x,c,nc);

%------------------------------------------------------------------------
% step 4: Check convergence
%------------------------------------------------------------------------
if (moved==0), break, end

%------------------------------------------------------------------------
end % while(1)


