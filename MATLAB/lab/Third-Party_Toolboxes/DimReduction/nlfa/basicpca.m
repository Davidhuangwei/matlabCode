function [s, V, D] = basicpca(x, dim)
% BASICPCA  do simple linear PCA
% 
% Usage:
%    s = BASICPCA(x, dim)
%    returns dim first PCA components of data, all scaled to
%    unity variance
%    [s, V, D] = BASICPCA(data, dim)
%    returns dim first unscaled PCA components of data and the
%    transformation matrices.
%

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

% Remove the means from the data and calculate covariance matrix
xn = x - mean(x, 2) * ones(1, size(x, 2));
covm = xn * xn' ./ size(x, 2);

% Calculate eigenvalues and find the greatest ones
[V0, D0] = eig(covm);
[S, I] = sort(-diag(D0));
S = -S;

% Return the sources normalized to unit variance
s = diag(sqrt(1./S(1:dim))) * V0(:,I(1:dim))' * xn;

% Return unnormalized sources and transformation matrices
if nargout == 3
  s = V0(:,I(1:dim))' * xn;
  V = V0(:,I);
  D = S;
end
