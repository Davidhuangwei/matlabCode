% Measures of cluster quality
% [HalfDist] = ClusterQuality(Fet, MySpikes)
%
% see also FileQuality -  a wrapper function that runs this for every cluster
% in a given file.
%
% Inputs: Fet - N by D array of feature vectors (N spikes, D dimensional feature space)
% MySpikes: list of spikes corresponding to cell whose quality is to be evaluated.
% Res - Spike times
% BurstTimeWin - spikes within this time count as a burst
%
% make sure you only pass those features you want to use!

function [HalfDist] = ClusterQuality(Fet, MySpikes)

% check there are enough spikes (but not more than half)
if length(MySpikes) < size(Fet,2) | length(MySpikes)>size(Fet,1)/2
	HalfDist = 0;
	return
end

% find spikes in this cluster
nSpikes = size(Fet,1);
nMySpikes = length(MySpikes);
InClu = ismember(1:nSpikes, MySpikes);


% mark other spikes
OtherSpikes = setdiff(1:nSpikes, MySpikes);

%%%%%%%%%%% compute mahalanobis distances %%%%%%%%%%%%%%%%%%%%%
m = mahal(Fet, Fet(MySpikes,:));
mMy = m(MySpikes); % mahal dist of my spikes
mOther = m(OtherSpikes); % mahal dist of others

%fprintf('done mahalanobis calculation...');
% calculate point where mD of other spikes = n of this cell
if (nMySpikes < nSpikes/2)
	[sorted order] = sort(mOther);
	HalfDist = sorted(nMySpikes);
else
	HalfDist = 0; % If there are more of this cell than every thing else, forget it.
end
	
%%%%%%%%%%%%%% plotting	%%%%%%%%%%%%%%%%%%%%%%%%%%%
mmin = min(m);
mmax = max(m);
		

% make histograms
Bins = 0:1:300;
hMy = hist(mMy, Bins);
hOther = hist(mOther, Bins);

clf

% plot pdfs
subplot(2,1,1)

semilogy(Bins, [hMy', hOther']);
xlim([0 100]);
ylabel('spike density');
xlabel('Mahalanobis distance');
legend('This cluster', 'Others');

% plot cdfs
subplot(2,1,2)
cdMy = cumsum(hMy);% / length(MySpikes);
cdOther = cumsum(hOther);% / length(OtherSpikes);
semilogy(Bins, [cdMy', cdOther']);
ylabel('cumulative # spikes');
xlabel('Mahalanobis distance');
xlim([0 100]);

