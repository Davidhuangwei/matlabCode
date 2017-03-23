% p = MGProbs(Fet1, Fet2, Clu2)
%
% classifies points in Fet1 as belonging to a mixture of Gaussians
% which are specified by the example data Fet2 and Clu2.
%
% the output p is a nPointsxnClusters array giving the posterior
% probabilities of belonging to each cluster of Fet2, for each point of Fet1.

function p = MGProbs(Fet1, Fet2, Clu2)

nPoints = size(Fet1, 1);
nDims = size(Fet1, 2);
nClusters = max(Clu2);

LogP = zeros(nPoints, nClusters);
for c=1:nClusters
	MyPoints = find(Clu2==c);
    MyFet2 = Fet2(MyPoints, :);
	if length(MyPoints) > nDims
		LogProp = log(length(MyPoints) ./ nPoints); % log of the proportion in cluster c
		Mean = mean(MyFet2);  %
		CovMat = cov(MyFet2); % stats for cluster c
		LogDet = log(det(CovMat));   %

		dx = Fet1 - repmat(Mean, nPoints, 1); % distance of each point from cluster
		y = dx / CovMat;
		LogP(:,c) = sum(y.*dx, 2)/2 + LogDet/2 - LogProp + log(2*pi)*nDims/2; % -Log Likelihood
            % -log of joint probability that the point lies in cluster c and has given coords.
	else
		LogP(:,c) = inf;
	end
end

JointProb = exp(-LogP);

% if any points have all probs zero, set them to cluster 1
JointProb(find(sum(JointProb,2)==0),1) = eps;

%probability that point belongs to cluster, given coords
p = JointProb ./ repmat(sum(JointProb,2), 1, nClusters); 
