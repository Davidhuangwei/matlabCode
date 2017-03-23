function param = estimatehypers(x)
% ESTIMATEHYPERS  Estimate highest level hyperparameter values for given data
%

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

mv = mean(x.e);

seff = sum((x.e - mv).^2 + x.var) / (prod(size(x)) - 1);
varvar = .5 ./ prod(size(x));

param.mean = probdist(mv, seff / prod(size(x)));
param.var = probdist(varvar + .5*log(seff), varvar);
