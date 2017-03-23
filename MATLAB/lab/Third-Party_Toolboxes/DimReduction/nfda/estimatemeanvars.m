function [m_x, v_x] = estimatemeanvars(x, mprior, vprior, v_x0, dim)
% ESTIMATEMEANVARS  Estimate parameters for variables with nonzero
%                   mean and variance
%
%    ESTIMATEMEANVARS can be used to estimate parameter values
%    for variables that are assumed to have nonzero mean and variance.

%    [M_X, V_X] = ESTIMATEMEANVARS(X, MPRIOR, VPRIOR, V_X0, DIM) finds
%    the estimates M_X and V_X for parameters of X with previous value
%    of V_X V_X0 and priors for the parameters MPRIOR and VPRIOR.
%    Different samples of data are assumed to be along dimension DIM
%    (default: 2).

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if nargin < 5
  dim = 2;
end

N = size(x, dim);
veff = exp(2*v_x0.e - 2*v_x0.var);
vmeff = exp(2*mprior.var.e - 2*mprior.var.var);
new_var = 1./(N./veff + 1/vmeff);
new_mean = (sum(x.e, dim)./veff + mprior.mean.e/vmeff).*new_var;
m_x = probdist(new_mean, new_var);

epsilon = 1e-5;
minstep = -0.5;
basex = v_x0.e;

vveff = exp(2*vprior.var.e - 2*vprior.var.var);
xval = sum(x.e .^ 2 + x.var, dim) + N*(new_var + new_mean.^2) - ...
    2*sum(x.e, dim).*new_mean;

beta = vveff .* xval .* exp(-2 * basex + 2 * v_x0.var);
gamma = vprior.mean.e - N * vveff - basex;

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
new_var = vveff ./ (1 + 2*(t - gamma));

v_x = probdist(new_mean, new_var);
