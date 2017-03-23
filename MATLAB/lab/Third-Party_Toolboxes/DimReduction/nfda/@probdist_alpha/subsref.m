function b = subsref(a,index)
% SUBSREF implement subscripted reference for probdist_alphas

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
    b = a.probdist.e;
   case 'var'
    b = a.probdist.var;
   case 'malpha'
    b = a.malpha;
   case 'valpha'
    b = a.valpha;
   case 'msign'
    b = a.msign;
   case 'vsign'
    b = a.vsign;
   otherwise
    error(sprintf('Probdist_alpha object does not have element %s', ...
                  index(1).subs))
  end
 case '()'
  thissubs = index(1).subs;
  b = probdist_alpha(a.probdist(thissubs{:}), a.malpha(thissubs{:}), ...
                     a.valpha(thissubs{:}), a.msign(thissubs{:}), ...
		     a.vsign(thissubs{:}));
 otherwise
  error('Unsupported function')
end

% Handle other references recursively
if length(index) > 1
  b = subsref(b, index(2:end));
end
