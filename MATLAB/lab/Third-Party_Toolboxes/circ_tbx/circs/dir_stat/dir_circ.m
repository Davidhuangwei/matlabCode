%   DIR_CIRC        Compute circular variance - matrix version.

% directional statistics package
% Dec-2001 ES


function S0 = dir_circ(theta);

%matrix version

% basic computations
[rows, n] = size(theta);
x = cos(theta);
y = sin(theta);
C = sum(x,2)/n;
S = sum(y,2)/n;
    
% uniformity and variance
R = (C.^2 + S.^2).^0.5;
S0 = 1 - R;
