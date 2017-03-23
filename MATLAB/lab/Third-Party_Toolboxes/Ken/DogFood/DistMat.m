% d = DistMat(X, G)
%
% produces a matrix of distances between classified data
% the (i,j)th entry of d is the mahalanobis distance of 
% the mean of group i from group j.

function d = DistMat(X, G)

nGps = max(G);
nDims = size(X,2);

Means = zeros(nGps, nDims);
d = zeros(nGps);

for g=1:nGps
	Means(g,:) = mean(X(find(G==g), :));
end

for g = 1:nGps
	d(:, g) = mahal(Means, X(find(G==g),:));
end