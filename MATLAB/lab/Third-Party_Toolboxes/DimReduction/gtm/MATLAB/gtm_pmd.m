function modes = gtm_pmn(T, X, FI, W)
% Calculates the posterior mode projection of data into the latent space.
%
%		The posterior mode projection of a point from the target
%		space, t, is the mode of the correspondig posterior 
%		distribution induced in the latent space.
%				
% Synopsis:	modes = gtm_pmn(T, X, FI, W)
%
% Arguments:	T -	data points representing the distribution
%			in the target space. N-by-D
%
%		X -	data points forming a latent variable sample
%			of the distribution in the latent space.
%			K-by-L
%
%		FI -	activations of the basis functions when
%			fed X; K-by-(M+1)
%
%		W -	a matrix of trained weights
%
% Return:	modes -	the posterior modes in latent space. N-by-L
%
% See also:	gtm_ppd, gtm_pmn
%

% Version:	The GTM Toolbox v1.0 beta
%
% Copyright:	The GTM Toolbox is distributed under the GNU General Public 
%		Licence (version 2 or later); please refer to the file 
%		licence.txt, included with the GTM Toolbox, for details.
%
%		(C) Copyright Markus Svensen, 1996

D = length(T(1,:));
DIST = gtm_dist(T, FI*W, 0);
[minDist, minDistIndx] = min(DIST);
modes = X(minDistIndx',:);
