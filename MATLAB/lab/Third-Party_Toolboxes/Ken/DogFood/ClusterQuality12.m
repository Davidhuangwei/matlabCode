% computes isolation distance in 12D space by taking the 
% 12 dimensions for which my cluster is least like other data (KS test)
% eDist = ClusterQuality(Fet, MySpikes, nDim)
%
% see also ClusterQuality 
%
% make sure you only pass those features you want to use (it will pick 12 of them)
% if you pass nDim, it will pick this many, instead of 12

function HalfDist = ClusterQuality(Fet, MySpikes, nDim)

if nargin<3
    nDim = 12;
end

% check there are enough spikes (but not more than half)
if length(MySpikes) < size(Fet,2) | length(MySpikes)>=size(Fet,1)/2
	HalfDist = 0;
	return
end

% find spikes in this cluster and calculate mahal dist
nSpikes = size(Fet,1);
nMySpikes = length(MySpikes);
		
% mark other spikes
OtherSpikes = setdiff(1:nSpikes, MySpikes);
			
%find best features
for d=1:size(Fet,2)
    [h p ks(d)] = kstest2(Fet(MySpikes,d), Fet(OtherSpikes,d));
    fprintf('dim %d: %f\n', d, ks(d));
end

[sorted order] = sort(-ks);
Best12 = order(1:nDim)

%%%%%%%%%%% compute mahalanobis distances %%%%%%%%%%%%%%%%%%%%%
m = mahal(Fet(:,Best12), Fet(MySpikes,Best12));
mMy = m(MySpikes); % mahal dist of my spikes
mOther = m(OtherSpikes); % mahal dist of others
% calculate point where mD of other spikes = n of this cell

[sorted order] = sort(mOther);
HalfDist = sorted(nMySpikes);
