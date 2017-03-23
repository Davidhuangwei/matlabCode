function a = updatevar(a, dim)
% UPDATEVAR Calculate the total variance of acprobdist_alpha matrix
% 
% Syntax
%   updatevar(a, dim) or updatevar(a)
% where a is a acprobdist_alpha object and dim gives the dimension
% along which the dependence a.ac operates.  Default is dim = 2.

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if (nargin < 2 | dim == 2)
  a.probdist_alpha.var = computevar(a.nvar, a.ac);
else
  a.probdist_alpha.var = computevar(a.nvar', a.ac')';
end
