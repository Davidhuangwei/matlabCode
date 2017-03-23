% tabout ReturnMap(Res, Clu, CellNos, SampleRate, BurstTime, LongTime)
%
% Plots a return map for ISIs on a log scale.
% Res can be an array or a file name.
% 
% Clu and CellNo are optional arguments.
% If you provide them, it will restrict to only the spikes
% of the specified cells.  Different cells are plotted in
% different colors
% SampleRate defaults to 20000 (Hz).
% BurstTime and LongTime for doing the statistics - defaults to 6 and 100 ms
%
% optional output argument tabout stores the cross-tables

function tabout = ReturnMap(Res, Clu, CellNos, SampleRate, BurstTime, LongTime)
		
% process arguments
if (ischar(Res))
	 Res = load(Res);
end

if (nargin<2 | isempty(Clu))
	Clu = 2*ones(size(Res));
elseif (ischar(Clu))
	Clu = LoadClu(Clu);
end

if (nargin<3 | isempty(CellNos))
	CellNos = 2:max(Clu);
end

if (nargin<4)
	SampleRate = 20000;
end

if (nargin<5)
	BurstTime = 6; %ms
end

if (nargin<6)
	LongTime = 100; %ms
end

ColorOrder = get(gca, 'ColorOrder');
nColors = size(ColorOrder,1);


clf
hold on
set(gca, 'xscale', 'log');
set(gca, 'yscale', 'log');

jitter = 1000/SampleRate;

% loop through cells

for c=1:length(CellNos)
	MyRes = Res(find(Clu==CellNos(c)));
	nMySpikes = length(MyRes);
	ISIs = diff(MyRes) *1000 / SampleRate;
	PreviousISI = ISIs(1:nMySpikes-2);
	NextISI = ISIs(2:end);
	
	Color = ColorOrder(1+mod(c-1,7), :);
	
	plot(PreviousISI+jitter*randn(size(PreviousISI)), ...
			NextISI+jitter*randn(size(NextISI)), ...
			'.', 'MarkerSize', 2, 'MarkerEdgeColor', Color);
	% do median smoothing
	Bins = log(3):.2:log(max(ISIs))	;
	[m Bins] = MedianSmooth(log(PreviousISI), NextISI, Bins);

	plot(exp(Bins), m, 'Color', Color);		
	plot(xlim, xlim, 'k--');

	xlabel('Previous ISI (ms)');
	ylabel('Next ISI (ms)');	
	
	% do stats
	PreviousGp = (PreviousISI<BurstTime) ...
				+ 2*(PreviousISI>=BurstTime & PreviousISI<LongTime) ...
				+ 3*(PreviousISI>=LongTime);

	NextGp = (NextISI<BurstTime) ...
			+ 2*(NextISI>=BurstTime);
			%	+ 2*(NextISI>=BurstTime & NextISI<LongTime) ...
			%	+ 3*(NextISI>=LongTime);
				
	OK = find(PreviousGp>1);
	[table chi2 p] = crosstab(PreviousGp(OK)-1, NextGp(OK));
	
	% store if required
	if (nargout>=1)
		tabout(:,:,c) = table;
	end

	fprintf('cell %d - %% burst short %f long %f.  p = %f\n', ...
		CellNos(c), 100*table(1,1)/sum(table(1,:)), 100*table(2,1)/sum(table(2,:)), p);
	
end
