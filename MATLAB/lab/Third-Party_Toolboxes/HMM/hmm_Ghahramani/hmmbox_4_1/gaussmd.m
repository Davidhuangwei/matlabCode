function [px] = gaussmd (x,mu,sigma,logoption)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   [px] = gaussmd (x,mu,sigma)
%
%   computes m-D probability density from x values given
%   mean mu and standard deviation sigma
%              1                                     T       -1
%   p(x)= ------------------------- exp (-0.5  (x-mu)   Sigma    (x-mu)  )
%         (2*pi)^(d/2) |Sigma|^0.5
%
%  e.g: [X,Y] = meshgrid(-2:.2:2, -2:.2:2);
%       mu=[0;0];sigma=[1 0;0 1];
%       for i=1:21, for j=1:21, 
%             p(i,j)=gaussmd([ X(i,j) Y(i,j)],mu,sigma); 
%       end; end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<4,
  logoption=0;
end;

d=size(sigma,1);
if (size(x,2)~=d)  x=x'; end;
if (size(mu,2)~=d)  mu=mu'; end;

N=size(x,1);
ndim=size(x,2);


%px=zeros(N,1);

z=(x-ones(N,1)*mu);
IS=inv(sigma);
DS=det(sigma);

px=exp(-0.5.*sum((z*IS).*z,2))./sqrt((2*pi)^ndim*DS);
return;

if ~logoption
  px=log(px);
end;