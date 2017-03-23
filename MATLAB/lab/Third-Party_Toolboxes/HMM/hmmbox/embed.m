function  [U] = embed(x,embd,lag)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	[U] = embed(x,embd,lag)
%
%	Creates an embedding matrix using the values of vector x 
%	at lags <lag>. Embedding matrix U has embedding 
%	dimension <embd>
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% need column vector;
  x=x(:);
  N=size(x,1);

% embed data sequence for embedding dimension <embd> and lag <lag>

  hindex=1:lag:embd*lag;	% horizontal vector
  hindex=hindex-1;
  vindex=1:N-(embd-1)*lag;vindex=vindex';	% vertical vector
  Nv=max(size(vindex));	

  U=x(:,ones(1,embd));
  U=U(hindex(ones(Nv,1),:)+vindex(:,ones(embd,1)));

