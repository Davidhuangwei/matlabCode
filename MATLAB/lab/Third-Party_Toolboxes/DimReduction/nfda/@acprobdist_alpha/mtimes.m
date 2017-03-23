function c = mtimes(a,b)
% MTIMES matrix multiply probability distributions

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if (isa(a, 'acprobdist_alpha'))
  b = acprobdist_alpha(b);
  c = a;
elseif (isa(b, 'acprobdist_alpha'))
  a = acprobdist_alpha(a);
  c = b;
else
  a = acprobdist_alpha(a);
  b = acprobdist_alpha(b);
  c = acprobdist_alpha;
end
c.probdist_alpha = a.probdist_alpha*b.probdist_alpha;
