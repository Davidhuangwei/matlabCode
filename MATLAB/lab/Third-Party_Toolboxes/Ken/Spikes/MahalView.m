% MahalView(FetFile, DiffCluFile, FeaturesConsidered, ShowLegend)
%
% Plots the mahalanobis distances of the true spikes
% detected spikes, false positives, and false negatives
%
% mahal distance is computed w.r.t. the correct spikes
%
% DiffClu file is : 1 for correctly ignored
%                   2 for false neg
% 					3 for false pos
%					4 for correctly detected
%
% A legend is plotted if ShowLegend is on.

function MahalView(FetFile, DiffCluFile, FeaturesConsidered, ShowLegend)

Fet = LoadFet(FetFile);
DiffClu = LoadClu(DiffCluFile);

TrueSpikes = Fet(find(DiffClu==2 | DiffClu==4), FeaturesConsidered);
OtherSpikes = Fet(find(DiffClu==1 | DiffClu==3), FeaturesConsidered);
ChosenCluster = Fet(find(DiffClu==3 | DiffClu==4), FeaturesConsidered);

F2 = Fet(find(DiffClu==2), FeaturesConsidered);
F3 = Fet(find(DiffClu==3), FeaturesConsidered);
F4 = Fet(find(DiffClu==4), FeaturesConsidered);

m2 = mahal(F2, TrueSpikes);
m3 = mahal(F3, TrueSpikes);
m4 = mahal(F4, TrueSpikes);
%mo = mahal(OtherSpikes, TrueSpikes);

nBins = 50;
%mmax = max([m2;m3;m4;mo]);
%mmin = min([m2;m3;m4;mo]);
mmax = max([m2;m3;m4]);
mmin = min([m2;m3;m4]);


Bins = mmin:(mmax-mmin)/nBins:mmax;

[h2, x2] = hist(m2, Bins);
[h3, x3] = hist(m3, Bins);
[h4, x4] = hist(m4, Bins);
%[ho, xo] = hist(mo, nBins);

hold on
cla;
stairs(x4, h4/size(m4,1), 'b');
stairs(x2, h2/size(m2,1), 'g');
stairs(x3, h3/size(m3,1), 'r');
%stairs(xo, ho/size(mo,1), 'k');

if (nargin >=4 & ShowLegend)
	legend('Correct', 'False Negatives', 'False Positives');
end;

hold off;
