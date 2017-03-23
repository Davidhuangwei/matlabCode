function [d1, d2, d3] = dtanh(a)
% DTANH  Calculate three first derivatives of 'tanh'

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

y = tanh(a);
y2 = y .^ 2;

if nargout == 1
  d1 = 1 - y2;
else
  d1 = 1 - y2;
  d2 = -2 * y .* d1;
  d3 = 2 * d1 .* (3*y2 - 1);
end
