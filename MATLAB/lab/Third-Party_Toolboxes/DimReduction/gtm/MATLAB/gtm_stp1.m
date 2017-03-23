function [X, MU, FI, W, beta] = gtm_stp1(T, noLatVarSmpl, noBasFn, s)
% Generates the components of a GTM with a 1D latent space.
%
% Synopsis: [X, MU, FI, W, beta] = gtm_stp1(T, noLatVarSmpl, noBasFn, s)
%
% Arguments:	T -		target data, to be modelled by the GTM.
%
%		noLatVarSmpl -	number of samples in the latent variable
%				space
%
%		noBasFn -	number of basis functions
%
%		s - 		the width of basis functions relative
%				to the distance between two neighbouring 
%				basis function centres, i.e. if s = 1,
%				the basis functions will have widths
%				(std.dev) equal to (i.e. 1 times) the  
%				distance between two neighbouring basis  
%				function centres.  
%
% Return:	X -		the grid of data points making up the
%				latent variable sample; a vector of length
%				noLatVarSmpl, in which each row is 
%				a data point
%
%		MU -		a noBasFn-element vector holding the 
%				coordinates of the centres of the  
%				basis functions
%
%		FI -		the activations of the basis functions when 
%				fed the latent variable sample X, and a bias 
%				unit fixed to 1.0; a matrix with the same 
%				number of rows as X and noBasFn+1 columns 
%				(+1 for the bias).
%
%		W -		the initial matrix of weights, mapping
%				the latent variable sample X linearly
%				onto the first principal component
%				of the target data (T)
%
%		beta - 		the intial value for the inverse variance
%				of the data space noise model
%
% Notes:	The latent variable sample is constructed as a uniform
%		grid on the interval [-1, 1]. Similarly	the centres of 
%		the basis function are gridded uniformly over the latent 
%		variable sample, with equal standard deviation, set  
%		relative to the distance between two centres. The initial 
%		linear mapping maps mean and std.devs. 1:1 from	the latent 
%		to the target sample along the principal component.
%
% See also:	gtm_stp2
%

% Version:	The GTM Toolbox v1.0 beta
%
% Copyright:	The GTM Toolbox is distributed under the GNU General Public 
%		Licence (version 2 or later); please refer to the file 
%		licence.txt, included with the GTM Toolbox, for details.
%
%		(C) Copyright Markus Svensen, 1996


%%%%% Some error handling %%%%%

if (fix(noLatVarSmpl)~=noLatVarSmpl | fix(noBasFn)~=noBasFn ...
    | noLatVarSmpl<0 | noBasFn<0)
  error(['Invalid value(s) -  noLatVarSmpl: ', num2str(noLatVarSmpl), ...
		 ' noBasFn: ', num2str(noBasFn)]);
end

if (s <= 0)
  error('Argument s must have strict positive value');
end

%%%%% Create lat. var. grid sample %%%%%

X = [-1:2/(noLatVarSmpl-1):1]';

%%%%% Generate basis fns. parameters and calulate activations %%%%%

% create basid fn. centres grid
MU = [-1:2/(noBasFn-1):1]';
% scale basid fn. centres grid
MU = MU*(noBasFn/(noBasFn-1));
% the spread of the basis fns. = s times  the distance 
% between two neighbouring centres
sigma = s*(MU(2)-MU(1));
% calculate the actvations of the hidden unit when fed the lat. var. sample
FI = gtm_gbf(MU, sigma, X);


%%%%% Generate an initial set of weights %%%%%

[W, beta] = gtm_pci(T, X, FI);

