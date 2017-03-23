% BSD               bootstrap directions.
%
% call              [ RANK, PD, R, MX ] = BSD( X, NBS, THETA, GRAPHICS )
%
% gets              x           1. matrix - each column - trials in a direction
%                                   use NaNs to fill up empty spaces
%                               2. cell array
%                   nbs         number of bootstrap trials
%                   theta       angles of the directions
%
% returns           rank        of original sample among bootstrapped
%                   pd, R       mean and resultant length of original sample
%                   mx          the mean response per direction
%
% does              algorithm as in Crammond & Kalaska 1996
%
% note              1. x should have same number of columns as theta
%                   2. x may be composed of any data ( spikes counts, 
%                           emg rmd, lfp power, sta p2p, cc area, etc. )
%
% see also          COMP_RS, MIXMAT

% 13-jul-03 ES

% revisions
% 14-jul-03 cell array handling
% 02-may-04 Rs returned
% 19oct04 IA cell array fixup : should always be trials = rows
% 12-jan-05 mixmat called without replacement (permutation test)

function [ rank, pd, R, mx, Rs ] = bsd( x, nbs, theta, graphics )

debugMode = 0;

% input check
if nargin < 2, error( '2 arguments' ), end
if nargin < 3 | isempty( theta )
    theta = [1/6 0 5/6:-1/6:1/3]'*2*pi;
end
if nargin < 4 | isempty( graphics )
    graphics = 0;
end

% handle cell array
if iscell( x )
    len = length( x );
    if prod( size( x ) ) ~= len
        error( 'input format mismatch' )
    end
    for i = 1 : len
        nt( i ) = length( x{ i } );
        x{ i } = x{i}(:); % 19oct04 IA should always be trials = rows  
    end
    xx = NaN * ones( max( nt ), len );
    for i = 1 : len
        xx( 1 : nt( i ), i ) = x{ i };
    end
    x = xx;
    clear xx;
end
[ m n ] = size( x );
if n ~= length( theta )
    error( 'input size mismatch' )
end

if debugMode
    figure, subplot( 221 ), imagesc( x ); axis xy; colorbar
end

% compute statistics
mx = my_mean( x, 1 )';
[ pd S0 s0 ] = dir_mean( theta, mx );
R = 1 - S0;

% format and replicate
nans = isnan( x );
ridx = [ 0 cumsum( sum( ~nans, 1 ) ) ];
x = x( : );
x( nans ) = [];
X = repmat( x, 1, nbs );

% mix and compute rank
mixX = mixmat( X, 1, 1 );
for i = 1 : n
    indx = ridx( i ) + 1 : ridx( i + 1 );
    meanX( i, : ) = mean( mixX( indx, : ), 1 );
end
Rs = comp_rs( theta, meanX );
rank = ( sum( Rs < R ) + 1 ) / ( nbs + 1 );

if debugMode
    subplot( 222 ), hist( Rs, 20 ), separators( R );
    tstr = sprintf( 'rank = %0.3g; pd = %0.3g; r = %0.3g', rank, pd, R );
    h = subplot( 2, 1, 2 );
    plot_circ( theta, mx, h, [], 8 );
    title( tstr )
end

if graphics
    newplot
    plot_circ( theta, mx, gca, [], 0 );
end

return