function [W, beta] = gtm_pci(T, X, FI)
% Returns a weight matrix initialised using principal components.
%
% 		The returned weight matrix maps the mean of the 
%		latent variable to the mean of the target variable, 
%		and the L-dimensional latent variable variance to 
%		the variance of the target data along its L first
%		principal components. 
%
%		An initial value for beta can also be calculated,
%		based on the noise of the data (the "L+1"th
%		eigenvalue) and the interdistances between 
%		Gaussian mixture centres in the data space.
%
% Synopsis:	[W, beta] = gtm_pci(T, X, FI)
%		W = gtm_pci(T, X, FI)
%
% Arguments: 	T -	target distribution sample; one data point
%			per row; N-by-D
%
%		X -	the latent distribution sample, K-by-L
%
%		FI -	basis functions' activation when fed 
%			the latent data, X, plus a bias, K-by-(M+1)
%
% Return:	W -	the initialised weight matrix, (K+1)-by-D
%
%		beta -	the initial beta value, scalar. This is an 
%			optional output argument; if ommitted, the
%			corresponding (rather time consuming)
%			calculations are ommitted too.
%
% Notes:	The first dimension (column) of X will map to the 
%		first principal component, the second dimension 
%		(column) of X will map to the second principal
%		component, and so on.
%		This may be of importance for the choice of 
%		sampling density along the different dimensions
%		of X, if it differs between different dimensions 
%
% See also:	gtm_ri
%

% Version:	The GTM Toolbox v1.0 beta
%
% Copyright:	The GTM Toolbox is distributed under the GNU General Public 
%		Licence (version 2 or later); please refer to the file 
%		licence.txt, included with the GTM Toolbox, for details.
%
%		(C) Copyright Markus Svensen, 1996

[K,L] = size(X);
[K,Mplus1] = size(FI);

% calculate the L first principal components and scale them by there 
% respective eigenvalues
[eVts, eVls] = gtm_pca(T);
A = eVts(:,1:L)*diag(sqrt(eVls(1:L)));

% normalise X to ensure 1:1 mapping of variances and calculate W
% as the solution of the equation: FI*W = normX*A'
normX = (X - ones(size(X))*diag(mean(X)))*diag(1./std(X));
W = FI \ (normX*A');
% add data mean (removed by gtm_pca)
W(Mplus1,:) = mean(T);

if (nargout > 1)
  interDistBeta = gtm_bi(FI*W);
  if (L < length(T(1,:))) 
    beta = min(interDistBeta,(1/eVls(L+1)));
  else
    beta = interDistBeta;
  end
end
