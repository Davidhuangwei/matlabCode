function c = vertcat(a, b)
% VERTCAT concatenate two probdist objects vertically
%
% Arrays of probdists are made by composing such arrays of respective
% expectations and variances.

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if(nargin == 1)
  c = a;
else
  c = probdist([a.e; b.e], [a.var; b.var]);
end
