function c = kl_data(data, meanprior, varprior, dim)
% KL_DATA  Calculate the contribution of observations and their
%          reconstruction to the Kullback-Leibler divergence

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
    .5 * log(2*pi) * prod(size(data)) + ...
    sum(varprior.e) * prod(size(data)) / prod(size(varprior)) + ...
    .5 * sum(sum((data.e - meanprior.e).^2 + ...
		  data.var + meanprior.var, dim) ./ effvar);
