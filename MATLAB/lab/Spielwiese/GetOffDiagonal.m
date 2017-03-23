function [y yi] = GetOffDiagonal(x,varargin)
% function [y yi] = GetOffDiagonal(x,varargin)
% [half] = DefaultArgs(varargin,{1});
%
% get the elemends x(:,i,j), i~=j 
% and sort dem into a matrix y 
% of pairs yi = [i j];
% 
% optional argument: 
%   half: take only lower half
%
% if you want the diagonal elements, use GetDiagonal
%
[half] = DefaultArgs(varargin,{1});

[nf nch nch] = size(x);

ind = [];
yi = [];
for n=1:nch-1
  
  a = repmat(n,1,nch-n);
  b = [n+1:nch];
  
  ind = [ind; sub2ind( size(x), repmat([1:nf],1,nch-n)',reshape(repmat(a,nf,1),[],1), reshape(repmat(b,nf,1),[],1))];
  yi = [yi; [a' b']];

end

y = reshape(x(ind), nf, sum([1:nch-1]));

return;