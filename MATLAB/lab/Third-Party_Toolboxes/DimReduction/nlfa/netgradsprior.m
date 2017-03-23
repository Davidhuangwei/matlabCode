function [dcp_dwm, dcp_dwv, dcp_dbm, dcp_dbv] = ...
    netgradsprior(w, b, wprior, bprior)
% NETGRADSPRIOR Calculate the contribution of priors to partial
%   derivatives of kldiv with respect to network weights
%

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

wpvar = repmat(wprior, [size(w, 1) 1]);
bpexp = repmat(bprior.mean.e, size(b));
bpvar = repmat(normalvar(bprior.var), size(b));

dcp_dwm = w.e ./ wpvar;
dcp_dwv = .5 ./ wpvar;

dcp_dbm = (b.e - bpexp) ./ bpvar;
dcp_dbv = .5 ./ bpvar;
