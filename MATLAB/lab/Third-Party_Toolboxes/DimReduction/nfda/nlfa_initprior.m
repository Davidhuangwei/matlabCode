function prior = nlfa_initprior(mm, mv, vm, vv)

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

prior.mean.mean = probdist(mm, 0);
prior.mean.var = probdist(mv, 0);
prior.var.mean = probdist(vm, 0);
prior.var.var = probdist(vv, 0);
