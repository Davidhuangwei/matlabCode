%   RAY_CDF         find the cumulative distribution for the Rayleigh LR test.
%
%       call:   PR = RAY_CV(R,N).
%       does:   gives the Pearson approximation for the nR^2 statistic,
%               namely, Pr(nR^2 >= K).
%
%               the return value indicates the probability of
%               R to be larger than or equal than K under the
%               null hypothesis that the data is uniformly distributed.
%               a large return value means the data is likely to
%               originate in a uniform distribution.

% directional statistics package
% Nov-2001 ES

function pr = ray_cdf(R,n);

k = n*R^2;
pr = exp(-k)*( 1 + (2*k - k^2)/(4*n) - (24*k - 132*k^2 +  76*k^3 - 9*k^4)/(288*n^2) );

