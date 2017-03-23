function ind = end(a, k, n)
% END last index in an indexing expression

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if (n==1)
  ind = prod(size(a.e));
else
  ind = size(a.e, k);
end
