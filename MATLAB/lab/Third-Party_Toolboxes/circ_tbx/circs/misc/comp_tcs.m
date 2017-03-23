% COMP_TCS          compare 2 tuning curves.
%
% call              [ RANK, RANK_PD, RANK_R ] = COMP_TCS( X1, X2 )
%                   [ ..., BS_DATA ] = COMP_TCS( ..., NPERM, THETA, ALPHA )
%
% gets              X1, X2      1. matrices - each column - trials in a direction
%                                   use NaNs to fill up empty spaces
%                               2. cell arrays
%                   NPERM       number of permutations ( 1000 )
%                   THETA       angles of the directions ( radians )
%                   ALPHA       desired level of significance ( 0.05 )
%
% returns           RANK        the rank of the statistic; high rank
%                               indicates low probability to accept H0.
%                   RANK_PD     contribution of the 1st moment
%                   RANK_R      "   "   "           2nd moment
%
%                   PERM_DATA   the actual values of the 3 statistics and
%                                   their permuted distributions
%                   
% does              test the hypothesis f(f1,theta) == f(f2,theta)
%                   against the alternative that they are different.
%                   both samples are discrete in angular sampling but may
%                   be continuous in their amplitudes.
%
% algorithm         see notebook p59-60.
%
% note              1. input should have same number of columns as theta
%                   2. it may be composed of any data ( spikes counts, 
%                           emg rms, lfp power, sta p2p, cc area, etc. )
%                   3. the test usually converges after < 1000
%                           resamples
%                   4. the granularity of p-values is 1/nbs
%
% calls             COMP_RS, MIXMAT, MY_MEAN
%
% called by         CALL_TC_COMP_FUNCS, PREH_SUA

% 13-dec-03 ES

% revisions
% 14-dec-03 correction for different sample sizes
% 25-jan-04 ranks of the different moments added
% 03-may-04 graphics added
% 04-jul-04 perm_data output added

function [ rank, rank_pd, rank_r, perm_data ] = comp_tcs( ...
    x1, x2, nperm, theta, alpha, graphics )

debugMode = 0;

% input check

if nargin < 2, error( '2 arguments' ), end
if nargin < 3 | isempty( nperm ), nperm = 1000; end
if nargin < 4 | isempty( theta )
    theta = [1/6 0 5/6:-1/6:1/3]'*2*pi;             % prehension experiment directions
end
if nargin < 5 | isempty( alpha ) | alpha >= 1 | alpha <= 0
    alpha = 0.05;
end
if nargin < 6 | isempty( graphics ), graphics = 0; end
if debugMode, graphics = 1; end

% constants

% absolute difference between 2 vectors
vec_diff = inline(...
    'sqrt( (a1.*cos(d1) - a2.*cos(d2)).^2 + (a1.*sin(d1) - a2.*sin(d2)).^2 )'...
    , 'a1', 'd1', 'a2', 'd2' );
% rank of a statistic
calc_rank = inline(...
    '( sum( x < x0 ) + 1 ) / ( length( x ) + 1 )', 'x', 'x0' );
% replacement method
rflag = 1;              % 1 w/o; 2 w/

% handle cell arrays

if iscell( x1 )
    len = length( x1 );
    if prod( size( x1 ) ) ~= len
        error( 'input format mismatch' )
    end
    for i = 1 : len
        nt( i ) = length( x1{ i } );
    end
    xx = NaN * ones( max( nt ), len );
    for i = 1 : len
        xx( 1 : nt( i ), i ) = x1{ i };
    end
    x1 = xx;
    clear xx;
end
if iscell( x2 )
    len = length( x2 );
    if prod( size( x2 ) ) ~= len
        error( 'input format mismatch' )
    end
    for i = 1 : len
        nt( i ) = length( x2{ i } );
    end
    xx = NaN * ones( max( nt ), len );
    for i = 1 : len
        xx( 1 : nt( i ), i ) = x2{ i };
    end
    x2 = xx;
    clear xx;
end
[ m n ] = size( x1 );
if n ~= length( theta ) | any( size( x1 ) ~= size( x2 ) )
    error( 'input size mismatch' )
end

% compute the statistic

mx1 = my_mean( x1, 1 )';
mx2 = my_mean( x2, 1 )';
[ R1 P1 ] = comp_rs( theta, mx1 );
[ R2 P2 ] = comp_rs( theta, mx2 );
dR = vec_diff( R1, P1, R2, P2 );                % resultants' difference
dR_pd = vec_diff( 1, P1, 1, P2 );               % PD difference
dR_r = vec_diff( R1, 1, R2, 1 );                % variance difference

if graphics == 1
    f = figure;
    subplot( 2, 3, 1 ), imagesc( 1 : n, 1 : m, x1 ); my_colorbar; axis xy, axe_title( 'x1' );
    subplot( 2, 3, 2 ), imagesc( 1 : n, 1 : m, x2 ); my_colorbar; axis xy, axe_title( 'x2' );
    colormap( myjet )
    rmax = dmax( mx1, mx2, 0.1 );
    h = subplot( 2, 3, 4 );
    ph = mypolar( theta, mx1, rmax, P1, rmax * R1, h, '.-b', 'b', 1 );
    h = subplot( 2, 3, 5 );
    ph = mypolar( theta, mx2, rmax, P2, rmax * R2, h, '.-r', 'r', 1 );
end

% format and replicate

x1 = x1( : );
X1 = repmat( x1, 1, nperm );
x2 = x2( : );
X2 = repmat( x2, 1, nperm );
ridx = [ 0 m : m : m*n ];

% mix

X = [ X1 X2 ];
clear X1; clear X2;
mixX = mixmat( X, 2, rflag );
clear X;
mixX1 = mixX( :, 1 : nperm );
mixX2 = mixX( :, nperm + 1 : end );
clear mixX;
for i = 1 : n
    indx = ridx( i ) + 1 : ridx( i + 1 );
    meanX1( i, : ) = my_mean( mixX1( indx, : ), 1 );
    meanX2( i, : ) = my_mean( mixX2( indx, : ), 1 );
end
clear mixX1; clear mixX2;

% compute the resampled statistic

[ Rs1 Ps1 ] = comp_rs( theta, meanX1 );
[ Rs2 Ps2 ] = comp_rs( theta, meanX2 );
dRs = vec_diff( Rs1, Ps1, Rs2, Ps2 );
rank = calc_rank( dRs, dR );

% check the 1st and 2nd moments separately

dummy = ones( size( Rs1 ) );
dR_r_bs = vec_diff( Rs1, dummy, Rs2, dummy );
dR_pd_bs = vec_diff( dummy, Ps1, dummy, Ps2 );
rank_r = calc_rank( dR_r_bs, dR_r );
rank_pd = calc_rank( dR_pd_bs, dR_pd );

% assign output

if nargout >= 4
    perm_data.dR = dR; 
    perm_data.dR_pd = dR_pd; 
    perm_data.dR_r = dR_r;
    perm_data.dR_bs = dRs; 
    perm_data.dR_pd_bs = dR_pd_bs; 
    perm_data.dR_r_bs = dR_r_bs;
end

if graphics
    
    global NicePlot
    if NicePlot
        color1stat = [ 1 0 0 ];
        genwidth = 3;
        statstyle = '-';
    else
        color1stat = [ 1 0 0 ];
        genwidth = 1;
        statstyle = '-';
    end
    color = [ 0 0 1 ];

    % dR
    if graphics == 1
        subplot( 3, 3, 3 );
    else
        figure
    end
    if dR > 1
        be = 0 : 0.01 : 2;
    else
        be = 0 : 0.01 : 1;           % bin edges; theoretically, should be until 2
    end
    be = linspace( 0, max( [ dR dRs ] ), 100 );
    bc = histc( dRs, be );      % bin counts
    hb = bar( be, bc / nperm, 'hist' );
    set( hb, 'edgecolor', color, 'facecolor', color )
    xlim( [ be( 1 ) be( end ) ] );
    separators( dR, [], color1stat, 'x', genwidth, statstyle );
    tstr = sprintf( 'rank = %0.3g; dR = %0.3g; nPerm = %d'...
        , rank, dR, nperm );
    xlim( [ 0 dmax( dR, dRs, 0.1 ) ] );
    if graphics == 1
        axe_title( tstr );
    else
        set( gcf, 'Name', tstr )
    end
    
    % dR PD
    if graphics == 1
        subplot( 3, 3, 6 );
    else
        figure
    end
    if dR_pd > 1
        be = 0 : 0.01 : 2;
    else
        be = 0 : 0.01 : 1;
    end
    be = linspace( 0, max( [ dR_pd dR_pd_bs ] ), 100 );
    bc = histc( dR_pd_bs, be );
    hb = bar( be, bc / nperm, 'hist' );
    set( hb, 'edgecolor', color, 'facecolor', color )
    
    xlim( [ be( 1 ) be( end ) ] );
    separators( dR_pd, [], color1stat, 'x', genwidth, statstyle );
    tstr = sprintf( 'rank_pd = %0.3g; dR_pd = %0.3g', rank_pd, dR_pd );
    xlim( [ 0 dmax( dR_pd, dR_pd_bs, 0.1 ) ] );
    if graphics == 1
        axe_title( slash_( tstr ) );
    else
        set( gcf, 'Name', tstr )
    end

    % dR R
    if graphics == 1
        subplot( 3, 3, 9 );
    else
        figure
    end
    be = 0 : 0.01 : 1;
    be = linspace( 0, max( [ dR_r dR_r_bs ] ), 100 );
    bc = histc( dR_r_bs, be );
    hb = bar( be, bc / nperm, 'hist' );
    set( hb, 'edgecolor', color, 'facecolor', color )
    xlim( [ be( 1 ) be( end ) ] );
    separators( dR_r, [], color1stat, 'x', genwidth, statstyle );
    tstr = sprintf( 'rank_r = %0.3g; dR_r = %0.3g', rank_r, dR_r );
    xlim( [ 0 dmax( dR_r, dR_r_bs, 0.1 ) ] );
    if graphics == 1
        axe_title( slash_( tstr ) );
    else
        set( gcf, 'Name', tstr )
    end

end

return