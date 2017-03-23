function c = minus(a,b)
% MINUS subtract mprobdist objects

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if (isa(a, 'probdist') & ~isa(a, 'mprobdist'))
  c = mprobdist(a.e - get(b.probdist, 'E'), ...
		a.var + get(b.probdist, 'Var'), ...
		b.multivar, a.var + b.extravar);
elseif (isa(b, 'probdist') & ~isa(b, 'mprobdist'))
  c = mprobdist(get(a.probdist, 'E') - b.e, ...
		get(a.probdist, 'Var') + b.var, ...
		a.multivar, a.extravar+b.var);
else
  if (~isa(a, 'mprobdist'))
    a = mprobdist(a);
  end
  if (~isa(b, 'mprobdist'))
    b = mprobdist(b);
  end
  c = mprobdist(get(a.probdist, 'E')-get(b.probdist, 'E'), ...
		get(a.probdist, 'Var')+get(b.probdist, 'Var'), ...
		a.multivar-b.multivar, a.extravar+b.extravar);
end
