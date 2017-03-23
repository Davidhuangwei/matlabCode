function llh = gtm_rspg(beta, D, mode)
% Log-likelihood and component responsibilities over a Gaussian mixture
%
%		The responsibilities are returned via the global variable
%		matrix gtmGlobalR. The responsibility gtmGlobalR(k,n) is 
%		the probability of a particular component in the Gaussian 
%		mixture, k, having generated a particular data point, n.
%		It is calculated from the distances between the data point
%		n and the centres of the mixture components, 1..K, and the
%		inverse variance, beta, common to all components. 
%
% Synopsis:	llh = gtm_rspg(beta, D, mode)
%		llh = gtm_rspg(beta, D)
%
% Arguments:	beta -	a scalar value of the inverse variance common
%			to all components of the mixture.
%
%		D -	dimensionality of space where the data and
%			the Gaussian mixture lives; necessary to
%			calculate the correct log-likelihood.
%
%		mode -	optional argument used to control the mode 
%			of calculation; it can be set to 0, 1 or 2 
%			corresponding to increasingly elaborate 
%			measure taken to reduce the amount of
%			numerical errors; mode = 0 will be fast but 
%			less accurate, mode = 2 will be slow but 
%			more accurate; the default mode is 0
%
% Return:	llh -	the log-likelihood of data under a the Gaussian 
%			mixture.
%
% Global variables:	gtmGlobalR -	an K-by-N responsibility matrix; 
%					gtmGlobalR(k,n) is the responsa-
%					bility takened by mixture component 
%					k for data point n.
%
% 			gtmGlobalDIST -	an K-by-N matrix in which element 
%					(k,n) is the Euclidean distance 
%					between the centre of component m 
%					and the data point n.
%
%			gtmGlobalMinDist, gtmGlobalMaxDist - 
%					vectors containing the minimum and 
%					maximum of each column in DIST, 
%					respectively; 1-by-N; required 
%					iff m > 0.
%
% See also:	gtm_resp, gtm_dstg, gtm_dist
%

% Version:	The GTM Toolbox v1.0 beta
%
% Copyright:	The GTM Toolbox is distributed under the GNU General Public 
%		Licence (version 2 or later); please refer to the file 
%		licence.txt, included with the GTM Toolbox, for details.
%
%		(C) Copyright Markus Svensen, 1996

if (nargin == 3)
  if (mode < 0 | mode > 2 | mode~=fix(mode))
    error(['Unknown mode of calculation: ', num2str(mode)]);
  end
elseif (nargin == 2)
  mode = 0;
else
  error(['Wrong number of arguments! Expected 3 or 4, received ', ...
		num2str(nargin), '.']);
end
 
if (D ~= fix(D))
  error(['Invalid value for D: ', num2str(D)]);
end

global gtmGlobalDIST;
if (isempty(gtmGlobalDIST))
  fprintf('gtm_rspg -- Warning: gtmGlobalDIST empty.\n');
end
[K, N] = size(gtmGlobalDIST);

if (mode > 0)
  global gtmGlobalMinDist;
  global gtmGlobalMaxDist;
  if ([1,N] ~= size(gtmGlobalMaxDist) | [1,N] ~= size(gtmGlobalMinDist))
    error(['gtm_rspg -- Warning: Mismatch in size between ', ...
		'gtmGlobalDIST and gtmGlobalMinDist/gtmGlobalMaxDist.']);
  end
end

global gtmGlobalR
if (isempty(gtmGlobalR))
  fprintf('gtm_rspg -- Warning: gtmGlobalR empty.\n');
end

if (size(gtmGlobalDIST) ~= size(gtmGlobalR))
  fprintf(['gtm_rspg -- Warning: Mismatch in size between ', ...
		'gtmGlobalR and gtmGlobalDIST.\n']);
end



if (mode > 0)
  % In calculation mode > 0, the distances between Gaussian centres
  % and data points are shifted towards being centred around zero,  
  % w.r.t. the extreme (min- and max-) values.
  % Since the difference between any two distances is still the same, 
  % the responsabilities will be the same. The advantage is that 
  % the risk of responsabilities dropping below zero (in finite precision) 
  % in the exponentiation below, due to large distances, is decreased.
  % However, while we CAN calculate reliably with zero (0), we CAN'T 
  % calculate reliably with infinity (Inf). Hence, the shifting of distances 
  % must not be so large that the exponentiation yields infinity as result.
  distCorr = (gtmGlobalMaxDist + gtmGlobalMinDist) ./ 2;

  distCorr = min(distCorr,(gtmGlobalMinDist+700*(2/beta)));
  % exp(709) < realmax < exp(710), plus a few digits margin to avoid
  % overflow when calculating rSum below.

  % Here a loop is preferred to array-operation involving a large 
  % temporary matrix, in order to limit memory usage.
  for n = 1:N
    gtmGlobalDIST(:,n) = gtmGlobalDIST(:,n) - distCorr(n);
  end
end


% Since the normalisation factor of the Gaussians is cancelled out
% when normalising the responsabilities below (R = R*diag(1 ./ rSum))
% it is omitted here. This, however, is corrected for when calculating
% the log-likelihood further below.
gtmGlobalR = exp((-beta/2)*gtmGlobalDIST);

if (mode < 2)
  rSum = sum(gtmGlobalR);
else
  % In calculation mode >= 2, the columns of R are first sorted, 
  % so that the summation over columns is done in increasing order,
  % which minimizes the amount of round-off error in the summation.
  rSum = sum(gtm_sort(gtmGlobalR));
end

% Here a loop is preferred to an array-operation involving a large 
% temporary matrix, in order to limit memory usage.
for n = 1:N	
  gtmGlobalR(:,n) = gtmGlobalR(:,n)./rSum(n);
end

% In the calculation of the log-likelihood, constants so far omitted in the
% calculations are takened into account
if (mode < 1)
  llh = sum(log(rSum)) + N*((D/2)*log(beta/(2*pi)) - log(K));
else
  % If the distances were adjusted above, to improve numerical accuracy,
  % this must be corrected for when calculating the log-likelihood.
  llh = sum(log(rSum) + distCorr*(-beta/2)) ...
		+ N*((D/2)*log(beta/(2*pi)) - log(K));
end



