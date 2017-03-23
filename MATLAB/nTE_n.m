function [nte, me, ste, pval, h, XBins, YBins, ZBins, Pos]=nTE_n(X,Y,Z,npmt)
% function [nte, me, ste, h, XBins, YBins, ZBins, Pos]=nTE(X,Y,Z,npmt)
% npmt=number of permutations. 
% compute nTE
bins=5;
% CENTRIZE
X=bsxfun(@times,X,conj(fangle(mean(X,1))));
X=zscore(angle(X));
Y=bsxfun(@times,Y,conj(fangle(mean(Y,1))));
Y=zscore(angle(Y));
Z=bsxfun(@times,Z,conj(fangle(mean(Z,1))));
Z=zscore(angle(Z));
[h, XBins, YBins, ZBins, Pos] = histc3([X(:),Y(:),Z(:)], bins, bins,bins);
nte=centrop(h,[1 2 3]);
% pval
e=zeros(npmt,1);
% isal=false;
yy=ShuffleNr(Y,npmt);
for k=1:npmt
    hh = histc3([X(:),circshift(Y(:),yy(k)),Z(:)], bins, bins,bins);
    e(k)=centrop(hh,[1 2 3]);
end
me=mean(e);
ste=std(e);
% single side
pval=sum(e>nte)/npmt;