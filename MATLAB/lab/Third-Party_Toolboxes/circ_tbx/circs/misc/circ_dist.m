% CIRC_DIST         angular difference on a circle.
%
% call              D = CIRC_DIST( A, B, AFLAG )
%
% gets              A, B        equal size arrays. alternatively, one may
%                               be a scalar and the other - a vector of a
%                               matrix.
%                   AFLAG       {1} absolute difference
%                               0   ordered difference (from a to b)
%                               
%
% returns           D           an array w/ the angular distances
%
% calls             nothing
%
% does              computes the absolute circular diffrence between 2 arrays.

% 14-jul-03 ES

% revisions
% 29-mar-04 single input of 2 columns is treated as two vectors
% 28-apr-04 scalar input supported

function d = circ_dist( a, b, aflag )

if nargin == 1 | isempty( b )
    b = a( :, 2 );
    a = a( :, 1 );
end
if nargin < 3 | isempty( aflag ), aflag = 1; end

if prod( size( a ) ) ~= 1 & prod( size( b ) ) ~= 1 & ~isequal( size( a ), size( b ) )
    error( 'input size mismatch' )
end

if aflag
    d = pi - abs( pi - abs( a - b ) );
else
    d = mod( b - a + 2 * pi, 2 * pi ); 
end

return

% circ_dist = inline('pi - abs( pi - abs( a - b ) )','a','b')