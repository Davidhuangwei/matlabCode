% cov2(X, Y)
%
% like cov but deals with matrices properly.
% X is n by m, y is n by p matrix
% output C is a m by p matrix giving the covariances
%
%   cov2(X,Y) normalizes by (N-1) where N is the number of
%   observations.  This makes cov2(X) the best unbiased estimate of the
%   covariance matrix if the observations are from a normal distribution.
%
%   cov2(X,Y,1) normalizes by N and produces the second
%   moment matrix of the observations about their mean.  cov2(X,Y,0) is
%   the same as cov2(X,Y).
%
%   The mean is removed from each column before calculating the
%   result.

function xy = cov2(x,y,flag);

if nargin<2, error('Not enough input arguments.'); end
if nargin>3, error('Too many input arguments.'); end
if nargin==2 flag = 0; end;
nin = nargin;

[n m] = size(x);
[n2 p] = size(y);

if (n2 ~= n) error('x and y must have same number of rows'); end;

if n==1,  % Handle special case
  xy = 0;

else
  xc = x - repmat(mean(x),n,1);  % Remove mean
  yc = y - repmat(mean(y),n,1);  % Remove mean
  
  if flag
    xy = xc' * yc / n;
  else
    xy = xc' * yc / (n-1);
  end
end
