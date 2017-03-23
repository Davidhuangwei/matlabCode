% A quick dog food script to check whether EM is practical

Fet = LoadFet('/u5/b/ken/data/d151/2/tetrode.fet.1');
Clu = LoadClu('/u5/b/ken/data/d151/2/ken.clu');


x = Fet(:,1:12);

nDim = size(x,2);
nClusters = max(Clu);
nPoints = size(x, 1);


Mix = gmm(nDim, nClusters, 'full');

% set up according to Clu file

for i = 1:Mix.ncentres
	% Pick out data points belonging to this centre
	ThisClust = x(find(Clu==i),:);
	
	Mix.priors(i) = size(ThisClust, 1) / nPoints;
	
	Mix.centres(i,:) = mean(ThisClust);
	Mix.covars(:,:,i) = cov(ThisClust);
	
	diffs = x - (ones(size(x, 1), 1) * Mix.centres(i, :));
	Mix.covars(:,:,i) = (diffs'*diffs)/(size(x, 1));
	
%	% Add WIDTH*Identity to rank-deficient covariance matrices
%	if rank(mix.covars(:,:,i)) < mix.nin
%		mix.covars(:,:,i) = mix.covars(:,:,i) + WIDTH.*eye(mix.nin);
%	end

end


options = zeros(14,1);
options(1) = 1;
options(3) = 0.1;
options(5) = 1;
options(14) = 25;

	[mp BestClass] = max(gmmactiv(Mix, x), [], 2);
	xgobi(x, BestClass);
%	pause;
	
	[Mix2, Options, Errlog] = gmmem(Mix, x, options);
	
	[mp BestClass] = max(gmmactiv(Mix, x), [], 2);
	xgobi(x, BestClass);

	SaveClu('em.clu', BestClass);