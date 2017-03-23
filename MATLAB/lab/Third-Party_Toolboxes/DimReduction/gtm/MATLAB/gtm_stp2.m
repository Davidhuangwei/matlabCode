function [X, MU, FI, W, beta] = gtm_stp2(T, noLatVarSmpl, noBasFn, s)
% Generates the components of a GTM with a 2D latent space.
%
% Synopsis: [X, MU, FI, W, beta] = gtm_stp2(T, noLatVarSmpl, noBasFn, s)
%
% Arguments:	T -		target data, to be modelled by the GTM.
%
%		noLatVarSmpl -	number of samples in the latent variable
%				space; must be an integer^2, e.g.
%				1, 4, 9, 16, 25, 36, 49, ...
%
%		noBasFn -	number of basis functions in the;
%				must be an integer^2
%
%		s - 		the width of basis functions relative
%				to the distance between two neighbouring 
%				basis function centres, i.e. if s = 1,
%				the basis functions will have widths
%				(std.dev) equal to (1 times) the distance 
%				between two neighbouring basis function 
%				centres.  
%
% Return:	X -		the grid of data points making up the
%				latent variable sample; a matrix of size
%				noLatVarSmpl-by-2, in which each row is 
%				a data point
%
%		MU - 		a noBasFn-by-2 matrix holding the 
%				coordinates of the centres of the  
%				 basis functions
%
%		FI - 		the activations of the basis functions 
%				when fed the latent variable sample X, 
%				and a bias unit fixed to 1.0; a matrix 
%				with the same number of rows as X and 
%				noBasFn+1 columns (+1 for the bias).
%
%		W - 		the initial matrix of weights, mapping
%				the latent variable sample X linearly
%				onto the 2 first principal components 
%				of the target data (T)
%
% Notes:	The latent variable sample is constructed as a uniform
%		grid in the square [-1 -1; -1 1; 1 1; 1 -1]. Similarly
%		the centres of the basis function are gridded uniformly
%		over the latent variable sample, with equal standard
%		deviation, set relative to the distance between neigh-
%		bouring centres.The initial linear mapping maps the 
%		std.devs. 1:1 from the latent to the target sample 
%
% See also:	gtm_stp1
%

% Version:	The GTM Toolbox v1.0 beta
%
% Copyright:	The GTM Toolbox is distributed under the GNU General Public 
%		Licence (version 2 or later); please refer to the file 
%		licence.txt, included with the GTM Toolbox, for details.
%
%		(C) Copyright Markus Svensen, 1996


%%%%% Some error handling %%%%%

if (s <= 0)
  error('Argument s must have strict positive value');
end

gridXdim = sqrt(noLatVarSmpl);
gridFIdim = sqrt(noBasFn);

if ((gridXdim~=fix(gridXdim)) | (gridFIdim~=fix(gridFIdim)))
  error('Invalid number of basis functions or latent variable size.');
end


%%%%% Create lat. var. grid sample %%%%%

X = gtm_rctg(gridXdim, gridXdim);


%%%%% Generate basis fns. parameters and calulate activations %%%%%

% create basis fn. centres grid
MU = gtm_rctg(gridFIdim, gridFIdim);
% scale basid fn. centres grid
MU = MU*(gridFIdim/(gridFIdim-1));
% the spread of the basis fns. = s * the distance 
% between two neighbouring centres
sigma = s*(MU(1,2)-MU(2,2));
% calculate the actvations of the hidden unit when fed the lat. var. sample
FI = gtm_gbf(MU, sigma, X);


%%%%% Generate an initial set of weights %%%%%

[W, beta] = gtm_pci(T, X, FI);


