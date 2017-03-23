% Comodugram2(x, nFFT, SampleRate, FreqRange, Clip)
%
% Takes an input sequence x and does a multi-pane
% plot showing correlated changes in power in frequency
% bands 
%
% nFFT and SampleRate are just like for specgram() function
%
% FreqRange = [fLow fHigh] allows you to view only a certain 
% frequency range.  Specify it in Hz.
%
% NB x is of the form x(Channel, Time)
%
% if Clip is 1, correlations below 0 will be replaced by 0.
%
% Comodugram2 is like Comodugram but also includes coherences

function Comodugram2(x, nFFT, SampleRate, FreqRange)

if (nargin<2 | isempty(nFFT)) nFFT = 256; end;
if (nargin<3 | isempty(SampleRate)) SampleRate = 2; end;
if (nargin<4 | isempty(FreqRange)) FreqRange = [0 SampleRate/2]; end;
if (nargin<5) Clip = 0; end;

nChannels = size(x,1);
nChannelsSq = nChannels*nChannels;
nSamples = size(x,2);

% compute number of time bins that will be produced by specgram(), and allocate array
%nTimeBins = fix((nSamples - nFFT/2) / (nFFT/2));
nTimeBins = round((nSamples-nFFT) / (nFFT/2));
spex = zeros(1 + nFFT/2, nTimeBins, nChannels);

% calculate spectrograms
	
[spex, f, t] = mtspec(x', 3, 5, nFFT, nFFT, nFFT/2, SampleRate);

% normalize cross-spectra into coherences

spex = abs(spex);

for Ch1=1:nChannels, for Ch2 = 1:nChannels
	if (Ch1 ~= Ch2)
		spex(:,:,Ch1, Ch2) = spex(:,:,Ch1,Ch2) ./ sqrt(spex(:,:,Ch1,Ch1) .*spex(:,:,Ch2,Ch2));
	end;
end; end;

spex = spex(:,:,:);

% find frequency bins to consider
FreqBins = find(f >= FreqRange(1) & f <= FreqRange(2));
nFreqBins = length(FreqBins);

% calculate correlation coefficients
DataMat = reshape(permute(spex(FreqBins, :, :), [2 1 3]), ...
				[nTimeBins, nFreqBins*nChannels*nChannels]);
				
CorrMat = corrcoef(DataMat);
if (Clip) CorrMat = clip(CorrMat, 0, 1); end;

% plot it

for i=1:(nChannelsSq)
	for j=1:(nChannelsSq)
		subplot(nChannelsSq, nChannelsSq, j + (i-1) * nChannelsSq);
		
		imagesc(f(FreqBins), f(FreqBins), ...
				CorrMat((i-1)*nFreqBins + (1:nFreqBins), (j-1)*nFreqBins + (1:nFreqBins)));
		
		drawnow;
	end;
end;
