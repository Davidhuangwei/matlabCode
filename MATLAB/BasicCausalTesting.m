function [pl,mi,npl,nmi]=BasicCausalTesting(X,Y,y,nbs,nb)
% [pl,mi,npl,nmi]=BasicCausalTesting(X,Y,y,nbs,nb)
% compute phase locking value and mutual information between two sequence X
% and Y. return null distribution by permutation, whose order given by y.
% THis could be used to detect redundancy of time sequence and get a rough
% idea about causal relation(pl and mi). perform on phase data, to change
% binning number of mutual information, please go to MutualInformation.m.
% It is now using 4 equilpopulation on marginal distribution.
% for nbs and nb of course you can compute inside, this is just to save
% time...
% YY
pl=X'*Y/nb;
mi=MutualInformation(X,Y,4,4);% 4 bins,4bins
npl=zeros(nbs,1);
nmi=zeros(nbs,1);
for bs=1:nbs
    npl(bs)=X(y(:,bs),:)'*Y/nb;
    nmi(bs)=MutualInformation(X(y(:,bs),:),Y,4,4);
end