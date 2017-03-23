function a = subsasgn(a, index, b)
% SUBSASGN implement subscripted assignment for probdists

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
  a.e(index(1).subs{:})=b.e;
  a.var(index(1).subs{:})=b.var;
 case '.'
  switch index(1).subs
   case 'e'
    a.e = b;
   case 'var'
    a.var = b;
   otherwise
    error(sprintf('Probdist object does not have element %s', index(1).subs))
  end
 
 otherwise
  error('Unsupported function')
end
