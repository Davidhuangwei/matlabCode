function v = kl_batch(fs, s, x, params)
% KL_BATCH  calculate batch-dependent part of Kullback-Leibler divergence
%
%    Usage:
%      kl = kl_batch(fs, s, x, params)
%      where fs (probdist) contains the found values for data, s
%      (probdist) the found values for sources, x (double) the
%      original data, params (probdist struct) estimated values for
%      variances of different values

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

v = kl_data(fs - x, probdist(0), params.noise, 2) + ...
    kl_param(s, probdist(0), params.src, 2);
