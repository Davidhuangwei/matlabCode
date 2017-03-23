% CIRC_BOUNDS       angular lower and upper bounds.
%
% call              [ CB MSG ] = CIRC_BOUNDS( X, ALPHA, GRAPHICS )
%
% gets              X           angles (if matrix - works on columns)
%                   ALPHA       1-confidence {0.01}
%                   GRAPHICS    flag {0}
%
% returns           CB          lower, upper bounds
%                   MSG         mirrored
%
% calls             BOUNDS, CIRC_MEAN.
%
% algorithm         translation is used to support non-symmetric bounds.

% 02-may-04 ES

function [ cb, msg ] = circ_bounds( x, alpha, graphics )

nargs = nargin;
if nargs < 1, error( '1 argument' ), end
if nargs < 2 | isempty( alpha ), alpha = 0.01; end
if nargs < 3 | isempty( graphics ), graphics = 0; end
if prod( size( x ) ) == length( x ), x = x( : ); end

xm = circ_mean( x );
d = ( xm - pi );
[ b msg ] = bounds( mod( x - ones( size( x, 1 ), 1 ) * d, 2 * pi ), alpha );
cb = mod( b + ones( size( x, 2 ), 1 ) * d, 2 * pi );

if graphics
    figure, nbins = 20;
    subplot( 2,1,1 ), rose( x, nbins ); 
    lines( [ 0 0 ], [ 0 0 ], length( x ) / nbins * 4 * [ 1 1 ], cb', [], [ 0 0 1 ] );
    lines( 0, 0, length( x ) / nbins * 4, xm, [], [ 1 0 0 ] );
    subplot( 2,1,2 ), hist( x, nbins ); xlim( [ 0 2 * pi ] ); 
    separators( cb, [], [ 0 0 1 ] ); separators( xm );
end

return