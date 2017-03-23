% [f, t] = SmoothFiring(Res, Clu, SampleRate, BinSize, tRange)
%
% Produces a smoothed interpolated time series of mean firing rate
%
% Res and Clu can be arrays or filenames
%
% At the moment it uses a triangular window for the smoothing - because this is easiest.
% f is in Hz, t gives the time coordinate in seconds
%
% SampleRate defaults to 20000 (Hz)
% BinSize defaults to 0.0008 (seconds) - to be like the eeg files.
% tRange gives the range (in seconds) to look at.  Any spikes outside
% this range will be ignored.
%
% NB if you're working in the frequency domain, remember that this
% function acts like a low-pass filter!  If you don't want that, use
% hHistFiring instead.

function [f, t] = SmoothFiring(Res, Clu, SampleRate, BinSize, tRange)

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

% you need to make the array 1 bin bigger than you should in case the last spike falls on a bin boundary
% the last value will always be 0 though.
f = zeros(nBins+2, nCells);
t = (0:nBins+1)*BinSize;

% loop through cells
for Cell = 1:nCells

	% find 
	SpikeTimes = Res(find(Spikes2Consider & Clu==Cell)) / SampleRate - MinTime;
	nSpikes = length(SpikeTimes); % number of spikes of this cell
	
	LeftBin = floor(SpikeTimes / BinSize);
	PositionWithinBin = (SpikeTimes - LeftBin*BinSize) / BinSize;
	
	% make sparse matrices with one row per spike and one column per time point
	% there are two: one for the contributions to the left time point
	% and one for the right
	LeftPart = sparse(1:nSpikes, LeftBin+1, 1-PositionWithinBin, nSpikes, nBins+2);
	RightPart = sparse(1:nSpikes, LeftBin+2, PositionWithinBin, nSpikes, nBins+2);
	
	f(:,Cell) = (sum(LeftPart)' + sum(RightPart)') / BinSize;
end;
