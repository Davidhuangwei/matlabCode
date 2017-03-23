function com = CenterOfMass(T,X)

if size(T,1)<size(T,2)
  T = T';
end
if size(X,1)~=size(T,1)
  X = X';
end

com = sum(X.*repmat(T,1,size(X,2)))./sum(X);

return;