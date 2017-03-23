function b = subsref(a,index)
% SUBSREF implement subscripted reference for probdist_alphas

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

switch index(1).type
 case '.'
  switch index(1).subs
   case 'e'
    b = get(a.probdist, 'E');
   case 'var'
    b = get(a.probdist, 'Var');
   case 'malpha'
    b = a.malpha;
   case 'valpha'
    b = a.valpha;
   case 'msign'
    b = a.msign;
   case 'vsign'
    b = a.vsign;
  end
 case '()'
  ex = get(a.probdist, 'E');
  var = get(a.probdist, 'Var');
  thissubs = index(1).subs;

  b = probdist_alpha(ex(thissubs{:}), var(thissubs{:}), ...
		     a.malpha(thissubs{:}), a.valpha(thissubs{:}), ...
		     a.msign(thissubs{:}), a.vsign(thissubs{:}));
 otherwise
  error('Unsupperted function')
end

% Handle other references recursively
if length(index) > 1
  b = subsref(b, index(2:end));
end
