% HowClean(CluFname, FetFname, FeaturesConsidered, ClusterNo, nSpikesCorrect, LineSpec)
%
% Reads in cluster file CluFname and feature file FetFname
% Prints the number of false positive spikes that you have to have
% in order to detect a given percentage of the real spikes of cluster
% ClusterNo.  Spikes are classified by mahalanobis distance
% from cluster ClusterNo along axes of FeaturesConsidered.
%
% If nSpikesCorrect is not specified, it is set as the total number of
% spikes in the specified cluster (which may be less if spikes are
% missed during detection)

function [CumCorrect, CumIncorrect] = HowClean(CluFname, FetFname, FeaturesConsidered, ClusterNo, nSpikesCorrect, LineSpec)

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

fclose('all');
	
% Find spikes of cluster we are interested in
RealSpikes = find(Clu==ClusterNo);
OtherSpikes = find(Clu~=ClusterNo);

% get number of correct spikes (if not specified)
if (nargin<5 | isempty(nSpikesCorrect)) nSpikesCorrect = size(RealSpikes, 1); end;

if (nargin<6) LineSpec = 'b'; end;

% get number of spikes
nSpikes = size(Fet, 1);


% Compute Mahanobolis distance
md = mahal(Fet(:, FeaturesConsidered), Fet(RealSpikes, FeaturesConsidered));

% sort them
[Sorted Index] = sort(md);

% SortedCorrect is a vector which goes up the sorted spikes
% saying if they were in the correct cluster.
SortedCorrect = (Clu(Index)==ClusterNo);

CumCorrect = cumsum(SortedCorrect);
CumIncorrect = cumsum(~SortedCorrect);

plot(100*(CumIncorrect./(CumIncorrect + CumCorrect)), 100*(1-CumCorrect/nSpikesCorrect), LineSpec)