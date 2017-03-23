function Perr=amariIdx(A,eA)
% function Perr=amariIdx(A,eA)
% Compute Amari performance index Perr. 
% ref: Amari 1996
% bug to: YYC 

ncomp=size(A,2);
P=abs(pinv(eA)*A);
Perr=1/2/ncomp*sum(sum((bsxfun(@rdivide,P,max(P,[],2))+bsxfun(@rdivide,P,max(P,[],1)))))-1;