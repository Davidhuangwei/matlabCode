function b = subsref(a, index)
% SUBSREF implement subscripted reference for probdists

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
    b = a.expection;
   case 'var'
    b = a.variance;
  end
 case '()'
  b = probdist(a.expection(index(1).subs{:}), ...
	       a.variance(index(1).subs{:}));
 otherwise
  error('Unsupperted function')
end

% Handle possible other references recursively
if length(index) > 1
  b = subsref(b, index(2:end));
end
