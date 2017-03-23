function c = mtimes(a,b)
% MTIMES matrix multiply probability distributions

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if (~isa(a, 'probdist'))
  a = probdist(a);
end
if (~isa(b, 'probdist'))
  b = probdist(b);
end
c = probdist(a.e*b.e, (a.var+a.e.^2)*(b.var+b.e.^2)-a.e.^2*b.e.^2);
