function a = subsasgn(a, index, b)
% SUBSASGN implement subscripted assignment for probdists

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

switch index(1).type
 case '()'
  a.expection(index(1).subs{:})=b.expection;
  a.variance(index(1).subs{:})=b.variance;
 
 otherwise
  error('Unsupperted function')
end

% Handle possible other references recursively
if length(index) > 1
  error('Recursive subscripted assignments not supported')
  %  a = subsref(a, index(2:end), b);
end
