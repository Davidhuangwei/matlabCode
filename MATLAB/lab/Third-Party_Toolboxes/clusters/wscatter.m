function SW = wscatter(x,c);
% WSCATTER(x,c) = within-cluster scatter matrix
% SW = wscatter(x,c)
%	x  - data
%	c  - classification
%	SW - within scatter matrix

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

[d,n] = size(x);
nc = max(c);

SW = zeros(d);
for i=1:nc
  SW = SW + scatter(cluster(x,c,i));
end