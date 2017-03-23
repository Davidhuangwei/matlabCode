% ComplexImageColorBar 
%
% plots a color scale for reference to ComplexImage

xr = 0:.001:1;

Im = exp(i*xr*2*pi);
ComplexImage(xr*360, 1, Im);

set(gca, 'ytick', []);
set(gca, 'xtick', [0 90 180 270 360]);
title('Color Scale');