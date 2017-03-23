function d=mamari(V,W)

% AMARI - amari distance: measure invariance to permutation and scaling of the columns of V and W;

m=size(V,1);
% normalize each row of V and W before calculate amari-distance;
V=bsxfun(@rdivide,V,sqrt(sum(V.^2,2)));
W=bsxfun(@rdivide,W,sqrt(sum(W.^2,2)));

Per=W*pinv(V);
Perf=[sum(abs(Per))./max(abs(Per))-1,sum(abs(Per'))./max(abs(Per'))-1];

d=mean(Perf)/(m-1);

return;