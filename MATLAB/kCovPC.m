function [eg,egv]=kCovPC(Y,X,lags,tobs)
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
nY=zscore(Y);
oX=bsxfun(@minus,tobs,lags);
Y=repmat(nY(tobs),nlags,1);
X=nX(oX(:),:);
% cov based method
% [eg,egv,~]=svd(X'*Y*Y'*X);

% kernel based methods
nobs=size(X,1);
H =  eye(nobs) - ones(nobs)/nobs;
width=.25;
theta = 1/(width^2); 
KY = kernel(Y, Y, [theta,1]); %[1 theta]
KY = H * KY * H;

Cov_X = X'*X/nobs;
U_white = chol(pdinv(Cov_X));%sqrtm
X_new = X;%*U_white';
X_KY_X = X_new' * KY * X_new;
[eg, egv, ~] = svd((X_KY_X+X_KY_X')/2);
% eg=U_white'*eg;