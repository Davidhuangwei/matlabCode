function recon=fsvd_rcn(X,mask)
%FSVD_RCN Returns the first index of space to the dimension of mask
%
% RECON = FSVD_RCN(SPACE,MASK) returns the first index of space to
% that of mask filling the entries where mask is 1.
%

% Author:  Bijan Pesaran, version date 10/08/98

nch=size(X,1);
nt=size(X,2);
nnch=length(find(mask > 0));
szMask=size(mask);
indices=find(mask > 0);

if length(szMask) == 2 recon=zeros(szMask(1),szMask(2),nt); end
if length(szMask) == 3 recon=zeros(szMask(1),szMask(2),szMask(3),nt); end

for ii=1:nt
tmp=mask;
tmp(indices)=X(:,ii);
if length(szMask) == 2 recon(:,:,ii)=tmp; end
if length(szMask) == 3 recon(:,:,:,ii)=tmp; end
end
	


