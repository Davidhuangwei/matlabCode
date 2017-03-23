function s = sky(m)
%SKY colormap in sky-colors ranging from light blue to white
%   SKY(M) returns an M-by-3 matrix containing a "bone" colormap.
%   SKY, by itself, is the same length as the current colormap

if nargin < 1, m = size(get(gcf,'colormap'),1); end

r = 0.5 + (1:m)' /(2*m);

s = [r , r , ones(m,1)];
