function v = kldiv(fs, s, x, net, params, hypers, priors)
% KLDIV  calculate Kullback-Leibler divergence
%
%    Usage:
%      kl = kldiv(founddata, sources, data, net, params, hypers, priors)
%      where founddata (probdist) contains the found values for data,
%      sources (probdist) the found values for sources, data (double)
%      the original data, net (probdist struct) the found values for
%      network, params (probdist struct) estimated values for variances
%      of different values, hypers (probdist struct) estimated
%      values for hyperparameters of the model and priors (probdist struct)
%      user defined prior distributions for the hyperparameters.

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

%% NOTE: Assume prior variance of net.w1 to be unity

v = kl_param(net.w2, probdist(0), params.net.w2var, 1) + ...
    kl_param(params.net.w2var, hypers.net.w2var.mean, ...
	     hypers.net.w2var.var) + ...
    kl_data(fs - x, probdist(0), params.noise, 2) + ...
    kl_param(params.noise, hypers.noise.mean, hypers.noise.var) + ...
    kl_param(s, probdist(0), params.src, 2) + ...
    kl_param(params.src, hypers.src.mean, hypers.src.var) + ...
    kl_param(net.b1, hypers.net.b1.mean, hypers.net.b1.var) + ...
    kl_param(net.b2, hypers.net.b2.mean, hypers.net.b2.var) + ...
    kl_param(net.w1, probdist(0), probdist(0)) + ...
    kl_param(hypers.net.w2var.mean, priors.net.w2var.mean.mean, ...
	     priors.net.w2var.mean.var) + ...
    kl_param(hypers.net.w2var.var, priors.net.w2var.var.mean, ...
	     priors.net.w2var.var.var) + ...
    kl_param(hypers.noise.mean, priors.noise.mean.mean, ...
	     priors.noise.mean.var) + ...
    kl_param(hypers.noise.var, priors.noise.var.mean, priors.noise.var.var) ...
    + ...
    kl_param(hypers.src.mean, priors.src.mean.mean, priors.src.mean.var) + ...
    kl_param(hypers.src.var, priors.src.var.mean, priors.src.var.var) + ...
    kl_param(hypers.net.b1.mean, priors.net.b1.mean.mean, ...
	     priors.net.b1.mean.var) + ...
    kl_param(hypers.net.b1.var, priors.net.b1.var.mean, ...
	     priors.net.b1.var.var) + ...
    kl_param(hypers.net.b2.mean, priors.net.b2.mean.mean, ...
	     priors.net.b2.mean.var) + ...
    kl_param(hypers.net.b2.var, priors.net.b2.var.mean, ...
	     priors.net.b2.var.var);
