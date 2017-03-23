% Redish's Measures of cluster quality
% [Lextra Lintra n] = ClusterQuality(Fet, MySpikes)
%
% see also FileQuality -  a wrapper function that runs this for every cluster
% in a given file.
%
% Inputs: Fet - N by D array of feature vectors (N spikes, D dimensional feature space)
% MySpikes: list of spikes corresponding to cell whose quality is to be evaluated.
%
% Lextra: sum of chi2 likelihoods for other points, Lintra for these points
% n - number of points
%
% make sure you only pass those features you want to use!

function [Lextra, Lintra, n] = ClusterQuality(Fet, MySpikes, Res, BurstTimeWin)

% check there are enough spikes (but not more than half)
n = length(MySpikes);

if n < size(Fet,2)
	Lextra = 0;
	Lintra = 0;
	return
end

% mark other spikes
OtherSpikes = setdiff(1:size(Fet,1), MySpikes);


%%%%%%%%%%% compute mahalanobis distances %%%%%%%%%%%%%%%%%%%%%
m = mahal(Fet, Fet(MySpikes,:));
chi2l = chi2pdf(m, size(Fet,2));

Lintra = sum(chi2l(MySpikes));
Lextra = sum(chi2l(OtherSpikes));

d=size(Fet,2);

Mintra = histc(m(MySpikes), 0:d*3);
Mextra = histc(m(OtherSpikes), 0:d*3);
Mchi = chi2pdf(.5:d*3+.5, d)*length(MySpikes);
stairs(0:d*3, [Mintra, Mextra, Mchi']);
legend('this', 'other', 'chi2')
drawnow

return