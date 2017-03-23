function c = mtimes(a,b)
% MTIMES matrix multiply probability distributions

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if (isa(a, 'probdist_alpha'))
  b = probdist_alpha(b);
  c = a;
elseif (isa(b, 'probdist_alpha'))
  a = probdist_alpha(a);
  c = b;
else
  a = probdist_alpha(a);
  b = probdist_alpha(b);
  c = probdist_alpha;
end
c.probdist = a.probdist*b.probdist;
