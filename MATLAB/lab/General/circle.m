%function h = circle(x, y, r, style);
% Draw circle with center at x,y with radius r with plot style 'style'
function h = circle(x, y, r, style);
if (nargin<4) style='k'; end
csteps = floor(2*pi*r)*1000;
grid = [1:csteps];
angle =grid*2*pi/csteps;
X = x + sin(angle) * r;
Y = y + cos(angle) * r;
h  = plot (X, Y, style);
