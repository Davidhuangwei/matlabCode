% VM_EST            estimate Vm distribution for different states.
%
% call              [ MYU2, SIGMA2 ] = VM_EST( TC1, TC2 )
%                   [ ..., R2, P ] = VM_EST( TC1, TC2, MODE, GRAPHICS )
%
% gets              TC1, TC2        tuning curves (eg 6 point vecotrs)
%                   MODE            {'constrained'} or 'unconstrained'
%                   GRAPHICS        flag {0}
%
% returns           MYU2, SIGMA2    of Vm(TC2) assuming Vm(TC1)~N(0,1)
%                   R2, P           of fit (if > 2 points in each TC)
%
% does              assuming first column comes from a Vm~N(0,1),
%                   compute Vm for each element.
%                   then assume the same Vm values are kept, but the 
%                   distribution is different, ie the 2nd state causes
%                   EPSPs to impinge more vigorously or more dispersed.
%                   then, assuming the TH for a spike is constant, we'll
%                   get the rates in the 2nd column.
%                   we return the new distribution, Vm~N(myu2,sigma2).
%
% calls             NORMCDFC, FITFUNC
%
% see code for further details

% 04-feb-04 ES

% 17-feb-04 overdetermined problem solved as well
% 08-mar-04 i/o

% Vm - is a random variable, distributed ~N. we may normalize it mean and
% variance at rest to ~N(0,1). when threshold T is crossed, a spike is
% emitted. this threshold is at TD = T/sigma distance from the mean, and
% thus the probability to get a spike is
%   (1) lambda / C = prob( Vm > T ) = 1 - normcdf( T/sigma, 0, 1 ) = 
%           1 - 0.5 * erfc(-(T/sigma-myu)./(sqrt(2)*sigma))
% and the invervse solution ( find TD = T/sigma given p = lambda / C ) is
%   (2) TD = - sqrt(2) * sigma * erfcinv( 2 .* ( 1 - p ) ) + myu
% where C is a units transformation constant (prob->rate given Vm
% fluctuations and refractory period).
%
% influence of EPSPs - these cause the membrane potential to shift closer
% to the threshold (which is a contant) - TD increases. the relationship
% between TD and lambda is thus inverse.
% 
% influence of object - assume that rates for different directions cause
% only shifting of the mean of Vm. thus each has a TD of its own. given a
% new disribution of rates for directions (given a different objsect),
% these may be due to additional changes in ~Vm: for example, the mean 'at
% rest' and the variance may change. thus we may ask what are
% ~N(myu2,sigma2) s.t. TD for each direction remains constant.
%
% if we have 2 directions this is a 2 equation-2 parameter probelm with
% constraint - myu < TDi for all directions.
% if we have more - this is an overdetermined probelm, solved eg by
% non-linear curve fitting.

% so, steps:
% 1. for 1st state (object) - compute TD for each direction (rate) given
% ~N(0,1). this computed by (2).
% 2. then try to fit a curve of the sort in (1) to these TDi with lambdas
% of the 2nd state (object). the 2 free parameters to be fitted are my and
% sigma. however, the T/sigma will be constant (TDi).

function [ myu2, sigma2, R2, p ] = vm_est( tc1, tc2, mode, graphics )

% arguments

if nargin < 3 | isempty( mode ), mode = 'unconstrained'; end
if nargin < 4 | isempty( graphics ), graphics = 0; end
if prod( size( tc1 ) ) ~= prod( size( tc2 ) )
    error( 'input size mismatch' )
end

% constants

C = 1000;
calc_td = inline( '- sqrt(2) * sigma .* erfcinv( 2 .* ( 1 - p ) ) + myu', 'p', 'myu', 'sigma' );
calc_myu = inline( '(c(1) * v(2) - c(2) * v(1)) / ( c(1) - c(2) )', 'v', 'c' );
calc_sigma = inline( '(v(1) - v(2)) / (c(1) - c(2) )', 'v', 'c' );

% output

myu1 = 0;
sigma1 = 1;
R2 = 1;
p = NaN;

% preparations

p1 = tc1(:).' / C;
p2 = tc2(:).' / C;
TD = calc_td( p1, myu1, sigma1 );
n = length( p1 );

% by definition, calc_ptd( TD1, 0, 1 ) is equal to p1:

if norm( p1 -  normcdfc( [ myu1 sigma1 ], TD ) ) .^ 2 > eps
    error( 'numerical error' )
end

if n == 2
    % for 2 samples, we can solve analitically (unconstrained)
    TDhat = ( calc_td( p2, myu1, sigma1 ) - myu1 ) / sigma1;
    myu2 = calc_myu( TD, TDhat );
    sigma2 = calc_sigma( TD, TDhat );
else
    % otherwise, we need optimization
    switch mode
        case 'unconstrained'
%            [ params ign1 ign2 R2 p ci ] = fitfunc( TD, p2, @normcdfc, [ myu1 sigma1 ] );
            [ params ign1 ign2 R2 p ] = fitfunc( TD, p2, @normcdfc, [ myu1 sigma1 ] );
        case 'constrained'
            LB = [ -inf 0 ];
            UB = [ min( TD ) inf ];
%            [ params ign1 ign2 R2 p ci ] = fitfunc( TD, p2, @normcdfc, [ myu1 sigma1 ], [], [], [], LB, UB );
            [ params ign1 ign2 R2 p ] = fitfunc( TD, p2, @normcdfc, [ myu1 sigma1 ], [], [], [], LB, UB );
    end
    myu2 = params( 1 );
    sigma2 = params( 2 );
end

% keep plot parameters

myu2p = myu2;
sigma2p = sigma2;

% check results

if ~( all( myu2 < TD ) & sigma2 > 0 ) | R2 < 0
    myu2 = NaN;
    sigma2 = NaN;
    msg = 'no solution';
else
    msg = 'converged';
end

% output

if graphics > 0
    newplot
    t = -5 : 0.01 : 5;
    MSIZE = 30;
    XLIM = [ dmin( TD, [], 0.01 ) dmax( TD, [], 0.01 ) ];
    XLIM( isinf( XLIM ) ) = t( end );
%    YLIM = [ dmin( p1, p2, 0.001 ) dmax( p1, p2, 0.001 ) ];
    YLIM = [ 0 dmax( p1, p2, 0.001 ) ];
    ph = plot( TD, p1, '.', TD, p2, '.', t, normcdfc( [ myu1 sigma1 ], t ) );
    set( ph( 1 ), 'markersize', MSIZE, 'color', [ 0 0 1 ] )
    set( ph( 2 ), 'markersize', MSIZE, 'color', [ 1 0 0 ] )
    set( ph( 3 ), 'linewidth', 3, 'color', [ 0 0 1 ], 'linestyle', '-' );
    if ~isnan( myu2 ) & ~isnan( sigma2 )
        hold on
        ph( 4 ) = plot( t, normcdfc( [ myu2p sigma2p ], t ) );
        set( ph( 4 ), 'linewidth', 3, 'color', [ 1 0 0 ], 'linestyle', '--'  );
    end
    set( gca, 'xlim', XLIM + [ -0.1 0.1 ], 'ylim', [ 0 0.01 ] ) ;%%YLIM );
%    set( gca, 'xlim', XLIM, 'ylim', YLIM );
    for i = 1 : length( TD )
        separators( TD( i ), [], [ 0 0 0 ], 'x', [], ':' );
% %         th( i ) = text( TD( i ) + 0.001, range( YLIM ) / 10, num2str( i ) );
% %         set( th( i ), 'FontSize', 12 );
    end
    ylabel( 'prob (Vm > TD)', 'FontSize', 12 )
    xlabel( 'Vm (std)', 'FontSize', 12 )

%     p1str = '';
%     for i = 1 : n
%         p1str = sprintf( '%s  %0.2g', p1str, p1( i ) );
%     end
%     p2str = '';
%     for i = 1 : n
%         p2str = sprintf( '%s  %0.2g', p2str, p2( i ) );
%     end
%     axe_title( sprintf( '~N(%0.3g,%0.3g); p1 = %s', myu1, sigma1, p1str ) );
%     axe_title( sprintf( '~N(%0.3g,%0.3g) (R2=%0.3g, p=%0.3g); p2 = %s', myu2, sigma2, R2, p, p2str ) );
    axe_title( sprintf( 'obj1: ~N(%0.3g,%0.3g); obj2: ~N(%0.3g,%0.3g)', myu1, sigma1, myu2, sigma2 ) );
    
end

if graphics >= 0
    fprintf( 1, '%s\n', msg );
end

return

% example with real data
load w:\diana\02nov02\osf\stable\sua_osf1
i = find( CHS == 15 )
for e = 1 : 7
    figure, fig_title( sprintf( 'epoch %d', e ) )
    tc1 = res( i ).mx(:,e,1);
    tc2 = res( i ).mx(:,e,2);
    [ myu2 sigma2 ] = vm_est( tc1, tc2, 'constrained', 1 );
    figure, tc2 = scale_tcs( tc2, tc1, 1 );
    [ myu2 sigma2 ] = vm_est( tc1, tc2, 'constrained', 1 );
end