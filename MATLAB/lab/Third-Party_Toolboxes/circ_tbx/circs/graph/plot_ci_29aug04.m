% PLOT_CI           polar plots for 1 or 2 TCs w/ or w/o CL for PD, R.
%
% called by         MAKE_BSC_PLOTS, MAKE_SEG_PLOTS, PLOT_PDS_CLUSTS

% 31-may-04 ES

% revisions
% 17-jun-04 sectorf added
% 10-jul-04 BNW support

function plot_ci( mx, pd, r, pd_ci, r_ci, rmax, mx2, pd2, r2, pd_ci2, r_ci2, sectorf, makeleg )

global NicePlot
global GENWIDTH
global BNW
if isempty( NicePlot ), NicePlot = 0; end
if isempty( GENWIDTH ), GENWIDTH = 0.5; end
if isempty( BNW ), BNW = 0; end

nargs = nargin;
if nargs < 3, error( 'input missing' ), end
if nargs < 4, pd_ci = []; end
if nargs < 5, r_ci = []; end
if nargs < 6, rmax = []; end
if nargs < 7, mx2 = []; end
if nargs < 8, pd2 = []; end
if nargs < 9, r2 = []; end
if nargs < 10, pd_ci2 = []; end
if nargs < 11, r_ci2 = []; end
if nargs < 12 | isempty( sectorf ), sectorf = 1; end
if nargs < 13 | isempty( makeleg ), makeleg = 0; end

mx = mx(:);
if ~isempty( pd_ci )
    pd_ci = pd_ci( : ).';
end
if ~isempty( r_ci )
    r_ci = r_ci( : ).';
end

if BNW
    color1 = 0.7 * [ 1 1 1 ];
    color2 = 0.5 * [ 1 1 1 ];
else
    color1 = [ 0 0 1 ];
    color2 = [ 1 0 0 ];
end
linestyle1 = '-';
linestyle2 = '-';
cistyle1 = '-';
cistyle2 = '-';
% linestyle2 = ':';
% cistyle1 = '--';
% cistyle2 = '--';
if NicePlot
    tcwidth = 1;
    pdwidth = 1.25 * GENWIDTH;%2.5;
    ciwidth = 1.25 * GENWIDTH;%2.5;
    MSIZE = 15;
else
    tcwidth = 1;
    pdwidth = 2.5;
    ciwidth = 1;
    MSIZE = 6;
end

if isempty( rmax )
    if ~isempty( mx2 )
        rmax = dmax( mx, mx2, 0.1 );
    else
        rmax = dmax( mx, [], 0.1 );
    end
end
w = rmax / 20;

newplot; h = gca;

ph = mypolar( [], mx, rmax, pd, rmax * r, h, '.-b', 'b', tcwidth );
set( ph( 1 ), 'linewidth', tcwidth, 'linestyle', linestyle1, 'color', color1, 'markersize', MSIZE )
set( ph( 2 ), 'linewidth', pdwidth, 'linestyle', linestyle1, 'color', color1 )

% CL for PD
if ~isempty( pd_ci ) & ~isempty( r_ci ) & sectorf
    lh1 = plot_sector( pd_ci, rmax * r_ci);
    set( lh1, 'linewidth', ciwidth, 'linestyle', cistyle1, 'color', color1 )
else
    if ~isempty( pd_ci )
        lines( [ 0 0 ], [ 0 0 ], rmax * [ 1 1 ], pd_ci, [], color1, ciwidth, cistyle1 );
    end
    if ~isempty( r_ci )
        [ x1 y1 ] = pol2car( rmax * r_ci, pd * [ 1 1 ] );
        [ dx1 dy1 ] = pol2car( w, pd + pi / 2 );
        xx1 = [ x1( 1 ) + dx1 * [ -1 1 ] NaN x1 x1( 2 ) + dx1 * [ -1 1 ] ];
        yy1 = [ y1( 1 ) + dy1 * [ -1 1 ] NaN y1 y1( 2 ) + dy1 * [ -1 1 ] ];
        lh1 = line( xx1, yy1 ); 
        set( lh1, 'color', color1, 'linewidth', ciwidth, 'linestyle', linestyle1 );
    end
end
% theta_ci = round( pd_ci * 180 / pi );
% theta = ( theta_ci( 1 ) : theta_ci( 2 ) ) * pi / 180;
% h = line( rmax * cos( theta ), rmax * sin( theta ) );
% set( h, 'linewidth', genwidth );


if isempty( mx2 )
    % elongate PD
    [ xx yy ] = pol2car( rmax, pd ); 
    lh = line( [ 0 xx ], [ 0 yy ] );
    set( lh, 'linewidth', pdwidth );
    return
end

mx2 = mx2(:);
if ~isempty( pd_ci2 )
    pd_ci2 = pd_ci2( : ).';
end
if ~isempty( r_ci2 )
    r_ci2 = r_ci2( : ).';
end

hold on
ph = mypolar( [], mx2, rmax, pd2, rmax * r2, h, '.-r', 'r' );
set( ph( 1 ), 'linewidth', tcwidth, 'linestyle', linestyle2, 'color', color2, 'markersize', MSIZE )
set( ph( 2 ), 'linewidth', pdwidth, 'linestyle', linestyle2, 'color', color2 )

if ~isempty( pd_ci2 ) & ~isempty( r_ci2 ) & sectorf
    lh2 = plot_sector( pd_ci2, rmax * r_ci2);
    set( lh2, 'linewidth', ciwidth, 'linestyle', cistyle2, 'color', color2 )
else
    if ~isempty( pd_ci2 )
        lines( [ 0 0 ], [ 0 0 ], rmax * [ 1 1 ], pd_ci2, [], color2, ciwidth, cistyle2 );
    end
    if ~isempty( r_ci2 )
        [ x1 y1 ] = pol2car( rmax * r_ci2, pd2 * [ 1 1 ] );
        [ dx1 dy1 ] = pol2car( w, pd2 + pi / 2 );
        xx1 = [ x1( 1 ) + dx1 * [ -1 1 ] NaN x1 x1( 2 ) + dx1 * [ -1 1 ] ];
        yy1 = [ y1( 1 ) + dy1 * [ -1 1 ] NaN y1 y1( 2 ) + dy1 * [ -1 1 ] ];
        lh1 = line( xx1, yy1 ); 
        set( lh1, 'color', color2, 'linewidth', ciwidth, 'linestyle', linestyle2 );
    end
end

if NicePlot
    hold on
    ph = plot( 0, 0, '+k' );
    %set( ph, 'markersize', MSIZE )
    if isa( makeleg, 'cell' ) & length( makeleg ) == 2 & isa( makeleg{ 1 }, 'char' ) & isa( makeleg{ 2 }, 'char' )
        figure
        ph = plot( [ 0 1 ], [ 0 1 ], '.', [ 0 -1 ], [ 0 -1 ], '.-' );
        set( ph( 1 ), 'linewidth', tcwidth, 'linestyle', linestyle1, 'color', color1, 'markersize', MSIZE )
        set( ph( 2 ), 'linewidth', tcwidth, 'linestyle', linestyle2, 'color', color2, 'markersize', MSIZE )
        legend( makeleg{ 1 }, makeleg{ 2 }, 0 )
    end
end

return

% plot a sector around 
function lh = plot_sector( pd_ci, r_ci )
angs = round( pd_ci * 180 / pi );
if angs( 1 ) > angs( 2 ), angs = [ angs( 1 ) : 360 1 : angs( 2 ) ] / 180 * pi;
else, angs = ( angs( 1 ) : angs( 2 ) ) / 180 * pi; end
amps = remrnd( r_ci, 0.01 );
amps = amps( 1 ) : 0.01 : amps( 2 );
ANGS = [ ones( 1, length( amps ) ) * angs( 1 ) angs ones( 1, length( amps ) ) * angs( end ) fliplr( angs ) ];
AMPS = [ amps ones( 1, length( angs ) ) * amps( end ) fliplr( amps ) ones( 1, length( angs ) ) * amps( 1 ) ];
[ X Y ] = pol2car( AMPS, ANGS );
lh = line( X, Y );
return