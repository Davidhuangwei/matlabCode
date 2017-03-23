function b = makeprop(a)
% MAKEPROP Transform probdists to mprobdists

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

mvar = repmat(eye(size(a, 1)), [1 1 size(a,2)]);
b = mprobdist(a.e, a.var, mvar, zeros(size(a)));
