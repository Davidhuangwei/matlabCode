function [zj,j,d] = nearest(z,xi);
% NEAREST: return the vector zj in z that is nearest to xi
% [zj,j,d] = nearest(z,xi)
%	z  - d*J vectors that need to be compared to xi
%	xi - the vector that wants to be matched up with zj
%	zj - the nearest vector to xi in z
%	j  - the index of zj in z
%	d  - the minimum distance

% Copyright (c) 1995 Frank Dellaert
% All rights Reserved

[r,J] = size(z);
if size(xi) ~= r, error('NEAREST: z and x need to be of same dimensions!'); end

zj = z(:,1); j = 1;
if (J==1), return, end

d = norm(zj-xi);
for i=2:J,
  zi = z(:,i);
  distance = norm(zi-xi);
  if (distance<d), zj=zi; j=i; d=distance; end
end




