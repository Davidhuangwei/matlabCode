function b = subsref(a, index)
% SUBSREF implement subscripted reference for probdists

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
    b = a.e;
   case 'var'
    b = a.var;
   otherwise
    error(sprintf('Probdist object does not have element %s', index(1).subs))
  end
 case '()'
  b = probdist(a.e(index(1).subs{:}), a.var(index(1).subs{:}));
 otherwise
  error('Unsupported function')
end

% Handle possible other references recursively
if length(index) > 1
  b = subsref(b, index(2:end));
end
