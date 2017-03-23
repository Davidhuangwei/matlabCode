% [a b R2] = CanonCov(X, Y)
%
% does a canonical correlation analysis on two sets of data X and Y
%
% R2 is the returned vector of cannonical covariates
% a and b are the projections that produce them

function [a b R2] = CanonCov(X, Y)

% Make covariance matrices
XSize = size(X, 2);
YSize = size(Y, 2);

BigCov = cov([X, Y]);
CXX = BigCov(1:XSize, 1:XSize);
CYY = BigCov(XSize+1:end, XSize+1:end);
CYX = BigCov(XSize+1:end, 1:XSize);

% matrix to do svd on ...
M = CYY^-0.5 * CYX * CXX^-0.5;

% do svd
[u s v] = svd(M);