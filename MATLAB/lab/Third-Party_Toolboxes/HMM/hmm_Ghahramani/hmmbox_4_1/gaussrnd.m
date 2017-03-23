function [x]=gaussrnd(m,C,N)
%
%  x=GAUSSRND(m,C,N)
%
%  samples N-times from an multi-dimensional gaussian distribution 
%  with covariance matrix C and mean m. Dimensionality is implied
%  in the mean vector
%
%  e.g: C=[1 .7;0.7 1];
%       m=[0;0];
%       x=gaussrnd(m,C,300);
m=m(:);
ndim=size(C,1);
if size(C,2)~=ndim,
  x=[];
  error('Wrong specification calling sampgauss');
end

if ndim==1,
   x=m+C*randn(1,N);
   return;
end;

% check determinant of covariance matrix
%if det(C)>1 | det(C)<=0, error('Covariance matrix determinant must be 0< |C| <=1'); end;

% generate zero mean/unit variance samples
e=randn(ndim,N);
% make sure they are unit variance; only works if N>ndim
if N>ndim
  s=std(e');
else
  s=ones(ndim,1);
end;

for i=1:ndim,
   e(i,:)=e(i,:)./s(i);
end;

% decompose cov-matrix
S=chol(inv(C));
x=inv(S)*e+m(:,ones(N,1));
