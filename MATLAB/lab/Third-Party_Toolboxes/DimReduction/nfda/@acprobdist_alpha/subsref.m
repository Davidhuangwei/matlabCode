function b = subsref(a,index)
% SUBSREF implement subscripted reference for acprobdist_alphas

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

switch index(1).type
 case '.'
  switch index(1).subs
   case 'e'
    b = a.probdist_alpha.e;
   case 'var'
    b = a.probdist_alpha.var;
   case 'malpha'
    b = a.probdist_alpha.malpha;
   case 'valpha'
    b = a.probdist_alpha.valpha;
   case 'msign'
    b = a.probdist_alpha.msign;
   case 'vsign'
    b = a.probdist_alpha.vsign;
   case 'ac'
    b = a.ac;
   case 'nvar'
    b = a.nvar;
   otherwise
    error(sprintf('Acprobdist_alpha object does not have element %s', ...
                  index(1).subs))
  end
 case '()'
  thissubs = index(1).subs;
  b = acprobdist_alpha(a.probdist_alpha(thissubs{:}), a.ac(thissubs{:}), ...
                                        a.nvar(thissubs{:}));
 otherwise
  error('Unsupported function')
end

% Handle other references recursively
if length(index) > 1
  b = subsref(b, index(2:end));
end
