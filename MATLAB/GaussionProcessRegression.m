function ny=GaussionProcessRegression(x,y,width,varargin)
% function ny=GaussionProcessRegression(x,y,width)
% or        ny=GaussionProcessRegression(x,y,width,lambda, nx)
% use gaussion process regression to fit ny=f(nx | y,x)
% when nx is not given, nx=unique(x).
% here gaussion kernel is used, kernel width given by width, while the
% noise level lambda is defined by user. 
% 
% see also: BasicRegression, 
% functionlist.

mx=mean(x,1);
x=bsxfun(@minus,x,mx);
T=size(x,1);
if nargin<5
    nx=unique(x);
else
    nx=bsxfun(@minus,varargin{2},mx);
end
% nT=length(nx);
if nargin<4
    lambda=100;%.00
else
    lambda=varargin{1};
end
theta = 1/(width^2 );
% H =  eye(T) - ones(T)/T;
% my=mean(y,1);
% y=bsxfun(@minus,y,my);
Kx=kernel(x,x,[theta,1]);%widthwidth[theta,1][theta,1]
% Kx = H * Kx * H;
R= chol(Kx + lambda*eye(T));
nKx=kernel(nx,x,[theta,1]);%(eye(nT) - ones(nT)/nT)**H
ny=nKx/R*(R'\y);
% ny=bsxfun(@plus,nKx/R*(R\y),my);
end
function [kx, bw_new] = kernel(x, xKern, theta)

% KERNEL Compute the rbf kernel
% Copyright (c) 2010-2011  ...
% All rights reserved.  See the file COPYING for license terms.
n2 = dist2(x, xKern);% need to modify dist2p
if theta(1)==0
    theta(1)=2/median(n2(tril(n2)>0));
    theta_new=theta(1);
end
wi2 = theta(1)/2;
kx = theta(2)*exp(-n2*wi2);
bw_new=1/theta(1);
end