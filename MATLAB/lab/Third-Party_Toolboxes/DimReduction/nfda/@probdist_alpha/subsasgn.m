function a = subsasgn(a, index, b)
% SUBSASGN implement subscripted assignment for probdist_alphas

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
  a.malpha(index(1).subs{:}) = b.malpha;
  a.valpha(index(1).subs{:}) = b.valpha;
  a.msign(index(1).subs{:}) = b.msign;
  a.vsign(index(1).subs{:}) = b.vsign;
case '.'
  switch index(1).subs
  case 'e'
    a.probdist.e = b;
  case 'var'
    a.probdist.var = b;
  case 'malpha'
    a.malpha = b;
  case 'valpha'
    a.valpha = b;
  case 'msign'
    a.msign = b;
  case 'vsign'
    a.vsign = b;
  otherwise
    error(sprintf('Probdist_alpha object does not have element %s', ...
	index(1).subs))
  end
otherwise
  error('Unsupported function')
end
