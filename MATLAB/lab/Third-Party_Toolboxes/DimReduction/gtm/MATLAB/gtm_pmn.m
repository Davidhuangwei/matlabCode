function means = gtm_pmn(T, X, FI, W, b)
% Calculates the posterior mean projection of data into the latent space.
%
%		The posterior mean projection of a point from the target
%		space, t, is the mean of the correspondig posterior 
%		distribution induced in the latent space.
%				
% Synopsis:	means = gtm_pmn(T, X, FI, W, b)
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
%		b -	the trained value for beta
%
% Return:	means -	the posterior means in latent space. N-by-L
%
% See also:	gtm_ppd, gtm_pmd
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
[err, R] = gtm_resp(DIST, b, D);
means = R'*X;
