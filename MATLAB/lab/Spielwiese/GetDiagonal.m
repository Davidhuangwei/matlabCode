function y = GetDiagonal(x)
% function y = GetDiagonal(x)
% 
% get the diagonal elemends x(:,i,i) 
% and sorts dem into a matrix y(:,i)

[nf nch nch] = size(x);
ind = sub2ind( size(x), repmat([1:nf],1,nch)',reshape(repmat([1:nch],nf,1),[],1), reshape(repmat([1:nch],nf,1),[],1));
y = reshape(x(ind), nf, nch);

return;