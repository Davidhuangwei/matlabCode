function nte=nTEp(X,Y,Z)
% function [nte, me, ste, h, XBins, YBins, ZBins, Pos]=nTE(X,Y,Z,npmt)
% npmt=number of permutations. 
% compute nTE
bins=10;
% CENTRIZE
X=bsxfun(@times,X,conj(fangle(mean(X,1))));
X=zscore(angle(X));
Y=bsxfun(@times,Y,conj(fangle(mean(Y,1))));
Y=zscore(angle(Y));
Z=bsxfun(@times,Z,conj(fangle(mean(Z,1))));
Z=zscore(angle(Z));
[h, XBins, YBins, ZBins, Pos] = histc3([X(:),Y(:),Z(:)], bins, bins,bins);
nte=centrop(h,[1 2 3]);
