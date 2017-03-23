function [dcp_dwm, dcp_dwv, dcp_dbm, dcp_dbv] = netgradstop(x, dx, w, b)
% NETGRADSTOP Calculate partial derivatives of kldiv with respect to
%   network weights
%

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

nsampl = size(x, 2);

dcp_dwm = dx.e * x.e' + ...
	  2 * (dx.var * x.var') .* w.e + ...
	  sum(dx.multi, 3);
dcp_dwv = (dx.extra + dx.var) * (x.var + x.e .^ 2)';

dcp_dbm = dx.e * ones(nsampl,1);
dcp_dbv = (dx.var + dx.extra) * ones(nsampl,1);

