function [W, beta] = gtm_ri(T, FI)
% Returns an initial random weight matrix.
%
%		Generates a weight matrix with the bias weights set to 
%		map to the mean of the target distribution and remaining 
%		weights drawn at random from a Gaussian distribution with 
%		zero mean and variances choosen so that the variances of 
%		the generated distribution roughly match the variances 
%		of the target distribution.
%
%		In addition, an initial value for beta may be calculated as
%		the inverse of the average distance between each Gaussian 
%		centre, calculated with the random mapping, and its nearest 
%		neighbours in the set of data points.
%
% Synopsis:	[W, beta] = gtm_ri(T, FI)
%		W = gtm_ri(T, FI)
%
% Arguments:	T -	sample of target distribution, used for
%			calculating the mean; one data point
%			per row; N-by-D
%
%		FI -	basis functions' activations when fed 
%			the latent data, X, plus a bias, K-by-(M+1)
%
% Return:	W - 	the initialised weight matrix; 
%			(M+1)-by-D
%
%		beta -	the initial beta value, scalar. This is an 
%			optional output argument; if omitted, the
%			corresponding calculations are omitted too.
%
% See also:	gtm_pci
%

% Version:	The GTM Toolbox v1.0 beta
%
% Copyright:	The GTM Toolbox is distributed under the GNU General Public 
%		Licence (version 2 or later); please refer to the file 
%		licence.txt, included with the GTM Toolbox, for details.
%
%		(C) Copyright Markus Svensen, 1996

[N, D] = size(T);
[K, Mplus1] = size(FI);

varT = std(T).^2;
mnVarFI = mean(std(FI(:,1:(Mplus1-1))).^2);
stdW = varT./(mnVarFI*(Mplus1-2));

W = [randn((Mplus1-1), D)*diag(sqrt(stdW));zeros(1,D)];

W(Mplus1,:) = mean(T) - mean(FI*W);

if (nargout > 1)
  beta = 1 / mean(min(gtm_dist(T, FI*W, 0)));
end





