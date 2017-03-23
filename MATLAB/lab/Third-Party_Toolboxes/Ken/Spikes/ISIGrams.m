% [n, t] = ISIGrams(Res, Clu, SampleRate, BinSize, nBins)
%
% collect and plot a load of ISI histograms for several cells
%
% BinSize is in seconds
%
% n is a matrix n(TimeBin, CellNumber) giving the ISI count
% t is a time variable giving the time of the bins in seconds

function [n, t] = ISIGrams(Res, Clu, SampleRate, TimeBin)

if (nargin<3) SampleRate = 20000; end;
if (nargin<4) BinSize = 0.05; end;
if (nargin<5) nBins = 100; end;

nCells = max(Clu);
nSpikes = length(Res);

n = zeros(nBins+1, nCells);

BinEdges = (0:nBins) * BinSize;
t = ((0:nBins-1) + 0.5)' * BinSize;

for Cell=2:nCells
	ISIs = diff(Res(find(Clu==Cell))) / SampleRate;
	n(:,Cell) = histc(ISIs, BinEdges);
end;

% delete final bin because histc always produces a last bin with value 0
n(end,:) = [];
