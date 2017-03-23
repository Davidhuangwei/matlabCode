function hyper = nlfa_inithyper(mm, mv, vm, vv)

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

hyper.mean = probdist(mm, mv);
hyper.var = probdist(vm, vv);
