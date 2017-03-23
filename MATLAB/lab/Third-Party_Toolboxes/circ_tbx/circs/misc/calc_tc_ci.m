% CALC_TC_CI        CI of TC by BS.
%
% call              [ PHI_CI, R_CI ] = CALC_TC_CI( X1 )
%                   [ ..., PHI_P, R_P ] = CALC_TC_CI( ..., X2, NBS, THETA, ALPHAS )
%
% gets              X1          data matrix
%                   X2          (optional) additional data
%                   NBS         number of bootstrap trials {1000}
%                   THETA       angles of the directions (radians) {6}
%                   ALPHAS      desired levels of significance {[0.005 0.01 ... 0.2]}
%
% returns           PHI_CI      CI for circular mean: [ low high ]
%                                   if ALPHAS is a vector, different CI are in rows
%                                   if X2 is input, second sheet
%                   R_CI        CI for resultant (same format as PHI_CI)
%                   PHI_P       p-values: [ one-sided two-side ] tests
%                                   ( H0: phi( x1 ) = phi( x2 ) )
%                   R_P         H0: r( x1 ) = r( x2 )
%
% calls             BS_JK_TC, CALC_CI, COMP_RS, MY_MEAN, INRANGE

%                   AXE_TITLE, BOUNDS, CIRC_BOUNDS, SEPARATORS

% 02-may-04 ES

% revisions
% 11-jun-04 NicePlot added

% call from PREH_SUA:
% calc_tc_ci( mat(:,1:6), mat(:,7:12), 1000 );

%function [ phi_ci, r_ci, phi_p, r_p ] = calc_tc_ci( x1, x2, nbs, theta, alphas, graphics )
function [ phi_ci, r_ci, phi_p, r_p, bs_data ] = calc_tc_ci( x1, x2, nbs, theta, alphas, graphics )

debugMode = 0;

% input check

nargs = nargin;
if nargs < 1, error( '1 argument' ), end
if nargs < 2, x2 = []; end
if nargs < 3 | isempty( nbs ), nbs = 1000; end
if nargs < 4 | isempty( theta )
    theta = [1/6 0 5/6:-1/6:1/3]'*2*pi;             % prehension experiment directions
end
if nargs < 5 | isempty( alphas ) | any( alphas >= 1 ) | any( alphas <= 0 )
    alphas = [ 0.005 0.01 0.02 0.025 0.05 0.1 0.2 ];
end
if nargin < 6 | isempty( graphics ), graphics = 0; end
if debugMode, graphics = 1; end

n = length( theta );
if n ~= size( x1, 2 ) | ( ~isempty( x2 ) & n ~= size( x2, 2 ) )
    error( 'input size mismatch' )
end
global NicePlot
if isempty( NicePlot ), NicePlot = 0; end

% constants

alphas = alphas(:);
na = length( alphas );
method = 'percentiles';

% initialize output

phi_p = [ NaN NaN ]';
r_p = [ NaN NaN ]';

% CI by BS of first TC

mx1 = my_mean( x1, 1 )';
[ R1 P1 ] = comp_rs( theta, mx1 );
[ phi_bs1, r_bs1 ] = bs_jk_tc( x1, nbs, theta );
phi_ci( :, :, 1 ) = calc_ci( P1, phi_bs1, [], alphas, method, 'circular' );
r_ci( :, :, 1 ) = calc_ci( R1, r_bs1, [], alphas, method, 'linear' );
% method = 'bcanon';
% [ phi_bs1, r_bs1, phi_jk1, r_jk1 ] = bs_jk_tc( x1, nbs, theta );
% phi_ci( :, :, 1 ) = calc_ci( P1, phi_bs1, phi_jk1, alphas, method, 'circular' );
% r_ci( :, :, 1 ) = calc_ci( R1, r_bs1, r_jk1, alphas, method, 'linear' );

if ~isempty( x2 )
    
    % CI by BS of second TC
    
    mx2 = my_mean( x2, 1 )';
    [ R2 P2 ] = comp_rs( theta, mx2 );
    [ phi_bs2, r_bs2 ] = bs_jk_tc( x2, nbs, theta );
    phi_ci( :, :, 2 ) = calc_ci( P2, phi_bs2, [], alphas, method, 'circular' );
    r_ci( :, :, 2 ) = calc_ci( R2, r_bs2, [], alphas, method, 'linear' );
%     [ phi_bs2, r_bs2, phi_jk2, r_jk2 ] = bs_jk_tc( x2, nbs, theta );
%     phi_ci( :, :, 2 ) = calc_ci( P2, phi_bs2, phi_jk2, alphas, method, 'circular' );
%     r_ci( :, :, 2 ) = calc_ci( R2, r_bs2, r_jk2, alphas, method, 'linear' );
    
    % mutual inclusion
    
    diff_PDs( :, 1 ) = ~inrange( P1 * ones( na, 1 ), phi_ci( :, :, 2 ), [], 'circ' );
    diff_PDs( :, 2 ) = ~inrange( P2 * ones( na, 1 ), phi_ci( :, :, 1 ), [], 'circ' );
    diff_Rs( :, 1 ) = ~inrange( R1 * ones( na, 1 ), r_ci( :, :, 2 ), [], 'linear' );
    diff_Rs( :, 2 ) = ~inrange( R2 * ones( na, 1 ), r_ci( :, :, 1 ), [], 'linear' );
    
    % one sided test
    
    tmp = min( alphas( any( diff_PDs, 2 ) ) ) / 2;
    if ~isempty( tmp ), phi_p( 1 ) = tmp; end
    tmp = min( alphas( any( diff_Rs, 2 ) ) ) / 2;
    if ~isempty( tmp ), r_p( 1 ) = tmp; end
    
    % two sided test
    
    tmp = min( alphas( all( diff_PDs, 2 ) ) ) / 2;
    if ~isempty( tmp ), phi_p( 2 ) = tmp; end
    tmp = min( alphas( all( diff_Rs, 2 ) ) ) / 2;
    if ~isempty( tmp ), r_p( 2 ) = tmp; end
    
end

if nargout >= 5
    bs_data.phi_bs1 = phi_bs1;
    bs_data.r_bs1 = r_bs1;
    if ~isempty( x2 )
        bs_data.phi_bs2 = phi_bs2;
        bs_data.r_bs2 = r_bs2;
    end
end

if graphics
    
    % histograms
    
    p_bins = 0 : 0.01 : 2 * pi;
    r_bins = 0 : 0.005 : 1;
    [ p1_h p_b ] = hist( phi_bs1, p_bins ); 
    [ r1_h r_b ] = hist( r_bs1, r_bins );
    
    % use alpha of 0.01 for plots
    
    a2 = find( alphas == 0.01 );
    if isempty( a2 ), a2 = 1; end
    
    % plot arguments
    
    color1 = [ 0 0 1 ];
    color2 = [ 1 0 0 ];
    cistyle = '--'; %'-.'
    statstyle = '-';
    if NicePlot
        genwidth = 3;
        color1stat = [ 1 0 0 ];
    else
        genwidth = 1;
        color1stat = color1;
    end
    pdwidth = 2.5;
    if isempty( x2 )
        rmax = dmax( mx1, [], 0.1 );
    else
        rmax = dmax( mx1, mx2, 0.1 );
    end
    
    figure
    h = subplot( 2, 3, 2 );
    ph = mypolar( [], mx1, rmax, P1, rmax * R1, h, '.-b', 'b', 1 );
    set( ph( 2 ), 'linewidth', pdwidth )
    lines( [ 0 0 ], [ 0 0 ], rmax * [ 1 1 ], phi_ci( a2, :, 1 ), [], color1, [], cistyle );
    axe_title( sprintf( 'nbs = %d; radius = %0.3g; alpha = %0.3g', nbs, rmax, alphas( a2 ) ) );
    
    if ~isempty( x2 )
        
        p2_h = hist( phi_bs2, p_bins );
        r2_h = hist( r_bs2, r_bins );
        tstrP = sprintf( 'Phi: one sided < %0.3g; two sided < %0.3g', phi_p( 1 ), phi_p( 2 ) );
        tstrR = sprintf( 'R: one sided < %0.3g; two sided < %0.3g', r_p( 1 ), r_p( 2 ) );
        p_bounds = circ_bounds( [ phi_bs1 phi_bs2 ], 0.001 );
        p_h = [ p1_h' p2_h' ];
        phi_ci_plot = squeeze( phi_ci( a2, :, : ) )';
        P1_plot = P1;
        P2_plot = P2;
        if p_bounds( 1 ) > p_bounds( 2 ), 
            idx = inrange( p_b, p_bounds, [], 'circ' );
            p_b = p_b( idx );
            p_h = p_h( idx, : );
            idx = p_b < p_bounds( 2 );
            p_b( idx ) = p_b( idx ) + 2 * pi;
            p_bounds = p_bounds + [ 0; 2 * pi ];
            pidx( 1, : ) = ~inrange( phi_ci_plot( 1, : ), p_bounds, [], 'circ' );
            pidx( 2, : ) = ~inrange( phi_ci_plot( 2, : ), p_bounds, [], 'circ' );
            phi_ci_plot( pidx ) = phi_ci_plot( pidx ) + 2 * pi;
            if ~inrange( P1_plot, p_bounds, [], 'circ' ), P1_plot = P1_plot + 2 * pi; end
            if ~inrange( P1_plot, p_bounds, [], 'circ' ), P2_plot = P2_plot + 2 * pi; end
        else
%            if NicePlot, figure, else, subplot( 2, 3, 1 ), end
            subplot( 2, 3, 1 )
            [ ycdf1, xcdf1 ] = cdfcalc( phi_bs1 ); 
            [ ycdf2, xcdf2 ] = cdfcalc( phi_bs2 ); 
            plot( xcdf1, ycdf1( 2 : end ), 'b', xcdf2, ycdf2( 2 : end ), 'r' )
            axe_title( 'cdf( phi )' );
            separators( phi_ci_plot( 1, : ), [], color1, 'x', [], cistyle );
            separators( phi_ci_plot( 2, : ), [], color2, 'x', [], cistyle );
            lh = line( P1 * [ 1 1 ], [ 0.4 0.6 ] ); set( lh, 'linewidth', pdwidth, 'color', color1 )
            lh = line( P2 * [ 1 1 ], [ 0.4 0.6 ] ); set( lh, 'linewidth', pdwidth, 'color', color2 )
%            if NicePlot, figure, else, subplot( 2, 3, 3 ), end
            subplot( 2, 3, 3 )
            [ ycdf1, xcdf1 ] = cdfcalc( r_bs1 ); 
            [ ycdf2, xcdf2 ] = cdfcalc( r_bs2 ); 
            plot( xcdf1, ycdf1( 2 : end ), 'b', xcdf2, ycdf2( 2 : end ), 'r' )
            axe_title( 'cdf( R )' );
            separators( r_ci( a2, :, 1 ), [], color1, 'x', [], cistyle );
            separators( r_ci( a2, :, 2 ), [], color2, 'x', [], cistyle );
            lh = line( R1 * [ 1 1 ], [ 0.4 0.6 ] ); set( lh, 'linewidth', pdwidth, 'color', color1 )
            lh = line( R2 * [ 1 1 ], [ 0.4 0.6 ] ); set( lh, 'linewidth', pdwidth, 'color', color2 )
        end

        hold on
        ph = mypolar( [], mx2, rmax, P2, rmax * R2, h, '.-r', 'r' );
        set( ph( 2 ), 'linewidth', pdwidth )
        lines( [ 0 0 ], [ 0 0 ], rmax * [ 1 1 ], phi_ci( a2, :, 2 ), [], color2, [], cistyle );
        
        subplot( 2, 2, 3 ); 
        h = bar( p_b, p_h / nbs, 5, 'group' );
        set( h( 1 ), 'edgecolor', color1, 'facecolor', color1 )
        set( h( 2 ), 'edgecolor', color2, 'facecolor', color2 )
        xlim( p_bounds )
        ylim( ylim * 1.5 )
        separators( phi_ci_plot( 1, : ), [], color1, 'x', [], cistyle );
        separators( phi_ci_plot( 2, : ), [], color2, 'x', [], cistyle );
        separators( P1_plot, [], color1 );
        separators( P2_plot, [], color2 );
        axe_title( tstrP );
        
        subplot( 2, 2, 4 ); 
        h = bar( r_b, [ r1_h' r2_h' ] / nbs, 2, 'group' );
        set( h( 1 ), 'edgecolor', color1, 'facecolor', color1 )
        set( h( 2 ), 'edgecolor', color2, 'facecolor', color2 )
        xlim( bounds( [ r_bs1 r_bs2 ], 0.001 ) );
        ylim( ylim * 1.5 )
        separators( r_ci( a2, :, 1 ), [], color1, 'x', [], cistyle );
        separators( r_ci( a2, :, 2 ), [], color2, 'x', [], cistyle );
        separators( R1, [], color1 );
        separators( R2, [], color2 );
        axe_title( tstrR );
                
    else
        
        if NicePlot, figure, else, subplot( 2, 3, 3 ), end
%        subplot( 2, 2, 3 ); 
        h = bar( p_b, p1_h / nbs, 3.5, 'group' );
        set( h( 1 ), 'edgecolor', color1, 'facecolor', color1 )
        p_bounds = circ_bounds( phi_bs1, 0.001 );
        if p_bounds( 1 ) > p_bounds( 2 ), p_bounds = [ 0 2*pi ]; end
        xlim( p_bounds )
        ylim( ylim * 1.5 )
        separators( phi_ci( a2, :, 1 ), [], color1, 'x', genwidth, cistyle );
        separators( P1, [], color1stat, 'x', genwidth, statstyle );
        tstr = 'Phi';
        if NicePlot, set( gcf, 'Name', tstr ), fprintf( 1, 'PD = %0.3g; PD %0.3g CL = %s\n', P1, 1 - alphas( a2 ), num2str( phi_ci( a2, :, 1 ) ) )
        else, axe_title( tstr ); end
            
        
        if NicePlot, figure, else, subplot( 2, 2, 4 ), end
%        subplot( 2, 2, 4 ); 
        h = bar( r_b, r1_h / nbs, 3.5, 'group' );
        set( h( 1 ), 'edgecolor', color1, 'facecolor', color1 )
        xlim( bounds( r_bs1, 0.001 ) );
        ylim( ylim * 1.5 )
        separators( r_ci( a2, :, 1 ), [], color1, 'x', genwidth, cistyle );
        separators( R1, [], color1stat, 'x', genwidth, statstyle );
        tstr = 'R';
        if NicePlot, set( gcf, 'Name', tstr ), fprintf( 1, 'R = %0.3g; R %0.3g CL = %s\n', R1, 1 - alphas( a2 ), num2str( r_ci( a2, :, 1 ) ) )
        else, axe_title( tstr ); end
        
    end
    
    if ~NicePlot & ~isempty( x2 )
        legend( '1', '2' )
    end
    
end

return