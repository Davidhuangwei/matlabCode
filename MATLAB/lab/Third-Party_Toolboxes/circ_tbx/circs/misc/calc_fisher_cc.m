% CALC_FISHER_CC        circular-circular correlation coefficient
% call                  cc = calc_fisher_cc( theta, phi )
% gets                  works on columns of THETA, PHI
% 30-oct-04 ES from Fisher p.150
function cc = calc_fisher_cc( theta, phi )
n = size( theta, 1 );
if size( phi, 1 ) ~= n, cc = []; return, end
A = sum( cos( theta ) .* cos( phi ) );
B = sum( sin( theta ) .* sin( phi ) );
C = sum( cos( theta ) .* sin( phi ) );
D = sum( sin( theta ) .* cos( phi ) );
E = sum( cos( 2 * theta ) );
F = sum( sin( 2 * theta ) );
G = sum( cos( 2 * phi ) );
H = sum( sin( 2 * phi ) );
nom = 4 * ( A .* B - C .* D );
sigma1 = ( n^2 - E.^2 - F.^2 );
sigma2 = ( n^2 - G.^2 - H.^2 );
cc = nom ./ sqrt( sigma1 .* sigma2 );
return