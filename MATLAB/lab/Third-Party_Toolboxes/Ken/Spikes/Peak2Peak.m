% Fet = Peak2Peak(Spk)
%
% Detects peak to peak amplitudes out of a spike array.

function Fet = Peak2Peak(Spk);

nChannels = size(Spk, 1);
nSamples = size(Spk, 2);
nSpikes = size(Spk, 3);

HiPeaks = squeeze(max(Spk, [], 2));
LoPeaks = squeeze(min(Spk, [], 2));

Fet = (HiPeaks - LoPeaks)';