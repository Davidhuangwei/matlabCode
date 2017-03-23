function c = kl_param(param, meanprior, varprior, dim)
% KL_PARAM  Calculate the contribution of a variable and its
%           hyperparameter to the Kullback-Leibler divergence

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if nargin < 4
  dim = 2;
end

effvar = normalvar(varprior);

c = ...
    -.5 * prod(size(param)) - .5 * sum(sum(log(2*pi*param.var))) + ...
    .5 * log(2*pi) * prod(size(param)) + ...
    sum(varprior.e) * prod(size(param)) / prod(size(varprior)) + ...
    .5 * sum(sum((param.e - meanprior.e).^2 + ...
		  param.var + meanprior.var, dim) ./ effvar);
