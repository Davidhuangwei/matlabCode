% ClusterDiagnose(Fet,Clu)
%
% Plots some hopefully useful statistics about Fet and Clu

function ClusterDiagnose(Fet,Clu)

nGroups = max(Clu);
[nSpikes nDim] = size(Fet);

Means = zeros(nGroups, nDim);

for i=1:nGroups
	Means(i,:) = mean(Fet(find(Clu==i)),1);
end

Covs = zeros(nDim,nDim,nGroups);

if 0
for i=1:nGroups
	Covs(:,:,i) = cov(Fet(find(Clu==i),:));
end
end

% calculate mahalanobis distances to each cluster
Mahals = zeros(nSpikes,nGroups);

for i=2:nGroups
	i
	Mahals(:,i) = mahal(Fet,Fet(find(Clu==i),:));
end;

if 0
figure(1)
for i=2:nGroups, for j=2:nGroups
	subplot(nGroups,nGroups, (i-1)*nGroups + j);
	chi2plot(Mahals(find(Clu==i),j),nDim);
	title(sprintf('Group %d against %d', i,j));
	drawnow
end;end
end

% find outliers
BigDist  = chi2inv(.99,nDim);
SmallDist = chi2inv(.5,nDim);

[MinDist MinInd] = min(Mahals(:,2:nGroups),[],2);
[SortDist SortInd] = sort(Mahals(:,2:nGroups),2);


Outliers = find(MinDist > BigDist);
NotOutliers = find(MinDist <= BigDist);
Inliers = find(MinDist < SmallDist);
Confused = find(SortDist(:,2) < BigDist);
VeryConfused = find(SortDist(:,2) < SmallDist);

% analyse group 1
fprintf('Group 1: \n');

for i=2:nGroups
	MyNotOutliers = find(Clu == 1 & Mahals(:,i)<BigDist);
	MyInliers = find(Clu == 1 & Mahals(:,i)<SmallDist);
	fprintf('for group %d (%d spikes), ', i, sum(Clu==i));
	fprintf(' %d have p>.001, %d have p>.5\n', length(MyNotOutliers), length(MyInliers));
	fprintf('of which %d and %d have p>.001 for some other group\n', length(intersect(MyNotOutliers,Confused)), length(intersect(MyInliers,Confused)));
end

fprintf('\n\n');

% analyse all other groups
for i=2:nGroups
	MySpikes = find(Clu==i);
	MyOutliers = find(Clu==i & Mahals(:,i)>BigDist);
	MyConfused = intersect(Confused, MySpikes);
	
	fprintf('Group %d\n', i);
	
	fprintf('%d outliers (%f %%), ',length(MyOutliers), length(MyOutliers)/length(MySpikes));
	
	fprintf(' of which %d belong in another group ', length(setdiff(MyOutliers, Outliers)));
	fprintf(' and %d are confused\n', length(intersect(MyOutliers, Confused)));
end

Tab = CrossTab(MinInd, Clu);
