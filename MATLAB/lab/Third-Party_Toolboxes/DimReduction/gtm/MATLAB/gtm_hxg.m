function grid = gtm_hxg(xDim, yDim)
% Produces a 2D grid with points arranged in a hexagonal lattice.
%
%		The grid is centered on the origin and scaled so the 
%		dimension (X or Y) with largest number of points 
%		ranges from -1 to 1.
%
% Synopsis:	grid = gtm_hxg(xDim, yDim)
%
% Arguments:	xDim, yDim -	number of points along the X and Y 
%				dimensions, respectively; must be >=2.
%
% Return:	grid -	a (xDim*yDim)-by-2 matrix of grid points
%			with the first point being the top-left corner
%			and subsequent points following columnwise.
%
% See also:	gtm_rctg
%

% Version:	The GTM Toolbox v1.0 beta
%
% Copyright:	The GTM Toolbox is distributed under the GNU General Public 
%		Licence (version 2 or later); please refer to the file 
%		licence.txt, included with the GTM Toolbox, for details.
%
%		(C) Copyright Markus Svensen, 1996


if (xDim<2 | yDim<2 | (yDim ~= fix(yDim)) | (xDim ~= fix(xDim)))
  error(['Invalid grid dimensions ', ...
		40, num2str(xDim), 44, num2str(yDim), 41, 46]);
end

% Produce a grid with the right number of rows and columns, and correct 
% relative X-Y distances
[X, Y] = meshgrid([0:1:(xDim-1)], [(yDim-1)*(sqrt(3)/2):-sqrt(3)/2:0]);

% Shift even rows of the grid half a step
i = 2;
while (i <= yDim)
 X(i,:) = X(i,:) + 0.5;
 i = i + 2;
end;

% Change grid representation 
grid = gtm_m2r(X, Y);

% Scale grid to correct size
maxVal = max(max(grid));
grid = grid*(2/maxVal);

% Shift grid to correct position
maxXY= max(grid);
grid(:,1) = grid(:,1) - maxXY(1)/2;
grid(:,2) = grid(:,2) - maxXY(2)/2;

