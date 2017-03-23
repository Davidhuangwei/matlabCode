function [dc_dnetm, dc_dnetv] = feedback_netpriors(net, params, hypers)
% FEEDBACK_NETPRIORS Calculate the contribution of network priors
%   to the gradients of the cost function with respect to network weights
%

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

w1var = ones(1, size(net.w1, 2));
w2var = normalvar(params.w2var);

[dc_dnetm.w2, dc_dnetv.w2, dc_dnetm.b2, dc_dnetv.b2] = ...
    netgradsprior(net.w2, net.b2, w2var, hypers.b2);
[dc_dnetm.w1, dc_dnetv.w1, dc_dnetm.b1, dc_dnetv.b1] = ...
    netgradsprior(net.w1, net.b1, w1var, hypers.b1);
