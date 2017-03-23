% CIRC_MEAN         Compute mean direction - matrix version.
%
% call              PHI = CIRC_MEAN( THETA )
%                   [ ..., R, s ] = CIRC_MEAN
%
% gets              THETA       matrix of angles
%
% returns           PHI         mean direction, computed for each column separately
%                   R           resultant (")
%                   S           circular SD
%
% calls             nothing

% 26-mar-04

% revisions
% 02-may-04 nan handling

function [ phi, R, s ] = circ_mean( t )

nans = isnan( t );
n = sum( ~nans, 1 );
x = cos(t);
y = sin(t);
sumx = nansum( x );
sumy = nansum( y );
C = sumx ./ n;
S = sumy ./ n;
phi = mod( atan2(S,C), 2*pi );
if nargout > 1
    R = (C.^2 + S.^2).^0.5;
end
if nargout > 2
    s = (-2*log(R)).^0.5;
end

return