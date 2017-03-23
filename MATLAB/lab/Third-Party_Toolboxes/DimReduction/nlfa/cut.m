function v = cut(a, up, down)
% CUT  cut down values of matrix that are not between given limits
%
%   Usage:
%     B = CUT(A, up, down)
%     will return a matrix with all values in A greater than up
%     replaced by up and all values less than down replaced by down

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

v = a .* (a >= down) + down .* (a < down);
v = v .* (v <= up)   + up   .* (v > up);
