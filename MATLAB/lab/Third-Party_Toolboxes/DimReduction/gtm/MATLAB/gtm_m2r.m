function cXcYcZ = gtm_m2r(X, Y, Z)
% Converts from a mesh-matrix to vector representation
%
%		Returns a matrix in which each row corresponds to a point 
%		on the grid defined by the mesh-matrices X and Y. 
%		The enumeration of points goes from the top-left corner of 
%		the mesh to the bottom-right, columnwise.
%
% Synopsis:	cXcYcZ = gtm_m2r(X, Y, Z)
%		cXcYcZ = gtm_m2r(X, Y)
%		cXcYcZ = gtm_m2r(X)
%
% Arguments:	X, Y, Z -	mesh-matrices for x-, y- and z- coordinates 
%				respectively; M-by-N.
%
% Return:	cXcYcZ -	matrix of rows of tuples; (M*N)-by-k, where 
%				k is 1, 2 or 3
%
% See also:	gtm_r2m
%

% Version:	The GTM Toolbox v1.0 beta
%
% Copyright:	The GTM Toolbox is distributed under the GNU General Public 
%		Licence (version 2 or later); please refer to the file 
%		licence.txt, included with the GTM Toolbox, for details.
%
%		(C) Copyright Markus Svensen, 1996

if (nargin == 1)
  cXcYcZ = X(:);
elseif (nargin == 2)
  cXcYcZ = [X(:), Y(:)];
elseif (nargin == 3)
  cXcYcZ = [X(:), Y(:), Z(:)];
else 
  error('Wrong number of input arguments');
end

