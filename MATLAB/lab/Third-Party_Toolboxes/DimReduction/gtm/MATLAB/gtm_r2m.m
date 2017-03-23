function [X, Y, Z] = gtm_r2m(cX, cY, cZ, meshRows, meshCols)
% Convert data from column vector to a mesh-matrix representation
%
%		The mesh-matrices are filled columnwise, starting from the
%		top left corner, with the elements from the corresponding 
%		column vectors. The exact (cX, cY, cZ) - (X, Y, Z) 
%		relationship being:
%
%			X(i,j) = cX(meshRows*(i-1)+j)
%
%			Y(i,j) = cY(meshRows*(i-1)+j)
%
%			Z(i,j) = cZ(meshRows*(i-1)+j)
%
%
%
% Synopsis:	[X, Y, Z] = gtm_r2m(cX, cY, cZ, meshRows, meshCols)
%		[X, Y] = gtm_r2m(cX, cY, meshRows, meshCols)
%		X = gtm_r2m(cX, meshRows, meshCols)
%
% Arguments:	cX, cY, cZ -	column vectors with x-, y-, and x-data
%				respectively; N-by-1
%
%		meshRows, 
%		  meshCols -	number of rows and colmuns of the mesh
%				matrices; meshRows*meshCols = N
%
% Return:	X, Y, Z -	mesh matrices; meshRows-by-meshCols
%
% See also:	gtm_m2r
%

% Version:	The GTM Toolbox v1.0 beta
%
% Copyright:	The GTM Toolbox is distributed under the GNU General Public 
%		Licence (version 2 or later); please refer to the file 
%		licence.txt, included with the GTM Toolbox, for details.
%
%		(C) Copyright Markus Svensen, 1996

if (nargin == 5 & nargout == 3)
  X = reshape(cX, meshRows, meshCols);
  Y = reshape(cY, meshRows, meshCols);
  Z = reshape(cZ, meshRows, meshCols);
elseif (nargin == 4 & nargout == 2)
  meshCols = meshRows;
  meshRows = cZ;
  X = reshape(cX, meshRows, meshCols);
  Y = reshape(cY, meshRows, meshCols);
elseif (nargin == 3 & nargout == 1)
  meshCols = cZ;
  meshRows = cY;
  X = reshape(cX, meshRows, meshCols);
else
  error('Mismatch in number of input/output arguments');
end



