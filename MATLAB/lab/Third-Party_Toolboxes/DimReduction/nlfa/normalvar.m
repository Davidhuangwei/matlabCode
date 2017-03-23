function sigma2 = normalvar(v)
% NORMALVAR  Calculate the value of the variance from one
%    that is represeted in log scale

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

sigma2 = exp(2*(v.e - v.var));
