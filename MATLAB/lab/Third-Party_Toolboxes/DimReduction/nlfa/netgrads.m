function [dcp_dwm, dcp_dwv, dcp_dbm, dcp_dbv] = netgrads(x, dx, w, b)
% NETGRADS Calculate partial derivatives of kldiv with respect to
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

% A more efficient way to calculate
%temp = x.multivar;
%for i=1:nsampl
%  bonus = bonus + dx.multi(:,:,i) * temp(:,:,i)';
%end
d0 = size(x.multivar, 1);
[d1 d2 d3] = size(dx.multi);
bonus = reshape(dx.multi, [d1 d2*d3]) * reshape(x.multivar, [d0 d2*d3])';

dcp_dwm = dx.e * x.e' + ...
	  2 * (dx.extra * x.extravar') .* w.e ...
	  + bonus;
dcp_dwv = dx.extra * (x.var + x.e .^ 2)';

dcp_dbm = dx.e * ones(nsampl,1);
dcp_dbv = dx.extra * ones(nsampl,1);

