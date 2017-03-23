function NM=subscalar(M,X,Sign);
%% if X scalar:
%% substacts X from each value of M
%% if X vector:
%% substracts X_i from ith row or column of M, depending if X is row or column vector.

sizeM = size(M);
sizeX = size(X);

if length(X)==1
  NM = M+Sign*X*ones(sizeM);
elseif length(sizeX)>2
  error('X must be scalar or vector!');
else
  
  if sizeX(1)>sizeX(2)
    NM = M+Sign*repmat(X,1,size(M,2)).*M;
  else
    NM = M+Sign*repmat(X',1,size(M',2))'.*M;
  end
  
end
return