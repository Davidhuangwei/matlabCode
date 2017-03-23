function d = dmean(x1,x2);
% DMEAN : distance between means of two clusters
% d = dmean(x1,x2)
%	x1, x2 - the two clusters
%	d      - the result

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

m1 = mean(x1')';
m2 = mean(x2')';
d = norm(m1-m2);