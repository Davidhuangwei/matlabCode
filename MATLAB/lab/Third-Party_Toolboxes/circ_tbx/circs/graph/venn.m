% VENN          plot a Venn diagram for 2 or 3 groups.
%
% call          [ R, X, H ] = VENN( N, NI, NX, GRAPHICS )
%
% gets          N           total number of elements
%               NI          number of elements in each group
%               NX          number of elements in each pairwise intersection
%               GRAPHICS    flag:
%                           0   doesn't plot
%                           1   does
%                           2   also plots entire population (100%, black)
%                                   and adds a legend
%                           3   also scale circle (0.1%, filled black)
%
% returns       R           radius of each circle [all;1;2;3]
%               X           circle coordiantes (same structure)
%               H           handle to circles' plots ("), may be used to
%                               change circle's colors
%
% notes         1. number of groups may be 2 or three; when three, NI is
%                   assumed to be [ n1 n2 n3 ] and NX = [ n12 n13 n23 ]. other
%                   configurations will results in errorneous plots. 
%               2. all input arguments may contain non-integers (eg
%                   probabilities); in any case, the grand total is assumed to
%                   be N (eg 1).
%
% calls         CIRC, CIRC_S2D
%
% example
%                   n = 1492; n1 = 478; n2 = 578; n3 = 851;
%                   n12 = 341; n13 = 359; n23 = 449;
%                   figure, venn( n, [ n1 n2 ], n12 )
%
% this produces a plot of the first 2 groups. to plot all 3 together, use
%
%                   venn( n, [ n1 n2 n3 ], [ n12 n13 n23 ] )

% 19-apr-04 ES

% revisions
% 21-apr-04 axis changed from equal to standardized
% 17-jun-04 graphics 3 plots scale circle; x0 by data edges

function [ R, X, h ] = venn( n, ni, nx, graphics )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% arguments

% argument check

nargs = nargin;
if nargin < 3 | isempty( n ) | isempty( ni ) | isempty( nx ) |...
        ~isa( n, 'double' ) | ~isa( ni, 'double' ) | ~isa( nx, 'double' )
    error( '3 double arguments' )
end
if nargs < 4 | isempty( graphics )
    graphics = 1;
end
if prod( size( n ) ) ~= 1
    error( 'n should be a scalar' )
end

% argument readout

N = prod( size( ni ) );
NX = prod( size( nx ) );
if ( N == 2 & NX ~= 1 ) | ( N == 3 & NX ~= 3 )
    error( 'NX should match NI in size' )
end
n1 = ni( 1 );
n2 = ni( 2 );
n12 = nx( 1 );
switch N
    case 2
    case 3
        n3 = ni( 3 );
        n13 = nx( 2 );
        n23 = nx( 3 );
    otherwise
        error( 'ni should have 2 or 3 elements' )        
end

% inlines

% circle's radius given area
s2r = inline( 'sqrt( s / pi )', 's' );
% angle opposing c in a triangle a,b,c
mycos = inline( 'acos( ( a.^2 + b.^2 - c.^2 ) ./ ( 2 .* a .* b ) )', 'a', 'b', 'c' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% computations

% radii
r = s2r( 1 );
r1 = s2r( n1 / n );
r2 = s2r( n2 / n );
if N == 3
    r3 = s2r( n3 / n );
end

% areas of overlap
s12 = n12 / n;
if N == 3
    s13 = n13 / n;
    s23 = n23 / n;
end

% inter-origin distances
d12 = circ_s2d( s12, r1, r2 );
if N == 3
    d13 = circ_s2d( s13, r1, r3 );
    d23 = circ_s2d( s23, r2, r3 );
end

% angle between a,b
if N == 3
    gamma = mycos( d12, d13, d23 );
end

% circles' origins
x1 = [ 0 0 ];
x2 = [ d12 0 ];
if N == 3
    x3 = d13 * [ cos( gamma ) sin( gamma ) ];
end

% origin of big circle (some analytical geometry)
x0( 1 ) = mean( [ x1( 1 ) x2( 1 ) ] );
if N == 3
    mid23 = [ mean( [ x2( 1 ) x3( 1 ) ] ) mean( [ x2( 2 ) x3( 2 ) ] ) ];
    m = -( x3( 1 ) - x2( 1 ) ) / ( x3( 2 ) - x2( 2 ) );
    x0( 2 ) = m * ( x0( 1 ) - mid23( 1 ) ) + mid23( 2 );
else
    x0( 2 ) = 0;
end

% alternatively, use edges
if N == 3
    x0 = mean( [ min( [ x1 - r1; x2 - r2; x3 - r3 ] ); max( [ x1 + r1; x2 + r2; x3 + r3 ] ) ] );
else
    x0 = mean( [ min( [ x1 - r1; x2 - r2 ] ); max( [ x1 + r1; x2 + r2 ] ) ] );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% graphics

if graphics
    newplot
    h( 1 ) = circ( x1( 1 ), x1( 2 ), r1, [ 1 0 0 ] );
    h( 2 ) = circ( x2( 1 ), x2( 2 ), r2, [ 0 1 0 ] );
    if N == 3
        h( 3 ) = circ( x3( 1 ), x3( 2 ), r3, [ 0 0 1 ] );
    end
    if graphics > 1
        h( end + 1 ) = circ( x0( 1 ), x0( 2 ), r, [ 0 0 0 ] );                          % outer circle
        if graphics == 3
            h( end + 1 ) = circ( -0.5, 0, s2r( 0.001 ), [ 0 0 0 ], [ 0 0 0 ] );         % 0.1% scale
        end
        if N == 3
            legend( '1', '2', '3' );%, 'all' )
        else
            legend( '1', '2' );%, 'all' )
        end
    end
    xlims = ( circ_s2d( 0, s2r( 0.5 ), s2r( 0.5 ) ) ) * [ -1 1 ];
    set( gca, 'xlim', xlims, 'ylim', xlims )
    axis square
else
    h = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% output

R = [ r; r1; r2 ];
X = [ x0; x1; x2 ];
if N == 3
    R = [ R; r3 ];
    X = [ X; x3 ];
end

return