%   COMP_CIRC_VAR   Compute circular variance - matrix version.
% 
% input is a matrix of vectors. this function works on the ROWS.

% directional statistics package
% Dec-2001 ES

% revisions
% 10-apr-04 NaN handling included (MY_MEAN)

function S0 = comp_circ_var(theta);

%matrix version

% basic computations
[rows, n] = size(theta);
x = cos(theta);
y = sin(theta);
% C = sum(x,2)/n;
% S = sum(y,2)/n;
C = my_mean(x,2);
S = my_mean(y,2);

% uniformity and variance
% R = (C.^2 + S.^2).^0.5;
% S0 = 1 - R;
S0 = 1 - (C.^2 + S.^2).^0.5;

% S0 - a column vector
