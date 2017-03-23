function a = updatevar(a, sources)
% UPDATEVAR Calculate the actual variance from multivar array and extravar
% 
% Syntax
%   updatevar(a, sources)
% where a is a mprobdist object and sources is a column vector
% of source variances (real numbers, not probdists)

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

% Calculate the variance because of the source variances.
% The code presents efficient Matlab way of calculating
%   mv(i, j) = a.multivar(i, :, j).^2 * sources(:, j)

[d1 d2 d3] = size(a.multivar);
mv = reshape(sum(repmat(reshape(sources, [1 d2 d3]), ...
			[d1 1 1]) .* a.multivar .^ 2, 2), [d1 d3]);

a = set(a, 'Var', mv + a.extravar);
