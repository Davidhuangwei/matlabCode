function [A]=mdsum(B,dim);
% A = mdsum(B,dim)
% Summation over multiple dimensions
% sums over all dimensions specified in vector <dim> which 
% must start with the largest dimension down to the smallest
% the sum is returned in A
%
% example:
% X=round(10*rand(2,2,2,2));
% dim=[3 4];
% Y=mdsum(X,dim);
% disp([sum(sum(X(1,1,:,:))), Y(1,1)])
%

dim=flipud(sort(dim(:)));	% sort in decending order
A=B;
if max(dim)>length(size(A)),
   error('Integrating Dimensions do not match N-D Array dimensions');
end;

for n=1:length(dim)
    A=sum(A,dim(n));
end;
  
A=squeeze(A);