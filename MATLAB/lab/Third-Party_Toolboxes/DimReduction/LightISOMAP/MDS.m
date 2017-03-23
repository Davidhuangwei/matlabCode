function [Y,r] = mds(D,dims);
% Y = mds(D,dims)
%
% D contains the pairwise SQUARED distances
% dims is a vector containing the dimensionalities of the desired embeddings
%
% Y{di} contains the embedding in di-dimensions 
opt.disp = 0; 

n=size(D,1);

A = -D/2;
Ac = -sqrt(D)/2;

M  = mean(A);  M2 = M'*ones(1,n);
Mc = mean(Ac); M2c= Mc'*ones(1,n); 

B = A - M2 - M2' + mean(M);
Bc= Ac-M2c -M2c'+mean(Mc);

[vecs, vals] = eigs(B, max(dims), 'LR', opt);
vals=diag(vals);
[val,I] = sort(real(vals)); 
I = I(end:-1:end-max(dims)+1);
val = val(end:-1:1);
vec = vecs(:,I);
vec = vec.*repmat(sqrt(val'),n,1); 

for di=dims(1:end)
  Y{di} = real(vec(:,1:di))';      		       
end
r=cumsum(val(1:di))/sum(val);


