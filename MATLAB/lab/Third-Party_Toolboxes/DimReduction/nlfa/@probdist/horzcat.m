function c = horzcat(a, b)
% HORZCAT concatenate two probdist objects horizontally
%
% Arrays of probdists are made by composing such arrays of respective
% expectations and variances.

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if (nargin == 1)
  c = a;
else
  c = probdist([a.expection b.expection], [a.variance b.variance]);
end
