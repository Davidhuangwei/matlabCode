function [llh, R] = gtm_resp(DIST, minDist, maxDist, beta, D, mode)
% Log-likelihood and component responsibilities under a Gaussian mixture
%
%		The responsibility R(k,n) is the probability of a particular 
%		component in the Gaussian mixture, k, having generated a 
%		particular data point, n. It is calculated from the distances 
%		between the data point n and the centres of the mixture 
%		components, 1..K, and the inverse variance, beta, common to 
%		all components. 
%
% Synopsis:	[llh, R] = gtm_resp(DIST, minDist, maxDist, beta, D, mode)
%		[llh, R] = gtm_resp(DIST, beta, D)
%
% Arguments:	DIST -	a K-by-N matrix in which element (k,n) is
%			the squared distance between the centre of
%			component k and the data point n.
%
%		minDist,
%		  maxDist -	vectors containing the minimum and 
%				maximum of each column in DIST, 
%				respectively; 1-by-N; required 
%				iff m > 0.
%
%		beta -	a scalar value of the inverse variance common
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
% Return:	llh -	the log-likelihood of data under the Gaussian 
%			mixture
%
%		R - 	an K-by-N responsibility matrix; R(k,n) is
%			the responsibility takened by mixture component
%			k for data point n.
%
% Notes:	'llh' is put as the first output argument, as 'R' 
%		is not of interest in the fairly common task of 
%		calculating the log-likelihood of a data set under a
%		given model. This allows for calls like:
%
%		llh = gtm_resp(...);
%
% See also:	gtm_dist, gtm_rspg, gtm_dstg
%

% Version:	The GTM Toolbox v1.0 beta
%
% Copyright:	The GTM Toolbox is distributed under the GNU General Public 
%		Licence (version 2 or later); please refer to the file 
%		licence.txt, included with the GTM Toolbox, for details.
%
%		(C) Copyright Markus Svensen, 1996


if (nargin == 6)
  if (mode < 0 | mode > 2 | mode~=fix(mode))
    error(['Unknown mode of calculation: ', num2str(mode)]);
  end
elseif (nargin == 4)
  mode = beta;
  if (mode < 0 | mode > 2 | mode~=fix(mode))
    error(['Unknown mode of calculation: ', num2str(mode)]);
  elseif(mode > 0)
    error('Calcultions in mode > 0 requires 6 input arguments.');
  else
    D = maxDist;
    beta = minDist;
  end
elseif (nargin == 3)
  mode = 0;
  beta = minDist;
  D = maxDist;
else
  error(['Wrong number of arguments! Expected 3,4 or 6 - received ', ...
		num2str(nargin), '.']);
end
 
if (size(beta)~=[1 1] | size(D)~=[1 1])
  error('beta and D should be scalars - mismatch of arguments?');
end

if (D ~= fix(D))
  error(['Invalid value for D: ', num2str(D)]);
end

[K,N] = size(DIST);

if (mode > 0)
  % In calculation mode > 0, the distances between Gaussian centres
  % and data points are shifted towards being centred around zero,
  % w.r.t. the extreme (min- and max-) values.
  % Since the difference between any two distances is still the same, 
  % the responsabilities (R) will be the same. The advantage is that 
  % the risk of responsabilities dropping below zero (in finite precision) 
  % in the exponentiation below, due to large distances, is decreased.
  % However, while we CAN calculate with zero (0), we CAN'T calculate
  % with infinity (Inf). Hence, the shifting of distances must not be
  % so large that the exponentiation yields infinity as result.

  distCorr = (maxDist + minDist) ./ 2;

  distCorr = min(distCorr,(minDist+700*(2/beta)));
  % exp(709) < realmax < exp(710), plus a few digits margin to avoid
  % overflow when calculating rSum below.

  % Here a loop is preferred to array-operation involving a large 
  % temporary matrix, in order to limit memory usage.
  for n = 1:N
    DIST(:,n) = DIST(:,n) - distCorr(n);
  end
end


% Since the normalisation factor of the Gaussians is cancelled out
% when normalising the responsabilities below (R = R*diag(1 ./ rSum))
% it is omitted here. This, however, is corrected for when calculating
% the log-likelihood further below.
R = exp((-beta/2)*DIST);

if (mode < 2)
  rSum = sum(R);
else
  % In calculation mode >= 2, the columns of R are first sorted, 
  % so that the summation over columns is done in increasing order,
  % which minimizes the amount of round-off error in the summation.
  rSum = sum(gtm_sort(R));
end

% Here a loop is preferred to an array-operation involving a large 
% temporary matrix, in order to limit memory usage.
for n = 1:N	
  R(:,n) = R(:,n)./rSum(n);
end

% In the calculation of the log-likelihood, constants so far omitted in the
% calculations are takened into account.
if (mode < 1)
  llh = sum(log(rSum)) + N*((D/2)*log(beta/(2*pi)) - log(K));
else
  % If the distances were adjusted above, to improve numerical accuracy,
  % this must be corrected for when calculating the log-likelihood.
  llh = sum(log(rSum) + distCorr*(-beta/2)) ...
		+ N*((D/2)*log(beta/(2*pi)) - log(K));
end



