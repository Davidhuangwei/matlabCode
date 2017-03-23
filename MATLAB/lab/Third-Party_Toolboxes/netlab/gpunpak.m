function net = gpunpak(net, w)
%GPUNPAK Separates hyperparameter vector into components. 
%
%	Description
%	NET = GPUNPAK(NET, HP) takes an Gaussian Process data structure NET
%	and  a hyperparameter vector HP, and returns a Gaussian Process data
%	structure  identical to the input model, except that the covariance
%	bias BIAS, output noise NOISE, the input weight vector INWEIGHTS and
%	the vector of covariance function specific parameters  FPAR have all
%	been set to the corresponding elements of HP.
%
%	See also
%	GP, GPPAK, GPFWD, GPERR, GPGRAD
%

%	Copyright (c) Ian T Nabney (1996-9)

% Check arguments for consistency
errstring = consist(net, 'gp');
if ~isempty(errstring);
  error(errstring);
end
if net.nwts ~= length(w)
  error('Invalid weight vector length');
end

net.bias = w(1);
net.noise = w(2);

% Unpack input weights
mark1 = 2 + net.nin;
net.inweights = w(3:mark1);

% Unpack function specific parameters
net.fpar = w(mark1 + 1:size(w, 2));

