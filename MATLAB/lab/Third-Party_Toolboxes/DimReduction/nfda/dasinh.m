function [d1, d2, d3] = dasinh(a)
% DASINH  Calculate first three derivatives of 'asinh'
%

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if nargout == 1
  d1 = (a.^2 + 1).^(-.5);
else
  d1 = (a.^2 + 1).^(-.5);
  d2 = -a .* d1.^3;
  d3 = (2 * a.^2 - 1) .* d1.^5;
end
