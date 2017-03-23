function [out, t, Pairs] = CCG(T, G, BinSize, HalfBins, SampleRate, GSubset, Normalization)
% constructs multiple cross and Auto correlogram
% usage: [ccg, t, pairs] = CCG(T, G, BinSize, HalfBins, SampleRate, GSubset, Normalization)
%
% T gives the time of the events, (events need not be sorted by TIME)
% G says which one is in which group
% BinSize gives the size of a bin in input units (i.e. not scaled by SampleRate)
% HalfBins gives the number of bins on each side of 0 - so the total is 1+2*HalfBins
% SampleRate is for x-axis scaling only.  It defaults to 20000
% GSubset says which groups to plot the CCGS of (defaults to all but group 1)
% Normalization indicates the type of y-axis normalization to be used.  
% 'count' indicates that the y axis should show the raw spike count in each bin.
% 'hz' will normalize to give the conditional intensity of cell 2 given that cell 1 fired a spike (default)
% 'hz2' will give the joint intensity, measured in hz^2.
% 'scale' will scale by both firing rates so the asymptotic value is 1
%
% The output array will be 3d with the first dim being time lag and the second two 
% specifying the 2 cells in question.
% If there is no output specified, it will plot the CCGs
%
% This file calls a C program so your CCG is computed fast (unlike PointCorrel)
%
% optional output t gives time axis for the bins in ms
% optional output argument pairs gives a nx2 array with the indices of the spikes
% in each train that fall in the CCG.

if nargin<5
	SampleRate = 20000;
end
if nargin<6
	GSubset = unique(G);
	GSubset = setdiff(GSubset, 1);
end
if nargin<7
	Normalization = 'hz';
end;

if length(G)==1
	G = ones(length(T), 1);
	GSubset = 1;
	nGroups = 1;
else
	nGroups = length(GSubset);
end;


% Prepare Res and Clu arrays.
G=G(:);
T=T(:);

Included = find(ismember(G,GSubset) & isfinite(T));
Res = T(Included);
% if no spikes, return nothing
if isempty(Res)
    nBins = 1+2*HalfBins;
    out = zeros(nBins, nGroups, nGroups);
    t = 1000*(-HalfBins:HalfBins)*BinSize/SampleRate;
    Pairs = [];
    return
end

% To make the Clu array we need a indexing array, which SUCKS!
G2Clu = full(sparse(GSubset,1,1:nGroups));
Clu = G2Clu(G(Included));


% sort by time
[Res ind] = sort(Res);
Clu = Clu(ind);

% Now call the C program...


%create files
FileBase = tempname;
ResFile = [FileBase, '.res'];
CluFile = [FileBase, '.clu'];
OutFile = [FileBase, '.out'];
if nargout>=3
    PairFile = [FileBase, '.pairs'];
else
    PairFile = '';
end
bsave(ResFile, Res, 'double');
bsave(CluFile, Clu, 'uint');

% call the program
nSpikes = length(Res);
Command = sprintf('!/u5/b/ken/bin/CCGEngine %d %s %s %f %d %s %s', nSpikes, ResFile, CluFile, BinSize, HalfBins, OutFile, PairFile);
eval(Command);

% read in and shape the results
Counts = bload(OutFile, Inf, 0, 'uint');
nBins = 1+2*HalfBins;
Counts = reshape(Counts,[nBins nGroups nGroups]); 
if nargout>=3
    Pairs = Included(ind(bload(PairFile, [2 Inf], 0, 'uint')' + 1));
end

% delete temporary files
Command = sprintf('!rm %s %s %s %s', ResFile, CluFile, OutFile, PairFile);
eval(Command);

% OK so we now have the bin counts.  Now we need to rescale it.
% NB There is no bias correction for edge effects (yet)

Trange = max(Res) - min(Res); % total time
t = 1000*(-HalfBins:HalfBins)*BinSize/SampleRate;

% count the number of spikes in each group:
for g=1:nGroups
	nSpikesPerGroup(g) = sum(Clu==g);
end;

% normalize each group
for g1=1:nGroups, for g2=g1:nGroups
	switch Normalization
		case 'hz'
			Factor = SampleRate / (BinSize * nSpikesPerGroup(g1));
			AxisUnit = '(Hz)';
		case 'hz2'
			Factor = SampleRate * SampleRate / (Trange*BinSize);	
			AxisUnit = '(Hz^2)';
		case 'count';
			Factor = 1;
			AxisUnit = '(Spikes)';
		case 'scale'
			Factor = Trange / (BinSize * nSpikesPerGroup(g1) * nSpikesPerGroup(g2));
			AxisUnit = '(Scaled)';
		otherwise
			warning(['Unknown Normalization method ', Normalization]);
	end;
	ccg(:,g1,g2) = flipud(Counts(:,g1,g2)) * Factor; 
	
	% now plot, if there is no output argument
	if (nargout==0)
		FigureIndex = g1 + nGroups*(nGroups-g2);
		subplot(nGroups,nGroups,FigureIndex);		
	
		% plot graph
%		bar(1000*(-HalfBins:HalfBins)*BinSize/SampleRate, ccg(:,g1,g2));
		bar(t, ccg(:,g1,g2));
		xlabel('ms');

		% label y axis
		if g1==g2
			ylabel(['ACG ', AxisUnit])	
    		FiringRate = SampleRate * nSpikesPerGroup(g1) / Trange;
    		Ttitle = sprintf('%d (~%5.2fHz)',GSubset(g1),FiringRate);
			title(Ttitle);
		else
			ylabel(['CCG ', AxisUnit])
			Ttitle = sprintf('%d vs %d', GSubset(g1), GSubset(g2));
			title(Ttitle);
		end

		axis tight
	end
end,end;

% only make an output argument if its needed (to prevent command-line spew)
if (nargout>0)
	out = ccg;
end


