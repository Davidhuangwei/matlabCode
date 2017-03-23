function beta = gtm_bi(Y)
% Calculate an initial value for beta. 
%
%		The value is calculated from the average distance between
%		the nearest neighbours in Y, the centres of the constrained
%		Gaussian mixture generated in the target space from latent 
%		sample.
%
% Synopsis:	beta = gtm_bi(Y)
%
% Arguments:	Y -	a matrix containing the positions of the centres
%			of the Gaussian mixture induced in target space
%			from the latent variable samples.
%
% Return:	beta -	an initial value for the inverse variance of the
% 			Gaussian mixture
%

% Version:	The GTM Toolbox v1.0 beta
%
% Copyright:	The GTM Toolbox is distributed under the GNU General Public 
%		Licence (version 2 or later); please refer to the file 
%		licence.txt, included with the GTM Toolbox, for details.
%
%		(C) Copyright Markus Svensen, 1996

% calculate the inter-distance matrix for Y, but 'exclude' the
% case of a point being its own neighbour, by setting the
% corresponding distance to realmax

yInterDist = gtm_dist(Y, Y, 0) + diag(ones(length(Y(:,1)),1)*realmax); 


% Find the average distance between nearest neigbours 
meanNN = mean(min(yInterDist));

beta = (2/meanNN);





