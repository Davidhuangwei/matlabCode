function [dc_dsm, dc_dsv] = feedback_srcpriors(sources, srcparams)
% FEEDBACK_SRCPRIORS Calculate the contribution of source priors
%   to the gradients of the cost function with respect to source values
%

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

sourcevar = normalvar(srcparams);

nsampl = size(sources, 2);

temp = sourcevar * ones(1, nsampl);

dc_dsm = sources.e ./ temp;
dc_dsv = .5 ./ temp;
