% subfunction to compute K-L divergences from means and covariance matrices
% on multivariate Gaussians
function kl = MVGKL(M1, S1, M2, S2)

kl = MVGLik(M1, S1, M1, S1) - MVGLik(M1, S1, M2, S2);


return

% old version that is probably wrong
kl =  .5*log(det(iC2))/log(det(iC1)) ...
	+ .5*trace(inv(iC1)*(iC2-iC1)) ...
	+ .5*delta' * iC2 * delta;