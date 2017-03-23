function [s, varargout] = size(x, dim)
% SIZE calculate the size of a probdist object

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if nargin == 1
  s = size(x.expection);
else
  s = size(x.expection, dim);
end

nout = max(nargout,1)-1;
for i=1:nout,
  varargout(i) = {s(i+1)};
end
if nout > 0
  s = s(1);
end
