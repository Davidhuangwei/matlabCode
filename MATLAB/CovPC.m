function [eg,egv]=CovPC(Y,X,lags,tobs)
[nobs, nvar]=size(X);
[yobs, yvar]=size(Y);
if nobs~=yobs
    error('check dimension')
end
if isempty(tobs)
    if lags(end)<0
        tobs=1:(nobs+min(lags));
    else
        tobs=(max(lags)+1):nobs;
    end
end
tobs=tobs(:);
nlags=length(lags);
nX=bsxfun(@minus,X,mean(X,1));
% sX=cov(X);
% nY=zscore(Y);
oX=bsxfun(@minus,tobs,lags);
Y=zscore(repmat(Y(tobs),nlags,1));
X=nX(oX(:),:);
U_white = sqrtm(pdinv(cov(X)));%chol
X_new = X;%*U_white';
X_Ky_X = X_new' * Y * Y' * X_new;

% eigenvalue decomposition
[eg, egv,~]=svd((X_Ky_X+X_Ky_X')/2);%cov(Y_new)
% [eig_Y, eiY] = eigdec((Y_Kx_Y+Y_Kx_Y')/2, 20); % /2
% eg = U_white' * eg;

% [eg,egv,~]=svd(X'*Y*Y'*X);
