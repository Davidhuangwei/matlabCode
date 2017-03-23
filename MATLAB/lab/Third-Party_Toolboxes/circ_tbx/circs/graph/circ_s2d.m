% CIRC_S2D      inter-origin distance given overlap.
%
% call          [ D, ALPHA, BETA ] = CIRC_S2D( S, R1, R2 )
%
% gets          S       area of overlap between circles
%               R1      radius of one circle
%               R2      radius of the other
%
% returns       D       inter-origin distance
%               ALPHA   peripheral angle of circle 1 leaning on common chord
%               BETA    same for circle 2
%
% calls         nothing
%
% called by     VENN
%
% algorithm     fast numerical approximation

% 19-apr-04 ES

% revisions
% 21-apr-04 symmetry

function [ d, alpha, beta ] = circ_s2d( s, r1, r2 )

if nargin < 3, error( '3 arguments' ); end

% simple numeric approximation
dx = 5e-4;
xalpha = 0 : dx : pi / 2;

% make sure r2 > r1 (symmetric problem)
if r1 > r2
    tmp = r1;
    r1 = r2;
    r2 = tmp;
end

% compute error
xbeta = asin( sin( xalpha ) * r1 ./ r2 );
s1 = r1.^2 * ( xalpha - sin( 2 * xalpha ) / 2 );
s2 = r2.^2 * ( xbeta - sin( 2 * xbeta ) / 2 );
e = s1 + s2 - s;

% find the minial error
[ val idx ] = min( abs( e ) ); 

% evaluate the function at this point
alpha = xalpha( idx );
beta = asin( sin( alpha ) * r1 / r2 );
d = r1 * cos( alpha ) + r2 * cos( beta );

return

% the forward problem (find s given d,r1,r2) may be solved analytically:
alpha = acos( ( r1.^2 + d.^2 - r2.^2 ) ./ 2 ./ r1 ./ d );
beta = acos( ( r2.^2 + d.^2 - r1.^2 ) ./ 2 ./ r2 ./ d );
s1 = r1.^2 * ( alpha - sin( 2 * alpha ) / 2 );
s2 = r2.^2 * ( beta - sin( 2 * beta ) / 2 );
s = s1 + s2;