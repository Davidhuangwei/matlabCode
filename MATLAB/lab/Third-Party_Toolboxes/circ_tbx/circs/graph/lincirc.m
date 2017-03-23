% LINCIRC           plot circular distibution on a linear axis.
%
% call              PH = LINCIRC( THETA, F, FSTD, STR )
%
% calls plot/ewrrorbar

% 30-jan-04 ES

% 08-feb-04 errorbar added

function ph = lincirc( theta, f, fstd, str )

nargs = nargin;
if nargs < 3 | isempty( fstd )
    fstd = [];
end
if nargs < 4 | isempty( str )
    str = 'b';
end

f = f(:);
theta = theta(:);
[ phi tidx ] = sort( theta );
f = f( tidx );
phi = [ phi( end ) - 2*pi; phi; phi(end) + phi(2) - phi(1) ];
%phi = [ phi; phi(end) + phi(2) - phi(1) ];
f = [ f(end); f; f(1) ];

if isempty( fstd )
    ph = plot( phi, f, str );
else
    fstd = fstd(:);
    fstd = fstd( tidx );
    fstd = [ fstd(end); fstd; fstd(1) ];
    ph = errorbar( phi, f, fstd, str );
end
xlim( [ ( phi( 1 ) + phi( 2 ) ) / 2 ( phi( end - 1 ) + phi( end ) ) / 2 ] );

return