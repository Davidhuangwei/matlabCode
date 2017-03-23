function a = subsasgn(a, index, b)
% SUBSASGN implement subscripted assignment for mprobdist

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
  a.probdist(index(1).subs{:}) = b.probdist;
  a.multivar(index(1).subs{:}) = b.multivar;
case '.'
  switch index(1).subs
  case 'e'
    a.probdist.e = b;
  case 'var'
    a.probdist.var = b;
  case 'multivar'
    a.multivar = b;
  otherwise
    error(sprintf('Mprobdist object does not have element %s', ...
	index(1).subs))
  end
otherwise
  error('Unsupported function')
end
