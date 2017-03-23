function b = tanh(a)
% TANH Hyperbolic tangent of a propability distribution
%
% The result is calculated using second order Taylor approximation
% for expectation and first order for variance:
%
% E[res] = tanh(E[arg]) + 1/2 * tanh''(E[arg]) * Var[arg]
% Var[res] = (tanh'(E[arg]))^2 * Var[arg]
%

% Copyright (C) 2002 Harri Valpola and Antti Honkela.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

e = get(a.probdist, 'E');
var = get(a.probdist, 'Var');

% Calculate first and second derivative of tanh at given point
val = tanh(e);
d = 1 - val.^2;
d2 = -2 * val .* d;

% Multiply the multivar vectors, i.e. calculate
%  m(:,i,:) = d .* a.multivar(:,i,:);
[dim1 dim2 dim3] = size(a.multivar);
m = repmat(reshape(d, [dim1 1 dim3]), [1 dim2 1]) .* a.multivar;

b = mprobdist(val+.5*d2.*var, d.^2.*var, m, d.^2 .* a.extravar);

