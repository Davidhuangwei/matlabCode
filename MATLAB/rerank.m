function rW=rerank(rW,W)
% rW=rerank(rW,W)
rW=bsxfun(@rdivide,rW,sqrt(sum(rW.^2,2)));
W=bsxfun(@rdivide,W,sqrt(sum(W.^2,2)));
dist=rW*W';
ncomp=size(W,1);
idx=[1:ncomp*ncomp;repmat(1:ncomp,1,ncomp);reshape(repmat(1:ncomp,ncomp,1),1,[])]';
Rank=zeros(ncomp,1);
dist=dist(:);
for k=1:ncomp
    [~,mxd]=max(dist(idx(:,1)));
    Rank(idx(mxd,2))=idx(mxd,3);
    idx(idx(:,2)==idx(mxd,2) | idx(:,3)==idx(mxd,3),:)=[];
end
rW=rW(Rank,:);
end