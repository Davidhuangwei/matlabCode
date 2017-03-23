% [f, t] = HistFiring(Res, Clu, SampleRate, BinSize, tRange)
%
% Produces an unsmoothed histogram of firing rate.  If you want smoothed use 
% SmoothFiring.  It also subtracts the mean.
%
% Res and Clu can be arrays or filenames
%
% SampleRate defaults to 20000 (Hz)
% BinSize defaults to 0.0008 (seconds) - to be like the eeg files.
% tRange gives the range (in seconds) to look at.  Any spikes outside
% this range will be ignored.

function [f, t] = HistFiring(Res, Clu, SampleRate, BinSize, tRange)

if (isstr(Res)) Res = load(Res); end;
if (isstr(Clu)) Clu = LoadClu(Clu); end;

if (nargin<3) BinSize = 0.0008; end;
if (nargin<4) SampleRate = 20000; end;

if (nargin<5)
	MinTime = min(Res) / SampleRate;
	MaxTime = max(Res) / SampleRate;
else
	MinTime = tRange(1);
	MaxTime = tRange(2);
end;
Spikes2Consider = find(Res>=MinTime*SampleRate & Res<=MaxTime*SampleRate);
nBins = ceil((MaxTime-MinTime) / BinSize);

nCells = max(Clu);

% you need to make the array 1 bin bigger than you should in 
% case the last spike falls on a bin boundary

f = zeros(nBins+1, nCells);
t = (0:nBins)*BinSize;

% loop through cells
for Cell = 1:nCells

	h = histc(Res(find(Clu==Cell))/SampleRate, t);
	f(:,Cell) = h(:);
	f(:,Cell) = f(:,Cell) - mean(f(:,Cell));
end;

% lost last bin
f(end,:) = [];
t(end) = [];