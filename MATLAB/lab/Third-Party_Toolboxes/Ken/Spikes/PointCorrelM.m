function PointCorrelM(T, G, BinSize, HalfBins, SampleRate, GSubset, Normalization)
% constructs multiple cross and Auto correlogram
% usage: PointCorrelM(T, G, BinSize, HalfBins, SampleRate, GSubset, Normalization)
%
% T gives the time of the events,
% G says which one is in which group
% GSubset says which groups to plot the CCGS of (defaults to all but group 1)
% SampleRate defaults to 20000
% Normalization determines the y-axis scaling (see PointCorrel)

if nargin<5
	SampleRate = 20000;
end
if nargin<6
	GSubset = unique(G);
	GSubset = setdiff(GSubset, 1);
end
if nargin<7
	Normalization = 'hz'
end;

nGroups = length(GSubset);

for G1 = 1:nGroups
  for G2 = 1:G1
    % select apropriate subplot
    figure_index = nGroups*(G1-1) + G2;
    subplot(nGroups,nGroups,figure_index);

    PointCorrel(T(find(G==GSubset(G1))), T(find(G==GSubset(G2))),...
    			BinSize,HalfBins,G1==G2, SampleRate, Normalization);
    drawnow;

    if (G1 == G2)
    	FiringRate = SampleRate * length(find(G == GSubset(G1))) / T(end);
    	Ttitle = sprintf('%d (~%5.2fHz)',GSubset(G1),FiringRate);
		title(Ttitle);
	end;		
  end
end

