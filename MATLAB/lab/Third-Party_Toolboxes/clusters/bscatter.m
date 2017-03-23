function SB = bscatter(x,c);
% BSCATTER : between-cluster scatter matrix
% SB = bscatter(x,c)
%	x - data
%	c - categories

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

[d,n] = size(x);
nc = max(c);

tm = mean(x')';               % total mean
[nr,m,v] = clusterstats(x,c); % get individual cluster means

SB = zeros(d);
for i=1:nc
  mi = m(:,i);
  SB = SB + nr(i) * (mi-tm) * (mi-tm)';
end