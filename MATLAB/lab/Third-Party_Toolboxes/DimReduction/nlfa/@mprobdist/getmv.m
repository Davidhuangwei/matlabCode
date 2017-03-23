function b = getmv(a, n)
% GETMV return a matrix with multivar vectors as column vectors
% 
% getmv(a) returns such matrix associated to the first column
% vector of samples
%
% getmv(a, n) does the same for nth column

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if nargin == 1
  n = 1;
end

b = (a.multivar(:,:,n))';
