% CALC_VM_CI        for a circular sample.
%
% call              PD_CI = CALC_VM_CI( PHI, R, N, ALFA )
%
% gets              R, PHI      amplitude and direction
%                   N           sample size
%                   alternatively, R and PHI can be vectors (the sample itself)
%                   ALFA        confidence interval desired
%
% return            PD_CI       
%
% calls             CHECK_VM_FIT, R2K, COMP_RS

% example 6.6
% theta = [ 85 135 135 140 145 150 150 150 160 185 200 210 220 225 270 ]';
% theta = theta * pi / 180;
% [ R phi ] = comp_rs( theta, ones( size( theta ) ) ); 
% ci = calc_von_mises_ci( R, phi, length( theta ), 0.05 )
%
% example 6.8
% theta = [ 115 120 120 130 135 140 150 150 150 165 185 210 235 270 345 ]';
% theta = theta * pi / 180;
% [ R phi ] = comp_rs( theta, ones( size( theta ) ) ); 

% reference: Mardia (1972) p.145-146 (PD CL), p.150-151 (R CL)

% 29-jul-04 ES

function [ pd_ci, r_ci, p_vmfit ] = calc_von_mises_ci( phi, R, n, alfa )

% arguments, sample statistics

nargs = nargin;
if nargs < 2 | isempty( phi ) | isempty( R ), error( '2 arguments' ), end
if length( phi ) > 1
    n = length( phi );
    if ~isequal( n, length( R ) ), error( 'input size mismatch' ), end
    theta = phi;
    f = R;
    [ R phi ] = comp_rs( theta, f );
elseif nargs < 3 | isempty( n ),
    error( '3rd argument must be specified' )
end
if nargs < 4 | isempty( alfa ), alfa = 0.01; end

% initialize output

pd_ci = [ NaN NaN ]';
r_ci = pd_ci;
DV = -1;

% make sure von-mises is a plausible assumption

if exist( 'theta', 'var' ) & exist( 'f', 'var' )
    p_vmfit = check_vm_fit( theta, f );
else
    p_vmfit = DV;
end

if p_vmfit < alfa & p_vmfit ~= DV
    return
end

% compute CL for PD (assume VM; kappa unknown)
% approximation (p.145) accurate for n > 30

k = r2k( R );
zalpha = norminv( 1 - alfa / 2, 0, 1 );
pd_ci = phi + [ -1 1 ]' * zalpha / sqrt( n * R * k );

% compute CL for R (assume VM; myu unknown)
% approximation (p.150-151) accurate for k > 2

d = n - R * n;
a = d / chi2inv( alfa / 2, n - 1 );
b = d / chi2inv( 1 - alfa / 2, n - 1 );
k_ci = [ ( 1 + sqrt( 1 + 3 .* a ) ) ./ a / 4; ( 1 + sqrt( 1 + 3 .* b ) ) ./ b / 4 ];
r_ci = k2r( k_ci );

return

% mean direction unknown:
stat = 2 ./ ( 1 ./ k + 3/8 .* k .^ -2 ) * ( n - R )     % p.150
g = 1 ./ ( 1 ./ k + 3/8 .* k .^ -2 )     % p.150
stata = 2 * g * ( n - R )
chi2inv( stat, n - 1 )

% example from p.151:
n = 15;
R = 0.6264;
