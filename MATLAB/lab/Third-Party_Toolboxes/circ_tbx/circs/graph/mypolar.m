% MYPOLAR       polar plot tailored to tuning curve ploting.
%
% call          PH = MYPOLAR( THETA, F, RMAX, PD, R, H, CURVESTR, PDSTR, BKGRND )
%
% gets          THETA       directions (radians)
%               F           amplitudes
%               RMAX        radius of outer circle (scaling factor)
%                           {ceil(max(f))}
%               PD          direction of mean vector {null}
%               R           amplitude of mean vector {rmax}
%               H           handle {newplot}
%               CURVESTR    PLOT format (eg '.-b') {'r'}
%               PDSTR       " {'b'}
%               BKGRND      plot white circle as background {0}
%
% returns       handles to plots
%
% calls         CIRC, POL2CAR.
%

% 24-jan-04 ES

% we want a polar plot to be at exactly the points
% with the mean at the radius

function ph = mypolar( theta, f, rmax, pd, r, h, curvestr, pdstr, bkgrnd )

nargs = nargin;
if isempty( theta )
    theta = [1/6 0 5/6:-1/6:1/3]'*2*pi;
end
if nargs < 2 | isempty( f )
    error( 'amplitude un-specified' ); 
end
theta = theta(:);
f = f(:);
if length( theta ) ~= length( f )
    error( 'input length mismatch' )
end
if nargs < 3 | isempty( rmax )
    rmax = ceil( max( f ) );
end
if nargs < 4
    pd = [];
end
if nargs < 5 | isempty( r )
    r = rmax;
end
if nargs < 6 | isempty( h )
    newplot;
else
    subplot( h );
    hold on
end
if nargs < 7 | isempty( curvestr )
    curvestr = 'r';
end
if nargs < 8 | isempty( pdstr )
    pdstr = 'b';
end
if nargs < 9
    bkgrnd = [];
end

% prepare background
if ~isempty( bkgrnd ) & bkgrnd
    ch = circ( 0, 0, rmax, [ 1 1 1 ], [ 0 0 0 ] );
    set( ch, 'linewidth', bkgrnd );
end
hold on, axis equal, axis off
set(get(gca,'xlabel'),'visible','on')
set(get(gca,'ylabel'),'visible','on')

% plot closed curve
fhat = [ f; f(1) ]; 
thetahat = [ theta; theta(1) ]; 
[ xx yy ] = pol2car( fhat, thetahat ); 
ph( 1 ) = plot( xx, yy, curvestr );

% plot mean direction (vector of length rmax)
if ~isempty( pd )
    [ x y ] = pol2car( r, pd );
    ph( 2 ) = plot( [ 0 x ], [ 0 y ], pdstr );
    % ph( 3 ) = plot( 0, 0, [ '+' pdstr( end ) ] );
end

return