% K2W               half width (radians) of VM distribution.
%
% call              [ HW SI ] = K2W( K, A )
%
% gets              K       kappa of VM
%                   A       width factor; {2} corresponds to cosine SI (see
%                               below)
%
% returns           HW      half width (radians);
%                               maximum possible is pi/2 (90 degrees)
%                   SI      sharpness index, ( pi - w ) / pi;
%                               0 corresponds to cosine (90 degrees half width)
%                               1 to an impossibly sharp distribution
%                               other pairs are { si, hw in degrees }:
%                               {0.25, 67.5}, {0.5, 45}, {0.75, 22.5}
%
% calls             nothing
%
% algorithm         analytic.

% see home notebook p.27

% 25-mar-04 ES

% testing
% ( pi - 2 * k2w( [ 0.01 0.1 1 10 100 ] ) ) / pi

function [ hw, si ] = k2w( k, a )

if nargin < 2
    hw = acos( log( ( exp( k ) + exp( -k ) ) / 2 ) ./ k );
else
    hw = acos( log( a * exp( k ) + ( 1 - a ) * exp( -k ) ) ./ k );
end

if nargout > 1
    si = ( pi - 2 .* hw ) / pi;
    if any( any( any( si < 0 ) ) )
        fprintf( 1, 'negative SI\n' )
        beep
        keyboard
    end
end

return

% thus sharpness index may be defined as
si = ( pi - 2*w ) / pi;
% and its inverse
pi * ( 1 - si ) / 2