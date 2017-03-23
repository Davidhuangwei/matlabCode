function grad = netgrad_zeros(net)
% NETGRAD_ZEROS  Create an empty structure for network gradients

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

grad.w2 = zeros(size(net.w2));
grad.b2 = zeros(size(net.b2));
grad.w1 = zeros(size(net.w1));
grad.b1 = zeros(size(net.b1));
