function a = subsasgn(a, index, b)
% SUBSASGN implement subscripted assignment for probdist_alphas

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

switch index(1).type
 case '()'
  a.probdist(index(1).subs{:}) = b.probdist;
  a.malpha(index(1).subs{:}) = b.malpha;
  a.valpha(index(1).subs{:}) = b.valpha;
  a.msign(index(1).subs{:}) = b.msign;
  a.vsign(index(1).subs{:}) = b.vsign;
 otherwise
  error('Unsupperted function')
end

% Handle possible other references recursively
if length(index) > 1
  error('Recursive subscripted assignments not supported')
  %  a = subsref(a, index(2:end), b);
end
