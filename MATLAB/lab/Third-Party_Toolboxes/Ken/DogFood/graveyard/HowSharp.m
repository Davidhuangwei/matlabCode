% HowSharp(CluFname, FetFname, FeaturesConsidered)
%
% Reads in cluster file CluFname and feature file FetFname
% prints out total means and variances of the features in
% FeaturesConsidered for each cluster, and then prints variances
% as a percentage of total variance in the whole file.

function HowSharp(CluFname, FetFname, FeaturesConsidered)

% open files
CluFp = fopen(CluFname, 'r');
FetFp = fopen(FetFname, 'r');

% get number of clusters and number of features
nClusters = fscanf(CluFp, '%d', 1);
nFeatures = fscanf(FetFp, '%d', 1);

% read in data
Clu = fscanf(CluFp, '%d');
% fscanf reads down the columns - so we need to transpose it
% to get the same shape as our original file
Fet = fscanf(FetFp, '%f', [nFeatures, inf])';
	
% find mean and covariance of entire file
TotMean = mean(Fet(:,FeaturesConsidered));
TotCov = cov(Fet(:,FeaturesConsidered));

% print them
fprintf('\nEntire file:\n');
PrintHeaderLine(FeaturesConsidered);
PrintWithTabs('Mean', TotMean, sum(TotMean));
PrintWithTabs('Var', diag(TotCov), trace(TotCov));

% find mean and covariance of each cluster and print useful info
for Cluster = 1:nClusters

	% print header info
	fprintf('\nCluster %d:\n', Cluster);
	PrintHeaderLine(FeaturesConsidered);

	% find mean of the cluster
	Mean = mean(Fet(find(Clu==Cluster), FeaturesConsidered));
	
	% print it
	PrintWithTabs('Mean', Mean, sum(Mean));
	
	% find covariance of the cluster
	Cov = cov(Fet(find(Clu==Cluster), FeaturesConsidered));

	% print variances and total
	PrintWithTabs('Var', diag(Cov), trace(Cov));
	
	% print variances as a percentage
	PrintWithTabs('%Var', 100*diag(Cov)./diag(TotCov), 100*trace(Cov)/trace(TotCov));	
end


fclose('all');




% PrintWithTabs(s, v) prints string s then the elements of v then the last number (usually the sum - but not for the total variance)
function PrintWithTabs(s, v, tot)

	fprintf('%s\t', s);
	for i=v fprintf('%.1f\t', i); end
	fprintf('%.1f\n', tot);


% print header line for n points and a total
function PrintHeaderLine(FeaturesConsidered)

	fprintf('\t');
	for i=FeaturesConsidered fprintf('%d\t', i); end
	fprintf('Tot\n');
	fprintf('\t');
	for i=FeaturesConsidered fprintf('-\t'); end
	fprintf('---\n');
	