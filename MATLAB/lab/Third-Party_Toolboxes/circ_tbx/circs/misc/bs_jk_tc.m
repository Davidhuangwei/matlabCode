% BS_JK_TC          bootstrap and jacknife a TC.
%
% call              [ PHI_BS, R_BS, PHI_JK, R_JK, PHI, R ] = BS_JK_TC( X )
%                   BS_JK_TC( ..., NBS, THETA, GRAPHICS )
%
% gets              X           (matrix) data
%                   NBS         number of BS repetitions {1000}
%                   THETA       angles (same length as X's columns) {6}
%                   GRAPHICS    flag {0}
%
% returns           PHI_BS      NBS estimations
%                   R_BS        "
%                   PHI_JK      full JK estimations
%                   R_JK        "
%                   PHI         mean direction
%                   R           resultant
%
% calls             COMP_RS, JKIDX, MAKE_IDX (internal), MIXMAT, MY_MEAN.
%
% see also          CALC_CI.

% 29-apr-04 ES

% example:

% nsamps = 100; nbs = 1000;
% theta = [1/6 0 5/6:-1/6:1/3]'*2*pi;
% ncols = length( theta );
% x0 = rand( nsamps, ncols ); 
% x = x0 .* ( ones( size( x0, 1 ), 1 ) * [ 1 1 1 3 1 1 ] );
% figure, [ phi, phi_bs, phi_jk, r, r_bs, r_jk ] = bs_jk_tc( x, nbs, theta, 1 );

%function [ phi, phi_bs, phi_jk, r, r_bs, r_jk ] = bs_jk_tc( x, nbs, theta, graphics )
function [ phi_bs, r_bs, phi_jk, r_jk, phi, r ] = bs_jk_tc( x, nbs, theta, graphics )

nargs = nargin;
nout = nargout;
if nargs < 1, error( '1 argument' ), end
if nargs < 2 | isempty( nbs ), nbs = 1000; end
if nargs < 3 | isempty( theta )
    theta = [1/6 0 5/6:-1/6:1/3]'*2*pi;
end
if nargs < 4 | isempty( graphics )
    graphics = 0;
end

[ m n ] = size( x );                                        % m samples, n columns
if n ~= length( theta )
    error( 'input size mismatch' )
end


% bootstrap

idx = mixmat( [ 1 : m ]' * ones( 1, nbs ), 1, 2 );          % row indices
xbs = x( idx( : ), : );                                     % resampled rows
xbs = xbs( make_idx( m, n, nbs ) );                         % resampled blocks
xbs = reshape( my_mean( xbs, 1 ), n, [] );                  % average each column and resahpe
[ r_bs phi_bs ] = comp_rs( theta, xbs );                    % bs estimates

% jacknife

if nout > 2 | graphics
    
    idx = jkidx( m );
    xjk = x( idx( : ), : );
    xjk = xjk( make_idx( m - 1, n, m ) );
    xjk = reshape( my_mean( xjk, 1 ), n, [] );
    [ r_jk phi_jk ] = comp_rs( theta, xjk );                    % jk estimates
    
end

% estimate

if nout > 4 | graphics
    
    [ r phi ] = comp_rs( theta, my_mean( x, 1 )' );             % estimate
    
end
% graphics

if graphics
    bias_jk = inline( '( n - 1 ) * ( mean( that ) - t )', 'n', 'that', 't' );
    newplot
    bias_phi = bias_jk( m, phi_jk, phi );
    bias_r = bias_jk( m, r_jk, r );
    philim = [ dmin( phi_jk, phi_bs, 0.1 ) dmax( phi_jk, phi_bs, 0.1 ) ];
    rlim = [ dmin( r_jk, r_bs, 0.1 ) dmax( r_jk, r_bs, 0.1 ) ];
    subplot( 2, 2, 1 ), hist( phi_bs, 100 ), separators( phi ); xlim( philim ); axe_title( 'phi BS' );
    subplot( 2, 2, 2 ), hist( phi_jk, 100 ), separators( phi ); xlim( philim ); axe_title( sprintf( 'phi JK, bias = %0.3g', bias_phi ) );
    subplot( 2, 2, 3 ), hist( r_bs, 100 ), separators( r ); xlim( rlim ); axe_title( 'R BS' );
    subplot( 2, 2, 4 ), hist( r_jk, 100 ), separators( r ); xlim( rlim ); axe_title( sprintf( 'R JK, bias = %0.3g', bias_r ) );
    fig_title( sprintf( '%d samples, %d BS', m, nbs ) );
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% auxiliary function for reshaping

function idx = make_idx( m, n, reps )
cidx = ones( n, 1  ) * [ 1 : m : reps * m ];
cidx = ones( m, 1 ) * cidx( : ).';
ridx = [0 : 1 : m - 1]' * ones( 1, reps * n );
c = ones( m, 1 ) * [ 0 : m * reps : m * reps * (n-1) ];
idx = ridx + cidx + c( 1 : m, ( 1 : n )' * ones( 1, reps ) );
return