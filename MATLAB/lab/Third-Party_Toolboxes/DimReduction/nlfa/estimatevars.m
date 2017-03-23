function v_x = estimatevars(x, vprior, v_x0, dim)
% ESTIMATEVARS  Estimate parameters for variables with zero mean
%
%    ESTIMATEVARS can be used to estimate variance parameter
%    values for variables that are assumed to have zero mean.
%    V_X = ESTIMATEVARS(X, VPRIOR, V_X0, DIM) finds the estimate V_X for
%    variance parameters of X with previous value V_X0 and
%    hyperparameter value VPRIOR.  Different samples of data
%    are assumed to be along dimension DIM (default: 2).

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

epsilon = 1e-5;
minstep = -0.5;
basex = v_x0.e;

N = size(x, dim);
sueff = exp(2*vprior.var.e - 2*vprior.var.var);
xval = sum(x.e .^ 2 + x.var, dim);

beta = sueff .* xval .* exp(-2 * basex + 2 * v_x0.var);
gamma = vprior.mean.e - N * sueff - basex;

t = zeros(size(v_x0));
% solve t - beta * exp(-2 t) - gamma = 0
% using Newton's iteration

step = ones(size(v_x0)) + epsilon;

while max(abs(step)) > epsilon
  step = (t - beta .* exp(-2 * t) - gamma) ./ (-1 - 2*beta.*exp(-2 * t));
  step = step .* (step >= minstep) + minstep * (step < minstep);
  t = t + step;
end

new_mean = basex + t;
new_var = sueff ./ (1 + 2*(t - gamma));

v_x = probdist(new_mean, new_var);
