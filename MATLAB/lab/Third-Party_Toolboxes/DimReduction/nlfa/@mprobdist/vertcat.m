function c = vertcat(a, b)
% VERTCAT concatenate two mprobdist objects vertically
%
% Arrays of mprobdists are made by composing such arrays of respective
% expectations and variances.

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if(nargin == 1)
  c = a;
else
  % As multivars are stored a bit differently, the array dimensions
  % must be permutated before and after concatenation
  mv = [permute(a.multivar, [1 3 2]); permute(b.multivar, [1 3 2])];
  mv = permute(mv, [1 3 2]);
  
  c = mprobdist([get(a, 'E'); get(b, 'E')], [get(a, 'Var'); get(b, 'Var')], ...
		mv, [a.extravar; b.extravar]);
end
