% NewClu = ClusterClean(Fet, Clu)
%
% cleans up a cluster file

function NewClu = ClusterClean(Fet, Clu)

fprintf('Original cluster file:\n');
tabulate(Clu);

% get array dimensions
nClusters = max(Clu);
[nSpikes nDims] = size(Fet);

% initialize output to be unchanged
NewClu = Clu;

%Calculate covariance matrix - assuming equal for all groups
Means = zeros(nClusters, nDims);
for i=2:nClusters
	Means(i,:) = mean(Fet(find(Clu==i),:));
end
NotClu1 = find(Clu~=1);
CovMat = cov(Fet(NotClu1,:) - Means(Clu(NotClu1),:));
CovMatMH = CovMat^-0.5;

% calculate mahalanobis distances

for i=2:nClusters
	NormVex = (Fet - repmat(Means(i,:),nSpikes,1)) * CovMatMH;
	Mahals(:,i) = sum(NormVex.*NormVex,2);
end;


% calculate cut-off point
CutDist = chi2inv(.99, nDims);
IncludeDist = chi2inv(.99, nDims);

% sort them

[SortDist SortInd] = sort(Mahals(:,2:nClusters),2);

% find any outliers and allocate them to cluster 1

for i=2:nClusters
	Outliers = find(Clu==i & Mahals(:,i)>CutDist);
	fprintf('Cluster %d -> deleting %d outliers (out of %d)\n', i, length(Outliers), sum(Clu==i));
	NewClu(Outliers) = 1;
end

% go through cluster 1 (noise) and reallocate any that have p>0.01 for
% exactly one other cluster.

ReAllocate = find(Clu == 1 & SortDist(:,1) < IncludeDist & SortDist(:,2) >=IncludeDist);
NewClu(ReAllocate) = 1+SortInd(ReAllocate,1);
fprintf('Re-allocating to clusters:\n');
tabulate(1+SortInd(ReAllocate,1))