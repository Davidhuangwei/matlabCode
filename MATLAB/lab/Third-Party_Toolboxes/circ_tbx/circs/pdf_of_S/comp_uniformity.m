%   COMP_UNIFORMITY Circular variance of a sample.
%
%       See also DIR_MEAN (for explanations), UNIFORMITY_PDF (for motivation).

% Note: no error checking is performed.

% directional statistics package
% Dec-2001 ES

function S0 = comp_uniformity(theta);

% basic computations
n = length(theta);
x = cos(theta);
y = sin(theta);
C = sum(x)/n;
S = sum(y)/n;
x0t = atan(S/C);

% assignment of angle mod 2*pi
if (C<0)
    x0 = x0t + pi;
else if (S<0)
    x0 = x0t + 2*pi;
    else
        x0 = x0t;
    end
end

% uniformity and variance
R = (C^2 + S^2)^0.5;
S0 = 1 - R;
