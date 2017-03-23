function x = feedfw(s, net)
% FEEDFW  Do feedforward phase calculations
%
%    Usage:
%      x = feedfw(s, net)
%      where sources can be either probdist, when x will be a cell
%      array with intermediate results
%      or sources can be double, when x will also be double.

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

filler = ones(1, size(s, 2));

if isa(s, 'probdist')
  x = cell(1,4);
  x{1} = makeprop(s);
  x{2} = net.w1*x{1} + net.b1 * filler;
  x{3} = feval(net.nonlin, x{2});
  x{4} = net.w2*x{3} + net.b2 * filler;
  x{4} = updatevar(x{4}, s.var);
else
  x = net.w1.e*s + net.b1.e * filler;
  x = feval(net.nonlin, x);
  x = net.w2.e*x + net.b2.e * filler;
end
