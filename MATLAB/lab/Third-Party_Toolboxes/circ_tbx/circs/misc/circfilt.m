% CIRCFILT          filter a circular variable using a FIR.
%
% call              [ PHI, R ] = CIRCFILT( THETA, W )
%
% gets              THETA       a vector of angles
%                               if a matrix, CIRCFILT works on the columns
%
%                   W           FIR
%
% returns           PHI         the filtered angle
%
%                   R           the filtered resultant
%
% see expl. in notebook p65
%
% see also FIRFILT.

% 15-sep-03 ES

function [ phi, r ] = circfilt( theta, w )

% logical checks

if nargin < 2
    error( '2 arguments required' )
end

EPS = 1e-10;
nt = length( theta );
nw = length( w );

if any( theta > pi | theta < -pi )
    error( 'first argument should be angles (radians)' )
end
if nw > nt
    error( 'malconditioned input size' )
end
if prod( size( w ) ) ~= nw | ( ( round( sum( w ) / EPS ) * EPS ) ~= 1 )
    error( 'second argument should be a FIR' )
end

% actual algorithm

x = firfilt( cos( theta ), w );
y = firfilt( sin( theta ), w );
phi = atan2( y, x );

if nargout > 1  
    r = sqrt( x.^2 + y.^2 );
end

return