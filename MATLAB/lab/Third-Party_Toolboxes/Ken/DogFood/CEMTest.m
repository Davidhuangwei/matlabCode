% A quick dog food script to check whether CEM is practical

if ~exist('Fet')
	Fet = LoadFet('/u5/b/ken/data/d151/2/mfilt/tetrode.fet.1');
end
%Clu = LoadClu('/u5/b/ken/data/d151/2/mfilt/ken.clu');



M1 = [5 4; 4 5];
M2 = [5 -4; 4 -5];

if 0
	x = [randn(100, 2) *M1; randn(100,2)*M2 ; repmat([25 0], 20, 1) + randn(20,2)/5];
	nClusters = 3;
	PlotDim = [1 2];
else
	x = Fet(:,1:12);
	nClusters = 30;
	PlotDim = [1 4];
end

nPoints = size(x,1);
nDim = size(x,2);
nStarts = 7;
ColorOrder = hsv(nClusters);


DistMat = zeros(nPoints, nClusters);

BestScore = inf;
% repeat starts
for start=1:nStarts
	% do iteration
	subplot(2,1,1);
	Class = ceil(rand(nPoints,1)*nClusters);
	while 1
		% eliminate any empty classes
		ClassTot = full(sparse(Class, 1, 1));
		ReOrder = cumsum(ClassTot>0);
		Class = ReOrder(Class);
		nClusters = max(ReOrder);
		DistMat = zeros(nPoints, nClusters);
		ColorOrder = jet(nClusters);
		
		% calculate matrix of mahalanobis distances
		for c=1:nClusters	
			MyPoints = find(Class==c);
			LogProp = log(length(MyPoints) ./ nPoints);
			CovMat = cov(x(MyPoints,:));
			LogDet = log(det(CovMat));
			if (length(MyPoints) > nDim)
				DistMat(:,c) = mahal(x, x(MyPoints,:)) + LogDet -LogProp;
			else
				DistMat(:,c) = inf;
			end
		end
	
		% set class to be that that has the minimum distance
		OldClass = Class;
		[MinDist Class] = min(DistMat,[],2);
		Score = sum(MinDist);
	
		% compute nchanged
		nChanged = sum(OldClass ~= Class);
		fprintf('Score %f nChanged %d\n', sum(MinDist), nChanged);
		if nChanged==0 
			break; 
		end
	
		ColorScatter(x(:,PlotDim), Class, 3, ColorOrder);
		drawnow;
	end
	if (Score<BestScore) 
		BestScore = Score;
		BestClass = Class;
		subplot(2,1,2);
		ColorScatter(x(:,PlotDim), BestClass, 3, ColorOrder);
		title(sprintf('Best Score %f\n', BestScore));
	end
end