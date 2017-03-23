% [Spikes Crap] = SpikeAndCrapExtract(DatFileName, SpikeTimes, NumChannels,
%           Channels2Extract, BeforeSamps, AfterSamps)
%
%  will produce an array of extracted waveforms from a .dat file
%  at times specified by SpikeTimes
%
%  ---like SpikeExtract.  But it will also extract a load of junk from equally
%  spaced points in the file
%
%  First array dimension : channel number
%  Second dimension: time within spike waveform
%  Third dimension: spike number
%
%  SpikeTimes gives the spike times in samples - i.e. a .res file
%
%  Assumes input is centered on 2048.
%
%  SamplingRate should be in Hz
%
% NB the spikes are NOT resampled and realigned on the peak of the intracellular channel
% if you want that, use SpikeExtractRealign
%
% BeforeSamps and AfterSamps give the number of samples to store on either side of the spike
% (default values = 100)

function [Spikes, Crap] = SpikeAndCrapExtract(DatFileName, SpikeTimes, NChannels, ...
					Channels2Extract, BeforeSamps, AfterSamps)

Spikes = SpikeExtract(DatFileName, SpikeTimes, NChannels, ...
					Channels2Extract, BeforeSamps, AfterSamps);

nSpikes = length(SpikeTimes);
LastSpikeTime = max(SpikeTimes);
SpikeSpacing = round(LastSpikeTime/(4+nSpikes));

CrapTimes = (1:nSpikes)*SpikeSpacing + BeforeSamps +2;

Crap = SpikeExtract(DatFileName, CrapTimes, NChannels, ...
					Channels2Extract, BeforeSamps, AfterSamps);