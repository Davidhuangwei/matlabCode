% Measures of cluster quality
% [HalfDist, WorstBurstRat, WorstBurstRatAt] = ClusterQuality(Fet, MySpikes, Res, BurstTimeWin,Verbose)
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

function [HalfDist, WorstBurstRat, WorstBurstRatAt] = ClusterQuality(Fet, MySpikes, Res, BurstTimeWin, Verbose)

% check there are enough spikes (but not more than half)
if length(MySpikes) < size(Fet,2) | length(MySpikes)>length(Res)/2
	HalfDist = 0;
	WorstBurstRat = 0;
	WorstBurstRatAt = 0;
	return
end
if nargin<5
    Verbose=1;
end

% find spikes in this cluster and calculate mahal dist
nSpikes = size(Fet,1);
nMySpikes = length(MySpikes);
InClu = ismember(1:nSpikes, MySpikes);

		
% mark other spikes
OtherSpikes = setdiff(1:nSpikes, MySpikes);
			
%%%%%%%%%%% find what's in the CCG bins %%%%%%%%%%%%%%%
CCG1Spikes = zeros(nSpikes, 1); % spikes lying in CCG between 0 and BurstTimeWin
CCG2Spikes = zeros(nSpikes, 1); % spikes lying in CCG between BurstTimeWin and 2*BurstTimeWin
n1 = 1;	n2 = 1; %positions to put in CCGxSpikes arrays
		
if 0
    [ccg t pairs] = CCG(Res(MySpikes), 2, BurstTimeWin*4, 0);
    tDif = diff(Res(MySpikes(pairs)),1,2);
    CCG1Spikes = pairs(find(tDif>0 & tDif<BurstTimeWin),2);
    CCG2Spikes = pairs(find(tDif>=BurstTimeWin & tDif<2*BurstTimeWin),2);
else       
	for s1=MySpikes' % loop through spikes of selected cell
		t1 = Res(s1);
		for s2 = (s1+1):nSpikes    % loop through second spikes
			if (~InClu(s2))
				t2 = Res(s2);
				if (t2-t1 < BurstTimeWin) 
					CCG1Spikes(n1) = s2;
					n1 = n1+1;
				elseif (t2-t1 < 2*BurstTimeWin) 
					CCG2Spikes(n2) = s2;
					n2 = n2+1;
				else 
					break;
				end
			end
		end
	end
	% we overallocated the arrays - so clear the rest
	CCG1Spikes(n1:end) = [];
	CCG2Spikes(n2:end) = [];
	%fprintf('done correlograms...');
end		
					
%%%%%%%%%%% compute mahalanobis distances %%%%%%%%%%%%%%%%%%%%%
%do buffered mahal computation - memory overflow for many features (rare)
setlen =5000;
nblocks = floor(nSpikes/setlen)+1;
m = zeros(nSpikes,1);
for b=1:nblocks
    spkset = [(b-1)*setlen+1:min(nSpikes,b*setlen)];
    m(spkset) = mahal(Fet(spkset,:), Fet(MySpikes,:));
end
mMy = m(MySpikes); % mahal dist of my spikes
mOther = m(OtherSpikes); % mahal dist of others
mCCG1 = m(CCG1Spikes);
mCCG2 = m(CCG2Spikes);
%fprintf('done mahalanobis calculation...');
% calculate point where mD of other spikes = n of this cell
if (nMySpikes < nSpikes/2)
	[sorted order] = sort(mOther);
	HalfDist = sorted(nMySpikes);
else
	HalfDist = 0; % If there are more of this cell than every thing else, forget it.
end

mmin = min(m);
    mmax = max(m);


    % make histograms
    Bins = 0:1:300;
    hMy = hist(mMy, Bins);
    hOther = hist(mOther, Bins);
    hCCG1 = hist(mCCG1, Bins);
    hCCG2 = hist(mCCG2, Bins);

    cdMy = cumsum(hMy);% / length(MySpikes);
    cdOther = cumsum(hOther);% / length(OtherSpikes);
    cdCCG1 = cumsum(hCCG1);% / length(CCG1Spikes);
    cdCCG2 = cumsum(hCCG2);
    BurstRat = (cdCCG2>0).*(cdCCG1)./(cdCCG2+eps);
    AdjBurstRat = (cdCCG2>0).*(cdCCG1-sqrt(cdCCG1))./(cdCCG2+sqrt(cdCCG2)+eps);

    [WorstBurstRat WorstBurstRatAt] = max(AdjBurstRat);
    % fprintf('Worst burst ratio %f adjusted %f\n', max(BurstRat),
    % max(AdjBurstRat));

if Verbose

    %%%%%%%%%%%%%% plotting	%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure(3232323);
    clf

    % plot pdfs
    subplot(3,1,1)

    semilogy(Bins, [hMy', hOther', hCCG1', hCCG2']);
    xlim([0 100]);
    ylabel('spike density');
    xlabel('Mahalanobis distance');
    legend('This cluster', 'Others', 'within 10ms', '10-20ms');

    % plot cdfs
    subplot(3,1,2)
    semilogy(Bins, [cdMy', cdOther', cdCCG1', cdCCG2']);
    ylabel('cumulative # spikes');
    xlabel('Mahalanobis distance');
    xlim([0 100]);

    % plot burst ratio
    subplot(3,1,3)
    hold off
    plot(Bins, BurstRat, Bins, AdjBurstRat, '--')
       
    
    drawnow

end