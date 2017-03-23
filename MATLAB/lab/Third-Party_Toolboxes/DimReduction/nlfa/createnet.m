function net = createnet(n_in, n_hid, n_out, nonlin, ...
			 w1std, b1std, w2std, b2std)
% CREATENET  Create an MLP network with one hidden layer
%
%    Usage:
%      net = createnet(n_in, n_hid, n_out, nonlin,
%                      w1std, b1std, w2std, b2std)
%
%      where idim, hdim and odim are numbers of input, hidden
%      and output neurons, respectively.  Nonlin specifies the
%      name of activation function for the hidden layer (default: tanh).
%      The network is initialized randomly and other parameters
%      specify standard deviations for all values (defaults: 2,4,1,1).

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if nargin < 5
  w1std = 2;
  b1std = 4;
  w2std = 1;
  b2std = 1;
end
varcoef = .001;

net.w1 = probdist(w1std * randn(n_hid, n_in),  varcoef * ones(n_hid, n_in));
net.b1 = probdist(b1std * randn(n_hid, 1),     varcoef * ones(n_hid, 1));
net.w2 = probdist(w2std * randn(n_out, n_hid), varcoef * ones(n_out, n_hid));
net.b2 = probdist(b2std * randn(n_out, 1),     varcoef * ones(n_out, 1));

if nargin > 3
  net.nonlin = nonlin;
else
  net.nonlin = 'tanh';
end
