% ResampleRealignSpikes(Spikes, ResampleRatio, BeforeSampsR, AfterSampsR, MaxRange)
%
%This function resamples by a factor of ResampleRatio, realigns the spikes on their peaks
% then returns a vector of aligned spikes at the original sampling rate
%
% Spikes is a 5 x nSamples x nSpikes array
% containing spike data produced by SpikeExtract
% The first dimension is electrode number, with 1-4 being extracellular, and 5 being intracellular
%
% BeforeSampsR and AfterSampsR give the number of samples to include before and after
% the peak of the realigned waveform
%
% MaxRange gives the range in the original waveform in which to search for peaks

function RSpikesOut = ResampleRealignSpikes(Spikes, ResampleRatio, BeforeSampsR, AfterSampsR, MaxRange)

% number of samples of a realigned spike
WaveSampsR = BeforeSampsR + AfterSampsR + 1;

%number of samples in the original spike
WaveSamps = size(Spikes, 2);

nSpikesActuallyThere = size(Spikes,3);

ReshapedSpikes = reshape(permute(Spikes, [2 1 3]), WaveSamps, nSpikesActuallyThere * 5);

ResampledSpikes = resample(ReshapedSpikes, ResampleRatio, 1);

%MaxRange gives the range to look for the peak in.  Reexpress it in resampled coordinates
MaxRangeR = MaxRange(1)*10:MaxRange(end)*ResampleRatio;

% find peak positions of intracellular channel
[PeakVal PeakPos] = max(ResampledSpikes(MaxRangeR, 5:5:end));
PeakPos = PeakPos + MaxRangeR(1)-1;

% Set up array of realigned waves
RealignedSpikes = zeros(1+BeforeSampsR+AfterSampsR, nSpikesActuallyThere*5);

% Fill it up
for i=1:nSpikesActuallyThere
	RealignedSpikes(:,i*5-4:i*5) = ResampledSpikes(PeakPos(i)-BeforeSampsR*ResampleRatio:ResampleRatio:PeakPos(i)+AfterSampsR*ResampleRatio, i*5-4:i*5);
end;

% reshape spikes for output
RSpikesOut = permute(reshape(RealignedSpikes,[1+BeforeSampsR+AfterSampsR, 5, nSpikesActuallyThere]), [2 1 3]);
