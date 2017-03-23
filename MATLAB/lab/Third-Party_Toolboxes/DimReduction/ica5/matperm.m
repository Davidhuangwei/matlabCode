% matperm - transpose and sign rows of x to match y (run after matcorr)
%
%  [permx indperm] = matperm(x,y,indx,indy,corr);
%
% x, y  = two matrices with same number of columns
% indx  = column containing row indices for x (from matcorr())
% indy  = column containing row indices for y (from matcorr())
% corr  = column of correlations between indexed rows of x,y (from matcorr())
%            (used only for its signs, +/-) 
%
% permx = the matrix x permuted and signed according to (indx, indy,corr) 
%        to best match y. Rows of 0s added to x to match size of y if nec.
% indperm = permutation index turning x into y;

% 11-30-96  Scott Makeig CNL / Salk Institute, La Jolla (from matcorr.m) 
% 04-22-99  Adjusted for fixes and speed by Sigurd Enghoff & Tzyy-Ping Jung

function [permx,indperm]= matperm(x,y,indx,indy,corr)

[m,n] = size(x);
[p,q] = size(y);
[ix,z] = size(indx);
[iy,z] = size(indy);
oldm = m;

errcode=0;
if  ix ~= iy | p ~= iy,
 fprintf('matperm: indx and indy must be column vectors, same height as y.\n');
 errcode=1
end;

if n~=q,
   fprintf('matperm(): two matrices must be same number of columns.\n');
   errcode=2;
else
  if m<p,
  		x = [x;zeros(p-m,n)];	% add rows to x to match height of y
  		p=m;
  elseif p<m,
  		y = [y;zeros(m-p,n)];	% add rows to y to match height of x
  		m=p;
  end;
end;
if errcode==0,
%
% Return the row permutation of matrix x most correlated with matrix y:
%  plus the resulting permutation index
%
  indperm = [1:length(indx)]';	% column vector [1 2 ...nrows]   
  permx  = x(indx,:); 
  indperm = indperm(indx,:);
  ydni(indy) = 1:length(indy);
  permx = permx(ydni,:);% put x in y row-order
  indperm = indperm(ydni,:);
  permx = permx.*(sgn(corr(ydni))*ones(1,size(permx,2))); 
								 % make x signs agree with y
  permx = permx(1:oldm,:);		 % throw out bottom rows if 
								 % they were added to match y
  indperm = indperm(1:oldm,:);
end;

return

function vals=sgn(data)

 vals = 2*(data>=0)-1;

return
