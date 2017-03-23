function [a,v,y,y_pred] = arwls(Z,w,p);

%  function [a,v,y,ypred] = arwls(Z,w,p);
%  Weighted Least squares AR algorithm
%  See S. Weisberg. Applied Linear Regression. p. 76
%  y_pred (t) = - \sum_i a_i y (t-i) + e (t)
%  Minimise, E = \sum_t (1/w_t) (y_t-y_pred_t)^2
%  Note the sign and ordering. This to keep format with ar_spectra.
%  Z      univariate time series 
%  p      order of model
%  a      AR coefficients
%  v      variance of residuals
%  y      targets
%  y_pred predictions

if nargin < 2, error('arwls needs at least three arguments'); end

w=w(:);
[x,y] = arembed(Z,p);
N=length(y);

% This requires an N-by-N matrix
% c=diag(1./sqrt(w));  
% c=c(p+1:p+N,p+1:p+N);
% a = pinv(-1*c*x)*c*y;

% This only requires an N-by-p matrix
c=(1./sqrt(w))*ones(1,p);         
c=c(p+1:p+N,:);
a = pinv(-1*c.*x)*(c(:,1).*y);

y_pred = -x*a;

wl=w(p+1:p+N);

pl=1./wl;
v=sum(pl.*(y-y_pred).^2)/(sum(pl));

