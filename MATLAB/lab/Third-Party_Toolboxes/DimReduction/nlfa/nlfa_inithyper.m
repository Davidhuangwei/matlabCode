function hyper = nlfa_inithyper(mm, mv, vm, vv)
% NLFA_INITHYPER  Initialize a hyperparameter to given values

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

hyper.mean = probdist(mm, mv);
hyper.var = probdist(vm, vv);
