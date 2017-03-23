function a = subsasgn(a, index, b)
% SUBSASGN implement subscripted assignment for acprobdist_alphas

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

% Handle possible other references recursively
if (length(index) > 1)
  b = subsasgn(subsref(a, index(1)), index(2:end), b);
end

switch index(1).type
 case '()'
  a.probdist_alpha(index(1).subs{:}) = b.probdist_alpha;
  a.ac(index(1).subs{:}) = b.ac;
  a.nvar(index(1).subs{:}) = b.nvar;
 case '.'
  switch index(1).subs
   case 'e'
    a.probdist_alpha.e = b;
   case 'var'
    a.probdist_alpha.var = b;
   case 'malpha'
    a.probdist_alpha.malpha = b;
   case 'valpha'
    a.probdist_alpha.valpha = b;
   case 'msign'
    a.probdist_alpha.msign = b;
   case 'vsign'
    a.probdist_alpha.vsign = b;
   case 'ac'
    a.ac = b;
   case 'nvar'
    a.nvar = b;
   otherwise
    error(sprintf('Acprobdist_alpha object does not have element %s', ...
                  index(1).subs))
  end
 otherwise
  error('Unsupported function')
end
