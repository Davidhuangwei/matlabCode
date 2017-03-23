% L = GaussianLikelihood(Mu, Sigma, Mu0, Sigma0)
% 
% L is the LOG LIKELIHOOD PER OBSERVATION of seening data
% with empirical covariance Sigma and mean Mu, under a multivariate
% Gaussian distribution with mean Mu0 and covariance Sigma0
%
% see Johnson and Wichern p. 139

function L = MVGLik(Mu, Sigma, Mu0, Sigma0)

d = length(Mu);

if length(Mu0)~=d | ~all(size(Sigma)==d) | ~all(size(Sigma0)==d) 
    error('Sizes do not match');
end

del = Mu(:)-Mu0(:);

L = (-d*log(2*pi) - log(det(Sigma0)) - trace(Sigma0\Sigma) - del'*inv(Sigma0)*del)/2;