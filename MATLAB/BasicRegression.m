function [Ress,A]=BasicRegression(x,y,varargin)
% [Ress, A]=BasicRegression(x,y)
% linear vector regression.
% Ress=y-f(x)
% 
% see also: GaussionProcessRegression,
% functionlist.
if size(y,2)>1
    x=x(:);
    y=y(:);
end
lambda=.0001;
A=(lambda+x'*x)\(x'*y);
if nargin<3
    Ress= y-x*A;
else
    Ress=varargin{1}*A;
end