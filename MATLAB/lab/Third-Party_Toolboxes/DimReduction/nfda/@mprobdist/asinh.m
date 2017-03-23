function b = asinh(a)
% ASINH Inverse hyperbolic sine of a propability distribution
%
% The result is calculated using second order Taylor approximation
% for expectation and first order for variance:
%
% E[res] = arsinh(E[arg]) + 1/2 * arsinh''(E[arg]) * Var[arg]
% Var[res] = (arsinh'(E[arg]))^2 * Var[arg]
%

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

e = get(a.probdist, 'E');
var = get(a.probdist, 'Var');

% Calculate first and second derivative of asinh at given point
d = (e.^2 + 1).^(-.5);
d2 = -e.*(e.^2 + 1).^(-1.5);

% Multiply the multivar vectors, i.e. calculate
%  m(:,i,:) = d .* a.multivar(:,i,:);

[dim1 dim2 dim3] = size(a.multivar);
m = repmat(reshape(d, [dim1 1 dim3]), [1 dim2 1]) .* a.multivar;

b = mprobdist(asinh(e)+.5*d2.*var, d.^2.*var, m, d.^2 .* a.extravar);

