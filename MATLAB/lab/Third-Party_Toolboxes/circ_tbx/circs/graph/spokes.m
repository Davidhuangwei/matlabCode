% SPOKES        compass without arrows.
%
% call          PH = SPOKES( THETA, F, RMAX, H, PSTR, ARROWF )
%
% gets          THETA       angles (radians)
%               F           values {all are 1}
%               RMAX        radius {ceil( max( F ) )}
%               H           plot handle {newplot}
%               PSTR        argument to matlab's PLOT (or color triplet)
%                               {'b'}
%               ARROWF      lines will end with arrows
%
% returns       PH          handle to plot
%
% calls         ARROWS, POL2CAR
%
% see also      MYPOLAR, MY_POLAR, MY_COMPASS.

% 08-apr-04 ES

% revisions
% 12-nov-04 arrowf added

function ph = spokes( theta, f, rmax, h, pstr, arrowf );

nargs = nargin;
if nargs < 1
    error( '1 argument' )
end
theta = theta(:);
n = length( theta );
if nargs < 2 | isempty( f )
    f = ones( n, 1 );
else
    f = f(:);
    if length( f ) ~= n
        error( 'input size mismatch' )
    end
end
if nargs < 3 | isempty( rmax )
    rmax = ceil( max( f ) );
end
if nargs < 4 | isempty( h )
    newplot;
else
    subplot( h );
    hold on
end
if nargs < 5 | isempty( pstr ), pstr = 'b'; end
if nargs < 6 | isempty( arrowf ), arrowf = 0; end

% create a background  circle

if nargs < 4 | isempty( h )
    circ( 0, 0, rmax, [ 1 1 1 ], [ 0 0 0 ] );
    hold on, axis equal, axis off
    set(get(gca,'xlabel'),'visible','on')
    set(get(gca,'ylabel'),'visible','on')
end

% plot the data

if arrowf
    if isa( pstr, 'char' ), pstr = [ 0 0 1 ]; end
    ph = arrows( 0, 0, f, theta, [], pstr, [], [], 'origin' );
else
    phi = [ theta zeros( n, 1 ) ]';
    f = [ f  zeros( n, 1 ) ]';
    [ xx yy ] = pol2car( f(:), phi(:) );
    if isa( pstr, 'char' )
        ph = plot( xx, yy, pstr );
    else
        ph = plot( xx, yy );
        if isa( pstr, 'double' ) & prod( size( pstr ) ) == 3
            set( ph, 'color', pstr )
        end
    end
end

return